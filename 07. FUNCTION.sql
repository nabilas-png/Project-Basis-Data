USE db_bengkel;

-- 1. Fungsi untuk menghitung total biaya transaksi
--    berdasarkan id_transaksi

DROP FUNCTION IF EXISTS fn_total_transaksi;

DELIMITER //

CREATE FUNCTION fn_total_transaksi(
    p_id_transaksi VARCHAR(10)
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    -- Ambil total_biaya dari tabel pembayaran
    SELECT total_biaya
    INTO total
    FROM pembayaran
    WHERE id_transaksi = p_id_transaksi;
    
    -- Jika tidak ada pembayaran, kembalikan 0
    RETURN IFNULL(total, 0);
END //

DELIMITER ;

-- Contoh penggunaan:
-- SELECT fn_total_transaksi('TR001') AS Total_Transaksi;


-- 2. Fungsi untuk menghitung total pembelian sparepart
--    dalam sebuah transaksi

DROP FUNCTION IF EXISTS fn_total_sparepart_transaksi;

DELIMITER //

CREATE FUNCTION fn_total_sparepart_transaksi(
    p_id_transaksi VARCHAR(10)
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT SUM(subtotal_detail_sparepart)
    INTO total
    FROM detail_sparepart
    WHERE id_transaksi = p_id_transaksi;
    
    RETURN IFNULL(total, 0);
END //

DELIMITER ;

-- Contoh:
-- SELECT fn_total_sparepart_transaksi('TR001') AS Total_Sparepart;


-- 3. Fungsi untuk menghitung total biaya jasa
--    dalam sebuah transaksi

DROP FUNCTION IF EXISTS fn_total_jasa_transaksi;

DELIMITER //

CREATE FUNCTION fn_total_jasa_transaksi(
    p_id_transaksi VARCHAR(10)
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT SUM(subtotal_detail_jasa)
    INTO total
    FROM detail_servis
    WHERE id_transaksi = p_id_transaksi;
    
    RETURN IFNULL(total, 0);
END //

DELIMITER ;

-- untuk melihat salah satu hasil transaksi
SELECT fn_total_transaksi('TR001') + 1 AS Total_Transaksi_Plus_1;


-- FUNCTION
-- Buat function untuk menghitung rata-rata rating
-- berdasarkan mekanik (dari ulasan transaksi yang ditangani)
-- Parameter: id_mekanik
-- Mengembalikan rata-rata rating (DECIMAL)

-- Hapus function jika sudah ada
DROP FUNCTION IF EXISTS fn_rata_rata_ulasan_mekanik;

DELIMITER //

CREATE FUNCTION fn_rata_rata_ulasan_mekanik(
    p_id_mekanik VARCHAR(10)
)
RETURNS DECIMAL(3,2)
DETERMINISTIC
BEGIN
    DECLARE rata DECIMAL(3,2);
    
    SELECT AVG(u.rating)
    INTO rata
    FROM ulasan u
    JOIN transaksi t ON u.id_transaksi = t.id_transaksi
    WHERE t.id_mekanik = p_id_mekanik;
    
    -- Jika tidak ada ulasan, kembalikan 0
    RETURN IFNULL(rata, 0);
END //

DELIMITER ;

-- Contoh pemanggilan function untuk mekanik 'MK001'
SELECT fn_rata_rata_ulasan_mekanik('MK001') AS `Rata-rata Rating Mekanik MK001`;

-- Untuk mekanik 'MK005'
SELECT fn_rata_rata_ulasan_mekanik('MK005') AS `Rata-rata Rating Mekanik MK005`;

-- Untuk mekanik yang belum punya ulasan (misal 'MK002')
SELECT fn_rata_rata_ulasan_mekanik('MK002') AS `Rata-rata Rating Mekanik MK002`;