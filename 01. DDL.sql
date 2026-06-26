CREATE DATABASE IF NOT EXISTS db_bengkel;
USE db_bengkel;

-- TAHAP 1: Tabel independen (tidak punya FK)
CREATE TABLE pelanggan (
    id_pelanggan        VARCHAR(10)  NOT NULL,
    nama_pelanggan      VARCHAR(100) NOT NULL,
    alamat              VARCHAR(150),
    nomor_hp            VARCHAR(15)  NOT NULL,
    email_pelanggan     VARCHAR(100),
    PRIMARY KEY (id_pelanggan)
);

CREATE TABLE kendaraan (
    id_kendaraan         VARCHAR(10) NOT NULL,
    plat_nomor_kendaraan VARCHAR(15) NOT NULL,
    merk_kendaraan       VARCHAR(50) NOT NULL,
    tipe_kendaraan       VARCHAR(50) NOT NULL,
    tahun_kendaraan      YEAR        NOT NULL,
    warna_kendaraan      VARCHAR(30),
    PRIMARY KEY (id_kendaraan)
);

CREATE TABLE mekanik (
    id_mekanik           VARCHAR(10)  NOT NULL,
    nama_mekanik         VARCHAR(100) NOT NULL,
    spesialisasi         VARCHAR(50),
    nomor_hp_mekanik     VARCHAR(15)  NOT NULL,
    alamat_mekanik       VARCHAR(150),
    status_mekanik       VARCHAR(20)  NOT NULL DEFAULT 'Aktif',
    PRIMARY KEY (id_mekanik)
);

CREATE TABLE admin (
    id_admin             VARCHAR(10) NOT NULL,
    nama_admin           VARCHAR(100) NOT NULL,
    username_admin       VARCHAR(50)  NOT NULL,
    pasword_admin        VARCHAR(50)  NOT NULL,
    nomor_hp_admin       VARCHAR(15)  NOT NULL,
    PRIMARY KEY (id_admin)
);

CREATE TABLE supplier (
    id_supplier          VARCHAR(10)  NOT NULL,
    nama_supplier        VARCHAR(100) NOT NULL,
    alamat_supplier      VARCHAR(150),
    email_supplier       VARCHAR(100),
    PRIMARY KEY (id_supplier)
);

CREATE TABLE jasa (
    id_jasa              VARCHAR(10)  NOT NULL,
    nama_jasa            VARCHAR(100) NOT NULL,
    deskripsi_jasa       VARCHAR(200),
    harga_jasa_servis    INT          NOT NULL,
    durasi_servis        VARCHAR(20),
    PRIMARY KEY (id_jasa)
);

CREATE TABLE sparepart (
    id_sparepart         VARCHAR(10)  NOT NULL,
    nama_sparepart       VARCHAR(100) NOT NULL,
    harga_sparepart      INT          NOT NULL DEFAULT 0,
    stok_sparepart       INT          NOT NULL DEFAULT 0,
    PRIMARY KEY (id_sparepart)
);

-- TAHAP 2: Tabel transaksi → dibuat TANPA FK ke pembayaran dulu
-- (karena pembayaran belum ada, dan pembayaran butuh transaksi)

CREATE TABLE transaksi (
    id_transaksi         VARCHAR(10)  NOT NULL,
    id_pelanggan         VARCHAR(10)  NOT NULL,
    id_kendaraan         VARCHAR(10)  NOT NULL,
    id_mekanik           VARCHAR(10)  NOT NULL,
    id_admin             VARCHAR(10)  NOT NULL,
    id_supplier          VARCHAR(10)  NOT NULL,
    id_pembayaran        VARCHAR(10),              -- nullable dulu, FK ditambah nanti
    tanggal_servis       DATE         NOT NULL,
    keluhan_pelanggan    VARCHAR(255),
    status_servis        VARCHAR(30)  NOT NULL DEFAULT 'Selesai',
    PRIMARY KEY (id_transaksi),
    FOREIGN KEY (id_pelanggan)  REFERENCES pelanggan(id_pelanggan),
    FOREIGN KEY (id_kendaraan)  REFERENCES kendaraan(id_kendaraan),
    FOREIGN KEY (id_mekanik)    REFERENCES mekanik(id_mekanik),
    FOREIGN KEY (id_admin)      REFERENCES admin(id_admin),
    FOREIGN KEY (id_supplier)   REFERENCES supplier(id_supplier)
    -- FK ke pembayaran ditambahkan nanti via ALTER TABLE
);

-- TAHAP 3: Tabel pembayaran → sekarang bisa dibuat karena transaksi sudah ada
CREATE TABLE pembayaran (
    id_pembayaran        VARCHAR(10) NOT NULL,
    id_transaksi         VARCHAR(10) NOT NULL,
    metode_pembayaran    VARCHAR(30) NOT NULL,
    tanggal_bayar        DATE        NOT NULL,
    total_biaya          INT         NOT NULL,
    PRIMARY KEY (id_pembayaran),
    FOREIGN KEY (id_transaksi) REFERENCES transaksi(id_transaksi)
);

-- TAHAP 4: Setelah pembayaran ada, baru tambahkan FK ke pembayaran di tabel transaksi via ALTER TABLE
ALTER TABLE transaksi
    ADD CONSTRAINT fk_transaksi_pembayaran
    FOREIGN KEY (id_pembayaran) REFERENCES pembayaran(id_pembayaran);

-- TAHAP 5: Tabel detail (FK ke transaksi, jasa, sparepart)
CREATE TABLE detail_servis (
    id_detail_servis     VARCHAR(10) NOT NULL,
    id_transaksi         VARCHAR(10) NOT NULL,
    id_jasa              VARCHAR(10) NOT NULL,
    subtotal_detail_jasa INT         NOT NULL,
    PRIMARY KEY (id_detail_servis),
    FOREIGN KEY (id_transaksi) REFERENCES transaksi(id_transaksi),
    FOREIGN KEY (id_jasa)      REFERENCES jasa(id_jasa)
);

CREATE TABLE detail_sparepart (
    id_detail_sparepart           VARCHAR(10) NOT NULL,
    id_transaksi                  VARCHAR(10) NOT NULL,
    id_sparepart                  VARCHAR(10) NOT NULL,
    jumlah_sparepart              INT         NOT NULL DEFAULT 0,
    harga_satuan_detail_sparepart INT         NOT NULL DEFAULT 0,
    subtotal_detail_sparepart     INT         NOT NULL DEFAULT 0,
    total_pembelian               INT         NOT NULL DEFAULT 0,
    PRIMARY KEY (id_detail_sparepart),
    FOREIGN KEY (id_transaksi)  REFERENCES transaksi(id_transaksi),
    FOREIGN KEY (id_sparepart)  REFERENCES sparepart(id_sparepart)
);