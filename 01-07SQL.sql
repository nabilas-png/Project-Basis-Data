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

-- 1. INSERT DATA MASTER (tidak punya FK)
-- Pelanggan (20 data)
INSERT INTO pelanggan VALUES
('PL001','Ahmad Fauzi','Jl. Anggrek No.5, Semarang','08112300001','ahmad.fauzi@gmail.com'),
('PL002','Rina Maharani','Jl. Melati No.12, Solo','08112300002','bambang.sulistyo@yahoo.com'),
('PL003','Bambang Sulistyo','Jl. Kenanga No.3, Purwokerto','08112300003','hendra.kurniawan@gmail.com'),
('PL004','Sari Indahwati','Jl. Mawar No.7, Klaten','081123000004','doni.hermawan@yahoo.com'),
('PL005','Hendra Kurniawan','Jl. Dahlia No.9, Magelang','081123000005','wahyu.nugroho@gmail.com'),
('PL006','Yuli Astuti','Jl. Seroja No.14, Kudus','081123000006','eko.purnomo@yahoo.com'),
('PL007','Doni Hermawan','Jl. Flamboyan No.2, Pekalongan','081123000007','fajar.setiawan@gmail.com'),
('PL008','Fitri Handayani','Jl. Bougenville No.18, Tegal','081123000008','rizal.aditya@yahoo.com'),
('PL009','Wahyu Nugroho','Jl. Cempaka No.6, Jepara','081123000009','heni.purwaningsih@gmail.com'),
('PL010','Novi Susanti','Jl. Tulip No.11, Boyolali','081123000010','irfan.maulana@yahoo.com'),
('PL011','Eko Purnomo','Jl. Angsana No.4, Blora','081123000011','ahmad.fauzi@gmail.com'),
('PL012','Lina Wulandari','Jl. Akasia No.20, Rembang','081123000012','bambang.sulistyo@yahoo.com'),
('PL013','Fajar Setiawan','Jl. Beringin No.1, Demak','081123000013','hendra.kurniawan@gmail.com'),
('PL014','Mega Lestari','Jl. Cemara No.8, Salatiga','081123000014','doni.hermawan@yahoo.com'),
('PL015','Rizal Aditya','Jl. Durian No.15, Kendal','081123000015','wahyu.nugroho@gmail.com'),
('PL016','Tika Permatasari','Jl. Enau No.3, Batang','081123000016','lina.wulandari@gmail.com'),
('PL017','Galih Pradana','Jl. Flamboyan No.22, Brebes','081123000017','mega.lestari@gmail.com'),
('PL018','Heni Purwaningsih','Jl. Glugu No.10, Cilacap','081123000018','rizal.aditya@yahoo.com'),
('PL019','Irfan Maulana','Jl. Nangka No.5, Banyumas','081123000019','galih.pradana@gmail.com'),
('PL020','Jasmine Cahyani','Jl. Jambu No.17, Purbalingga','081123000020','jasmine.cahyani@gmail.com');

-- Kendaraan (20 data)
INSERT INTO kendaraan VALUES
('KD001','H 1234 AB','Honda','Beat',2021,'Hitam'),
('KD002','H 8877 KL','Yamaha','NMAX',2020,'Merah'),
('KD003','K 2211 ZX','Honda','Vario 125',2018,'Silver'),
('KD004','AA 8899 FG','Toyota','Avanza',2020,'Abu-abu'),
('KD005','AD 5678 RT','Daihatsu','Xenia',2024,'Putih'),
('KD006','G 3456 QW','Honda','Brio',2017,'Hitam'),
('KD007','R 7712 LM','Suzuki','Ertiga',2022,'Merah'),
('KD008','H 2345 CD','Yamaha','Aerox',2023,'Biru'),
('KD009','H 9988 MN','Honda','PCX 160',2018,'Putih'),
('KD010','K 3322 YZ','Toyota','Calya',2020,'Abu-abu'),
('KD011','AA 7766 EF','Toyota','Avanza',2021,'Hitam'),
('KD012','AD 1122 ST','Daihatsu','Xenia',2020,'Merah'),
('KD013','G 5544 WE','Honda','Brio',2018,'Silver'),
('KD014','R 4411 PQ','Suzuki','Ertiga',2020,'Abu-abu'),
('KD015','H 3456 EF','Yamaha','Aerox',2024,'Putih'),
('KD016','H 7654 GH','Honda','PCX 160',2019,'Putih'),
('KD017','K 4433 XY','Toyota','Calya',2020,'Abu-abu'),
('KD018','AA 5566 HI','Toyota','Avanza',2023,'Biru'),
('KD019','AD 9900 UV','Daihatsu','Xenia',2021,'Silver'),
('KD020','G 1122 QR','Honda','Brio',2023,'Merah');

