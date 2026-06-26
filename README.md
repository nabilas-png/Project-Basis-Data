# PERANCANGAN DAN IMPLEMENTASI BASIS DATA RELASIONAL PADA SISTEM INFORMASI BENGKEL KENDARAAN 
# Deskripsi project
Sistem Informasi Bengkel Kendaraan adalah sistem basis data relasional yang dirancang untuk mendukung dan mengotomatisasi proses operasional bengkel kendaraan secara menyeluruh. Sistem ini dibangun menggunakan MySQL dan mencakup pengelolaan:
- Data Pelanggan & Kendaraan — identitas pelanggan, alamat, kontak, serta data kendaraan (plat nomor, merk, tipe, tahun, dan warna)
- Data Mekanik & Admin — informasi mekanik beserta spesialisasi (Mesin, CVT, Kaki-kaki, AC Mobil, Injeksi) dan status keaktifan, serta data admin sebagai pengelola sistem
- Data Supplier — informasi pemasok sparepart yang digunakan dalam proses servis
- Jasa & Sparepart — daftar layanan servis beserta harga dan durasi, serta data sparepart lengkap dengan harga dan stok
- Transaksi Servis — pencatatan proses servis kendaraan mulai dari keluhan pelanggan, mekanik yang menangani, hingga status servis (Selesai, Dalam Proses, Menunggu Sparepart)
- Detail Servis & Detail Sparepart — rincian jasa dan sparepart yang digunakan dalam setiap transaksi beserta subtotal masing-masing
- Pembayaran — pencatatan metode pembayaran, tanggal bayar, dan total biaya yang terhubung langsung dengan transaksi
- Ulasan Pelanggan — penilaian (rating 1-5) dan komentar pelanggan terhadap kualitas servis yang diterima

Sistem ini dilengkapi dengan objek-objek SQL lanjutan seperti:
- VIEW — `vw_riwayat_servis` untuk menampilkan riwayat servis lengkap pelanggan, dan `vw_stok_sparepart` untuk memantau stok sparepart
- STORED PROCEDURE — `sp_riwayat_pelanggan` untuk menampilkan riwayat transaksi berdasarkan ID pelanggan
- TRIGGER — `before_update_ulasan` untuk memvalidasi rating ulasan agar selalu berada pada rentang 1-5
- FUNCTION — `fn_total_transaksi`, `fn_total_sparepart_transaksi`, `fn_total_jasa_transaksi`, dan `fn_rata_rata_ulasan_mekanik` untuk menghitung total biaya transaksi serta rata-rata rating performa mekanik

Kombinasi objek-objek tersebut mendukung efisiensi, keamanan, dan integritas data secara menyeluruh dalam pengelolaan operasional bengkel, mulai dari pendaftaran servis hingga evaluasi kinerja mekanik berdasarkan ulasan pelanggan.

# Anggota tim
1. Verdina Tista Pudyawardhana (K1D024002)
2. Nabila Dwi Setiawati (K1D024005)
3. Faza Hamdi Yogaswara (K1D024011)
4. Intan Vania Saraswati(K1D024014)
5. Eunike Prasetyaning Yuniawan (K1D024026)

# Cara menjalankan script
### Persiapan
Sebelum menjalankan project, pastikan:
- MySQL Server telah aktif.
- MySQL Workbench sudah terpasang.
- Seluruh file SQL tersedia dalam satu folder project.
### Urutan Eksekusi
Jalankan file SQL sesuai urutan berikut agar seluruh objek database dapat dibuat dengan benar.
```
01_ddl.sql
      ↓
02_dml.sql
      ↓
03_query.sql
      ↓
04_view.sql
      ↓
05_procedure.sql
      ↓
06_trigger.sql
      ↓
07_function.sql
```
### Langkah Menjalankan
1. Buka **MySQL Workbench** dan hubungkan ke server MySQL.
2. Pilih **File → Open SQL Script**.
3. Buka file SQL sesuai urutan.
4. Jalankan seluruh isi file menggunakan **Ctrl + Shift + Enter**.
5. Pastikan tidak terdapat pesan error pada panel **Output**.
6. Ulangi langkah tersebut hingga seluruh file selesai dieksekusi.
### Verifikasi Database
Pastikan seluruh tabel berhasil dibuat dengan menjalankan perintah berikut.
```sql
USE db_bengkel;
SHOW TABLES;
```
### Pengujian
Beberapa perintah berikut dapat digunakan untuk memastikan implementasi database berjalan dengan baik. Coba jalankan contoh query seperti:
```sql
-- Menampilkan data pelanggan
SELECT * FROM pelanggan LIMIT 5;
-- Menampilkan data transaksi
SELECT * FROM transaksi_servis LIMIT 5;
-- Menampilkan isi VIEW
SELECT * FROM view_laporan_transaksi;
-- Menjalankan Stored Procedure
CALL detail_transaksi('TR001');
-- Menggunakan Function
SELECT fn_total_sparepart_transaksi('TR001');
```
Apabila seluruh perintah di atas dapat dijalankan tanpa error dan menghasilkan output sesuai data yang telah dimasukkan, maka implementasi database telah berhasil dilakukan.

