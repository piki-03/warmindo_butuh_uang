import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants/app_colors.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import 'indomie_customizer_sheet.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  final VoidCallback onOpenCart;

  const CatalogScreen({
    super.key,
    required this.onOpenCart,
  });

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  final List<String> _categories = [
    'Semua',
    'Indomie Goreng',
    'Indomie Kuah',
    'Nasi & Lauk',
    'Minuman Dingin',
    'Minuman Hangat',
    'Camilan/Roti',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fitur Cerdas: Gacha Menu untuk Pelanggan yang Bingung
  void _rollGachaMenu(List<MenuItem> items) {
    final random = Random();
    final randomItem = items[random.nextInt(items.length)];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(
          child: Text(
            '🎰 GACHA MENU PILIHAN!',
            style: GoogleFonts.bebasNeue(
              fontSize: 24,
              color: AppColors.primaryYellow,
              letterSpacing: 1.2,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: randomItem.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.cardElevated,
                  height: 120,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.fastfood, size: 50),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              randomItem.name,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Takdir malam ini: Jangan kebanyakan mikir, perut udah keroncongan!',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          Semantics(
            identifier: 'btn_tolak_gacha',
            button: true,
            child: TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Tolak Takdir', style: TextStyle(color: AppColors.textMuted)),
            ),
          ),
          Semantics(
            identifier: 'btn_ambil_gacha',
            button: true,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _handleItemTap(randomItem);
              },
              child: const Text('Ambil Ini!'),
            ),
          ),
        ],
      ).animate().scale(duration: 250.ms, curve: Curves.easeOutBack),
    );
  }

  void _handleItemTap(MenuItem item) {
    if (item.isIndomie) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => IndomieCustomizerSheet(
          menuItem: item,
          onConfirm: (customization) {
            ref.read(cartProvider.notifier).addItem(item, customization: customization);
            _showAddedSnackbar(item.name);
          },
        ),
      );
    } else {
      ref.read(cartProvider.notifier).addItem(item);
      _showAddedSnackbar(item.name);
    }
  }

  void _showAddedSnackbar(String itemName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.cardElevated,
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.primaryYellow, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$itemName masuk keranjang!',
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'LIHAT',
          textColor: AppColors.primaryYellow,
          onPressed: widget.onOpenCart,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allItems = ref.watch(menuListProvider);
    final cartState = ref.watch(cartProvider);

    final filteredItems = allItems.where((item) {
      final matchesCategory =
          _selectedCategory == 'Semua' || item.category == _selectedCategory;
      final matchesSearch =
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WARMINDO BUTUH UANG',
              style: GoogleFonts.bebasNeue(
                fontSize: 26,
                letterSpacing: 1.5,
                color: AppColors.primaryYellow,
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryOrange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '📍 MEJA #${cartState.tableNumber}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryOrange,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '• Buka s/d 03:00 Pagi',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Semantics(
            identifier: 'btn_buka_keranjang',
            button: true,
            label: 'Keranjang, ${cartState.totalItemCount} item',
            child: IconButton(
              tooltip: 'Keranjang',
              onPressed: widget.onOpenCart,
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary, size: 28),
                  if (cartState.totalItemCount > 0)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.accentRed,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Text(
                          '${cartState.totalItemCount}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Banner Warkop & Gacha
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryYellow.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MALAM INI MAU MAKAN APA?',
                            style: GoogleFonts.bebasNeue(
                              fontSize: 22,
                              color: Colors.black,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '"Makan Indomie biar tenang, bayar biar kami senang!"',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Semantics(
                            identifier: 'btn_gacha_menu',
                            button: true,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: AppColors.primaryYellow,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              onPressed: () => _rollGachaMenu(allItems),
                              icon: const Icon(Icons.casino, size: 18),
                              label: const Text('PUTAR GACHA MENU'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Text('🍜', style: TextStyle(fontSize: 44)),
                    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                     .scale(duration: 1200.ms, begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05)),
                  ],
                ),
              ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1),
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Semantics(
                identifier: 'input_cari',
                textField: true,
                label: 'Cari Indomie, Nasi, atau Minuman Dingin...',
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Cari Indomie, Nasi, atau Minuman Dingin...',
                    hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: AppColors.primaryYellow),
                    filled: true,
                    fillColor: AppColors.cardBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (val) {
                    setState(() => _searchQuery = val);
                  },
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Category Chips Selector
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  final catSlug = cat
                      .toLowerCase()
                      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
                      .replaceAll(RegExp(r'^_|_$'), '');
                  return Semantics(
                    identifier: 'chip_kategori_$catSlug',
                    button: true,
                    selected: isSelected,
                    label: cat,
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: AppColors.primaryYellow,
                      backgroundColor: AppColors.cardBg,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 12,
                      ),
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedCategory = cat);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Menu List Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = filteredItems[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildMenuCard(item),
                  ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.05);
                },
                childCount: filteredItems.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildMenuCard(MenuItem item) {
    return Semantics(
      identifier: 'card_menu_${item.id}',
      button: true,
      label: '${item.name}, ${currencyFormatter.format(item.basePrice)}',
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: item.isIndomie ? AppColors.primaryYellow.withOpacity(0.3) : AppColors.cardElevated,
            width: item.isIndomie ? 1.5 : 1.0,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => _handleItemTap(item),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      width: 85,
                      height: 85,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.cardElevated,
                        width: 85,
                        height: 85,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.cardElevated,
                        width: 85,
                        height: 85,
                        child: const Icon(Icons.fastfood, color: AppColors.textMuted),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.name,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (item.isIndomie)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.accentRed.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Kustomisasi',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accentRed,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              currencyFormatter.format(item.basePrice),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryYellow,
                              ),
                            ),
                            Semantics(
                              identifier: 'btn_tambah_${item.id}',
                              button: true,
                              label: item.isIndomie ? '+ RACIK' : '+ PESAN',
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.cardElevated,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item.isIndomie ? '+ RACIK' : '+ PESAN',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryYellow,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
