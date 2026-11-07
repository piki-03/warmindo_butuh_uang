import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';
import 'kitchen_display_screen.dart';
import 'admin_login_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String _selectedAvatar = '🍜';
  final List<String> _avatarChoices = ['🍜', '🍳', '☕', '🌶️', '🥟', '🥤'];

  void _showStaffPinDialog(BuildContext context) {
    final pinController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.lock, color: AppColors.primaryYellow),
            const SizedBox(width: 8),
            Text(
              'MODE WARMINDO BUTUH UANG',
              style: GoogleFonts.bebasNeue(
                fontSize: 22,
                color: AppColors.primaryYellow,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masukkan PIN Khusus Staff Dapur / Kasir untuk memantau antrean pesanan wajan:',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Semantics(
              identifier: 'input_pin_staff',
              textField: true,
              label: 'PIN Khusus Staff Dapur / Kasir',
              child: TextField(
                controller: pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: GoogleFonts.bebasNeue(fontSize: 28, letterSpacing: 8),
                decoration: InputDecoration(
                  hintText: '••••',
                  filled: true,
                  fillColor: AppColors.cardElevated,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const Center(
              child: Text(
                '💡 PIN Demo Mahasiswa: 1234',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ),
          ],
        ),
        actions: [
          Semantics(
            identifier: 'btn_batal_pin',
            button: true,
            child: TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal',
                  style: TextStyle(color: AppColors.textMuted)),
            ),
          ),
          Semantics(
            identifier: 'btn_konfirmasi_pin',
            button: true,
            child: ElevatedButton(
              onPressed: () {
                if (pinController.text == '1234') {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const KitchenDisplayScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'PIN Salah! Khusus Staff Warmindo Butuh Uang & Kasir.'),
                      backgroundColor: AppColors.accentRed,
                    ),
                  );
                }
              },
              child: const Text('MASUK DAPUR'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.logout, color: AppColors.accentRed),
            const SizedBox(width: 8),
            Text(
              'LOGOUT ADMIN',
              style: GoogleFonts.bebasNeue(
                fontSize: 22,
                color: AppColors.accentRed,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        content: Text(
          'Yakin ingin keluar dari mode admin? Anda harus login kembali untuk mengakses profil dan dapur.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          Semantics(
            identifier: 'btn_batal_logout',
            button: true,
            child: TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal',
                  style: TextStyle(color: AppColors.textMuted)),
            ),
          ),
          Semantics(
            identifier: 'btn_konfirmasi_logout',
            button: true,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentRed,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                Navigator.pop(ctx);
              },
              child: const Text('LOGOUT'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Jika belum login, tampilkan halaman gate
    if (authState.status != AuthStatus.authenticated) {
      return _buildLoginGate(context);
    }

    // Jika sudah login, tampilkan profil admin
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PROFIL ADMIN',
          style: GoogleFonts.bebasNeue(
            fontSize: 24,
            letterSpacing: 1.2,
            color: AppColors.primaryYellow,
          ),
        ),
        actions: [
          Semantics(
            identifier: 'btn_logout_admin',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.logout, color: AppColors.accentRed),
              tooltip: 'Logout Admin',
              onPressed: _handleLogout,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            // Admin Profile Card Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.cardElevated, AppColors.cardBg],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: AppColors.primaryYellow.withOpacity(0.3),
                    width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Animated Avatar
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.darkBg,
                          border: Border.all(
                              color: AppColors.primaryYellow, width: 3),
                        ),
                        child: Center(
                          child: Text(
                            _selectedAvatar,
                            style: const TextStyle(fontSize: 48),
                          ),
                        ),
                      )
                          .animate()
                          .scale(duration: 400.ms, curve: Curves.easeOutBack),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.secondaryOrange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit,
                            size: 14, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Avatar Picker Selector
                  Wrap(
                    spacing: 8,
                    children: _avatarChoices.map((av) {
                      final isSelected = _selectedAvatar == av;
                      final avIndex = _avatarChoices.indexOf(av);
                      return Semantics(
                        identifier: 'btn_avatar_$avIndex',
                        button: true,
                        selected: isSelected,
                        label: 'Avatar $av',
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedAvatar = av),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? AppColors.primaryYellow.withOpacity(0.3)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryYellow
                                    : Colors.transparent,
                              ),
                            ),
                            child: Text(av, style: const TextStyle(fontSize: 20)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  // Admin Name & Role Badge
                  Text(
                    authState.user?.email?.split('@').first.toUpperCase() ??
                        'ADMIN',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 28,
                      letterSpacing: 1.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '👑 ADMIN WARMINDO',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    authState.user?.email ?? '',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1),

            const SizedBox(height: 16),

            // Connection Status Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.statusReady.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.statusReady.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.statusReady,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Supabase Terhubung • Sesi aktif',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.statusReady,
                      ),
                    ),
                  ),
                  const Icon(Icons.cloud_done,
                      size: 18, color: AppColors.statusReady),
                ],
              ),
            ).animate().fadeIn(delay: 50.ms),

            const SizedBox(height: 16),

            // Gamifikasi: "Status Anak Warmindo Butuh Uang"
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardElevated),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🏆', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        'PENCAPAIAN ANAK TONGKRONGAN',
                        style: GoogleFonts.bebasNeue(
                          fontSize: 18,
                          letterSpacing: 1.2,
                          color: AppColors.primaryYellow,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatBadge('Gelar Kehormatan',
                            'Sultan Cabe 15 🌶️', AppColors.accentRed),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatBadge(
                            'Poin WBU', '750 Poin', AppColors.primaryYellow),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatBadge('Spesialis Menu',
                            'Kuah Kari Nyemek', AppColors.secondaryOrange),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatBadge('Level Nongkrong',
                            'Warga Tetap Warkop', Colors.tealAccent),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 16),

            // Info Warmindo Butuh Uang
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TENTANG WARMINDO BUTUH UANG',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 18,
                      letterSpacing: 1.2,
                      color: AppColors.primaryYellow,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow(Icons.access_time,
                      'Jam Buka: 17:00 - 03:00 Pagi (Setiap Hari)'),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.location_on,
                      'Jl. Tongkrongan Kampus No. 88 (Dekat FTI)'),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.wifi,
                      'Free Wi-Fi: "WarmindoButuhUang_VIP" (Pass: bayardulukak)'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cardElevated,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '💬 "Hidup ini seperti Indomie, ada yang rebus ada yang goreng, tapi yang paling penting jangan lupa bayar!"',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 20),

            // Pintu Rahasia Masuk Kitchen Display System (Staff Only)
            SizedBox(
              width: double.infinity,
              child: Semantics(
                identifier: 'btn_masuk_kds',
                button: true,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryYellow,
                    side: const BorderSide(color: AppColors.primaryYellow),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => _showStaffPinDialog(context),
                  icon: const Icon(Icons.soup_kitchen),
                  label: Text(
                    'MASUK MODE DAPUR WARMINDO BUTUH UANG (KDS)',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 16,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  /// Tampilan gate login — muncul jika admin belum login
  Widget _buildLoginGate(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PROFIL & IDENTITAS MEJA',
          style: GoogleFonts.bebasNeue(
            fontSize: 24,
            letterSpacing: 1.2,
            color: AppColors.primaryYellow,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lock Icon
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cardBg,
                  border: Border.all(
                    color: AppColors.primaryYellow.withOpacity(0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryYellow.withOpacity(0.1),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🔒', style: TextStyle(fontSize: 50)),
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scaleXY(
                      begin: 1.0,
                      end: 1.05,
                      duration: 2000.ms,
                      curve: Curves.easeInOut),

              const SizedBox(height: 24),

              Text(
                'AREA ADMIN',
                style: GoogleFonts.bebasNeue(
                  fontSize: 30,
                  letterSpacing: 2,
                  color: AppColors.primaryYellow,
                ),
              ).animate().fadeIn(delay: 100.ms),

              const SizedBox(height: 8),

              Text(
                'Halaman ini hanya bisa diakses oleh\nadmin Warmindo Butuh Uang.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 32),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: Semantics(
                  identifier: 'btn_buka_login_admin',
                  button: true,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminLoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryYellow,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 6,
                      shadowColor: AppColors.primaryYellow.withOpacity(0.3),
                    ),
                    icon: const Icon(Icons.login_rounded),
                    label: Text(
                      'LOGIN ADMIN',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 20,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

              const SizedBox(height: 16),

              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.info_outline,
                        size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 6),
                    Text(
                      'Pelanggan tidak perlu login untuk memesan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBadge(String title, String value, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 10, color: AppColors.textMuted),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.secondaryOrange),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 12, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