# ERD
<img width="1842" height="1162" alt="Untitled Diagram drawio (1)" src="https://github.com/user-attachments/assets/8629010e-f771-4805-8884-a00ae032dd9f" />

# Struktur folder
```text
sistem-informasi-bengkel-kendaraan/
│
├── 01_DDL.sql         # DDL: pembuatan database, tabel, constraint, dan index
├── 02_DML.sql         # DML: data dummy untuk seluruh tabel
├── 03_QUERY.sql       # Query SELECT bertingkat (JOIN, subquery, CTE, agregat)
├── 04_VIEW.sql        # VIEW: vw_riwayat_servis, vw_stok_sparepart
├── 05_procedure.sql   # STORED PROCEDURE: sp_riwayat_pelanggan
├── 06_trigger.sql     # TRIGGER: ulasan
├── 07_function.sql    # FUNCTION: fn_total_transaksi, fn_total_sparepart_transaksi, fn_total_jasa_transaksi, dan fn_rata_rata_ulasan_mekanik
├── ERD_drawio.png     # Entity Relationship Diagram
├── PPT_Perancangan dan Implementasi Basis Data Relasional Pada Sistem Informasi Bengkel Kendaraan  #Powerpoint
└── README.md          # Dokumentasi project
```

# Penjelasan Query & Object SQL
### 03_query.sql — Query SELECT
#### Query Sederhana
| No | Fungsi |
|----|--------|
| 1 | Menampilkan data transaksi servis dengan status tertentu. |
| 2 | Menampilkan data pembayaran berdasarkan metode pembayaran dan total biaya. |
| 3 | Menampilkan jasa servis dengan harga tertentu yang diurutkan berdasarkan harga. |
#### Query JOIN
| No | Fungsi |
|----|--------|
| 1 | Menampilkan informasi transaksi beserta pelanggan, kendaraan, dan mekanik. |
| 2 | Menampilkan detail penggunaan jasa pada setiap transaksi servis. |
| 3 | Menampilkan detail penggunaan sparepart beserta supplier. |
| 4 | Menampilkan data pembayaran yang dikaitkan dengan transaksi dan pelanggan. |
#### Query Subquery dan CTE
| Jenis | Fungsi |
|-------|--------|
| Subquery | Menampilkan data berdasarkan hasil query lain, misalnya transaksi dengan total biaya di atas rata-rata. |
| CTE | Menyederhanakan query kompleks, seperti menghitung jumlah transaksi atau total pendapatan setiap mekanik. |
#### Query Agregasi
Menggunakan `GROUP BY` dan `HAVING` untuk menghasilkan informasi ringkasan, seperti total transaksi, jumlah pelanggan, atau pendapatan berdasarkan mekanik maupun periode tertentu.
---
### 04_view.sql — VIEW
| View | Fungsi |
|------|--------|
| `view_laporan_transaksi` | Menampilkan informasi transaksi secara lengkap dengan menggabungkan data pelanggan, kendaraan, mekanik, pembayaran, dan total biaya. |
| `view_stok_sparepart` | Menampilkan daftar sparepart beserta supplier, harga, dan stok yang tersedia. |
Contoh penggunaan:
```sql
SELECT * FROM view_laporan_transaksi;
SELECT * FROM view_stok_sparepart;
```
---
### 05_procedure.sql — Stored Procedure
| Procedure | Parameter | Fungsi |
|-----------|-----------|--------|
| `detail_transaksi` | `IN p_id_transaksi VARCHAR(10)` | Menampilkan informasi lengkap suatu transaksi servis berdasarkan ID transaksi. |
Contoh pemanggilan:
```sql
CALL detail_transaksi('TR001');
```
---

### 06_trigger.sql — Trigger

Trigger digunakan untuk menjalankan proses secara otomatis ketika terjadi perubahan data pada tabel tertentu.

| Trigger | Event | Fungsi |
|---------|-------|--------|
| `tr_update_total_transaksi` | AFTER INSERT | Memperbarui total biaya transaksi setelah data detail jasa atau sparepart ditambahkan. |
| `tr_update_stok_sparepart` | AFTER INSERT | Mengurangi stok sparepart secara otomatis sesuai jumlah yang digunakan pada transaksi. |
| `tr_audit_transaksi` | AFTER UPDATE | Mencatat perubahan data transaksi ke tabel log apabila terjadi pembaruan data. |

---

### 07_function.sql — Function

| Function | Return | Fungsi |
|----------|--------|--------|
| `fn_total_sparepart_transaksi` | `INT` | Menghitung total biaya sparepart yang digunakan dalam suatu transaksi. |
| `fn_total_jasa_transaksi` | `INT` | Menghitung total biaya jasa servis pada suatu transaksi. |

Contoh penggunaan:

```sql
SELECT fn_total_sparepart_transaksi('TR001');

SELECT fn_total_jasa_transaksi('TR001');
```
