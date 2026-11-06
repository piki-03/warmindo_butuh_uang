import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../models/order_model.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';

/// Halaman Status Pesanan Pelanggan
/// Menampilkan semua pesanan dari meja pelanggan saat ini
/// dengan status realtime: Menunggu → Dimasak → Siap Antar → Lunas
class OrderStatusScreen extends ConsumerWidget {
  const OrderStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final allOrders = ref.watch(kitchenOrdersProvider);
    final tableNumber = cartState.tableNumber;

    // Filter pesanan hanya milik meja ini
    final myOrders = allOrders
        .where((o) => o.tableNumber == tableNumber && o.status != OrderStatus.cancelled)
        .toList();

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'STATUS PESANAN',
              style: GoogleFonts.bebasNeue(
                fontSize: 22,
                letterSpacing: 1.5,
                color: AppColors.primaryYellow,
              ),
            ),
            if (tableNumber > 0)
              Text(
                'Meja #$tableNumber — ${cartState.customerName}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ),
      body: myOrders.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myOrders.length,
              itemBuilder: (context, index) {
                final order = myOrders[index];
                return _buildStatusCard(order, currencyFormatter, index);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🕐', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            'BELUM ADA PESANAN AKTIF',
            style: GoogleFonts.bebasNeue(
              fontSize: 22,
              letterSpacing: 1.2,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pesanan kamu akan muncul di sini setelah dikirim ke dapur.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            ),
        ],
      ).animate().fadeIn(duration: 300.ms),
    );
  }

  Widget _buildStatusCard(
    OrderModel order,
    NumberFormat currencyFormatter,
    int index,
  ) {
    final steps = [
      _StatusStep(
        icon: '📋',
        label: 'Pesanan Diterima',
        sublabel: 'Pesanan kamu sudah masuk ke sistem',
        isDone: true,
      ),
      _StatusStep(
        icon: '⏳',
        label: 'Menunggu Diproses',
        sublabel: 'Antri di dapur',
        isDone: order.status != OrderStatus.pending,
        isActive: order.status == OrderStatus.pending,
      ),
      _StatusStep(
        icon: '🍳',
        label: 'Sedang Dimasak',
        sublabel: 'Chef sedang masak pesananmu',
        isDone: order.status == OrderStatus.ready || order.status == OrderStatus.paid,
        isActive: order.status == OrderStatus.cooking,
      ),
      _StatusStep(
        icon: '✅',
        label: 'Siap Diantar',
        sublabel: 'Pesanan siap, tunggu sebentar!',
        isDone: order.status == OrderStatus.paid,
        isActive: order.status == OrderStatus.ready,
      ),
      _StatusStep(
        icon: '💰',
        label: 'Selesai & Lunas',
        sublabel: 'Terima kasih sudah makan di sini!',
        isDone: false,
        isActive: order.status == OrderStatus.paid,
      ),
    ];

    final statusColor = _getStatusColor(order.status);

    return Semantics(
      identifier: 'card_pesanan_${order.id}',
      container: true,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: statusColor.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.08),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.id,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Semantics(
                        identifier: 'txt_total_pesanan_${order.id}',
                        label: '${order.items.length} item, ${currencyFormatter.format(order.totalPrice)}',
                        child: Text(
                          '${order.items.length} item • ${currencyFormatter.format(order.totalPrice)}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Semantics(
                    identifier: 'status_pesanan_${order.id}',
                    label: order.statusLabel,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        order.statusLabel.toUpperCase(),
                        style: GoogleFonts.bebasNeue(
                          fontSize: 13,
                          letterSpacing: 1.2,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Status Timeline
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: steps.asMap().entries.map((entry) {
                  final i = entry.key;
                  final step = entry.value;
                  final isLast = i == steps.length - 1;
                  return _buildTimelineStep(step, isLast);
                }).toList(),
              ),
            ),

            // Item List
            if (order.status == OrderStatus.ready)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.statusReady.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.statusReady.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Text('🔔', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Pesananmu SIAP! Tunggu sebentar, akan segera diantar ke meja.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.statusReady,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().shake(duration: 600.ms),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 80).ms).slideY(begin: 0.1);
  }

  Widget _buildTimelineStep(_StatusStep step, bool isLast) {
    Color dotColor;
    if (step.isActive) {
      dotColor = AppColors.primaryYellow;
    } else if (step.isDone) {
      dotColor = AppColors.statusReady;
    } else {
      dotColor = AppColors.cardElevated;
    }

    final stepSlug = step.label
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');

    return Semantics(
      identifier: 'status_step_$stepSlug',
      selected: step.isActive,
      label: '${step.label}: ${step.sublabel}',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dot + Line
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: step.isActive || step.isDone
                      ? dotColor.withOpacity(0.2)
                      : AppColors.cardElevated,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: dotColor,
                    width: step.isActive ? 2.5 : 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    step.isDone ? '✓' : step.icon,
                    style: TextStyle(
                      fontSize: step.isDone ? 14 : 12,
                      color: step.isDone ? AppColors.statusReady : null,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 30,
                  color: step.isDone
                      ? AppColors.statusReady.withOpacity(0.5)
                      : AppColors.cardElevated,
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Label
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: step.isActive ? FontWeight.bold : FontWeight.w500,
                      color: step.isActive
                          ? AppColors.primaryYellow
                          : step.isDone
                              ? AppColors.textSecondary
                              : AppColors.textMuted,
                    ),
                  ),
                  if (step.isActive) ...[
                    const SizedBox(height: 2),
                    Text(
                      step.sublabel,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                  if (!isLast) const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.statusPending;
      case OrderStatus.cooking:
        return AppColors.statusCooking;
      case OrderStatus.ready:
        return AppColors.statusReady;
      case OrderStatus.paid:
        return AppColors.statusCompleted;
      case OrderStatus.cancelled:
        return AppColors.accentRed;
    }
  }
}

class _StatusStep {
  final String icon;
  final String label;
  final String sublabel;
  final bool isDone;
  final bool isActive;

  const _StatusStep({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.isDone,
    this.isActive = false,
  });
}
