-- Gerekli Sütun Kontrolü: Payments tablosuna ReleasedAt ekleme
IF NOT EXISTS (
    SELECT 1 
    FROM sys.columns 
    WHERE object_id = OBJECT_ID('Payments') AND name = 'ReleasedAt'
)
BEGIN
    ALTER TABLE Payments ADD ReleasedAt DATETIME NULL;
END;
GO

-- 1. Tetikleyici (Trigger): Çift Rezervasyonu Önleme
DROP TRIGGER IF EXISTS trg_PreventDoubleBooking;
GO

CREATE OR ALTER TRIGGER trg_PreventDoubleBooking
ON Appointments
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 
        FROM AvailabilitySlots s
        INNER JOIN inserted i ON s.SlotID = i.SlotID
        WHERE s.IsBooked = 1
    )
    BEGIN
        RAISERROR ('HATA: Bu zaman dilimi daha once rezerve edilmistir!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    UPDATE s
    SET s.IsBooked = 1
    FROM AvailabilitySlots s
    INNER JOIN inserted i ON s.SlotID = i.SlotID;
END;
GO

-- 2. Saklı Yordam (Stored Procedure): Escrow Çözme ve Dersi Tamamlama
DROP PROCEDURE IF EXISTS sp_CompleteLessonAndReleaseEscrow;
GO

CREATE PROCEDURE sp_CompleteLessonAndReleaseEscrow
    @AppointmentID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    BEGIN TRY
        IF NOT EXISTS (
            SELECT 1 
            FROM Appointments 
            WHERE AppointmentID = @AppointmentID AND Status = 'Confirmed'
        )
        BEGIN
            RAISERROR('HATA: Gecerli ve onayli bir randevu bulunamadi.', 16, 1);
        END;

        -- Randevuyu tamamlandı olarak güncelle
        UPDATE Appointments
        SET Status = 'Completed'
        WHERE AppointmentID = @AppointmentID;

        -- Ödemeyi serbest bırak ve zaman damgası ekle
        UPDATE Payments
        SET Status = 'Released',
            ReleasedAt = GETDATE()
        WHERE AppointmentID = @AppointmentID AND Status = 'In_Escrow';

        COMMIT TRANSACTION;
        PRINT 'Ders basariyla tamamlandi, odeme egitmene aktarildi.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
