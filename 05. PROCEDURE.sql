USE db_bengkel;

-- ============================================================
-- STORED PROCEDURE
-- Menampilkan riwayat transaksi berdasarkan ID pelanggan
-- Parameter : ID Pelanggan
-- ============================================================

DROP PROCEDURE IF EXISTS sp_riwayat_pelanggan;

DELIMITER //

CREATE PROCEDURE sp_riwayat_pelanggan(
    IN p_id_pelanggan VARCHAR(10)
)
BEGIN

    SELECT
        p.id_pelanggan,
        p.nama_pelanggan,
        k.plat_nomor_kendaraan,
        k.merk_kendaraan,
        m.nama_mekanik,
        t.id_transaksi,
        t.tanggal_servis,
        t.status_servis,
        byr.metode_pembayaran,
        byr.total_biaya
    FROM transaksi t
        JOIN pelanggan p
            ON t.id_pelanggan = p.id_pelanggan
        JOIN kendaraan k
            ON t.id_kendaraan = k.id_kendaraan
        JOIN mekanik m
            ON t.id_mekanik = m.id_mekanik
        JOIN pembayaran byr
            ON t.id_pembayaran = byr.id_pembayaran
    WHERE p.id_pelanggan = p_id_pelanggan
    ORDER BY t.tanggal_servis DESC;

END //

DELIMITER ;

-- ============================================================
-- Contoh Pemanggilan Procedure
-- ============================================================

CALL sp_riwayat_pelanggan('PL001');
CALL sp_riwayat_pelanggan('PL005');
CALL sp_riwayat_pelanggan('PL010');