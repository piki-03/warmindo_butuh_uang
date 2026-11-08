import zipfile
import xml.etree.ElementTree as ET
import os
import shutil

ET.register_namespace('', 'http://schemas.openxmlformats.org/spreadsheetml/2006/main')

BACKUP_FILE = 'UAT_template_original_backup.xlsx'
OUTPUT_FILE = 'UAT_template.xlsx'

def c_inline(col, row, s, text):
    c = ET.Element('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}c')
    c.set('r', f"{col}{row}")
    c.set('s', str(s))
    if text is not None and text != "":
        c.set('t', 'inlineStr')
        is_elem = ET.SubElement(c, '{http://schemas.openxmlformats.org/spreadsheetml/2006/main}is')
        t_elem = ET.SubElement(is_elem, '{http://schemas.openxmlformats.org/spreadsheetml/2006/main}t')
        t_elem.text = str(text)
    return c

def c_formula(col, row, s, formula, val=""):
    c = ET.Element('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}c')
    c.set('r', f"{col}{row}")
    c.set('s', str(s))
    f_elem = ET.SubElement(c, '{http://schemas.openxmlformats.org/spreadsheetml/2006/main}f')
    f_elem.text = formula
    v_elem = ET.SubElement(c, '{http://schemas.openxmlformats.org/spreadsheetml/2006/main}v')
    v_elem.text = str(val) if val is not None else ""
    return c

def c_val(col, row, s, val):
    c = ET.Element('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}c')
    c.set('r', f"{col}{row}")
    c.set('s', str(s))
    v_elem = ET.SubElement(c, '{http://schemas.openxmlformats.org/spreadsheetml/2006/main}v')
    v_elem.text = str(val)
    return c

# ----------------- SHEET 1: Petunjuk -----------------
def modify_sheet1(tree):
    sheet_data = tree.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}sheetData')
    
    # Map of row replacements
    replacements = {
        1: [('A', 1, "Studi Kasus Mobile Testing: Aplikasi Warmindo Butuh Uang")],
        2: [('A', 2, "Mata Kuliah Mobile Testing – Praktik Mobile Testing Semester 7")],
        4: [('A', 4, "Aplikasi"), ('B', 4, "Aplikasi Pemesanan & Dapur KDS Berbasis Flutter dan Supabase (Warmindo Butuh Uang), versi 1.0.0")],
        5: [('A', 5, "Cakupan"), ('B', 4, "F-01 Scan QR/Meja • F-02 Katalog Menu • F-03 Kustomisasi Indomie • F-04 Keranjang & Tip • F-05 Status Pesanan • F-06 Dapur KDS • F-07 Login Admin Supabase")],
        6: [('A', 4, "Di luar cakupan"), ('B', 4, "Payment Gateway Bank (QRIS Dinamis Otomatis), Pengantaran Ojol Luar (Khusus Dine-in Warkop)")],
        7: [('A', 4, "Akun Admin"), ('B', 4, "admin@warmindo.com / admin123 (Supabase Authentication)")],
        8: [('A', 4, "PIN Dapur KDS"), ('B', 4, "1234 (Mode Khusus Staff Dapur / Kasir Warmindo)")],
    }
    
    for r in sheet_data.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}row'):
        r_num = int(r.get('r'))
        if r_num in replacements:
            # Clear old cells in row
            for c in list(r):
                r.remove(c)
            for col_letter, s_idx, txt in replacements[r_num]:
                r.append(c_inline(col_letter, r_num, s_idx, txt))
                
    return tree

