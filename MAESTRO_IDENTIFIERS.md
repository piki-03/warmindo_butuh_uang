# Panduan Maestro UI Testing & Daftar Tabel Identifier
**Aplikasi: Warmindo Butuh Uang (`com.example.warmindo_butuh_uang`)**

Dokumen ini berisi seluruh `Semantics.identifier` yang telah ditambahkan ke dalam aplikasi untuk keperluan otomatisasi pengujian UI dengan **Maestro**.

---

## 📌 Cara Penggunaan di Maestro Flow (YAML)

Di Maestro, elemen dengan `Semantics(identifier: '...')` dapat diakses langsung menggunakan atribut `id`:

```yaml
appId: com.example.warmindo_butuh_uang
---
- launchApp

# Klik tombol pilih meja
- tapOn:
    id: "meja_1"

# Isi input nama pemesan
- tapOn:
    id: "input_nama"
- inputText: "Budi Santoso"

# Lanjut masuk ke menu utama
- tapOn:
    id: "btn_lanjut_meja"

# Membuka menu & filter
- tapOn:
    id: "chip_kategori_indomie_kuah"

# Menambahkan menu ke keranjang
- tapOn:
    id: "btn_tambah_m1"
```

---

## 📋 Tabel Lengkap Identifier Maestro

### 1. Navigasi & Dialog Pemilihan Meja (`main_navigation_screen.dart`)

| Identifier | Tipe Elemen | Teks / Keterangan di Layar | Contoh Perintah Maestro |
| :--- | :--- | :--- | :--- |
| `dialog_selamat_datang` | Container | Judul dialog ("SELAMAT DATANG!", "Warmindo Butuh Uang") | `assertVisible: { id: "dialog_selamat_datang" }` |
| `btn_scan_qr` | Button | Tombol "SCAN QR DI MEJA" | `tapOn: { id: "btn_scan_qr" }` |
| `meja_1` s/d `meja_12` | Button / Select | Tombol nomor meja 1 s/d 12 | `tapOn: { id: "meja_3" }` |
| `input_nama` | TextField | Input nama kamu (opsional) | `tapOn: { id: "input_nama" }` |
| `btn_lanjut_meja` | Button | Tombol "Lanjut dengan Meja #..." | `tapOn: { id: "btn_lanjut_meja" }` |
| `nav_menu` | Nav Item | Tab navigasi bawah "Menu" | `tapOn: { id: "nav_menu" }` |
| `nav_keranjang` | Nav Item | Tab navigasi bawah "Keranjang" | `tapOn: { id: "nav_keranjang" }` |
| `nav_riwayat` | Nav Item | Tab navigasi bawah "Riwayat" | `tapOn: { id: "nav_riwayat" }` |
| `nav_profil` | Nav Item | Tab navigasi bawah "Profil" | `tapOn: { id: "nav_profil" }` |

---

### 2. Katalog Menu & Gacha (`catalog_screen.dart`)

| Identifier | Tipe Elemen | Teks / Keterangan di Layar | Contoh Perintah Maestro |
| :--- | :--- | :--- | :--- |
| `input_cari` | TextField | Kolom cari menu ("Cari Indomie, Nasi...") | `tapOn: { id: "input_cari" }` |
| `btn_buka_keranjang` | Button | Icon keranjang di AppBar (atas kanan) | `tapOn: { id: "btn_buka_keranjang" }` |
| `btn_gacha_menu` | Button | Tombol banner "PUTAR GACHA MENU" | `tapOn: { id: "btn_gacha_menu" }` |
| `btn_tolak_gacha` | Button | Tombol "Tolak Takdir" pada dialog gacha | `tapOn: { id: "btn_tolak_gacha" }` |
| `btn_ambil_gacha` | Button | Tombol "Ambil Ini!" pada dialog gacha | `tapOn: { id: "btn_ambil_gacha" }` |
| `chip_kategori_semua` | Filter Chip | Tab filter "Semua" | `tapOn: { id: "chip_kategori_semua" }` |
| `chip_kategori_indomie_goreng` | Filter Chip | Tab filter "Indomie Goreng" | `tapOn: { id: "chip_kategori_indomie_goreng" }` |
| `chip_kategori_indomie_kuah` | Filter Chip | Tab filter "Indomie Kuah" | `tapOn: { id: "chip_kategori_indomie_kuah" }` |
| `chip_kategori_nasi_lauk` | Filter Chip | Tab filter "Nasi & Lauk" | `tapOn: { id: "chip_kategori_nasi_lauk" }` |
| `chip_kategori_minuman_dingin` | Filter Chip | Tab filter "Minuman Dingin" | `tapOn: { id: "chip_kategori_minuman_dingin" }` |
| `chip_kategori_minuman_hangat` | Filter Chip | Tab filter "Minuman Hangat" | `tapOn: { id: "chip_kategori_minuman_hangat" }` |
| `chip_kategori_camilan_roti` | Filter Chip | Tab filter "Camilan/Roti" | `tapOn: { id: "chip_kategori_camilan_roti" }` |
| `card_menu_<id>` *(cth: `card_menu_m1`)* | Card / Button | Kartu menu Indomie / Minuman / Nasi | `tapOn: { id: "card_menu_m1" }` |
| `btn_tambah_<id>` *(cth: `btn_tambah_m1`)* | Button | Tombol "+ RACIK" atau "+ PESAN" | `tapOn: { id: "btn_tambah_m1" }` |

