USE OzelDersDB;
GO
-- 1. Tüm Kullanıcıları Listele
SELECT * FROM Users;

-- 2. Eğitmen ve Ders Eşleşmelerini İsimleriyle Getir (JOIN)
SELECT 
    u.FirstName + ' ' + u.LastName AS EgitmenAdi,
    i.HourlyRate AS SaatlikUcret,
    s.Title AS Brans,
    s.Description AS Aciklama
FROM InstructorSubjects ins_sub
JOIN Instructors i ON ins_sub.InstructorId = i.InstructorId
JOIN Users u ON i.InstructorId = u.UserId
JOIN Subjects s ON ins_sub.SubjectId = s.SubjectId;
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE';
SELECT 
    u.FirstName + ' ' + u.LastName AS EgitmenAdi,
    i.HourlyRate AS SaatlikUcret,
    s.Title AS Brans,
    s.Description AS Aciklama
FROM InstructorSubjects ins_sub
JOIN Instructors i ON ins_sub.InstructorId = i.InstructorId
JOIN Users u ON i.InstructorId = u.UserId
JOIN Subjects s ON ins_sub.SubjectId = s.SubjectId;
USE OzelDersDB;
GO
-- Rezervasyona açık (IsBooked = 0) eğitmen saatlerini listele
SELECT 
    s.SlotId,
    u.FirstName + ' ' + u.LastName AS EgitmenAdi,
    s.StartTime AS BaslangicZamani,
    s.EndTime AS BitisZamani,
    i.HourlyRate AS Ucret
FROM AvailabilitySlots s
JOIN Instructors i ON s.InstructorId = i.InstructorId
JOIN Users u ON i.InstructorId = u.UserId
WHERE s.IsBooked = 0;

