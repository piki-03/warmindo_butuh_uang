import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../models/order_model.dart';
import '../providers/order_provider.dart';

class KitchenDisplayScreen extends ConsumerStatefulWidget {
  const KitchenDisplayScreen({super.key});

  @override
  ConsumerState<KitchenDisplayScreen> createState() =>
      _KitchenDisplayScreenState();
}

class _KitchenDisplayScreenState extends ConsumerState<KitchenDisplayScreen> {
  OrderStatus? _filterStatus;

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(kitchenOrdersProvider);
    final notifier = ref.read(kitchenOrdersProvider.notifier);

    final filteredOrders = orders.where((order) {
      if (_filterStatus == null) return true;
      return order.status == _filterStatus;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F1012),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16181B),
        titleSpacing: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.soup_kitchen, color: AppColors.primaryYellow, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KDS • LAYAR DAPUR',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.bebasNeue(
                      fontSize: 19,
                      letterSpacing: 1.2,
                      color: AppColors.primaryYellow,
                    ),
                  ),
                  Text(
                    'Warmindo Butuh Uang',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accentRed.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.accentRed.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.accentRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${orders.where((o) => o.status != OrderStatus.paid).length} ANTREAN',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentRed,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFF16181B),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildFilterChip('Semua Antrean', null),
                  const SizedBox(width: 8),
                  _buildFilterChip('Menunggu', OrderStatus.pending),
                  const SizedBox(width: 8),
                  _buildFilterChip('Dimasak', OrderStatus.cooking),
                  const SizedBox(width: 8),
                  _buildFilterChip('Siap Antar', OrderStatus.ready),
                ],
              ),
            ),
          ),

          // Orders Grid / List
          Expanded(
            child: filteredOrders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('☕', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text(
                          'TIDAK ADA PESANAN DI KATEGORI INI',
                          style: GoogleFonts.bebasNeue(
                            fontSize: 20,
                            color: AppColors.textMuted,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          'Warmindo Butuh Uang bisa santai sejenak sambil ngopi saset.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return _buildKitchenOrderCard(order, notifier);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, OrderStatus? status) {
    final isSelected = _filterStatus == status;
    final slug = status == null ? 'semua' : status.name;
    return Semantics(
      identifier: 'chip_filter_kds_$slug',
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        onTap: () => setState(() => _filterStatus = status),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryYellow : AppColors.cardElevated,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.black : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKitchenOrderCard(
      OrderModel order, KitchenOrdersNotifier notifier) {
    Color statusColor;
    String statusActionText;
    OrderStatus nextStatus;

    switch (order.status) {
      case OrderStatus.pending:
        statusColor = AppColors.statusPending;
        statusActionText = '👨‍🍳 MULAI MASAK DI WAJAN';
        nextStatus = OrderStatus.cooking;
        break;
      case OrderStatus.cooking:
        statusColor = AppColors.statusCooking;
        statusActionText = '🍜 TANDAI SIAP DIANTAR';
        nextStatus = OrderStatus.ready;
        break;
      case OrderStatus.ready:
        statusColor = AppColors.statusReady;
        statusActionText = '💰 TANDAI SELESAI & LUNAS';
        nextStatus = OrderStatus.paid;
        break;
      case OrderStatus.paid:
      case OrderStatus.cancelled:
        statusColor = AppColors.statusCompleted;
        statusActionText = 'ARSIP SELESAI';
        nextStatus = OrderStatus.paid;
        break;
    }

    return Semantics(
      identifier: 'card_kds_${order.id}',
      container: true,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: statusColor.withOpacity(0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'MEJA #${order.tableNumber}',
                          style: GoogleFonts.bebasNeue(
                            fontSize: 18,
                            letterSpacing: 1.2,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        order.customerName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    order.statusLabel.toUpperCase(),
                    style: GoogleFonts.bebasNeue(
                      fontSize: 14,
                      letterSpacing: 1.2,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),

            // Items List with High-Contrast Tags
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...order.items.map((cartItem) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryYellow.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${cartItem.quantity}x',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryYellow,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  cartItem.menuItem.name,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Critical Tags for Warmindo Butuh Uang (Cabe, Telur, Kuah)
                          if (cartItem.customization != null) ...[
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                _buildContrastTag(
                                  '🍜 ${cartItem.customization!.kematangan.toUpperCase()}',
                                  AppColors.secondaryOrange,
                                ),
                                _buildContrastTag(
                                  '🥚 ${cartItem.customization!.pilihanTelur.toUpperCase()}',
                                  AppColors.primaryYellow,
                                ),
                                _buildContrastTag(
                                  '🌶️ ${cartItem.customization!.jumlahCabe} CABE ULEK',
                                  cartItem.customization!.jumlahCabe > 7
                                      ? AppColors.accentRed
                                      : Colors.orangeAccent,
                                ),
                                ...cartItem.customization!.toppings.map(
                                  (top) => _buildContrastTag(
                                      '+ $top', Colors.cyanAccent),
                                ),
                              ],
                            ),
                            if (cartItem.customization!.catatan.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Catatan Khusus: "${cartItem.customization!.catatan}"',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.amberAccent,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ],
                      ),
                    );
                  }).toList(),

                  const Divider(color: AppColors.cardElevated, height: 16),

                  // Footer with Total & Tip
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tip WBU: ${currencyFormatter.format(order.tipAmount)}',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 11, color: AppColors.textMuted),
                      ),
                      Text(
                        'Total: ${currencyFormatter.format(order.totalPrice)}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryYellow,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Action Button for Kitchen Staff
                  if (order.status != OrderStatus.paid)
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: Semantics(
                        identifier: 'btn_aksi_kds_${order.id}',
                        button: true,
                        label: statusActionText,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: statusColor,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            notifier.updateOrderStatus(order.id, nextStatus);
                          },
                          child: Text(
                            statusActionText,
                            style: GoogleFonts.bebasNeue(
                              fontSize: 16,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  Widget _buildContrastTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color, width: 1.2),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}