> **Daftar ID Menu bawaan**:
> - `m1`: Indomie Goreng Original + Telur
> - `m2`: Indomie Goreng Aceh Pedas
> - `m3`: Indomie Kuah Soto Medan
> - `m4`: Indomie Kuah Kari Ayam Nyemek
> - `m5`: Nasi Magelangan (Nasi Goreng Mie)
> - `m6`: Nasi Sarden Saus Tomat
> - `m7`: Es Teh Manis Jumbo
> - `m8`: Es Nutrisari Jeruk Peras
> - `m9`: Extra Joss Susu (JOSSU)
> - `m10`: Kopi Hitam Tubruk Warkop
> - `m11`: Roti Bakar Cokelat Keju Susu

---

### 3. Kustomisasi Indomie (`indomie_customizer_sheet.dart`)

| Identifier | Tipe Elemen | Teks / Keterangan di Layar | Contoh Perintah Maestro |
| :--- | :--- | :--- | :--- |
| `chip_kematangan_kering_standar` | ChoiceChip | Kematangan: "Kering / Standar" | `tapOn: { id: "chip_kematangan_kering_standar" }` |
| `chip_kematangan_nyemek` | ChoiceChip | Kematangan: "Nyemek" | `tapOn: { id: "chip_kematangan_nyemek" }` |
| `chip_kematangan_lembek` | ChoiceChip | Kematangan: "Lembek" | `tapOn: { id: "chip_kematangan_lembek" }` |
| `chip_telur_tanpa_telur` | ChoiceChip | Olahan Telur: "Tanpa Telur" | `tapOn: { id: "chip_telur_tanpa_telur" }` |
| `chip_telur_ceplok_matang` | ChoiceChip | Olahan Telur: "Ceplok Matang" | `tapOn: { id: "chip_telur_ceplok_matang" }` |
| `chip_telur_ceplok_1_2_matang` | ChoiceChip | Olahan Telur: "Ceplok 1/2 Matang" | `tapOn: { id: "chip_telur_ceplok_1_2_matang" }` |
| `chip_telur_dadar` | ChoiceChip | Olahan Telur: "Dadar" | `tapOn: { id: "chip_telur_dadar" }` |
| `slider_level_pedas` | Slider | Slider kepedasan cabe rawit (0-15 cabe) | `swipe: { direction: RIGHT, element: { id: "slider_level_pedas" } }` |
| `chip_topping_kornet` | FilterChip | Topping: "Kornet" (+Rp 4.000) | `tapOn: { id: "chip_topping_kornet" }` |
| `chip_topping_keju` | FilterChip | Topping: "Keju" (+Rp 3.000) | `tapOn: { id: "chip_topping_keju" }` |
| `chip_topping_sosis` | FilterChip | Topping: "Sosis" (+Rp 3.000) | `tapOn: { id: "chip_topping_sosis" }` |
| `chip_topping_bakso` | FilterChip | Topping: "Bakso" (+Rp 3.000) | `tapOn: { id: "chip_topping_bakso" }` |
| `input_catatan_dapur` | TextField | Kolom catatan khusus untuk dapur | `tapOn: { id: "input_catatan_dapur" }` |
| `btn_tambah_keranjang` | Button | Tombol "MASUKKAN KERANJANG" | `tapOn: { id: "btn_tambah_keranjang" }` |

---

### 4. Keranjang Belanja (`cart_screen.dart`)

