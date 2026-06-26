-- 1. MENAMPILKAN DATA (SELECT)
-- Tampilkan seluruh data pada tabel pelanggan
SELECT * FROM pelanggan;
-- Tampilkan seluruh data pada tabel kendaraan
SELECT * FROM kendaraan;
-- Tampilkan seluruh data pada tabel mekanik
SELECT * FROM mekanik;
-- Tampilkan seluruh data pada tabel transaksi
SELECT * FROM transaksi;
-- Tampilkan seluruh data pada tabel sparepart
SELECT * FROM sparepart;
-- Tampilkan seluruh data pada tabel pembayaran
SELECT * FROM pembayaran;
-- Tampilkan hanya kolom nama_pelanggan, nomor_hp, dan email_pelanggan
SELECT nama_pelanggan, nomor_hp, email_pelanggan FROM pelanggan;
-- Tampilkan hanya kolom plat_nomor_kendaraan, merk_kendaraan, tipe_kendaraan, dan tahun_kendaraan
SELECT plat_nomor_kendaraan, merk_kendaraan, tipe_kendaraan, tahun_kendaraan FROM kendaraan;
-- Tampilkan hanya kolom nama_mekanik dan spesialisasi
SELECT nama_mekanik, spesialisasi FROM mekanik;
-- Tampilkan hanya kolom nama_jasa dan harga_jasa_servis
SELECT nama_jasa, harga_jasa_servis FROM jasa;
-- Tampilkan hanya kolom nama_sparepart dan harga_sparepart
SELECT nama_sparepart, harga_sparepart FROM sparepart;
-- Tampilkan hanya kolom id_transaksi, metode_pembayaran, dan total_biaya
SELECT id_transaksi, metode_pembayaran, total_biaya FROM pembayaran;

-- 2. MENAMPILKAN DATA BERDASARKAN KONDISI (WHERE)
-- Tampilkan data mekanik yang berstatus 'Aktif'
SELECT * FROM mekanik
WHERE status_mekanik = 'Aktif';

-- Tampilkan data mekanik dengan spesialisasi 'CVT'
SELECT * FROM mekanik
WHERE spesialisasi = 'CVT';
-- Tampilkan data kendaraan dengan merk 'Toyota'
SELECT * FROM kendaraan
WHERE merk_kendaraan = 'Toyota';
-- Tampilkan data kendaraan yang diproduksi setelah tahun 2020
SELECT * FROM kendaraan
WHERE tahun_kendaraan > 2020;
-- Tampilkan data sparepart dengan harga_sparepart lebih dari 100000
SELECT * FROM sparepart
WHERE harga_sparepart > 100000;
-- Tampilkan data transaksi dengan status 'Selesai'
SELECT * FROM transaksi
WHERE status_servis = 'Selesai';
-- Tampilkan data pembayaran dengan metode_pembayaran 'Transfer'
SELECT * FROM pembayaran
WHERE metode_pembayaran = 'Transfer';
-- Tampilkan data pembayaran dengan total_biaya lebih dari 300000
SELECT * FROM pembayaran
WHERE total_biaya > 300000;

-- 3. MENGUBAH DATA (UPDATE)
-- Matikan safe update mode
SET SQL_SAFE_UPDATES = 0;
-- Ubah status mekanik 'MK003' (Nanang Susilo) dari 'Tidak Aktif' menjadi 'Aktif'
-- Tampilkan data SEBELUM perubahan:
SELECT * FROM mekanik WHERE id_mekanik = 'MK003';
-- Jalankan UPDATE:
UPDATE mekanik
SET status_mekanik = 'Aktif'
WHERE id_mekanik = 'MK003';
-- Tampilkan data SESUDAH perubahan:
SELECT * FROM mekanik WHERE id_mekanik = 'MK003';
-- Ubah harga_jasa_servis jasa 'J001' (Servis CVT) dari 50000 menjadi 60000
-- Tampilkan data SEBELUM perubahan:
SELECT * FROM jasa WHERE id_jasa = 'J001';
-- Jalankan UPDATE:
UPDATE jasa
SET harga_jasa_servis = 60000
WHERE id_jasa = 'J001';
-- Tampilkan data SESUDAH perubahan:
SELECT * FROM jasa WHERE id_jasa = 'J001';

