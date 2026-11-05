import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../models/order_model.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';

class CartScreen extends ConsumerWidget {
  final VoidCallback onBackToMenu;

  const CartScreen({
    super.key,
    required this.onBackToMenu,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    if (cartState.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'KERANJANG MEJA #${cartState.tableNumber}',
            style: GoogleFonts.bebasNeue(
              fontSize: 24,
              letterSpacing: 1.2,
              color: AppColors.primaryYellow,
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🥢', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                Text(
                  'KERANJANG MASIH KOSONG!',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 26,
                    letterSpacing: 1.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Perut lapar kok cuma diliatin doang? Pilih Indomie kuah atau goreng dulu yuk!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Semantics(
                  identifier: 'btn_lihat_menu',
                  button: true,
                  child: ElevatedButton.icon(
                    onPressed: onBackToMenu,
                    icon: const Icon(Icons.restaurant_menu),
                    label: const Text('LIHAT DAFTAR MENU'),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.9, 0.9)),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'KERANJANG MEJA #${cartState.tableNumber}',
          style: GoogleFonts.bebasNeue(
            fontSize: 24,
            letterSpacing: 1.2,
            color: AppColors.primaryYellow,
          ),
        ),
        actions: [
          Semantics(
            identifier: 'btn_hapus_semua',
            button: true,
            child: TextButton(
              onPressed: () => cartNotifier.clearCart(),
              child: const Text('Hapus Semua', style: TextStyle(color: AppColors.accentRed)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // List of Items
            ...cartState.items.map((cartItem) {
              return Semantics(
                identifier: 'card_keranjang_${cartItem.id}',
                container: true,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardElevated),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartItem.menuItem.name,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  currencyFormatter.format(cartItem.unitPrice),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryYellow,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Qty Controller
                          Row(
                            children: [
                              Semantics(
                                identifier: 'btn_kurang_qty_${cartItem.id}',
                                button: true,
                                label: 'Kurang jumlah ${cartItem.menuItem.name}',
                                child: IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: const Icon(Icons.remove_circle_outline, color: AppColors.secondaryOrange),
                                  onPressed: () => cartNotifier.updateQuantity(cartItem.id, cartItem.quantity - 1),
                                ),
                              ),
                              Semantics(
                                identifier: 'txt_qty_${cartItem.id}',
                                label: '${cartItem.quantity}',
                                child: Text(
                                  '${cartItem.quantity}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Semantics(
                                identifier: 'btn_tambah_qty_${cartItem.id}',
                                button: true,
                                label: 'Tambah jumlah ${cartItem.menuItem.name}',
                                child: IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryYellow),
                                  onPressed: () => cartNotifier.updateQuantity(cartItem.id, cartItem.quantity + 1),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Customization Tags if Indomie
                      if (cartItem.customization != null) ...[
                        const Divider(color: AppColors.cardElevated, height: 16),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _buildTag('🍜 ${cartItem.customization!.kematangan}', AppColors.secondaryOrange),
                            _buildTag('🥚 ${cartItem.customization!.pilihanTelur}', AppColors.primaryYellow),
                            _buildTag(
                              '🌶️ ${cartItem.customization!.jumlahCabe} Cabe',
                              cartItem.customization!.jumlahCabe > 7 ? AppColors.accentRed : Colors.orangeAccent,
                            ),
                            ...cartItem.customization!.toppings.map((top) => _buildTag('+ $top', Colors.cyanAccent)),
                          ],
                        ),
                        if (cartItem.customization!.catatan.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Catatan: "${cartItem.customization!.catatan}"',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 8),

            // Fitur Cerdas: Tombol Tambah Gorengan Mandiri
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardElevated.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.secondaryOrange.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Text('🥟', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comot Gorengan di Piring Meja?',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '+Rp 1.500 per biji (Bakwan/Tempe/Tahu)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Semantics(
                    identifier: 'btn_tambah_gorengan',
                    button: true,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onPressed: () {
                        cartNotifier.addGorenganMandiri();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('+1 Gorengan ditambahkan ke tagihan meja!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: const Text('+ GORENGAN'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tip Uang Rokok untuk Warmindo Butuh Uang
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('☕', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        'Tip Kopi untuk Warmindo Butuh Uang',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '"Sesuai nama warung kami, tip Anda bikin dapur makin semangat masaknya!"',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [0.0, 1000.0, 2000.0, 5000.0].map((tip) {
                      final isSelected = cartState.tipAmount == tip;
                      final label = tip == 0 ? 'Ikhlas Doa (Rp 0)' : '+${currencyFormatter.format(tip)}';
                      final tipId = tip.toInt().toString();
                      return Semantics(
                        identifier: 'chip_tip_$tipId',
                        button: true,
                        selected: isSelected,
                        label: label,
                        child: ChoiceChip(
                          label: Text(label),
                          selected: isSelected,
                          selectedColor: AppColors.primaryYellow,
                          backgroundColor: AppColors.cardElevated,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.black : AppColors.textPrimary,
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (selected) {
                            if (selected) cartNotifier.setTipAmount(tip);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Ringkasan Pembayaran
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Subtotal Makanan & Minuman', currencyFormatter.format(cartState.subtotal)),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Tip Warmindo Butuh Uang', currencyFormatter.format(cartState.tipAmount)),
                  const Divider(color: AppColors.cardElevated, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TOTAL PEMBAYARAN',
                        style: GoogleFonts.bebasNeue(
                          fontSize: 20,
                          letterSpacing: 1.2,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Semantics(
                        identifier: 'txt_total_harga',
                        label: currencyFormatter.format(cartState.grandTotal),
                        child: Text(
                          currencyFormatter.format(cartState.grandTotal),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryYellow,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tombol Kirim Pesanan ke Dapur
            SizedBox(
              width: double.infinity,
              height: 54,
              child: Semantics(
                identifier: 'btn_kirim_pesanan',
                button: true,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryYellow,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    _submitOrder(context, ref, cartState);
                  },
                  icon: const Icon(Icons.outdoor_grill),
                  label: Text(
                    'KIRIM PESANAN KE DAPUR',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 20,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  void _submitOrder(BuildContext context, WidgetRef ref, CartState cartState) {
    final newOrder = OrderModel(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch % 10000}',
      tableNumber: cartState.tableNumber,
      customerName: cartState.customerName,
      items: List.from(cartState.items),
      tipAmount: cartState.tipAmount,
      totalPrice: cartState.grandTotal,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
    );

    // Kirim ke Dapur Provider
    ref.read(kitchenOrdersProvider.notifier).addOrder(newOrder);

    // Kosongkan keranjang
    ref.read(cartProvider.notifier).clearCart();

    // Tampilkan Dialog Sukses
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🍳🔥', style: TextStyle(fontSize: 54)),
            const SizedBox(height: 14),
            Text(
              'PESANAN DITERIMA DAPUR!',
              textAlign: TextAlign.center,
              style: GoogleFonts.bebasNeue(
                fontSize: 26,
                letterSpacing: 1.5,
                color: AppColors.primaryYellow,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pesanan Meja #${newOrder.tableNumber} sudah masuk ke dapur Warmindo Butuh Uang. Duduk manis, mie lezat segera meluncur!',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            Semantics(
              identifier: 'btn_kembali_ke_menu',
              button: true,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  onBackToMenu();
                },
                child: const Text('KEMBALI KE MENU'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.4), width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
