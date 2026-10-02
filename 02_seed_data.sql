USE OzelDersDB;
GO
-- Kullanıcılar (Ogrenci, Egitmen, Admin)
INSERT INTO Users (FirstName, LastName, Email, UserRole)
VALUES 
('Harun', 'Demir', 'harun@firat.edu.tr', 'Ogrenci'),
('Yahya', 'Demir', 'yahya@firat.edu.tr', 'Egitmen'),
('Furkan', 'Akbas', 'furkan@firat.edu.tr', 'Admin');

-- Eğitmen Profili
INSERT INTO Instructors (InstructorId, HourlyRate)
VALUES (2, 750.00);

-- Dersler
INSERT INTO Subjects (Title, Description)
VALUES 
('Yapay Zeka', 'Makine ogrenmesi, derin ogrenme ve NLP temelleri'),
('Kalkülüs', 'Limit, turev, integral ve cok degiskenli analiz'),
('C++ Programlama', 'Nesne yonelimli programlama, bellek yonetimi ve algoritmalar');
-- Eğitmenin Verebildiği Dersler
INSERT INTO InstructorSubjects (InstructorId, SubjectId)
VALUES 
(2, 1),
(2, 3);
USE OzelDersDB;
GO
-- Eğitmen için 2 adet 1'er saatlik müsaitlik slotu açıyoruz (IsBooked varsayılan 0)
INSERT INTO AvailabilitySlots (InstructorId, StartTime, EndTime, IsBooked)
VALUES 
(2, '2026-10-05 10:00:00', '2026-10-05 11:00:00', 0),
(2, '2026-10-05 14:00:00', '2026-10-05 15:00:00', 0);