-- Ubah warna kendaraan 'KD001' (Honda Beat) dari 'Hitam' menjadi 'Putih'
-- Tampilkan data SEBELUM perubahan:
SELECT * FROM kendaraan WHERE id_kendaraan = 'KD001';
-- Jalankan UPDATE:
UPDATE kendaraan
SET warna_kendaraan = 'Putih'
WHERE id_kendaraan = 'KD001';
-- Tampilkan data SESUDAH perubahan:
SELECT * FROM kendaraan WHERE id_kendaraan = 'KD001';

-- 4. MENGHAPUS DATA (DELETE) – DENGAN PERBAIKAN FK
-- 4a. Hapus sparepart 'SPR006' (data tidak valid)
--     Langkah aman: hapus dulu referensinya di detail_sparepart
-- Tampilkan data sparepart sebelum penghapusan
SELECT * FROM sparepart;
-- Tampilkan referensi di detail_sparepart yang menggunakan SPR006
SELECT * FROM detail_sparepart WHERE id_sparepart = 'SPR006';
-- Hapus referensi di detail_sparepart
DELETE FROM detail_sparepart WHERE id_sparepart = 'SPR006';
-- Hapus sparepart SPR006
DELETE FROM sparepart WHERE id_sparepart = 'SPR006';
-- Tampilkan data sparepart setelah penghapusan
SELECT * FROM sparepart;

-- 4b. Hapus detail_servis duplikat 'DSV003' (aman, tidak ada FK anak)
-- Tampilkan detail_servis sebelum penghapusan
SELECT * FROM detail_servis;
DELETE FROM detail_servis WHERE id_detail_servis = 'DSV003';
-- Tampilkan detail_servis setelah penghapusan
SELECT * FROM detail_servis;
-- 4c. Hapus mekanik 'MK017' (status Cuti)-- -----------------------------------------------------------------
-- Tampilkan mekanik sebelum penghapusan
SELECT * FROM mekanik;
-- Cek transaksi yang menggunakan mekanik MK017
SELECT * FROM transaksi WHERE id_mekanik = 'MK017';
-- Pindahkan referensi di transaksi TR019 ke mekanik lain (misal MK001)
UPDATE transaksi
SET id_mekanik = 'MK001'
WHERE id_mekanik = 'MK017';
-- Hapus mekanik MK017
DELETE FROM mekanik WHERE id_mekanik = 'MK017' AND status_mekanik = 'Cuti';
-- Tampilkan mekanik setelah penghapusan
SELECT * FROM mekanik;
-- (Opsional) Tampilkan transaksi TR019 untuk memastikan mekanik sudah berubah
SELECT * FROM transaksi WHERE id_transaksi = 'TR019';
-- 1. MENAMPILKAN DATA BERDASARKAN KRITERIA (WHERE)

-- Tampilkan mekanik yang BUKAN spesialisasi 'Mesin'
SELECT * FROM mekanik
WHERE spesialisasi <> 'Mesin';

-- Tampilkan kendaraan dengan tahun lebih besar atau sama dengan 2022
SELECT * FROM kendaraan
WHERE tahun_kendaraan >= 2022;

-- Tampilkan kendaraan dengan tahun lebih kecil atau sama dengan 2019
SELECT * FROM kendaraan
WHERE tahun_kendaraan <= 2019;

-- Tampilkan pembayaran dengan total_biaya kurang dari 200000
SELECT * FROM pembayaran
WHERE total_biaya < 200000;


-- Tampilkan pembayaran dengan total_biaya antara 200000 dan 500000
SELECT * FROM pembayaran
WHERE total_biaya BETWEEN 200000 AND 500000;

-- Tampilkan kendaraan yang diproduksi antara tahun 2019 dan 2022
SELECT * FROM kendaraan
WHERE tahun_kendaraan BETWEEN 2019 AND 2022;

-- Tampilkan jasa dengan harga_jasa_servis antara 50000 dan 100000
SELECT * FROM jasa
WHERE harga_jasa_servis BETWEEN 50000 AND 100000;

