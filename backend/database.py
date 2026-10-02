import pymssql

# SQL Server bağlantı bilgileri
SERVER = "127.0.0.1"
PORT = 1433
USER = "sa"
PASSWORD = "GucluSifre123!"
DATABASE = "OzelDersDB"

def get_db_connection():
    """SQL Server veritabanı bağlantısı döndürür."""
    conn = pymssql.connect(
        server=SERVER,
        port=PORT,
        user=USER,
        password=PASSWORD,
        database=DATABASE,
        as_dict=True
    )
    return conn
