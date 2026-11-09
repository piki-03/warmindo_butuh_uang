# Maestro E2E Testing - Warmindo Butuh Uang

Folder ini berisi skenario automated UI / E2E testing menggunakan **Maestro** untuk aplikasi Flutter **Warmindo Butuh Uang** (`com.example.warmindo_butuh_uang`).

---

## 📋 Daftar Flow Pengujian

| No | File Flow | Fitur yang Diuji | Deskripsi Skenario |
|---|---|---|---|
| 1 | `01_pilih_meja_flow.yaml` | **Pemilihan Meja Pelanggan** | Dialog selamat datang, memilih nomor meja (Meja 3), mengisi nama pelanggan, konfirmasi, dan validasi header katalog. |
| 2 | `02_pencarian_filter_menu_flow.yaml` | **Eksplorasi, Filter & Pencarian** | Filter kategori (Minuman Dingin), pencarian kata kunci ("Aceh"), dan trigger fitur interaktif Putar Gacha Menu. |
| 3 | `03_kustomisasi_dan_checkout_flow.yaml` | **Kustomisasi Indomie & Checkout** | Memilih Indomie, kustomisasi kematangan/telur/catatan di bottom sheet, cek rincian keranjang, dan kirim pesanan ke dapur. |
| 4 | `04_pantau_status_dan_admin_flow.yaml` | **Status Pesanan & Area Admin** | Navigasi ke tab status pesanan meja (Riwayat), gate area admin di tab profil, dan verifikasi form login admin. |

---

## 🚀 Cara Menjalankan Pengujian

### 1. Prasyarat
- Pastikan emulator Android atau perangkat fisik sudah aktif dan terhubung (`adb devices`).
- Pastikan aplikasi sudah terinstall (misal melalui `flutter run` atau `flutter build apk`).
- Maestro CLI sudah terinstall di sistem Anda:
  ```bash
  # Windows (via PowerShell)
  curl -fsSL "https://get.maestro.mobile.dev" | powershell -Command -
  ```

### 2. Menjalankan Satu Flow Spesifik
```bash
# Menjalankan Fitur 1
maestro test .maestro/01_pilih_meja_flow.yaml

# Menjalankan Fitur 2
maestro test .maestro/02_pencarian_filter_menu_flow.yaml

# Menjalankan Fitur 3
maestro test .maestro/03_kustomisasi_dan_checkout_flow.yaml

# Menjalankan Fitur 4
maestro test .maestro/04_pantau_status_dan_admin_flow.yaml
```

### 3. Menjalankan Seluruh Flow Secara Berurutan (Full Test Suite)
```bash
maestro test .maestro/
```