-- Tampilkan sparepart dengan harga_sparepart antara 40000 dan 100000
SELECT * FROM sparepart
WHERE harga_sparepart BETWEEN 40000 AND 100000;

-- Tampilkan mekanik dengan spesialisasi CVT, Mesin, atau Injeksi
SELECT * FROM mekanik
WHERE spesialisasi IN ('CVT', 'Mesin', 'Injeksi');

-- Tampilkan kendaraan dengan merk Honda, Yamaha, atau Suzuki
SELECT * FROM kendaraan
WHERE merk_kendaraan IN ('Honda', 'Yamaha', 'Suzuki');

-- Tampilkan transaksi dengan status Selesai atau Dalam Proses
SELECT * FROM transaksi
WHERE status_servis IN ('Selesai', 'Dalam Proses');

-- Tampilkan pembayaran dengan metode Transfer atau Debit
SELECT * FROM pembayaran
WHERE metode_pembayaran IN ('Transfer', 'Debit');


-- Tampilkan transaksi yang belum memiliki keluhan (keluhan_pelanggan IS NULL)
SELECT * FROM transaksi
WHERE keluhan_pelanggan IS NULL;

-- Tampilkan transaksi yang sudah memiliki keluhan
SELECT * FROM transaksi
WHERE keluhan_pelanggan IS NOT NULL;

-- Tampilkan jasa yang belum memiliki durasi servis (durasi_servis IS NULL)
SELECT * FROM jasa
WHERE durasi_servis IS NULL;


-- 2. OPERATOR LOGIKA (AND, OR, NOT)

-- Tampilkan mekanik yang Aktif DAN spesialisasinya CVT
SELECT * FROM mekanik
WHERE status_mekanik = 'Aktif' AND spesialisasi = 'CVT';

-- Tampilkan kendaraan merk Toyota DAN diproduksi setelah 2019
SELECT * FROM kendaraan
WHERE merk_kendaraan = 'Toyota' AND tahun_kendaraan > 2019;

-- Tampilkan pembayaran dengan metode Transfer DAN total_biaya lebih dari 300000
SELECT * FROM pembayaran
WHERE metode_pembayaran = 'Transfer' AND total_biaya > 300000;

-- Tampilkan transaksi yang statusnya Selesai DAN menggunakan supplier SP001
SELECT * FROM transaksi
WHERE status_servis = 'Selesai' AND id_supplier = 'SP001';

-- Tampilkan mekanik yang berstatus Cuti ATAU Tidak Aktif
SELECT * FROM mekanik
WHERE status_mekanik = 'Cuti' OR status_mekanik = 'Tidak Aktif';

-- Tampilkan kendaraan merk Honda ATAU Yamaha
SELECT * FROM kendaraan
WHERE merk_kendaraan = 'Honda' OR merk_kendaraan = 'Yamaha';

-- Tampilkan pembayaran dengan total_biaya kurang dari 150000 ATAU lebih dari 1000000
SELECT * FROM pembayaran
WHERE total_biaya < 150000 OR total_biaya > 1000000;

-- Tampilkan transaksi yang statusnya Menunggu Sparepart ATAU Dalam Proses
SELECT * FROM transaksi
WHERE status_servis = 'Menunggu Sparepart' OR status_servis = 'Dalam Proses';


-- Tampilkan mekanik yang BUKAN berstatus Aktif
SELECT * FROM mekanik
WHERE NOT status_mekanik = 'Aktif';

-- Tampilkan kendaraan yang BUKAN merk Toyota
SELECT * FROM kendaraan
WHERE NOT merk_kendaraan = 'Toyota';

-- Tampilkan transaksi yang BUKAN berstatus Selesai
SELECT * FROM transaksi
WHERE NOT status_servis = 'Selesai';

-- Tampilkan jasa dengan harga TIDAK lebih dari 100000 (harga <= 100000)
SELECT * FROM jasa
WHERE NOT harga_jasa_servis > 100000;


-- 3. PENCARIAN POLA (LIKE)
-- Tampilkan pelanggan dengan nama diawali huruf 'A'
SELECT * FROM pelanggan
WHERE nama_pelanggan LIKE 'A%';