| Identifier | Tipe Elemen | Teks / Keterangan di Layar | Contoh Perintah Maestro |
| :--- | :--- | :--- | :--- |
| `btn_lihat_menu` | Button | Tombol "LIHAT DAFTAR MENU" (saat keranjang kosong) | `tapOn: { id: "btn_lihat_menu" }` |
| `btn_hapus_semua` | Button | Tombol "Hapus Semua" di AppBar keranjang | `tapOn: { id: "btn_hapus_semua" }` |
| `card_keranjang_<id>` | Container | Kartu item dalam keranjang | `assertVisible: { id: "card_keranjang_..." }` |
| `btn_kurang_qty_<id>` | Button | Tombol (-) kurangi kuantitas item | `tapOn: { id: "btn_kurang_qty_..." }` |
| `txt_qty_<id>` | Text | Angka kuantitas item | `assertVisible: { id: "txt_qty_..." }` |
| `btn_tambah_qty_<id>` | Button | Tombol (+) tambah kuantitas item | `tapOn: { id: "btn_tambah_qty_..." }` |
| `btn_tambah_gorengan` | Button | Tombol "+ GORENGAN" (fitur comot gorengan) | `tapOn: { id: "btn_tambah_gorengan" }` |
| `chip_tip_0` | ChoiceChip | Tip: "Ikhlas Doa (Rp 0)" | `tapOn: { id: "chip_tip_0" }` |
| `chip_tip_1000` | ChoiceChip | Tip: "+Rp 1.000" | `tapOn: { id: "chip_tip_1000" }` |
| `chip_tip_2000` | ChoiceChip | Tip: "+Rp 2.000" | `tapOn: { id: "chip_tip_2000" }` |
| `chip_tip_5000` | ChoiceChip | Tip: "+Rp 5.000" | `tapOn: { id: "chip_tip_5000" }` |
| `txt_total_harga` | Text | Total pembayaran (cth: "Rp 24.000") | `assertVisible: { id: "txt_total_harga" }` |
| `btn_kirim_pesanan` | Button | Tombol utama "KIRIM PESANAN KE DAPUR" | `tapOn: { id: "btn_kirim_pesanan" }` |
| `btn_kembali_ke_menu` | Button | Tombol "KEMBALI KE MENU" di dialog konfirmasi sukses | `tapOn: { id: "btn_kembali_ke_menu" }` |

---

### 5. Status Pesanan Meja (`order_status_screen.dart`)

| Identifier | Tipe Elemen | Teks / Keterangan di Layar | Contoh Perintah Maestro |
| :--- | :--- | :--- | :--- |
| `card_pesanan_<id>` | Container | Kartu pesanan meja (misal: `card_pesanan_ORD-101`) | `assertVisible: { id: "card_pesanan_ORD-101" }` |
| `status_pesanan_<id>` | Badge | Status pesanan ("Antrean Baru", "Dimasak", dll.) | `assertVisible: { id: "status_pesanan_ORD-101" }` |
| `txt_total_pesanan_<id>` | Text | Teks item & total harga pesanan | `assertVisible: { id: "txt_total_pesanan_ORD-101" }` |
| `status_step_pesanan_diterima` | Timeline Step | Langkah 1: "Pesanan Diterima" | `assertVisible: { id: "status_step_pesanan_diterima" }` |
| `status_step_menunggu_diproses` | Timeline Step | Langkah 2: "Menunggu Diproses" | `assertVisible: { id: "status_step_menunggu_diproses" }` |
| `status_step_sedang_dimasak` | Timeline Step | Langkah 3: "Sedang Dimasak" | `assertVisible: { id: "status_step_sedang_dimasak" }` |
| `status_step_siap_diantar` | Timeline Step | Langkah 4: "Siap Diantar" | `assertVisible: { id: "status_step_siap_diantar" }` |
| `status_step_selesai_lunas` | Timeline Step | Langkah 5: "Selesai & Lunas" | `assertVisible: { id: "status_step_selesai_lunas" }` |

---

### 6. Riwayat Pesanan (`order_history_screen.dart`)

| Identifier | Tipe Elemen | Teks / Keterangan di Layar | Contoh Perintah Maestro |
| :--- | :--- | :--- | :--- |
| `card_riwayat_<id>` | Container | Kartu riwayat pesanan (misal: `card_riwayat_ORD-101`) | `assertVisible: { id: "card_riwayat_ORD-101" }` |
| `status_riwayat_<id>` | Badge | Label badge status riwayat | `assertVisible: { id: "status_riwayat_ORD-101" }` |
| `txt_total_riwayat_<id>` | Text | Teks total harga pesanan riwayat | `assertVisible: { id: "txt_total_riwayat_ORD-101" }` |

---

### 7. Profil & Akses Staff Dapur (`profile_screen.dart`)

