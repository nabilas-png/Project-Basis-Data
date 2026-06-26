USE db_bengkel;

DROP VIEW IF EXISTS vw_riwayat_servis;

CREATE VIEW vw_riwayat_servis AS
SELECT
    t.id_transaksi,
    p.nama_pelanggan,
    k.plat_nomor_kendaraan,
    k.merk_kendaraan,
    m.nama_mekanik,
    t.tanggal_servis,
    t.status_servis,
    byr.total_biaya
FROM transaksi t
JOIN pelanggan p
    ON t.id_pelanggan = p.id_pelanggan
JOIN kendaraan k
    ON t.id_kendaraan = k.id_kendaraan
JOIN mekanik m
    ON t.id_mekanik = m.id_mekanik
JOIN pembayaran byr
    ON t.id_pembayaran = byr.id_pembayaran;
SELECT * FROM vw_riwayat_servis;
DROP VIEW IF EXISTS vw_stok_sparepart;

CREATE VIEW vw_stok_sparepart AS
SELECT
    id_sparepart,
    nama_sparepart,
    harga_sparepart,
    stok_sparepart
FROM sparepart;
SELECT * FROM vw_stok_sparepart;
    
    