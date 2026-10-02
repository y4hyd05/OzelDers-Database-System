# Özel Ders Platformu Veritabanı Sistemi (OzelDersDB)

Bu proje, bir özel ders platformunun (eğitmen, öğrenci, branş, randevu ve emanet usulü ödeme akışı) uçtan uca ilişkisel veritabanı mimarisini içerir.

## 📌 Özellikler & İş Mantığı
- **Rol Tabanlı Kullanıcı Modeli:** Tek bir `Users` tablosu üzerinden öğrenci ve eğitmen ayrımı.
- **Dinamik Müsaitlik Yönetimi:** Eğitmenlerin tanımladığı saatlik dilimler (`AvailabilitySlots`) ve çakışma önleyici rezervasyon kontrolü (`IsBooked`).
- **Escrow (Güvence Hesabı) Ödeme Akışı:** Randevu onaylandığında ders ücreti havuzda (`In_Escrow`) tutulur; ders tamamlandığında platform komisyonu kesilerek eğitmene aktarılır (`Released`).
- **Değerlendirme Sistemi:** Yalnızca tamamlanan dersler üzerinden eğitmen puanlama ve yorumlama.

---

## 🗄️ Veritabanı Şeması (Tablolar)

| Tablo Adı | Açıklama |
| :--- | :--- |
| `Users` | Sistemdeki öğrenci ve eğitmen kullanıcı profilleri |
| `Instructors` | Eğitmen biyografileri ve saatlik ders taban ücretleri |
| `Subjects` | Verilen ders branşları ve kategorileri |
| `InstructorSubjects` | Eğitmenler ile verebildikleri branşların eşleşmesi (Çoka-çok ilişki) |
| `AvailabilitySlots` | Eğitmenlerin ders için açtığı müsait zaman aralıkları |
| `Appointments` | Alınan ders randevuları ve randevu durumları |
| `Payments` | Platform komisyonu ve eğitmen hak edişini yöneten ödeme akışı |
| `Reviews` | Ders sonrası öğrenci değerlendirmeleri |

---

## 🚀 Kurulum ve Çalıştırma

SQL Server üzerinde sırasıyla çalıştırınız:

1. **`01_schema.sql`**: Tabloları, birincil/yabancı anahtarları ve kısıtlamaları (constraints) kurar.
2. **`02_seed_data.sql`**: Test verilerini ekler ve örnek bir randevu/emanet ödeme transaction'ı yürütür.
3. **`03_queries.sql`**: Eğitmen arama, boş slot listeleme ve finansal raporlama sorgularını içerir.