-- Mekanik (20 data)
INSERT INTO mekanik VALUES
('MK001','Supriadi','Kaki-kaki','081311110011','Jl. Kenari No.12 Semarang','Aktif'),
('MK002','Agung Triyono','Mesin','081311110014','Jl. Cemara No.6 Pekalongan','Aktif'),
('MK003','Nanang Susilo','AC Mobil','081311110017','Jl. Durian No.7 Salatiga','Tidak Aktif'),
('MK004','Hendro Wibowo','CVT','081311110020','Jl. Sawo No.16 Purbalingga','Aktif'),
('MK005','Sarwono','Injeksi','081311110003','Jl. Dahlia No.20 Magelang','Aktif'),
('MK006','Aris Munandar','Kaki-kaki','081311110006','Jl. Akasia No.9 Blora','Aktif'),
('MK007','Bagus Santosa','Mesin','081311110009','Jl. Nangka No.12 Cilacap','Aktif'),
('MK008','Cahyo Prabowo','AC Mobil','081311110012','Jl. Anggrek No.15 Purwokerto','Cuti'),
('MK009','Darmawan','CVT','081311110015','Jl. Cempaka No.5 Jepara','Aktif'),
('MK010','Eko Aryanto','Injeksi','081311110018','Jl. Enau No.14 Kendal','Aktif'),
('MK011','Firdaus Ramadhan','CVT','081311110001','Jl. Kenari No.12 Semarang','Aktif'),
('MK012','Guntur Prasetyo','Mesin','081311110004','Jl. Cemara No.6 Pekalongan','Aktif'),
('MK013','Haryo Utomo','AC Mobil','081311110007','Jl. Beringin No.11 Demak','Aktif'),
('MK014','Ivan Setyawan','CVT','081311110010','Jl. Rambutan No.4 Banyumas','Aktif'),
('MK015','Jatmiko','Injeksi','081311110013','Jl. Dahlia No.20 Magelang','Aktif'),
('MK016','Krisna Adi','Kaki-kaki','081311110016','Jl. Angsana No.3 Rembang','Aktif'),
('MK017','Luqman Hamdani','Mesin','081311110019','Jl. Jambu No.5 Brebes','Cuti'),
('MK018','Marjono','Kaki-kaki','081311110002','Jl. Anggrek No.15 Purwokerto','Aktif'),
('MK019','Nurhadi','CVT','081311110005','Jl. Cempaka No.5 Jepara','Aktif'),
('MK020','Okky Pratama','Injeksi','081311110008','Jl. Enau No.14 Kendal','Aktif');

-- Admin (5 data)
INSERT INTO admin VALUES
('AD001','Andi Saputra','andi_admin','andi123','081234560001'),
('AD002','Budi Hartono','budi_admin','budi123','081234560002'),
('AD003','Citra Maharani','citra_admin','citra123','081234560003'),
('AD004','Dwi Kurniawan','dwi_admin','dwi123','081234560004'),
('AD005','Eka Prasetyo','eka_admin','eka123','081234560005');

