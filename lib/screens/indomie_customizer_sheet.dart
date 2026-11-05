import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../models/menu_item.dart';

class IndomieCustomizerSheet extends StatefulWidget {
  final MenuItem menuItem;
  final Function(IndomieCustomization customization) onConfirm;

  const IndomieCustomizerSheet({
    super.key,
    required this.menuItem,
    required this.onConfirm,
  });

  @override
  State<IndomieCustomizerSheet> createState() => _IndomieCustomizerSheetState();
}

class _IndomieCustomizerSheetState extends State<IndomieCustomizerSheet> {
  String _selectedKematangan = 'Nyemek';
  String _selectedTelur = 'Ceplok 1/2 Matang';
  int _jumlahCabe = 5;
  final Set<String> _selectedToppings = {'Kornet'};
  final TextEditingController _notesController = TextEditingController();

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  final List<String> _kematanganOptions = [
    'Kering / Standar',
    'Nyemek',
    'Lembek',
  ];

  final List<String> _telurOptions = [
    'Tanpa Telur',
    'Ceplok Matang',
    'Ceplok 1/2 Matang',
    'Dadar',
  ];

  final Map<String, double> _toppingOptions = {
    'Kornet': 4000.0,
    'Keju': 3000.0,
    'Sosis': 3000.0,
    'Bakso': 3000.0,
  };

  IndomieCustomization get currentCustomization => IndomieCustomization(
        kematangan: _selectedKematangan,
        pilihanTelur: _selectedTelur,
        jumlahCabe: _jumlahCabe,
        toppings: _selectedToppings.toList(),
        catatan: _notesController.text,
      );

  String get _spicyLabel {
    if (_jumlahCabe == 0) return '😴 Aman (Tanpa Cabe)';
    if (_jumlahCabe <= 3) return '🌶️ Hangat Biasa';
    if (_jumlahCabe <= 7) return '🌶️🌶️ Keringatan Mantap';
    if (_jumlahCabe <= 12) return '🔥🌶️ Pedas Mampus!';
    return '💀☠️ Dewa Lambung (Tanggung Sendiri)';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double totalPrice = widget.menuItem.basePrice + currentCustomization.extraPrice;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header Title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'KUSTOMISASI INDOMIE',
                        style: GoogleFonts.bebasNeue(
                          fontSize: 24,
                          letterSpacing: 1.2,
                          color: AppColors.primaryYellow,
                        ),
                      ),
                      Text(
                        widget.menuItem.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  currencyFormatter.format(widget.menuItem.basePrice),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryOrange,
                  ),
                ),
              ],
            ),
            const Divider(color: AppColors.cardElevated, height: 28),

            // 1. Kematangan Mie
            _buildSectionTitle('1. Tingkat Kuah / Kematangan Mie'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _kematanganOptions.map((opt) {
                final isSelected = _selectedKematangan == opt;
                final slug = opt
                    .toLowerCase()
                    .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
                    .replaceAll(RegExp(r'^_|_$'), '');
                return Semantics(
                  identifier: 'chip_kematangan_$slug',
                  button: true,
                  selected: isSelected,
                  label: opt,
                  child: ChoiceChip(
                    label: Text(opt),
                    selected: isSelected,
                    selectedColor: AppColors.primaryYellow,
                    backgroundColor: AppColors.cardElevated,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedKematangan = opt);
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // 2. Olahan Telur
            _buildSectionTitle('2. Pilihan Telur (+Rp 4.000 jika pilih telur)'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _telurOptions.map((opt) {
                final isSelected = _selectedTelur == opt;
                final slug = opt
                    .toLowerCase()
                    .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
                    .replaceAll(RegExp(r'^_|_$'), '');
                return Semantics(
                  identifier: 'chip_telur_$slug',
                  button: true,
                  selected: isSelected,
                  label: opt,
                  child: ChoiceChip(
                    label: Text(opt),
                    selected: isSelected,
                    selectedColor: AppColors.primaryYellow,
                    backgroundColor: AppColors.cardElevated,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedTelur = opt);
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // 3. Level Pedas Cabe Rawit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle('3. Level Pedas Cabe Rawit Ulek'),
                Text(
                  '$_jumlahCabe Cabe',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentRed,
                  ),
                ),
              ],
            ),
            Text(
              _spicyLabel,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _jumlahCabe > 7 ? AppColors.accentRed : AppColors.secondaryOrange,
              ),
            ),
            Semantics(
              identifier: 'slider_level_pedas',
              slider: true,
              label: 'Level Pedas, $_jumlahCabe Cabe',
              value: '$_jumlahCabe',
              child: Slider(
                value: _jumlahCabe.toDouble(),
                min: 0,
                max: 15,
                divisions: 15,
                activeColor: _jumlahCabe > 7 ? AppColors.accentRed : AppColors.secondaryOrange,
                inactiveColor: AppColors.cardElevated,
                onChanged: (val) {
                  setState(() => _jumlahCabe = val.round());
                },
              ),
            ),
            const SizedBox(height: 12),

            // 4. Topping Tambahan
            _buildSectionTitle('4. Topping Warkop Tambahan'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _toppingOptions.entries.map((entry) {
                final isSelected = _selectedToppings.contains(entry.key);
                final slug = entry.key
                    .toLowerCase()
                    .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
                    .replaceAll(RegExp(r'^_|_$'), '');
                return Semantics(
                  identifier: 'chip_topping_$slug',
                  button: true,
                  selected: isSelected,
                  label: '${entry.key} (+${currencyFormatter.format(entry.value)})',
                  child: FilterChip(
                    label: Text('${entry.key} (+${currencyFormatter.format(entry.value)})'),
                    selected: isSelected,
                    selectedColor: AppColors.secondaryOrange.withOpacity(0.3),
                    checkmarkColor: AppColors.secondaryOrange,
                    backgroundColor: AppColors.cardElevated,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primaryYellow : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedToppings.add(entry.key);
                        } else {
                          _selectedToppings.remove(entry.key);
                        }
                      });
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // 5. Catatan Khusus
            _buildSectionTitle('5. Catatan untuk Dapur Warmindo Butuh Uang'),
            const SizedBox(height: 8),
            Semantics(
              identifier: 'input_catatan_dapur',
              textField: true,
              label: 'Catatan untuk Dapur Warmindo Butuh Uang',
              child: TextField(
                controller: _notesController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Contoh: Sayur sawi dibanyakin, bawang goreng dipisah...',
                  hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  filled: true,
                  fillColor: AppColors.cardElevated,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: Semantics(
                identifier: 'btn_tambah_keranjang',
                button: true,
                label: 'Masukkan Keranjang, ${currencyFormatter.format(totalPrice)}',
                child: ElevatedButton(
                  onPressed: () {
                    widget.onConfirm(currentCustomization);
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MASUKKAN KERANJANG',
                        style: GoogleFonts.bebasNeue(
                          fontSize: 18,
                          letterSpacing: 1.2,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        currencyFormatter.format(totalPrice),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().scale(duration: 200.ms, curve: Curves.easeOutBack),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}