-- Tampilkan mekanik dengan nama diawali huruf 'S'
SELECT * FROM mekanik
WHERE nama_mekanik LIKE 'S%';

-- Tampilkan kendaraan dengan nomor plat diawali 'H'
SELECT * FROM kendaraan
WHERE plat_nomor_kendaraan LIKE 'H%';

-- Tampilkan jasa yang namanya diawali kata 'Servis'
SELECT * FROM jasa
WHERE nama_jasa LIKE 'Servis%';

-- Tampilkan sparepart yang namanya diawali 'Filter'
SELECT * FROM sparepart
WHERE nama_sparepart LIKE 'Filter%';

-- 3b. Mencari berdasarkan akhiran

-- Tampilkan pelanggan dengan nama yang berakhiran huruf 'i'
SELECT * FROM pelanggan
WHERE nama_pelanggan LIKE '%i';

-- Tampilkan kendaraan dengan warna yang berakhiran 'h' (contoh: Putih, Merah, Hitam)
SELECT * FROM kendaraan
WHERE warna_kendaraan LIKE '%h';

-- Tampilkan jasa yang namanya berakhiran 'CVT'
SELECT * FROM jasa
WHERE nama_jasa LIKE '%CVT';

-- Tampilkan sparepart yang namanya berakhiran 'L' (contoh: oli per liter)
SELECT * FROM sparepart
WHERE nama_sparepart LIKE '%L';


-- Tampilkan mekanik yang huruf keduanya 'a' (contoh: Nanang, Marjono, Sarwono)
SELECT * FROM mekanik
WHERE nama_mekanik LIKE '_a%';

-- Tampilkan kendaraan dengan plat nomor yang huruf keduanya angka atau spasi
-- (plat diawali satu karakter bebas lalu spasi)
SELECT * FROM kendaraan
WHERE plat_nomor_kendaraan LIKE '_ %';

-- Tampilkan sparepart yang mengandung kata 'CVT' di mana saja
SELECT * FROM sparepart
WHERE nama_sparepart LIKE '%CVT%';

-- Tampilkan jasa yang mengandung kata 'Ganti'
SELECT * FROM jasa
WHERE nama_jasa LIKE '%Ganti%';

-- Tampilkan pelanggan dengan nama yang mengandung kata 'Wulan'
SELECT * FROM pelanggan
WHERE nama_pelanggan LIKE '%Wulan%';


-- 4. MENGURUTKAN DATA (ORDER BY)

-- Tampilkan seluruh pembayaran diurutkan dari total_biaya terkecil (ASC)
SELECT * FROM pembayaran
ORDER BY total_biaya ASC;

-- Tampilkan seluruh pembayaran diurutkan dari total_biaya terbesar (DESC)
SELECT * FROM pembayaran
ORDER BY total_biaya DESC;

-- Tampilkan kendaraan diurutkan berdasarkan tahun_kendaraan dari terlama
SELECT * FROM kendaraan
ORDER BY tahun_kendaraan ASC;

-- Tampilkan kendaraan diurutkan berdasarkan tahun_kendaraan dari terbaru
SELECT * FROM kendaraan
ORDER BY tahun_kendaraan DESC;

-- Tampilkan jasa diurutkan dari harga_jasa_servis termurah
SELECT * FROM jasa
ORDER BY harga_jasa_servis ASC;

-- Tampilkan jasa diurutkan dari harga_jasa_servis termahal
SELECT * FROM jasa
ORDER BY harga_jasa_servis DESC;

-- Tampilkan mekanik diurutkan berdasarkan nama_mekanik secara alfabetis (ASC)
SELECT * FROM mekanik
ORDER BY nama_mekanik ASC;

-- Tampilkan sparepart diurutkan dari harga_sparepart terkecil ke terbesar
SELECT * FROM sparepart
ORDER BY harga_sparepart ASC;


-- 5. MEMBATASI DATA (LIMIT)

-- Tampilkan 5 data pertama dari tabel pelanggan
SELECT * FROM pelanggan
LIMIT 5;

-- Tampilkan 3 data pertama dari tabel kendaraan
SELECT * FROM kendaraan
LIMIT 3;