# ----------------- SHEET 2: Test Case -----------------
TEST_CASES = [
    # TS-01 Identitas & Scan QR Meja
    ("TC-MEJA-01", "TS-01 Meja & QR", "Pilih nomor meja manual dan nama pemesan", "Positif",
     "Aplikasi baru dibuka, dialog pemilihan meja tampil",
     "1. Ketuk nomor meja 3\n2. Isi nama pemesan 'Mas Dimas'\n3. Ketuk 'Lanjut dengan Meja #3'",
     "Meja: 3, Nama: 'Mas Dimas'",
     "Meja #3 dan nama 'Mas Dimas' tersimpan; badge meja tampil pada header aplikasi"),
    
    ("TC-MEJA-02", "TS-01 Meja & QR", "Pilih nomor meja tanpa mengisi nama pemesan (default fallback)", "Boundary",
     "Dialog pemilihan meja tampil",
     "1. Pilih nomor meja 7\n2. Biarkan kolom nama kosong\n3. Ketuk Lanjut",
     "Meja: 7, Nama: (kosong)",
     "Sistem otomatis menetapkan nama default 'Pelanggan Meja 7'; nomor meja 7 aktif"),

    ("TC-MEJA-03", "TS-01 Meja & QR", "Scan QR Code meja valid di warkop", "Positif",
     "Kamera HP aktif / izin kamera disetujui",
     "1. Ketuk tombol 'SCAN QR DI MEJA'\n2. Arahkan kamera ke QR Meja 5 (token: table-05)\n3. Tunggu pemindaian",
     "Token QR: table-05",
     "Scanner berhasil membaca token, meja otomatis diset ke #5, dialihkan ke Menu"),

    ("TC-MEJA-04", "TS-01 Meja & QR", "Scan QR Code acak / token tidak valid", "Negatif",
     "Scanner QR aktif",
     "1. Arahkan kamera ke QR non-warkop (misal URL https://google.com)",
     "QR Data: https://google.com",
     "Muncul pesan 'QR Code Meja Tidak Valid!'; nomor meja tidak berubah"),

    # TS-02 Katalog Menu
    ("TC-MENU-01", "TS-02 Katalog Menu", "Filter menu berdasarkan kategori Indomie Kuah", "Positif",
     "Katalog menu terbuka",
     "1. Ketuk tab kategori 'Indomie Kuah'\n2. Gulir daftar menu",
     "Kategori: Indomie Kuah",
     "Hanya menu Indomie Kuah yang tampil (Soto Medan, Kari Ayam Nyemek); kategori lain tersembunyi"),

    ("TC-MENU-02", "TS-02 Katalog Menu", "Filter menu kategori Minuman Dingin", "Positif",
     "Katalog menu terbuka",
     "1. Ketuk tab kategori 'Minuman Dingin'",
     "Kategori: Minuman Dingin",
     "Menampilkan varian minuman warkop (Es Teh Manis, Es Nutrisari, Extra Joss Susu)"),

    # TS-03 Kustomisasi Indomie Interaktif
    ("TC-CUSTOM-01", "TS-03 Kustomisasi", "Kustomisasi Indomie komplit (kematangan, telur, cabe, topping)", "Positif",
     "Lembar kustomisasi Indomie terbuka",
     "1. Pilih kematangan 'Nyemek'\n2. Pilih telur 'Ceplok 1/2 Matang'\n3. Geser cabe ke level 7\n4. Pilih topping 'Kornet'\n5. Isi catatan khusus 'Kuah kental'\n6. Ketuk 'Tambah ke Pesanan'",
     "Kematangan: Nyemek, Telur: Ceplok 1/2, Cabe: 7, Topping: Kornet (+Rp 4.000)",
     "Item masuk ke keranjang beserta detail kustomisasi lengkap dan kalkulasi harga akurat"),

    ("TC-CUSTOM-02", "TS-03 Kustomisasi", "Batas cabai gratis tanpa biaya ekstra (Boundary <= 5)", "Boundary",
     "Lembar kustomisasi Indomie terbuka",
     "1. Atur slider cabai ke level 0 (tidak pedas)\n2. Geser hingga tepat level 5 (pedas standar)",
     "Jumlah Cabe: 5",
     "Ekstra biaya cabai adalah Rp 0 (standar warkop gratis sampai 5 cabe)"),

    ("TC-CUSTOM-03", "TS-03 Kustomisasi", "Biaya tambahan cabai rawit pedas (Boundary > 5 cabe)", "Boundary",
     "Lembar kustomisasi Indomie terbuka",
     "1. Geser slider cabai dari 5 ke 6 cabe\n2. Geser lebih lanjut ke level 12 cabe",
     "Jumlah Cabe: 6 dan 12",
     "Biaya ekstra cabai otomatis bertambah secara proporsional pada total harga"),

    ("TC-CUSTOM-04", "TS-03 Kustomisasi", "Multi-seleksi topping (Keju + Kornet)", "Positif",
     "Lembar kustomisasi Indomie terbuka",
     "1. Centang topping Keju (+Rp 3.000)\n2. Centang topping Kornet (+Rp 4.000)",
     "Topping: Keju + Kornet",
     "Kedua topping terpilih bersamaan; total harga menu bertambah Rp 7.000"),

    # TS-04 Keranjang & Tip
    ("TC-CART-01", "TS-04 Keranjang & Tip", "Tambah dan kurangi kuantitas item di keranjang", "Positif",
     "Keranjang berisi 1 item menu",
     "1. Buka halaman Keranjang\n2. Ketuk tombol (+) pada item\n3. Ketuk tombol (-)",
     "Item: Es Teh Manis Jumbo (Rp 4.000)",
     "Kuantitas berubah 1 -> 2 (subtotal Rp 8.000) lalu kembali 1 (subtotal Rp 4.000)"),

    ("TC-CART-02", "TS-04 Keranjang & Tip", "Hapus item pesanan hingga keranjang kosong (Boundary 0 item)", "Boundary",
     "Keranjang berisi 1 item kuantitas 1",
     "1. Buka Keranjang\n2. Ketuk tombol (-) pada item terakhir",
     "Kuantitas: 1 -> 0",
     "Item terhapus dari daftar; tampilan beralih ke 'Keranjang Kosong', tombol checkout disabled"),

    ("TC-CART-03", "TS-04 Keranjang & Tip", "Tambah tip sukarela untuk barista/pelayan", "Positif",
     "Keranjang terisi menu",
     "1. Pilih chip tip Rp 3.000\n2. Periksa ringkasan pembayaran",
     "Tip: Rp 3.000",
     "Total harga bertambah tepat sebesar Subtotal Pesanan + Tip Rp 3.000"),

    # TS-05 Checkout & Pelacakan Pesanan
    ("TC-ORD-01", "TS-05 Checkout & Order", "Pesan makanan & kirim ke antrean dapur / Supabase", "Positif",
     "Keranjang terisi, nomor meja aktif",
     "1. Ketuk 'Pesan Sekarang & Antar ke Meja'\n2. Konfirmasi pemesanan",
     "Meja 3, Total Rp 24.000",
     "Pesanan tersimpan ke antrean dapur/Supabase, keranjang ter-reset, dialihkan ke Layar Status"),

    ("TC-ORD-02", "TS-05 Checkout & Order", "Pelacakan alur status pesanan meja secara real-time", "Positif",
     "Pesanan meja aktif telah dibuat",
     "1. Buka tab Riwayat / Status Pesanan\n2. Pantau kartu status saat dapur memproses",
     "Status pesanan meja",
     "Tahapan visual bergerak runtut: Menunggu (Kuning) -> Dimasak (Biru) -> Siap Antar (Hijau)"),

    # TS-06 Layar Dapur (KDS)
    ("TC-KDS-01", "TS-06 Dapur KDS", "Buka Layar Dapur KDS dengan PIN benar", "Positif",
     "Di halaman Profil, ketuk 'Masuk Mode Dapur (KDS)'",
     "1. Masukkan PIN 1234\n2. Ketuk 'MASUK DAPUR'",
     "PIN: 1234",
     "Berhasil membuka Layar Dapur KDS, menampilkan daftar pesanan wajan dan counter antrean"),

    ("TC-KDS-02", "TS-06 Dapur KDS", "Buka Layar Dapur KDS dengan PIN salah", "Negatif",
     "Dialog PIN KDS terbuka",
     "1. Masukkan PIN 0000\n2. Ketuk 'MASUK DAPUR'",
     "PIN: 0000",
     "Akses ditolak; muncul notifikasi 'PIN Salah! Khusus Staff Warmindo Butuh Uang & Kasir'"),

    ("TC-KDS-03", "TS-06 Dapur KDS", "Filter antrean pesanan di dapur wajan", "Positif",
     "Berada di halaman KDS dapur",
     "1. Ketuk filter 'Menunggu'\n2. Ketuk filter 'Dimasak'\n3. Ketuk 'Siap Antar'",
     "Filter status KDS",
     "Daftar kartu pesanan terfilter cepat sesuai tombol tanpa tabrakan layout judul/actions"),

    ("TC-KDS-04", "TS-06 Dapur KDS", "Koki perbarui status masak satu ketukan", "Positif",
     "Ada pesanan berstatus Menunggu di KDS",
     "1. Ketuk tombol 'MULAI MASAK DI WAJAN'\n2. Ketuk 'SIAP DIANTAR KE MEJA'",
     "Order aktif di KDS",
     "Status order langsung terupdate di layar KDS dan tersinkron ke layar status meja pelanggan"),

    # TS-07 Autentikasi Admin & Supabase
    ("TC-AUTH-01", "TS-07 Admin Auth", "Akses Tab Profil tanpa login admin (Security Gate)", "Positif",
     "Belum login admin",
     "1. Ketuk tab menu 'Profil' di Bottom Navigation Bar",
     "Kondisi unauthenticated",
     "Tampil halaman gerbang 'AREA ADMIN [Terkunci]' & tombol Login Admin; data internal warkop terlindungi"),

    ("TC-AUTH-02", "TS-07 Admin Auth", "Login Admin dengan format email tidak valid", "Negatif",
     "Halaman Login Admin terbuka",
     "1. Isi email 'adminwarmindo'\n2. Isi password 'admin123'\n3. Ketuk Masuk",
     "Email: adminwarmindo (tanpa @)",
     "Muncul pesan validasi 'Format email tidak valid'; request login ditahan"),

    ("TC-AUTH-03", "TS-07 Admin Auth", "Login Admin dengan password di bawah 6 karakter", "Boundary",
     "Halaman Login Admin terbuka",
     "1. Isi email 'admin@warmindo.com'\n2. Isi password '12345' (5 karakter)\n3. Ketuk Masuk",
     "Password: 12345",
     "Muncul pesan validasi 'Password minimal 6 karakter'; form ditolak"),

    ("TC-AUTH-04", "TS-07 Admin Auth", "Login Admin Supabase valid & Logout sesi", "Positif",
     "Akun admin terdaftar di Supabase Auth",
     "1. Isi email & password admin valid\n2. Ketuk Masuk Sebagai Admin\n3. Setelah masuk, tekan icon Logout di AppBar",
     "Akun admin Supabase valid",
     "Login berhasil, Profil Admin terbuka dengan badge 'ADMIN WARMINDO' & status koneksi aktif. Saat logout, kembali terkunci"),
]

