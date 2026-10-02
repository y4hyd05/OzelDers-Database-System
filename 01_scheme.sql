-- 1. KULLANICILAR
CREATE TABLE Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(200) NOT NULL UNIQUE,
    UserRole NVARCHAR(40) NOT NULL CHECK (UserRole IN ('Admin', 'Egitmen', 'Ogrenci')),
    CreatedAt DATETIME2 DEFAULT GETDATE()
);

-- 2. EGITMENLER
CREATE TABLE Instructors (
    InstructorId INT PRIMARY KEY,
    HourlyRate DECIMAL(10,2) NOT NULL CHECK (HourlyRate > 0),
    WalletBalance DECIMAL(10,2) DEFAULT 0.00 CHECK (WalletBalance >= 0),
    RatingAvg DECIMAL(3,2) DEFAULT 0.00 CHECK (RatingAvg BETWEEN 0 AND 5),
    TotalReviews INT DEFAULT 0 CHECK (TotalReviews >= 0),
    FOREIGN KEY (InstructorId) REFERENCES Users(UserId) ON DELETE CASCADE
);

-- 3. DERSLER (KONULAR)
CREATE TABLE Subjects (
    SubjectId INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL UNIQUE,
    Description NVARCHAR(500)
);

-- 4. EGITMEN - DERS KOPRUSU (MANY-TO-MANY)
CREATE TABLE InstructorSubjects (
    InstructorId INT NOT NULL,
    SubjectId INT NOT NULL,
    PRIMARY KEY (InstructorId, SubjectId),
    FOREIGN KEY (InstructorId) REFERENCES Instructors(InstructorId) ON DELETE CASCADE,
    FOREIGN KEY (SubjectId) REFERENCES Subjects(SubjectId) ON DELETE CASCADE
);

-- 5. MUSAITLIK SLOTLARI
CREATE TABLE AvailabilitySlots (
    SlotId INT IDENTITY(1,1) PRIMARY KEY,
    InstructorId INT NOT NULL,
    StartTime DATETIME NOT NULL,
    EndTime DATETIME NOT NULL,
    IsBooked BIT DEFAULT 0,
    FOREIGN KEY (InstructorId) REFERENCES Instructors(InstructorId) ON DELETE CASCADE,
    CONSTRAINT UQ_Instructor_Slot UNIQUE (InstructorId, StartTime),
    CONSTRAINT CHK_Slot_Time CHECK (EndTime > StartTime)
);

-- 6. RANDEVULAR
CREATE TABLE Appointments (
    AppointmentId INT IDENTITY(1,1) PRIMARY KEY,
    SlotId INT NOT NULL UNIQUE,
    StudentId INT NOT NULL,
    InstructorId INT NOT NULL,
    SubjectId INT NOT NULL,
    Status NVARCHAR(30) NOT NULL DEFAULT 'Confirmed' 
        CHECK (Status IN ('Confirmed', 'Completed', 'Cancelled_Student', 'Cancelled_Instructor', 'No_Show_Student')),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (SlotId) REFERENCES AvailabilitySlots(SlotId),
    FOREIGN KEY (StudentId) REFERENCES Users(UserId),
    FOREIGN KEY (InstructorId) REFERENCES Instructors(InstructorId),
    FOREIGN KEY (SubjectId) REFERENCES Subjects(SubjectId)
);

-- 7. ODEMELER VE ESCROW
CREATE TABLE Payments (
    PaymentId INT IDENTITY(1,1) PRIMARY KEY,
    AppointmentId INT NOT NULL UNIQUE,
    Amount DECIMAL(10,2) NOT NULL,
    PlatformFee DECIMAL(10,2) NOT NULL,
    InstructorEarning DECIMAL(10,2) NOT NULL,
    PaymentStatus NVARCHAR(30) NOT NULL DEFAULT 'In_Escrow'
        CHECK (PaymentStatus IN ('In_Escrow', 'Released_To_Instructor', 'Refunded_To_Student', 'Partial_Refund')),
    TransactionDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (AppointmentId) REFERENCES Appointments(AppointmentId) ON DELETE CASCADE,
    CONSTRAINT CHK_Payment_Amounts CHECK (Amount = PlatformFee + InstructorEarning)
);

-- 8. YORUMLAR
CREATE TABLE Reviews (
    ReviewId INT IDENTITY(1,1) PRIMARY KEY,
    AppointmentId INT NOT NULL UNIQUE,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(1000),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (AppointmentId) REFERENCES Appointments(AppointmentId) ON DELETE CASCADE
);