-- Tampilkan 5 pembayaran dengan total_biaya tertinggi
SELECT * FROM pembayaran
ORDER BY total_biaya DESC
LIMIT 5;

-- Tampilkan 3 pembayaran dengan total_biaya terendah
SELECT * FROM pembayaran
ORDER BY total_biaya ASC
LIMIT 3;

-- Tampilkan 3 jasa dengan harga_jasa_servis termahal
SELECT * FROM jasa
ORDER BY harga_jasa_servis DESC
LIMIT 3;

-- Tampilkan 5 sparepart dengan harga_sparepart termurah
SELECT * FROM sparepart
ORDER BY harga_sparepart ASC
LIMIT 5;


-- 6. MENAMPILKAN DATA UNIK (DISTINCT)

-- Tampilkan nilai unik dari kolom spesialisasi mekanik
SELECT DISTINCT spesialisasi
FROM mekanik;

-- Tampilkan nilai unik dari kolom status_mekanik
SELECT DISTINCT status_mekanik
FROM mekanik;

-- Tampilkan nilai unik dari kolom merk_kendaraan
SELECT DISTINCT merk_kendaraan
FROM kendaraan;

-- Tampilkan nilai unik dari kolom warna_kendaraan
SELECT DISTINCT warna_kendaraan
FROM kendaraan;

-- Tampilkan nilai unik dari kolom metode_pembayaran
SELECT DISTINCT metode_pembayaran
FROM pembayaran;

-- Tampilkan nilai unik dari kolom status_servis pada transaksi
SELECT DISTINCT status_servis
FROM transaksi;

-- Tampilkan nilai unik dari kolom tahun_kendaraan
SELECT DISTINCT tahun_kendaraan
FROM kendaraan
ORDER BY tahun_kendaraan ASC;

-- 7. PENGAMBILAN DATA BERDASARKAN KRITERIA (KOMBINASI)

-- 1: Tampilkan transaksi yang statusnya 'Selesai' oleh mekanik aktif
--         Diurutkan berdasarkan tanggal_servis dari terbaru, ambil 5 teratas
SELECT id_transaksi, id_pelanggan, id_mekanik, tanggal_servis, status_servis
FROM transaksi
WHERE status_servis = 'Selesai'
ORDER BY tanggal_servis DESC
LIMIT 5;

--  2: Tampilkan 5 pembayaran dengan total_biaya tertinggi menggunakan metode Transfer
SELECT * FROM pembayaran
WHERE metode_pembayaran = 'Transfer'
ORDER BY total_biaya DESC
LIMIT 5;

--  3: Tampilkan kendaraan dengan tahun antara 2020 dan 2023
SELECT * FROM kendaraan
WHERE tahun_kendaraan BETWEEN 2020 AND 2023;

--  4: Tampilkan nilai unik dari merk kendaraan
SELECT DISTINCT merk_kendaraan
FROM kendaraan;

--  5: Tampilkan mekanik dengan nama mengandung kata 'Eko'
SELECT * FROM mekanik
WHERE nama_mekanik LIKE '%Eko%';

--  6: Tampilkan pembayaran dengan total_biaya lebih dari 500000 dan metode Debit
SELECT * FROM pembayaran
WHERE total_biaya > 500000 AND metode_pembayaran = 'Debit';

--  7: Tampilkan transaksi dengan status 'Selesai' dan tanggal setelah 2024-07-15
SELECT * FROM transaksi
WHERE status_servis = 'Selesai' AND tanggal_servis > '2024-07-15';

--  8: Tampilkan 3 sparepart dengan harga_sparepart terendah
SELECT * FROM sparepart
ORDER BY harga_sparepart ASC
LIMIT 3;

--  9: Tampilkan kendaraan tahun sebelum 2019 ATAU setelah 2023
SELECT * FROM kendaraan
WHERE tahun_kendaraan < 2019 OR tahun_kendaraan > 2023;

--  10: Tampilkan mekanik dengan spesialisasi CVT atau Injeksi
SELECT * FROM mekanik
WHERE spesialisasi IN ('CVT', 'Injeksi');

--  11: Tampilkan data pembayaran diurutkan dari total_biaya terbesar
SELECT * FROM pembayaran
ORDER BY total_biaya DESC;