def modify_sheet2(tree):
    dim = tree.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}dimension')
    total_rows = 4 + len(TEST_CASES)
    dim.set('ref', f"A1:L{total_rows}")
    
    autofilter = tree.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}autoFilter')
    autofilter.set('ref', f"A4:L{total_rows}")
    
    sheet_data = tree.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}sheetData')
    
    # Remove old rows >= 5
    for r in list(sheet_data):
        if int(r.get('r')) >= 5:
            sheet_data.remove(r)
            
    # Add new rows
    for i, tc in enumerate(TEST_CASES, start=5):
        tc_id, scenario, judul, tipe, prasyarat, langkah, data_uji, expected = tc
        r_elem = ET.SubElement(sheet_data, '{http://schemas.openxmlformats.org/spreadsheetml/2006/main}row')
        r_elem.set('r', str(i))
        
        r_elem.append(c_inline('A', i, 4, tc_id))
        r_elem.append(c_inline('B', i, 4, scenario))
        r_elem.append(c_inline('C', i, 4, judul))
        r_elem.append(c_inline('D', i, 4, tipe))
        r_elem.append(c_inline('E', i, 4, prasyarat))
        r_elem.append(c_inline('F', i, 4, langkah))
        r_elem.append(c_inline('G', i, 4, data_uji))
        r_elem.append(c_inline('H', i, 4, expected))
        
        # Yellow editable columns for tester
        r_elem.append(c_inline('I', i, 6, "")) # Actual Result
        r_elem.append(c_inline('J', i, 6, "")) # Status
        r_elem.append(c_inline('K', i, 6, "")) # Bug ID
        r_elem.append(c_inline('L', i, 6, "")) # Tester / Tanggal

    # Update CF sqref
    cfs = tree.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}conditionalFormatting')
    for cf in cfs:
        cf.set('sqref', f"J5:J{total_rows}")
        
    # Update Data Validations
    dvs = tree.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}dataValidations/{http://schemas.openxmlformats.org/spreadsheetml/2006/main}dataValidation')
    for dv in dvs:
        if 'J5:J' in dv.get('sqref'):
            dv.set('sqref', f"J5:J{total_rows}")
        elif 'D5:D' in dv.get('sqref'):
            dv.set('sqref', f"D5:D{total_rows}")
            
    return tree, total_rows

# ----------------- SHEET 3: UAT -----------------
UAT_CASES = [
    ("UAT-01", "Pelanggan", "Sebagai pelanggan, saya ingin memilih nomor meja atau scan QR di meja agar pesanan saya diantar tepat ke tempat duduk saya.",
     "Buka aplikasi, pilih Meja 3 atau scan QR meja warkop.",
     "Nomor meja berhasil terpilih dan terlihat di header aplikasi dalam < 5 detik.", "Tinggi"),
    
    ("UAT-02", "Pelanggan", "Sebagai pelanggan, saya ingin melihat menu makanan & minuman lengkap dengan foto, harga, dan kategori agar mudah memilih.",
     "Buka katalog menu dan coba filter kategori (Indomie Goreng, Kuah, Minuman Dingin, Nasi & Lauk).",
     "Daftar menu tersaji lengkap, foto jelas, harga transparan, filter berjalan mulus.", "Tinggi"),

    ("UAT-03", "Pelanggan", "Sebagai penikmat Indomie, saya ingin mengkustomisasi kematangan mie, pilihan telur, jumlah cabai rawit pedas, dan topping sesuai selera warkop.",
     "Buka menu Indomie, atur kematangan Nyemek, telur ceplok 1/2 matang, cabe level 7, dan topping kornet.",
     "Kustomisasi tersimpan ke pesanan dengan perhitungan biaya ekstra yang akurat.", "Tinggi"),

    ("UAT-04", "Pelanggan", "Sebagai pelanggan, saya ingin memeriksa keranjang belanja, menambah/mengurangi porsi, dan melihat rincian harga sebelum checkout.",
     "Buka keranjang belanja, ubah jumlah porsi es teh jumbo, lalu periksa subtotal.",
     "Jumlah porsi dan total harga terhitung akurat dan mudah diatur.", "Tinggi"),

    ("UAT-05", "Pelanggan", "Sebagai pelanggan, saya ingin memberikan tip apresiasi untuk pelayan/barista warkop secara sukarela.",
     "Pilih opsi tip Rp 2.000 atau Rp 5.000 di keranjang belanja.",
     "Nilai tip otomatis ditambahkan ke total belanja secara transparan.", "Sedang"),

    ("UAT-06", "Pelanggan", "Sebagai pelanggan, saya ingin memantau alur pesanan secara langsung (Menunggu, Dimasak, Siap Antar) tanpa harus bolak-balik bertanya ke kasir.",
     "Buka tab Status Pesanan setelah melakukan checkout.",
     "Status pesanan tertera jelas dengan progres visual yang mudah dipahami.", "Tinggi"),

    ("UAT-07", "Koki Dapur", "Sebagai koki/staff dapur, saya ingin melihat antrean pesanan wajan di Kitchen Display System (KDS) yang mudah dibaca saat memasak.",
     "Buka layar KDS dapur menggunakan PIN staff warkop (1234).",
     "Tampilan antrean wajan kontras tinggi, detail kematangan dan cabe terlihat jelas.", "Tinggi"),

    ("UAT-08", "Koki Dapur", "Sebagai koki, saya ingin memperbarui status memasak dengan satu ketukan tombol agar cepat dan praktis.",
     "Ketuk tombol 'Mulai Masak di Wajan' lalu 'Siap Diantar ke Meja' pada kartu pesanan.",
     "Status langsung berubah warna dan kartu berpindah kategori secara responsif.", "Tinggi"),

    ("UAT-09", "Koki Dapur", "Sebagai koki warkop, saya ingin memfilter antrean di KDS (Semua, Menunggu, Dimasak, Siap Antar) agar tidak bingung saat warkop ramai.",
     "Gunakan tombol filter status antrean di bagian atas KDS.",
     "Daftar pesanan terfilter cepat sesuai tombol yang ditekan.", "Sedang"),

    ("UAT-10", "Pemilik/Admin", "Sebagai pemilik/admin, saya ingin halaman profil dan akses dapur dilindungi login akun khusus agar pelanggan tidak sembarangan masuk.",
     "Ketuk menu Profil tanpa login, lalu coba login dengan akun admin Supabase.",
     "Halaman Profil terkunci bagi pelanggan umum dan hanya bisa dibuka setelah login admin.", "Tinggi"),

    ("UAT-11", "Pemilik/Admin", "Sebagai pemilik warkop, saya ingin koneksi database Supabase aktif agar data pesanan terekam secara terpusat.",
     "Lakukan login admin dan periksa indikator koneksi Supabase di profil.",
     "Indikator koneksi Supabase berwarna hijau/aktif dan sesi terkelola dengan baik.", "Sedang"),

    ("UAT-12", "Pelanggan & Staff", "Sebagai pengguna, saya ingin aplikasi nyaman digunakan di smartphone (desain gelap warkop, layout rapi, tidak ada teks tabrakan, dan responsif).",
     "Gunakan aplikasi selama 10 menit di HP untuk alur pesan makan hingga selesai.",
     "Tidak ada error/tampilan terpotong, teks title dan badge tidak saling bertabrakan, navigasi mulus.", "Rendah"),
]

def modify_sheet3(tree):
    dim = tree.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}dimension')
    total_rows = 4 + len(UAT_CASES)
    dim.set('ref', f"A1:K{total_rows}")
    
    autofilter = tree.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}autoFilter')
    autofilter.set('ref', f"A4:K{total_rows}")
    
    sheet_data = tree.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}sheetData')
    
    for r in list(sheet_data):
        if int(r.get('r')) >= 5:
            sheet_data.remove(r)
            
    for i, uat in enumerate(UAT_CASES, start=5):
        uat_id, peran, story, skenario, kriteria, prioritas = uat
        r_elem = ET.SubElement(sheet_data, '{http://schemas.openxmlformats.org/spreadsheetml/2006/main}row')
        r_elem.set('r', str(i))
        
        r_elem.append(c_inline('A', i, 4, uat_id))
        r_elem.append(c_inline('B', i, 4, peran))
        r_elem.append(c_inline('C', i, 4, story))
        r_elem.append(c_inline('D', i, 4, skenario))
        r_elem.append(c_inline('E', i, 4, kriteria))
        r_elem.append(c_inline('F', i, 4, prioritas))
        
        # Yellow user input columns
        r_elem.append(c_inline('G', i, 6, "")) # Status
        r_elem.append(c_inline('H', i, 6, "")) # Skor (1-5)
        r_elem.append(c_inline('I', i, 6, "")) # Komentar
        r_elem.append(c_inline('J', i, 6, "")) # Nama Penguji
        r_elem.append(c_inline('K', i, 6, "")) # Tanggal

    # Update CF sqref
    cfs = tree.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}conditionalFormatting')
    for cf in cfs:
        cf.set('sqref', f"G5:G{total_rows}")
        
    # Update Data Validations
    dvs = tree.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}dataValidations/{http://schemas.openxmlformats.org/spreadsheetml/2006/main}dataValidation')
    for dv in dvs:
        if 'G5:G' in dv.get('sqref'):
            dv.set('sqref', f"G5:G{total_rows}")
        elif 'H5:H' in dv.get('sqref'):
            dv.set('sqref', f"H5:H{total_rows}")
        elif 'F5:F' in dv.get('sqref'):
            dv.set('sqref', f"F5:F{total_rows}")
            
    return tree, total_rows

# ----------------- SHEET 4: Bug Report -----------------
def modify_sheet4(tree):
    dim = tree.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}dimension')
    dim.set('ref', "A1:L15")
    
    autofilter = tree.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}autoFilter')
    autofilter.set('ref', "A4:L15")
    
    sheet_data = tree.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}sheetData')
    
    for r in list(sheet_data):
        if int(r.get('r')) >= 5:
            sheet_data.remove(r)
            
    # Row 5: Real example bug from our project
    r5 = ET.SubElement(sheet_data, '{http://schemas.openxmlformats.org/spreadsheetml/2006/main}row')
    r5.set('r', '5')
    r5.append(c_inline('A', 5, 6, "BUG-001"))
    r5.append(c_inline('B', 5, 6, "[KDS] Judul 'KDS • LAYAR DAPUR' dan badge antrean saling tabrakan di AppBar layar HP"))
    r5.append(c_inline('C', 5, 6, "TC-KDS-03 / UAT-12"))
    r5.append(c_inline('D', 5, 6, "Flutter 3.29 • Android 14 • HP Portrait 360x800dp"))
    r5.append(c_inline('E', 5, 6, "1. Buka aplikasi\n2. Masuk ke Layar KDS Dapur\n3. Perhatikan AppBar bagian atas"))
    r5.append(c_inline('F', 5, 6, "Judul dan badge antrean tersusun rapi tanpa overlap di layar"))
    r5.append(c_inline('G', 5, 6, "Teks judul panjang menabrak badge antrean di kanan hingga overflow"))
    r5.append(c_inline('H', 5, 6, "Medium"))
    r5.append(c_inline('I', 5, 6, "Medium"))
    r5.append(c_inline('J', 5, 6, "screenshot_kds_appbar.png"))
    r5.append(c_inline('K', 5, 6, "Fixed"))
    r5.append(c_inline('L', 5, 6, "QA Tester"))
    
    # Rows 6..15: Empty rows for future tester input
    for i in range(6, 16):
        r_elem = ET.SubElement(sheet_data, '{http://schemas.openxmlformats.org/spreadsheetml/2006/main}row')
        r_elem.set('r', str(i))
        for col in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L']:
            r_elem.append(c_inline(col, i, 6, ""))
            
    # Update Data Validations
    dvs = tree.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}dataValidations/{http://schemas.openxmlformats.org/spreadsheetml/2006/main}dataValidation')
    for dv in dvs:
        if 'H5:H' in dv.get('sqref'):
            dv.set('sqref', "H5:H15")
        elif 'I5:I' in dv.get('sqref'):
            dv.set('sqref', "I5:I15")
        elif 'K5:K' in dv.get('sqref'):
            dv.set('sqref', "K5:K15")
            
    return tree

# ----------------- SHEET 5: Rekap & Sign-off -----------------
def modify_sheet5(tree, tc_total_rows, uat_total_rows):
    sheet_data = tree.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}sheetData')
    
    tc_range_id = f"'Test Case'!A5:A{tc_total_rows}"
    tc_range_status = f"'Test Case'!J5:J{tc_total_rows}"
    
    uat_range_id = f"'UAT'!A5:A{uat_total_rows}"
    uat_range_status = f"'UAT'!G5:G{uat_total_rows}"
    uat_range_prio = f"'UAT'!F5:F{uat_total_rows}"
    uat_range_score = f"'UAT'!H5:H{uat_total_rows}"
    
    bug_range_sev = "'Bug Report'!H5:H15"
    bug_range_status = "'Bug Report'!K5:K15"
    
    # Update formulas in rows 5..16
    for r in sheet_data.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}row'):
        r_num = int(r.get('r'))
        if r_num == 5: # Total
            for c in r.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}c'):
                col = c.get('r')[0]
                f_elem = c.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}f')
                if f_elem is not None:
                    if col == 'B': f_elem.text = f"COUNTA({tc_range_id})"
                    elif col == 'C': f_elem.text = f"COUNTA({uat_range_id})"
        elif r_num == 6: # PASS
            for c in r.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}c'):
                col = c.get('r')[0]
                f_elem = c.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}f')
                if f_elem is not None:
                    if col == 'B': f_elem.text = f'COUNTIF({tc_range_status},"PASS")'
                    elif col == 'C': f_elem.text = f'COUNTIF({uat_range_status},"PASS")'
        elif r_num == 7: # FAIL
            for c in r.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}c'):
                col = c.get('r')[0]
                f_elem = c.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}f')
                if f_elem is not None:
                    if col == 'B': f_elem.text = f'COUNTIF({tc_range_status},"FAIL")'
                    elif col == 'C': f_elem.text = f'COUNTIF({uat_range_status},"FAIL")'
        elif r_num == 8: # BLOCKED
            for c in r.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}c'):
                col = c.get('r')[0]
                f_elem = c.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}f')
                if f_elem is not None:
                    if col == 'B': f_elem.text = f'COUNTIF({tc_range_status},"BLOCKED")'
                    elif col == 'C': f_elem.text = f'COUNTIF({uat_range_status},"BLOCKED")'
        elif r_num == 11: # Average score
            for c in r.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}c'):
                if c.get('r').startswith('C'):
                    f_elem = c.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}f')
                    if f_elem is not None:
                        f_elem.text = f'IFERROR(AVERAGE({uat_range_score}),"-")'
        elif r_num == 14: # UAT Tinggi belum pass
            for c in r.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}c'):
                if c.get('r').startswith('B'):
                    f_elem = c.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}f')
                    if f_elem is not None:
                        f_elem.text = f'COUNTIF({uat_range_prio},"Tinggi")-COUNTIFS({uat_range_prio},"Tinggi",{uat_range_status},"PASS")'
        elif r_num == 15: # Bug Critical/High masih terbuka
            for c in r.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}c'):
                if c.get('r').startswith('B'):
                    f_elem = c.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}f')
                    if f_elem is not None:
                        f_elem.text = f'COUNTIFS({bug_range_sev},"Critical",{bug_range_status},"<>Closed",{bug_range_status},"<>Fixed")+COUNTIFS({bug_range_sev},"High",{bug_range_status},"<>Closed",{bug_range_status},"<>Fixed")'

    return tree

