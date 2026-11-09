# 🍜 WARMINDO BUTUH UANG (WBU) 🍜
> **Sistem Pemesanan Mandiri Meja & Kitchen Display System (KDS) Berbasis Flutter & Supabase**  
> *Proyek Aplikasi Mobile / Web untuk Pengujian Otomatis (Mobile Testing) & UMKM Kuliner Warkop*

---

## 📖 Tentang Proyek
**Warmindo Butuh Uang (WBU)** adalah aplikasi pemesanan kuliner modern yang dirancang khusus untuk memecahkan masalah operasional paling krusial di **Warmindo (Warung Makan Indomie / Warkop)**:
1. **Kustomisasi Pesanan Rumit**: Pelanggan memiliki preferensi spesifik (*mie nyemek/kering, jumlah cabe rawit ulek, telur dadar/setengah matang*). Saat warkop ramai tengah malam, pelayan sering keliru mencatat atau mengingat pesanan pelanggan.
2. **Keterlambatan Antrean**: Antrean di jam sibuk (malam hari) dapat dipangkas karena pelanggan langsung memesan dari meja tanpa menunggu pelayan datang membawa buku catatan kertas.
3. **Penyatuan Sistem (Dual-Role App)**: Mengintegrasikan antarmuka pelanggan meja dan **Layar Dapur Aa' Warmindo (KDS)** dalam satu aplikasi dengan proteksi PIN staff sederhana.
4. **Kesiapan UI Automated Testing (Maestro)**: Seluruh elemen interaktif telah diintegrasikan dengan accessibility tree (`Semantics.identifier`) sehingga siap diuji secara otomatis menggunakan **Maestro**.

---

## ✨ Fitur Unggulan

### 1. 🍜 Kustomisasi Indomie Ekstrem (Indomie Customizer Sheet)
- **Tingkat Kuah**: *Kering / Standar*, *Nyemek*, atau *Lembek*.
- **Pilihan Olahan Telur**: *Tanpa Telur*, *Ceplok Matang*, *Ceplok 1/2 Matang*, atau *Dadar*.
- **Slider Pedas Cabe Ulek**: Pilihan $0$ hingga $15$ cabai dengan indikator humor (*0 = Aman*, *5 = Keringetan*, *15 = Dewa Lambung*).
- **Topping Warkop**: *Kornet*, *Keju*, *Sosis*, *Bakso*, dan catatan khusus untuk koki.

### 2. 🎰 Fitur "Gacha Menu" (Solusi Pelanggan Galau)
- Tombol putar acak dengan animasi halus di katalog menu untuk merekomendasikan menu bagi pengunjung yang bingung mau makan apa.

### 3. 🥟 Fitur Cerdas: "Tambah Gorengan Mandiri"
- Tombol 1-klik di keranjang: `+ GORENGAN MEJA (Rp 1.500)` untuk pelanggan yang mencomot bakwan/tempe mendoan di meja makan agar langsung masuk tagihan.

### 4. ☕ Tip Kopi untuk Aa' Warmindo
- Opsi tip receh (Rp 1.000 / Rp 2.000 / Rp 5.000) yang selaras dengan nama unik aplikasi: *"Warmindo Butuh Uang"*.

### 5. 🎨 Profil Keren & Gamifikasi Anak Tongkrongan
- **Tipografi**: Kombinasi `Bebas Neue` (street-style & tegas) dan `Plus Jakarta Sans` (modern & rapi).
- **Pilihan Avatar**: Ikon mangkuk mie 🍜, telur 🍳, cangkir kopi ☕, cabai 🌶️, dll.
- **Pencapaian Unik**: Gelar *"Sultan Cabe 15"*, poin WBU, dan kutipan santai khas warkop.
- **Pintu Rahasia Staff Dapur**: Akses ke layar KDS menggunakan PIN: **`1234`**.

### 6. 🍳 Kitchen Display System (KDS) untuk Aa' Warmindo
- Kartu antrean wajan dapur dengan **Badge Kontras Tinggi** (*Merah untuk CABE 10*, *Kuning untuk TELUR 1/2 MATANG*, *Oranye untuk MIE NYEMEK*).
- Tombol pengubah status alur memasak: `Menunggu` $\rightarrow$ `Mulai Masak` $\rightarrow$ `Siap Diantar` $\rightarrow$ `Selesai & Lunas`.

---

## 🛠️ Tech Stack & Arsitektur