--  12: Tampilkan pelanggan dengan nama diawali huruf 'A'
SELECT * FROM pelanggan
WHERE nama_pelanggan LIKE 'A%';

--  13: Tampilkan transaksi yang BUKAN berstatus 'Selesai'
SELECT * FROM transaksi
WHERE NOT status_servis = 'Selesai';

--  14: Tampilkan 5 jasa termahal dengan harga di atas 80000, diurutkan DESC
SELECT nama_jasa, harga_jasa_servis
FROM jasa
WHERE harga_jasa_servis > 80000
ORDER BY harga_jasa_servis DESC
LIMIT 5;

--  15: Tampilkan nilai unik dari kolom warna_kendaraan
SELECT DISTINCT warna_kendaraan
FROM kendaraan;


-- ============================================================
-- PENGUJIAN JOIN
-- ============================================================

-- JOIN 1
-- Menampilkan pelanggan beserta transaksi dan pembayaran

SELECT
    p.id_pelanggan,
    p.nama_pelanggan,
    t.id_transaksi,
    t.tanggal_servis,
    byr.total_biaya
FROM pelanggan p
JOIN transaksi t
    ON p.id_pelanggan = t.id_pelanggan
JOIN pembayaran byr
    ON t.id_pembayaran = byr.id_pembayaran;


-- ============================================================

-- JOIN 2
-- Menampilkan transaksi, kendaraan, dan mekanik

SELECT
    t.id_transaksi,
    k.plat_nomor_kendaraan,
    k.merk_kendaraan,
    m.nama_mekanik,
    t.status_servis
FROM transaksi t
JOIN kendaraan k
    ON t.id_kendaraan = k.id_kendaraan
JOIN mekanik m
    ON t.id_mekanik = m.id_mekanik;


-- ============================================================

-- JOIN 3
-- Menampilkan pelanggan, kendaraan, dan transaksi

SELECT
    p.nama_pelanggan,
    k.plat_nomor_kendaraan,
    k.merk_kendaraan,
    t.id_transaksi,
    t.tanggal_servis
FROM pelanggan p
JOIN transaksi t
    ON p.id_pelanggan = t.id_pelanggan
JOIN kendaraan k
    ON t.id_kendaraan = k.id_kendaraan;


-- ============================================================

-- JOIN 4
-- Menampilkan transaksi, mekanik, dan pembayaran

SELECT
    t.id_transaksi,
    m.nama_mekanik,
    byr.metode_pembayaran,
    byr.total_biaya
FROM transaksi t
JOIN mekanik m
    ON t.id_mekanik = m.id_mekanik
JOIN pembayaran byr
    ON t.id_pembayaran = byr.id_pembayaran;
-- ============================================================
-- SUBQUERY 1
-- Menampilkan jasa dengan harga di atas rata-rata
-- ============================================================

SELECT
    id_jasa,
    nama_jasa,
    harga_jasa_servis
FROM jasa
WHERE harga_jasa_servis >
(
    SELECT AVG(harga_jasa_servis)
    FROM jasa
);

-- ============================================================
-- SUBQUERY 2
-- Menampilkan transaksi dengan total biaya terbesar
-- ============================================================

SELECT
    t.id_transaksi,
    p.nama_pelanggan,
    byr.total_biaya
FROM transaksi t
JOIN pelanggan p
    ON t.id_pelanggan = p.id_pelanggan
JOIN pembayaran byr
    ON t.id_pembayaran = byr.id_pembayaran
WHERE byr.total_biaya =
(
    SELECT MAX(total_biaya)
    FROM pembayaran
);

-- ============================================================
-- GROUP BY + HAVING
-- Menampilkan mekanik yang menangani minimal 2 transaksi
-- ============================================================

SELECT
    m.id_mekanik,
    m.nama_mekanik,
    COUNT(t.id_transaksi) AS jumlah_transaksi
FROM mekanik m
JOIN transaksi t
    ON m.id_mekanik = t.id_mekanik
GROUP BY
    m.id_mekanik,
    m.nama_mekanik
HAVING COUNT(t.id_transaksi) >= 2;