# ----------------- MAIN PROCESSING -----------------
def main():
    print(f"Reading {BACKUP_FILE}...")
    with zipfile.ZipFile(BACKUP_FILE, 'r') as z_in:
        file_map = {name: z_in.read(name) for name in z_in.namelist()}
        
    tree1 = modify_sheet1(ET.fromstring(file_map['xl/worksheets/sheet1.xml']))
    tree2, tc_rows = modify_sheet2(ET.fromstring(file_map['xl/worksheets/sheet2.xml']))
    tree3, uat_rows = modify_sheet3(ET.fromstring(file_map['xl/worksheets/sheet3.xml']))
    tree4 = modify_sheet4(ET.fromstring(file_map['xl/worksheets/sheet4.xml']))
    tree5 = modify_sheet5(ET.fromstring(file_map['xl/worksheets/sheet5.xml']), tc_rows, uat_rows)
    
    file_map['xl/worksheets/sheet1.xml'] = ET.tostring(tree1, encoding='utf-8', xml_declaration=True)
    file_map['xl/worksheets/sheet2.xml'] = ET.tostring(tree2, encoding='utf-8', xml_declaration=True)
    file_map['xl/worksheets/sheet3.xml'] = ET.tostring(tree3, encoding='utf-8', xml_declaration=True)
    file_map['xl/worksheets/sheet4.xml'] = ET.tostring(tree4, encoding='utf-8', xml_declaration=True)
    file_map['xl/worksheets/sheet5.xml'] = ET.tostring(tree5, encoding='utf-8', xml_declaration=True)
    
    print(f"Writing updated {OUTPUT_FILE}...")
    with zipfile.ZipFile(OUTPUT_FILE, 'w', compression=zipfile.ZIP_DEFLATED) as z_out:
        for name, data in file_map.items():
            z_out.writestr(name, data)
            
    print("SUCCESS: UAT_template.xlsx updated successfully!")

if __name__ == '__main__':
    main()