-- Supplier (8 data)
INSERT INTO supplier VALUES
('SP001','PT Nusantara Otomotif','Jl. Veteran No.8 Yogyakarta','supplier01@autopartsjaya.com'),
('SP002','CV Berkah Otomotif','Jl. Pemuda No.7 Yogyakarta','supplier02@majumotor.co.id'),
('SP003','PT Sinar Motor','Jl. Sudirman No.30 Surabaya','supplier03@sumberonderdil.com'),
('SP004','PT Sumber Motor','Jl. Industri No.1 Semarang','supplier04@berkahsparepart.id'),
('SP005','PT Auto Parts Indonesia','Jl. Diponegoro No.10 Surabaya','supplier05@mitraotomotif.co.id'),
('SP006','PT Sinar Motor','Jl. Sudirman No.30 Surabaya','supplier06@primaautopart.com'),
('SP007','PT Sumber Motor','Jl. Industri No.1 Semarang','supplier07@sentosamotor.id'),
('SP008','PT Nusantara Otomotif','Jl. Veteran No.8 Yogyakarta','supplier08@globalsparepart.co.id');

-- Jasa (19 data)
INSERT INTO jasa (id_jasa, nama_jasa, deskripsi_jasa, harga_jasa_servis, durasi_servis) VALUES
('J001','Servis CVT','Perawatan dan pemeriksaan sistem CVT',50000,NULL),
('J002','Ganti Roller CVT','Perawatan CVT dan penggantian komponen roller',100000,NULL),
('J003','Ganti Shockbreaker','Pemeriksaan sistem kelistrikan kendaraan',100000,NULL),
('J004','Spooring','Servis menyeluruh pada kendaraan',80000,NULL),
('J005','Servis Kelistrikan','Perawatan CVT dan penggantian komponen roller',100000,NULL),
('J006','Diagnosa Scanner','Penyeimbangan roda dan spooring',50000,NULL),
('J007','Servis Lengkap','Pembersihan dan perawatan AC mobil',150000,NULL),
('J008','Balancing','Servis dan pembersihan AC kendaraan',120000,NULL),
('J009','Servis AC Mobil','Pembersihan dan penyetelan karburator',125000,NULL),
('J010','Pembersihan Injektor','Perawatan berkala CVT kendaraan',350000,NULL),
('J011','Servis Ringan','Pembersihan throttle body dan scanner',75000,NULL),
('J012','Ganti Belt CVT','Perawatan serta servis sistem CVT',150000,NULL),
('J013','Ganti Kampas Rem','Perawatan dan pemeriksaan sistem CVT',100000,NULL),
('J014','Servis Rem Cakram','Perbaikan sistem suspensi dan spooring roda',90000,NULL),
('J015','Servis Karburator','Perawatan CVT dan penggantian komponen roller',85000,NULL),
('J016','Ganti Oli Mesin','Pembersihan dan perawatan AC mobil',50000,NULL),
('J017','Ganti Filter Oli','Pembersihan sistem injeksi bahan bakar',25000,NULL),
('J018','Pembersihan Throttle Body','Penggantian kampas rem',80000,NULL),
('J019','Tune Up Mesin','Perawatan sistem AC kendaraan',125000,NULL);

-- Sparepart (27 data)
INSERT INTO sparepart VALUES
('SPR001','Disc Brake Pad Honda PCX',95000,50),
('SPR002','Shockbreaker Belakang Yamaha NMAX',350000,50),
('SPR003','Filter Udara Avanza',60000,50),
('SPR004','Roller CVT Honda Vario 13g',45000,50),
('SPR005','Bearing Roda Depan Universal',65000,50),
('SPR006','-',0,0),
('SPR007','Castrol Magnatec 10W40 1L',85000,50),
('SPR008','Filter Oli Honda Brio',42000,50),
('SPR009','Filter Udara Yamaha NMAX',55000,50),
('SPR010','Roller CVT Yamaha NMAX 15g',50000,50),
('SPR011','Belt CVT Honda Beat',110000,50),
('SPR012','Filter Bensin Universal',35000,50),
('SPR013','NGK Iridium IX',65000,50),
('SPR014','Coolant Prestone 1L',55000,50),
('SPR015','Per Shockbreaker Avanza',150000,50),
('SPR016','Kampas Rem Aspira Belakang',48000,50),
('SPR017','Kampas Rem Federal Parts Belakang',52000,50),
('SPR018','Shell Helix HX7 1L',90000,50),
('SPR019','Motul 5100 10W40 1L',110000,50),
('SPR020','Minyak Rem DOT 4 500mL',40000,50),
('SPR021','AHM MPX 2 0.8L',38000,50),
('SPR022','Sekring Set Universal',15000,50),
('SPR023','Kampas Rem Aspira Depan',55000,50),
('SPR024','Bohlam Osram H7 55W',95000,50),
('SPR025','Federal Matic 0.8L',35000,50),
('SPR026','Oli Gardan Yamalube 140mL',20000,50),
('SPR027','Bohlam LED Motor 12V',45000,50);

