USE db_bengkel;

-- TRIGGER
-- Buat tabel ULASAN untuk menampung review pelanggan
--       terhadap transaksi. Buat BEFORE UPDATE TRIGGER untuk
--       memvalidasi rating (1-5).

DROP TABLE IF EXISTS ulasan;

CREATE TABLE ulasan (
    id_ulasan       VARCHAR(10) NOT NULL,
    id_transaksi    VARCHAR(10) NOT NULL,
    rating          INT         NOT NULL,   -- 1-5
    komentar        VARCHAR(255),
    tanggal_ulasan  DATE        NOT NULL,
    PRIMARY KEY (id_ulasan),
    FOREIGN KEY (id_transaksi) REFERENCES transaksi(id_transaksi)
);

INSERT INTO ulasan (id_ulasan, id_transaksi, rating, komentar, tanggal_ulasan) VALUES
('ULS001', 'TR001', 5, 'Pelayanan sangat baik, mekanik profesional.', '2024-07-04'),
('ULS002', 'TR002', 4, 'Cukup memuaskan, namun waktu pengerjaan agak lama.', '2024-07-08'),
('ULS003', 'TR003', 3, 'Standar, tidak ada masalah.', '2024-07-11'),
('ULS004', 'TR004', 5, 'AC mobil dingin kembali, terima kasih.', '2024-07-17'),
('ULS005', 'TR005', 2, 'Kurang puas, mesin masih terasa berat.', '2024-07-18');

-- Buat TRIGGER BEFORE UPDATE untuk validasi rating
DROP TRIGGER IF EXISTS before_update_ulasan;

DELIMITER //

CREATE TRIGGER before_update_ulasan
BEFORE UPDATE ON ulasan
FOR EACH ROW
BEGIN
    -- Validasi rating harus antara 1 dan 5
    IF NEW.rating < 1 OR NEW.rating > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Rating harus berada pada rentang 1 sampai 5.';
    END IF;
END //

DELIMITER ;

-- 3d. Uji coba trigger
-- Perubahan dengan rating valid (4)
UPDATE ulasan SET rating = 4, komentar = 'Revisi: cukup baik'
WHERE id_ulasan = 'ULS005';

-- Perubahan dengan rating tidak valid (6) - akan menghasilkan error
-- UPDATE ulasan SET rating = 6 WHERE id_ulasan = 'ULS005';  -- uncomment untuk test

-- Tampilkan data ulasan setelah update
SELECT * FROM ulasan;

-- Penjelasan:
-- Trigger ini memastikan setiap perubahan rating selalu dalam rentang 1-5.
-- Jika rating di luar rentang, transaksi akan dibatalkan dan muncul pesan error.