| Identifier | Tipe Elemen | Teks / Keterangan di Layar | Contoh Perintah Maestro |
| :--- | :--- | :--- | :--- |
| `btn_buka_login_admin` | Button | Tombol "LOGIN ADMIN" (pada gerbang login) | `tapOn: { id: "btn_buka_login_admin" }` |
| `btn_logout_admin` | Button | Icon logout di AppBar profil admin | `tapOn: { id: "btn_logout_admin" }` |
| `btn_batal_logout` | Button | Tombol "Batal" pada dialog logout | `tapOn: { id: "btn_batal_logout" }` |
| `btn_konfirmasi_logout` | Button | Tombol "LOGOUT" konfirmasi keluar | `tapOn: { id: "btn_konfirmasi_logout" }` |
| `btn_avatar_0` s/d `btn_avatar_5` | Button | Pilihan avatar (🍜, 🍳, ☕, 🌶️, 🥟, 🥤) | `tapOn: { id: "btn_avatar_1" }` |
| `btn_masuk_kds` | Button | Tombol "MASUK MODE DAPUR WARMINDO BUTUH UANG (KDS)" | `tapOn: { id: "btn_masuk_kds" }` |
| `input_pin_staff` | TextField | Input dialog PIN staff dapur (Default PIN: 1234) | `tapOn: { id: "input_pin_staff" }` |
| `btn_batal_pin` | Button | Tombol "Batal" pada dialog PIN staff | `tapOn: { id: "btn_batal_pin" }` |
| `btn_konfirmasi_pin` | Button | Tombol "MASUK DAPUR" pada dialog PIN staff | `tapOn: { id: "btn_konfirmasi_pin" }` |

---

### 8. Pemindai QR Meja (`qr_scanner_screen.dart`)

| Identifier | Tipe Elemen | Teks / Keterangan di Layar | Contoh Perintah Maestro |
| :--- | :--- | :--- | :--- |
| `btn_kembali_scanner` | Button | Tombol icon kembali di AppBar scanner | `tapOn: { id: "btn_kembali_scanner" }` |
| `btn_toggle_flash` | Button | Tombol icon flash on/off | `tapOn: { id: "btn_toggle_flash" }` |
| `btn_flip_camera` | Button | Tombol ganti kamera depan/belakang | `tapOn: { id: "btn_flip_camera" }` |
| `btn_pilih_meja_manual` | Button | Teks tombol "Pilih meja manual" | `tapOn: { id: "btn_pilih_meja_manual" }` |
| `btn_lihat_menu_qr` | Button | Tombol "LIHAT MENU 🍜" di dialog sukses deteksi QR | `tapOn: { id: "btn_lihat_menu_qr" }` |

---

### 9. Halaman Login Admin (`admin_login_screen.dart`)

| Identifier | Tipe Elemen | Teks / Keterangan di Layar | Contoh Perintah Maestro |
| :--- | :--- | :--- | :--- |
| `btn_kembali_login` | Button | Tombol icon kembali di AppBar login | `tapOn: { id: "btn_kembali_login" }` |
| `input_email_admin` | TextField | Field input "Email Admin" | `tapOn: { id: "input_email_admin" }` |
| `input_password_admin` | TextField | Field input "Password" | `tapOn: { id: "input_password_admin" }` |
| `btn_toggle_password` | Button | Icon mata (lihat/sembunyikan password) | `tapOn: { id: "btn_toggle_password" }` |
| `btn_submit_login` | Button | Tombol "MASUK SEBAGAI ADMIN" | `tapOn: { id: "btn_submit_login" }` |

---

### 10. Layar Dapur / Kitchen Display System (`kitchen_display_screen.dart`)

| Identifier | Tipe Elemen | Teks / Keterangan di Layar | Contoh Perintah Maestro |
| :--- | :--- | :--- | :--- |
| `chip_filter_kds_semua` | Filter Chip | Tab "Semua Antrean" di layar dapur | `tapOn: { id: "chip_filter_kds_semua" }` |
| `chip_filter_kds_pending` | Filter Chip | Tab antrean "Menunggu" | `tapOn: { id: "chip_filter_kds_pending" }` |
| `chip_filter_kds_cooking` | Filter Chip | Tab antrean "Dimasak" | `tapOn: { id: "chip_filter_kds_cooking" }` |
| `chip_filter_kds_ready` | Filter Chip | Tab antrean "Siap Antar" | `tapOn: { id: "chip_filter_kds_ready" }` |
| `card_kds_<id>` | Container | Kartu antrean pesanan di dapur (misal: `card_kds_ORD-101`) | `assertVisible: { id: "card_kds_ORD-101" }` |
| `btn_aksi_kds_<id>` | Button | Tombol aksi juru masak ("MULAI MASAK DI WAJAN", dll.) | `tapOn: { id: "btn_aksi_kds_ORD-101" }` |