-- 2. INSERT TRANSAKSI dengan id_pembayaran = NULL
INSERT INTO transaksi (id_transaksi, id_pelanggan, id_kendaraan, id_mekanik, id_admin, id_supplier, id_pembayaran, tanggal_servis, keluhan_pelanggan, status_servis) VALUES
('TR001','PL001','KD001','MK011','AD005','SP007',NULL,'2024-07-03','Motor terasa bergetar dan tarikan CVT kurang responsif','Selesai'),
('TR002','PL002','KD002','MK018','AD003','SP001',NULL,'2024-07-04','Lampu indikator mesin menyala dan kelistrikan bermasalah','Selesai'),
('TR003','PL003','KD003','MK005','AD001','SP005',NULL,'2024-07-07','CVT mengeluarkan suara berisik saat akselerasi','Selesai'),
('TR004','PL004','KD004','MK012','AD005','SP005',NULL,'2024-07-09','AC mobil tidak dingin dan berbau','Selesai'),
('TR005','PL005','KD005','MK019','AD001','SP006',NULL,'2024-07-10','Mesin kurang bertenaga saat digunakan','Selesai'),
('TR006','PL006','KD006','MK006','AD002','SP007',NULL,'2024-07-11','Rem kurang pakem dan terdengar suara gesekan','Selesai'),
('TR007','PL007','KD007','MK013','AD003','SP008',NULL,'2024-07-15','Mesin sulit dinyalakan saat pagi hari','Selesai'),
('TR008','PL008','KD008','MK020','AD004','SP001',NULL,'2024-07-16','CVT terasa berat saat akselerasi','Selesai'),
('TR009','PL009','KD009','MK007','AD005','SP002',NULL,'2024-07-17','Throttle body kotor dan mesin brebet','Selesai'),
('TR010','PL010','KD010','MK014','AD001','SP003',NULL,'2024-07-19','Konsumsi BBM meningkat dan tenaga berkurang','Dalam Proses'),
('TR011','PL011','KD011','MK001','AD002','SP004',NULL,'2024-07-20','Motor terasa bergetar dan tarikan CVT kurang responsif','Selesai'),
('TR012','PL012','KD012','MK008','AD003','SP005',NULL,'2024-07-22','Lampu indikator mesin menyala dan kelistrikan bermasalah','Selesai'),
('TR013','PL013','KD013','MK015','AD004','SP006',NULL,'2024-07-26','CVT mengeluarkan suara berisik saat akselerasi','Selesai'),
('TR014','PL014','KD014','MK002','AD005','SP007',NULL,'2024-07-29','AC mobil tidak dingin dan berbau','Selesai'),
('TR015','PL015','KD015','MK009','AD001','SP008',NULL,'2024-07-31','Mesin kurang bertenaga saat digunakan','Selesai'),
('TR016','PL016','KD016','MK016','AD002','SP001',NULL,'2024-08-03','AC mobil kurang dingin dari biasanya','Selesai'),
('TR017','PL017','KD017','MK003','AD003','SP002',NULL,'2024-08-05','Perlu servis berkala dan penggantian oli','Selesai'),
('TR018','PL018','KD018','MK010','AD004','SP003',NULL,'2024-08-08','CVT terasa berat saat akselerasi','Selesai'),
('TR019','PL019','KD019','MK017','AD005','SP004',NULL,'2024-08-09','AC mobil tidak dingin maksimal','Dalam Proses'),
('TR020','PL020','KD020','MK004','AD001','SP005',NULL,'2024-08-13','CVT berbunyi kasar saat kendaraan berjalan','Menunggu Sparepart');

