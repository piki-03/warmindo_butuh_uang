import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../core/constants/app_colors.dart';
import '../providers/cart_provider.dart';

/// Screen QR Scanner — dipanggil saat user belum memilih meja
/// QR Code berisi token meja, format: WBU-MEJA-XXXXXX
/// Token dicocokkan dengan tabel `tables` di Supabase
class QRScannerScreen extends ConsumerStatefulWidget {
  const QRScannerScreen({super.key});

  @override
  ConsumerState<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends ConsumerState<QRScannerScreen> {
  final MobileScannerController _cameraController = MobileScannerController();
  bool _isProcessing = false;

  // Mapping QR token → nomor meja
  // Harus sinkron dengan data di tabel Supabase
  static const Map<String, int> _qrTokenToTable = {
    'WBU-MEJA-A1B2C3': 1,
    'WBU-MEJA-D4E5F6': 2,
    'WBU-MEJA-G7H8I9': 3,
    'WBU-MEJA-J0K1L2': 4,
    'WBU-MEJA-M3N4O5': 5,
    'WBU-MEJA-P6Q7R8': 6,
    'WBU-MEJA-S9T0U1': 7,
    'WBU-MEJA-V2W3X4': 8,
    'WBU-MEJA-Y5Z6A7': 9,
    'WBU-MEJA-B8C9D0': 10,
    'WBU-MEJA-E1F2G3': 11,
    'WBU-MEJA-H4I5J6': 12,
  };

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _onQRDetected(BarcodeCapture capture) {
    if (_isProcessing) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    final rawValue = barcode.rawValue!.trim();

    // Cek apakah token valid
    final tableNumber = _qrTokenToTable[rawValue];

    if (tableNumber != null) {
      setState(() => _isProcessing = true);
      _cameraController.stop();

      // Set nomor meja di cart state
      ref.read(cartProvider.notifier).setTableNumber(tableNumber);
      ref.read(cartProvider.notifier).setCustomerName('Pelanggan Meja $tableNumber');

      // Tampilkan dialog sukses lalu kembali
      _showSuccessDialog(tableNumber);
    } else {
      // QR tidak dikenali — tampilkan error singkat
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'QR Code tidak valid! Pastikan scan QR di meja Warmindo Butuh Uang.',
            style: GoogleFonts.plusJakartaSans(fontSize: 12),
          ),
          backgroundColor: AppColors.accentRed,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showSuccessDialog(int tableNumber) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('✅', style: TextStyle(fontSize: 54)),
            const SizedBox(height: 12),
            Text(
              'MEJA #$tableNumber TERDETEKSI!',
              textAlign: TextAlign.center,
              style: GoogleFonts.bebasNeue(
                fontSize: 24,
                letterSpacing: 1.5,
                color: AppColors.primaryYellow,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kamu duduk di Meja #$tableNumber. Selamat memesan!',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Semantics(
                identifier: 'btn_lihat_menu_qr',
                button: true,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryYellow,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);   // Tutup dialog
                    Navigator.pop(context); // Kembali ke menu utama
                  },
                  child: Text(
                    'LIHAT MENU 🍜',
                    style: GoogleFonts.bebasNeue(fontSize: 18, letterSpacing: 1.2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ).animate().scale(duration: 250.ms, curve: Curves.easeOutBack),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Semantics(
          identifier: 'btn_kembali_scanner',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'SCAN QR MEJA',
          style: GoogleFonts.bebasNeue(
            fontSize: 22,
            letterSpacing: 1.5,
            color: AppColors.primaryYellow,
          ),
        ),
        actions: [
          Semantics(
            identifier: 'btn_toggle_flash',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.flash_on, color: Colors.white),
              onPressed: () => _cameraController.toggleTorch(),
              tooltip: 'Flash',
            ),
          ),
          Semantics(
            identifier: 'btn_flip_camera',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
              onPressed: () => _cameraController.switchCamera(),
              tooltip: 'Ganti Kamera',
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera View
          MobileScanner(
            controller: _cameraController,
            onDetect: _onQRDetected,
          ),

          // Overlay: Frame Scanner
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primaryYellow,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
              .then(delay: 500.ms)
              .shimmer(
                duration: 1500.ms,
                color: AppColors.primaryYellow.withOpacity(0.3),
              ),
          ),

          // Instruksi bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                children: [
                  const Text('📱', style: TextStyle(fontSize: 32)),
                  const SizedBox(height: 8),
                  Text(
                    'Arahkan kamera ke QR Code di meja',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Nomor meja akan otomatis terdeteksi',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Tombol manual (jika tidak ada kamera)
                  Semantics(
                    identifier: 'btn_pilih_meja_manual',
                    button: true,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Pilih meja manual',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.primaryYellow,
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