- **Framework**: Flutter (Channel Stable >= 3.19, Dart SDK >= 3.0)
- **State Management**: `flutter_riverpod` (v2.x)
- **Database & Realtime**: `supabase_flutter` (PostgreSQL Realtime Channel + Offline Mock Fallback)
- **Desain & Tipografi**: `google_fonts` + Font Lokal (`Bebas Neue` & `Plus Jakarta Sans`)
- **Animasi**: `flutter_animate` (Transisi staggered, scale, fade, pulse 60/120 FPS)
- **Formatting**: `intl` (Format Rupiah `Rp 15.000` & tanggal lokal)
- **Image Caching**: `cached_network_image`
- **Scanner**: `mobile_scanner` (Deteksi QR Code meja)
- **Testing Framework**: Maestro UI Testing (`Semantics.identifier`)

---

## 🚀 Petunjuk Menjalankan Aplikasi

Ikuti panduan langkah demi langkah berikut untuk menjalankan aplikasi di lingkungan pengembangan lokal Anda:

### 1. Prasyarat Sistem (Prerequisites)
Pastikan perangkat Anda telah terpasang:
- **Flutter SDK**: Versi 3.19.0 atau yang lebih baru ([Panduan Install Flutter](https://docs.flutter.dev/get-started/install)).
- **Android Studio / VS Code**: Terpasang extension resmi **Flutter** dan **Dart**.
- **Android SDK & Emulator** (atau gunakan **Google Chrome** untuk web / HP Android fisik dengan USB Debugging).
- **Java Development Kit (JDK)**: JDK 17 atau yang kompatibel untuk kompilasi Android.

Periksa kesiapan lingkungan dengan menjalankan perintah berikut di terminal:
```bash
flutter doctor
```
Pastikan Flutter dan target perangkat (Android toolchain / Chrome) berstatus centang hijau (OK).

---

### 2. Membuka Direktori Proyek
Buka terminal (Command Prompt / PowerShell / Bash), lalu arahkan ke folder proyek ini:
```bash
cd "d:\KAMPUS\PRAKTEK_KAMPUS_SEMTR 7\MOBILE_TESTING\warmindo_butuh_uang"
```
*(Atau buka folder tersebut menggunakan menu **File > Open Folder** di VS Code / Android Studio).*

---

### 3. Mengunduh Dependensi Proyek
Jalankan perintah berikut untuk mengunduh semua package yang diperlukan:
```bash
flutter pub get
```

---

### 4. Memilih Perangkat Target
Cek daftar perangkat atau emulator yang aktif dan terdeteksi di komputer Anda:
```bash
flutter devices
```
Contoh output:
```text
3 connected devices:
• sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64  • Android 14 (API 34)
• Chrome (web)                • chrome        • web-javascript • Google Chrome
• Windows (desktop)           • windows       • windows-x64    • Microsoft Windows
```

---

### 5. Menjalankan Aplikasi

Pilih salah satu platform target sesuai kebutuhan Anda:

#### A. Menjalankan di Emulator Android / HP Fisik (Direkomendasikan)
Pastikan emulator sudah menyala atau HP fisik sudah terhubung via kabel USB dengan opsi *USB Debugging* aktif:
```bash
flutter run
```
Jika ada lebih dari satu perangkat terhubung, tentukan target ID perangkatnya:
```bash
flutter run -d emulator-5554
```

#### B. Menjalankan di Browser (Google Chrome)
Untuk pengujian cepat tanpa membuka emulator:
```bash
flutter run -d chrome
```

#### C. Menjalankan di Windows Desktop
```bash
flutter run -d windows
```

> 💡 **Catatan Mode Offline (Mock Mode)**:  
> Aplikasi ini sudah dilengkapi **Mode Mock Data Bawaan**. Anda dapat langsung mencoba dan mendemokan seluruh fitur (Katalog, Kustomisasi, Gacha, Keranjang, Profil, dan KDS Dapur) secara instan tanpa perlu koneksi internet atau konfigurasi ulang database!

---

### 6. Membuat File APK (Build Release APK)
Untuk memasang aplikasi langsung ke perangkat Android tanpa mode debug:
```bash
flutter build apk --release
```
File APK hasil build akan berada di direktori:
```text
build\app\outputs\flutter-apk\app-release.apk
```

---

## 📱 PANDUAN PENGGUNAAN APLIKASI DI HP / PERANGKAT (USER MANUAL)

Bagian ini memandu Anda menggunakan aplikasi **Warmindo Butuh Uang** setelah file APK dipasang di perangkat HP Android fisik maupun emulator.

---

### 📦 1. Cara Memasang (Install) APK di HP Android
1. **Salin / Unduh File APK ke HP**:
   - Salin file APK (`app-release.apk`) ke penyimpanan HP via kabel USB, Google Drive, WhatsApp, atau Bluetooth.
2. **Buka File APK**:
   - Buka aplikasi **File Manager** / **Pengelola File** di HP, cari file `app-release.apk`, lalu ketuk (*tap*) file tersebut.
3. **Izinkan Instalasi dari Sumber Tidak Dikenal**:
   - Jika muncul peringatan keamanan *"Demi keamanan, ponsel Anda tidak diizinkan menginstal aplikasi yang tidak dikenal dari sumber ini"*, pilih **Setelan (Settings)** $\rightarrow$ aktifkan centang **Izinkan dari sumber ini (Allow from this source)**.
4. **Selesaikan Instalasi**:
   - Tekan **Instal (Install)**, tunggu hingga selesai, lalu tekan **Buka (Open)**.
   - Jika aplikasi meminta izin **Kamera**, pilih **"Saat aplikasi digunakan" (While using the app)** untuk mengaktifkan pemindaian QR Code meja.

---

### 🍜 2. Skenario Penggunaan: Sebagai Pelanggan Meja

#### Langkah 1: Memilih Nomor Meja Makan
- Saat aplikasi pertama kali dibuka, layar akan menampilkan pop-up dialog bertuliskan **"🍜 SELAMAT DATANG! Warmindo Butuh Uang"**.
- Anda memiliki 2 cara untuk menentukan meja:
  - **Cara A (Pilih Manual)**: Ketuk salah satu kotak nomor meja dari nomor **1 sampai 12** sesuai tempat duduk Anda.
  - **Cara B (Scan QR di Meja)**: Ketuk tombol kuning **"SCAN QR DI MEJA"** $\rightarrow$ arahkan kamera HP Anda ke stiker QR Code yang tertempel di meja warkop. Nomor meja akan otomatis terdeteksi.
- **Nama Pemesan**: Masukkan nama panggilan Anda pada kolom *"Nama kamu (opsional)..."* (contoh: *Dimas* atau *Rian*). Jika dikosongkan, nama otomatis menjadi *"Pelanggan Meja X"*.
- Ketuk tombol **"Lanjut dengan Meja #..."** untuk masuk ke beranda menu.

#### Langkah 2: Memilih & Mencari Menu Makanan/Minuman
- **Pencarian Cepat**: Ketik nama makanan atau minuman pada kolom pencarian di bagian atas (contoh: ketik *"Aceh"*, *"Nutrisari"*, atau *"Magelangan"*).
- **Filter Kategori**: Geser tab kategori di bawah kolom cari (*Semua*, *Indomie Goreng*, *Indomie Kuah*, *Nasi & Lauk*, *Minuman Dingin*, *Minuman Hangat*, *Camilan/Roti*).
- **Fitur Gacha Menu (Jika Bingung Mau Makan Apa)**:
  - Ketuk banner **"PUTAR GACHA MENU"**.
  - Aplikasi akan mengacak dan memilihkan takdir menu warkop malam ini.
  - Ketuk **"Ambil Ini!"** untuk langsung memilih menu tersebut, atau ketuk **"Tolak Takdir"** jika ingin memilih sendiri.

#### Langkah 3: Meracik Kustomisasi Indomie Sesuai Selera
- Pada menu Indomie (misalnya *Indomie Goreng Original* atau *Indomie Kuah Kari Ayam*), ketuk tombol **"+ RACIK"**.
- Lembar kustomisasi (*bottom sheet*) akan terbuka dari bawah:
  1. **Tingkat Kuah / Kematangan Mie**: Pilih antara *Kering / Standar*, *Nyemek*, atau *Lembek*.
  2. **Pilihan Olahan Telur**: Pilih *Tanpa Telur*, *Ceplok Matang*, *Ceplok 1/2 Matang*, atau *Dadar* (+Rp 4.000).
  3. **Level Pedas Cabe Rawit Ulek**: Geser slider cabai dari **0 sampai 15 cabai rawit** (0 = Tanpa Cabe, 5 = Keringetan, 15 = Dewa Lambung).
  4. **Topping Warkop Tambahan**: Centang topping favorit Anda seperti *Kornet*, *Keju*, *Sosis*, atau *Bakso*.
  5. **Catatan Khusus untuk Dapur**: Tulis catatan tambahan jika ada (contoh: *"sawi dibanyakin mas"*, *"bawang goreng dipisah"*).
- Ketuk tombol kuning **"MASUKKAN KERANJANG"**.

#### Langkah 4: Memeriksa Keranjang Belanja & Fitur Meja Unik
- Buka layar keranjang dengan mengetuk **Ikon Keranjang** di pojok kanan atas atau tab **Keranjang** di navigasi bawah.
- Di dalam keranjang, Anda dapat:
  - **Mengatur Porsi**: Tekan tombol `+` atau `-` untuk mengubah jumlah pesanan.
  - **Comot Gorengan Meja Mandiri**: Jika Anda mengambil gorengan bakwan/tahu/tempe yang tersedia di meja makan, tekan tombol **"+ GORENGAN"** (+Rp 1.500 per biji) agar langsung otomatis ditambahkan ke total tagihan Anda.
  - **Memberikan Tip Kopi untuk Aa' Warmindo**: Pilih nominal tip sukarela (*Ikhlas Doa (Rp 0)*, *+Rp 1.000*, *+Rp 2.000*, atau *+Rp 5.000*).
- Periksa ringkasan rincian total pembayaran.
- Jika sudah sesuai, tekan tombol besar **"KIRIM PESANAN KE DAPUR"**.
- Pop-up sukses bertuliskan **"🍳 PESANAN DITERIMA DAPUR!"** akan muncul. Tekan **"KEMBALI KE MENU"**.

#### Langkah 5: Memantau Proses Pesanan (Live Order Tracking)
- Ketuk tab **Riwayat** di navigasi bawah.
- Anda dapat melihat pesanan Anda sedang berada di tahap mana secara langsung:
  - 📋 **Pesanan Diterima**: Pesanan sudah masuk ke sistem antrean.
  - ⏳ **Menunggu Diproses**: Antre menunggu giliran wajan.
  - 🍳 **Sedang Dimasak**: Koki dapur sedang memasak pesanan Anda di wajan.
  - 🔔 **Siap Diantar**: Masakan matang dan sedang diantar pelayan ke meja Anda.
  - 💰 **Selesai & Lunas**: Makanan telah dinikmati dan pembayaran selesai.

---

### 👨‍🍳 3. Skenario Penggunaan: Sebagai Staff Dapur / Koki (Mode KDS)

Aplikasi ini menyatukan sistem dapur (*Kitchen Display System*) langsung di dalam aplikasi tanpa perlu install aplikasi terpisah:

1. **Masuk ke Mode Dapur**:
   - Ketuk tab **Profil** di bilah navigasi bawah.
   - Gulir ke bagian paling bawah, lalu ketuk tombol:  
     **`MASUK MODE DAPUR WARMINDO BUTUH UANG (KDS)`**.
2. **Masukkan PIN Keamanan Staff**:
   - Ketik PIN Default: **`1234`**.
   - Ketuk **"MASUK DAPUR"**.
3. **Mengoperasikan Layar Dapur (KDS)**:
   - Tampilan layar akan berubah menjadi tema gelap khusus dapur wajan.
   - Di bagian atas, koki dapat memfilter antrean pesanan:
     - **Semua Antrean** | **Menunggu** | **Dimasak** | **Siap Antar**.
   - Setiap kartu pesanan menampilkan nomor meja, nama pemesan, dan **Label Kontras Tinggi** agar koki tidak salah racik:
     - 🌶️ Label Merah: *Jumlah Cabe Ulek (cth: "7 CABE ULEK")*
     - 🥚 Label Kuning: *Pilihan Telur (cth: "CEPLOK 1/2 MATANG")*
     - 🍜 Label Oranye: *Tingkat Kuah (cth: "NYEMEK")*
     - 💬 Catatan Khusus Pelanggan.
4. **Memajukan Alur Memasak**:
   - Saat mulai memasak, koki menekan tombol:  
     👉 **"👨‍🍳 MULAI MASAK DI WAJAN"** *(Status berpindah ke Dimasak)*.
   - Setelah mie matang dan siap di piring, koki menekan tombol:  
     👉 **"🍜 TANDAI SIAP DIANTAR"** *(Status berpindah ke Siap Diantar)*.
   - Setelah pelayan mengantar dan pelanggan membayar di kasir, koki/kasir menekan:  
     👉 **"💰 TANDAI SELESAI & LUNAS"** *(Pesanan diarsipkan)*.

---

### 👑 4. Skenario Penggunaan: Sebagai Admin Toko
1. Ketuk tab **Profil** di navigasi bawah.
2. Jika belum login admin, layar akan menampilkan gerbang **Area Admin**.
3. Ketuk tombol **"LOGIN ADMIN"**.
4. Masukkan alamat email admin dan kata sandi yang terdaftar.
5. Ketuk **"MASUK SEBAGAI ADMIN"**.
6. Admin dapat melihat status koneksi Supabase Realtime, profil akun warkop, dan keluar dari mode admin dengan menekan tombol **Ikon Logout** (warna merah di kanan atas layar profil).

---

## 🧪 Petunjuk Pengujian Otomatis (Testing)

Proyek ini telah dikonfigurasi secara menyeluruh untuk pengujian kualitas perangkat lunak:

### 1. Static Analysis (Pemeriksaan Kode)
Jalankan analisis statis untuk memastikan tidak ada kesalahan sintaks atau tipe:
```bash
flutter analyze
```

### 2. Unit & Widget Testing
Jalankan tes unit bawaan Flutter:
```bash
flutter test
```

### 3. UI Automated Testing (Maestro)
Aplikasi ini sudah dipasang `Semantics(identifier: ...)` pada seluruh elemen penting.
- Tabel lengkap ID selector Maestro dapat dilihat pada file:  
  👉 [**`MAESTRO_IDENTIFIERS.md`**](MAESTRO_IDENTIFIERS.md)
- Untuk menjalankan skrip pengujian Maestro:
  ```bash
  maestro test path/to/flow.yaml
  ```

---

## 🗄️ Menghubungkan Supabase Database (Opsional)

Aplikasi sudah terhubung dengan Supabase URL bawaan. Jika Anda ingin menggunakan database Supabase pribadi:

1. Buat proyek baru di [supabase.com](https://supabase.com).
2. Di menu **SQL Editor**, jalankan skrip berikut:
```sql
-- 1. Tabel Menu Items
CREATE TABLE menu_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  base_price NUMERIC(10, 2) NOT NULL,
  image_url TEXT,
  description TEXT,
  is_indomie BOOLEAN DEFAULT false,
  is_available BOOLEAN DEFAULT true
);

-- 2. Tabel Pesanan (Orders)
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  table_number INT NOT NULL,
  customer_name TEXT DEFAULT 'Pelanggan',
  total_price NUMERIC(10, 2) NOT NULL,
  tip_amount NUMERIC(10, 2) DEFAULT 0,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'cooking', 'ready', 'paid', 'cancelled')),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Aktifkan Realtime Replication
ALTER PUBLICATION supabase_realtime ADD TABLE orders;
```
3. Perbarui konfigurasi di file [`lib/core/config/supabase_config.dart`](lib/core/config/supabase_config.dart):
```dart
static const String supabaseUrl = 'https://YOUR_PROJECT_ID.supabase.co';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

---

## ❓ Troubleshooting (Solusi Masalah Umum)

| Masalah | Solusi |
| :--- | :--- |
| **Error `Target of URI doesn't exist` / Package merah** | Jalankan `flutter pub get` di terminal. Jika masih terjadi, restart Dart Analysis Server di VS Code (*Ctrl+Shift+P > Dart: Restart Analysis Server*). |
| **Error Gradle Build / Android Cache** | Jalankan pembersihan cache: `flutter clean`, lalu unduh ulang dependensi dengan `flutter pub get`. |
| **Koneksi Internet Putus / Offline** | Aplikasi secara cerdas otomatis beralih ke *Mode Mock Data*, sehingga fitur tetap dapat didemokan tanpa internet. |
| **Tampilan font lambat dimuat** | Font utama `Bebas Neue` dan `Plus Jakarta Sans` sudah di-bundle sebagai aset lokal di `lib/assets/fonts/` sehingga tampilan tetap konsisten. |

---

## 🎯 Tips Presentasi Demo di Depan Dosen / Penguji

1. **Sampaikan Latar Belakang Lapangan**:
   > *"Dosen penguji yang terhormat, di warung makan Indomie (Warmindo), pelanggan sering meminta kustomisasi unik seperti telur setengah matang dan cabai 7 biji. Saat warkop ramai, pelayan sering salah mencatat. Aplikasi Warmindo Butuh Uang hadir memecahkan masalah ini dengan sistem pemesanan mandiri meja dan Kitchen Display System real-time, lengkap dengan integrasi accessibility tree untuk pengujian otomatis (Maestro UI Testing)."*
2. **Demonstrasikan Fitur Unggulan**:
   - Tunjukkan dialog pilih meja dan scan QR meja.
   - Coba fitur interaktif kustomisasi Indomie (*kematangan, cabe ulek, telur*).
   - Tunjukkan fitur khas: **Gacha Menu**, tombol **+ Gorengan Meja**, dan **Tip Kopi**.
   - Buka layar dapur **KDS** dengan PIN `1234` dan tunjukkan alur perubahan status pesanan.