-- 3. INSERT PEMBAYARAN (urutan kolom sudah diperbaiki)
INSERT INTO pembayaran (id_pembayaran, id_transaksi, metode_pembayaran, tanggal_bayar, total_biaya) VALUES
('BY001','TR001','Debit','2024-07-03',245000),
('BY002','TR002','Transfer','2024-07-07',530000),
('BY003','TR003','Debit','2024-07-10',210000),
('BY004','TR004','Transfer','2024-07-16',245000),
('BY005','TR005','Debit','2024-07-17',205000),
('BY006','TR006','Transfer','2024-07-20',245000),
('BY007','TR007','Debit','2024-07-26',1627000),
('BY008','TR008','Transfer','2024-08-01',565000),
('BY009','TR009','Debit','2024-08-08',110000),
('BY010','TR010','Transfer','2024-08-10',415000),
('BY011','TR011','Debit','2024-07-03',355000),
('BY012','TR012','Transfer','2024-07-07',208000),
('BY013','TR013','Debit','2024-07-10',285000),
('BY014','TR014','Transfer','2024-07-16',115000),
('BY015','TR015','Debit','2024-07-17',285000),
('BY016','TR016','Transfer','2024-07-22',305000),
('BY017','TR017','Debit','2024-07-29',220000),
('BY018','TR018','Transfer','2024-08-01',120000),
('BY019','TR019','Debit','2024-08-06',310000),
('BY020','TR020','Transfer','2024-08-14',195000);

-- 4. UPDATE TRANSAKSI dengan id_pembayaran yang sudah ada
UPDATE transaksi SET id_pembayaran = 'BY001' WHERE id_transaksi = 'TR001';
UPDATE transaksi SET id_pembayaran = 'BY002' WHERE id_transaksi = 'TR002';
UPDATE transaksi SET id_pembayaran = 'BY003' WHERE id_transaksi = 'TR003';
UPDATE transaksi SET id_pembayaran = 'BY004' WHERE id_transaksi = 'TR004';
UPDATE transaksi SET id_pembayaran = 'BY005' WHERE id_transaksi = 'TR005';
UPDATE transaksi SET id_pembayaran = 'BY006' WHERE id_transaksi = 'TR006';
UPDATE transaksi SET id_pembayaran = 'BY007' WHERE id_transaksi = 'TR007';
UPDATE transaksi SET id_pembayaran = 'BY008' WHERE id_transaksi = 'TR008';
UPDATE transaksi SET id_pembayaran = 'BY009' WHERE id_transaksi = 'TR009';
UPDATE transaksi SET id_pembayaran = 'BY010' WHERE id_transaksi = 'TR010';
UPDATE transaksi SET id_pembayaran = 'BY011' WHERE id_transaksi = 'TR011';
UPDATE transaksi SET id_pembayaran = 'BY012' WHERE id_transaksi = 'TR012';
UPDATE transaksi SET id_pembayaran = 'BY013' WHERE id_transaksi = 'TR013';
UPDATE transaksi SET id_pembayaran = 'BY014' WHERE id_transaksi = 'TR014';
UPDATE transaksi SET id_pembayaran = 'BY015' WHERE id_transaksi = 'TR015';
UPDATE transaksi SET id_pembayaran = 'BY016' WHERE id_transaksi = 'TR016';
UPDATE transaksi SET id_pembayaran = 'BY017' WHERE id_transaksi = 'TR017';
UPDATE transaksi SET id_pembayaran = 'BY018' WHERE id_transaksi = 'TR018';
UPDATE transaksi SET id_pembayaran = 'BY019' WHERE id_transaksi = 'TR019';
UPDATE transaksi SET id_pembayaran = 'BY020' WHERE id_transaksi = 'TR020';

