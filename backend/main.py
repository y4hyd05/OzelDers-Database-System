from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from database import get_db_connection

app = FastAPI(title="Özel Ders Rezervasyon API", version="1.0.0")

# --- Pydantic Şemaları ---
class AppointmentCreate(BaseModel):
    slot_id: int
    student_id: int
    instructor_id: int
    subject_id: int

    class Config:
        json_schema_extra = {
            "example": {
                "slot_id": 2,
                "student_id": 4,
                "instructor_id": 2,
                "subject_id": 2
            }
        }

# --- Uç Noktalar (Endpoints) ---

@app.get("/")
def read_root():
    return {"mesaj": "Özel Ders Rezervasyon API Sistemi Aktif!"}

# 1. Randevuları Listeleme
@app.get("/appointments")
def get_appointments():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT AppointmentId, SlotId, StudentId, InstructorId, SubjectId, Status, CreatedAt 
        FROM Appointments
    """)
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return rows

# 2. Yeni Randevu Oluşturma (POST)
@app.post("/appointments", status_code=201)
def create_appointment(appointment: AppointmentCreate):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        query = """
            INSERT INTO Appointments (SlotId, StudentId, InstructorId, SubjectId, Status)
            VALUES (%d, %d, %d, %d, 'Onaylandi');
            SELECT SCOPE_IDENTITY() AS AppointmentId;
        """
        cursor.execute(query, (
            appointment.slot_id,
            appointment.student_id,
            appointment.instructor_id,
            appointment.subject_id
        ))
        
        new_row = cursor.fetchone()
        new_id = int(new_row['AppointmentId'])
        conn.commit()

        return {
            "status": "success",
            "message": "Randevu başarıyla oluşturuldu.",
            "appointment_id": new_id
        }

    except Exception as e:
        conn.rollback()
        raise HTTPException(
            status_code=400, 
            detail=f"Randevu oluşturulamadı (Slot dolu olabilir veya ID'ler geçersiz): {str(e)}"
        )
    finally:
        cursor.close()
        conn.close()



# 3. Dersi Tamamlayıp Emanet (Escrow) Bakiyeyi Aktaran Uç Nokta
@app.post("/appointments/{appointment_id}/complete")
def complete_lesson(appointment_id: int):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("EXEC sp_CompleteLessonAndReleaseEscrow @AppointmentID = %d", (appointment_id,))
        conn.commit()
        return {
            "status": "success",
            "message": f"Randevu {appointment_id} başarıyla tamamlandı ve bakiye eğitmene aktarıldı."
        }
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cursor.close()
        conn.close()
