import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_colors.dart';
import '../providers/cart_provider.dart';
import 'catalog_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

import 'order_status_screen.dart';
import 'qr_scanner_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Tampilkan dialog pilih meja saat pertama kali buka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTablePickerDialog();
    });
  }

  void _showTablePickerDialog() {
    if (!mounted) return;
    final cartState = ref.read(cartProvider);
    if (cartState.tableNumber != 0) return;

    final nameController = TextEditingController();
    int selectedTable = 1;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Semantics(
            identifier: 'dialog_selamat_datang',
            container: true,
            child: Column(
              children: [
                const Text('🍜', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 8),
                Text(
                  'SELAMAT DATANG!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bebasNeue(
                    fontSize: 26,
                    letterSpacing: 1.5,
                    color: AppColors.primaryYellow,
                  ),
                ),
                Text(
                  'Warmindo Butuh Uang',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TOMBOL SCAN QR — cara utama
              SizedBox(
                width: double.infinity,
                child: Semantics(
                  identifier: 'btn_scan_qr',
                  button: true,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryYellow,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const QRScannerScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.qr_code_scanner, size: 22),
                    label: Text(
                      'SCAN QR DI MEJA',
                      style: GoogleFonts.bebasNeue(fontSize: 18, letterSpacing: 1.2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.cardElevated)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'atau pilih manual',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.cardElevated)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Pilih Nomor Meja:',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(12, (i) {
                  final tableNum = i + 1;
                  final isSelected = selectedTable == tableNum;
                  return Semantics(
                    identifier: 'meja_$tableNum',
                    button: true,
                    label: '$tableNum',
                    selected: isSelected,
                    child: GestureDetector(
                      onTap: () => setDialogState(() => selectedTable = tableNum),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryYellow : AppColors.cardElevated,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryYellow : AppColors.cardElevated,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$tableNum',
                            style: GoogleFonts.bebasNeue(
                              fontSize: 20,
                              color: isSelected ? Colors.black : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              Semantics(
                identifier: 'input_nama',
                textField: true,
                label: 'Nama kamu (opsional)...',
                child: TextField(
                  controller: nameController,
                  style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Nama kamu (opsional)...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                    filled: true,
                    fillColor: AppColors.cardElevated,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: Semantics(
                identifier: 'btn_lanjut_meja',
                button: true,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryYellow,
                    side: const BorderSide(color: AppColors.primaryYellow),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    final name = nameController.text.trim().isNotEmpty
                        ? nameController.text.trim()
                        : 'Pelanggan Meja $selectedTable';
                    ref.read(cartProvider.notifier).setTableNumber(selectedTable);
                    ref.read(cartProvider.notifier).setCustomerName(name);
                    Navigator.pop(ctx);
                  },
                  child: Text(
                    'Lanjut dengan Meja #$selectedTable',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);

    final screens = [
      CatalogScreen(onOpenCart: () => setState(() => _currentIndex = 1)),
      CartScreen(onBackToMenu: () => setState(() => _currentIndex = 0)),
      const OrderStatusScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          border: Border(
            top: BorderSide(color: AppColors.cardElevated.withOpacity(0.8), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.restaurant_menu, 'Menu', 'nav_menu'),
                _buildCartNavItem(1, Icons.shopping_bag_outlined, 'Keranjang', cartState.totalItemCount, 'nav_keranjang'),
                _buildNavItem(2, Icons.receipt_long_outlined, 'Riwayat', 'nav_riwayat'),
                _buildNavItem(3, Icons.person_pin, 'Profil', 'nav_profil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, String identifier) {
    final isSelected = _currentIndex == index;
    return Semantics(
      identifier: identifier,
      label: label,
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryYellow.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected ? AppColors.primaryYellow : AppColors.textSecondary,
              ),
              if (isSelected) ...[
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryYellow,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartNavItem(int index, IconData icon, String label, int count, String identifier) {
    final isSelected = _currentIndex == index;
    final cartLabel = count > 0 ? '$label, $count item' : label;
    return Semantics(
      identifier: identifier,
      label: cartLabel,
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryYellow.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    icon,
                    size: 22,
                    color: isSelected ? AppColors.primaryYellow : AppColors.textSecondary,
                  ),
                  if (count > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: AppColors.accentRed,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '$count',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (isSelected) ...[
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryYellow,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