-- 5. INSERT DETAIL_SERVIS (tanpa kolom durasi, ID unik DSV001–DSV040)
INSERT INTO detail_servis (id_detail_servis, id_transaksi, id_jasa, subtotal_detail_jasa) VALUES
('DSV001','TR001','J001',50000),
('DSV002','TR002','J003',100000),
('DSV003','TR002','J003',100000),   -- id_transaksi sama, jasa sama, tapi beda baris
('DSV004','TR002','J004',80000),
('DSV005','TR003','J005',100000),
('DSV006','TR003','J006',50000),
('DSV007','TR004','J007',150000),
('DSV008','TR004','J007',150000),
('DSV009','TR005','J002',100000),
('DSV010','TR005','J001',50000),
('DSV011','TR006','J004',80000),
('DSV012','TR006','J008',120000),
('DSV013','TR007','J009',125000),
('DSV014','TR007','J009',125000),
('DSV015','TR008','J010',350000),
('DSV016','TR008','J010',350000),
('DSV017','TR009','J011',75000),
('DSV018','TR010','J012',150000),
('DSV019','TR010','J001',50000),
('DSV020','TR011','J014',90000),
('DSV021','TR011','J013',100000),
('DSV022','TR012','J009',125000),
('DSV023','TR012','J009',125000),
('DSV024','TR013','J015',85000),
('DSV025','TR013','J015',85000),
('DSV026','TR014','J016',50000),
('DSV027','TR014','J017',25000),
('DSV028','TR015','J001',50000),
('DSV029','TR015','J001',50000),
('DSV030','TR015','J001',50000),
('DSV031','TR016','J013',100000),
('DSV032','TR016','J013',100000),
('DSV033','TR017','J009',125000),
('DSV034','TR018','J006',50000),
('DSV035','TR018','J018',80000),
('DSV036','TR019','J019',125000),
('DSV037','TR019','J006',50000),
('DSV038','TR019','J018',80000),
('DSV039','TR020','J002',100000),
('DSV040','TR020','J001',50000);

-- 6. INSERT DETAIL_SPAREPART 
INSERT INTO detail_sparepart VALUES
('DSP001','TR001','SPR001',1,95000,95000,95000),
('DSP002','TR002','SPR002',1,350000,350000,350000),
('DSP003','TR003','SPR003',1,60000,60000,60000),
('DSP004','TR004','SPR004',1,45000,45000,45000),
('DSP005','TR005','SPR005',1,65000,65000,65000),
('DSP006','TR006','SPR006',0,0,0,0),
('DSP007','TR007','SPR007',1,85000,85000,85000),
('DSP008','TR007','SPR008',1,42000,42000,42000),
('DSP009','TR008','SPR009',1,55000,55000,55000),
('DSP010','TR008','SPR010',1,50000,50000,50000),
('DSP011','TR008','SPR011',1,110000,110000,110000),
('DSP012','TR009','SPR012',1,35000,35000,35000),
('DSP013','TR010','SPR013',1,65000,65000,65000),
('DSP014','TR011','SPR014',1,55000,55000,55000),
('DSP015','TR011','SPR015',1,150000,150000,150000),
('DSP016','TR012','SPR016',2,48000,96000,96000),
('DSP017','TR012','SPR017',1,52000,52000,52000),
('DSP018','TR013','SPR018',1,90000,90000,90000),
('DSP019','TR013','SPR019',1,110000,110000,110000),
('DSP020','TR014','SPR020',1,40000,40000,40000),
('DSP021','TR015','SPR021',1,38000,38000,38000),
('DSP022','TR015','SPR008',1,42000,42000,42000),
('DSP023','TR015','SPR022',2,15000,30000,30000),
('DSP024','TR016','SPR023',2,55000,110000,110000),
('DSP025','TR016','SPR001',1,95000,95000,95000),
('DSP026','TR017','SPR024',1,95000,95000,95000),
('DSP027','TR018','SPR023',1,55000,55000,55000),
('DSP028','TR019','SPR025',1,35000,35000,35000),
('DSP029','TR019','SPR026',1,20000,20000,20000),
('DSP030','TR019','SPR006',0,0,0,0),
('DSP031','TR020','SPR027',1,45000,45000,45000);

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