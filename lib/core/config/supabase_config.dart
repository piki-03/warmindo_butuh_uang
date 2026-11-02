import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // URL & Anon Key Supabase Warmindo Butuh Uang
  static const String supabaseUrl = 'https://pcigycnyhthytncdcchp.supabase.co';
  static const String supabaseAnonKey = 'sb_publishable_1U8a7ghBGn5Q29ypjRmYkQ_IzZ2t0ry';

  /// Supabase dianggap terkonfigurasi jika URL dan key bukan placeholder.
  static bool get isConfigured =>
      supabaseUrl.isNotEmpty &&
      supabaseAnonKey.isNotEmpty &&
      !supabaseUrl.contains('YOUR_SUPABASE');

  static Future<void> initialize() async {
    if (!isConfigured) {
      debugPrint('ℹ️ [Warmindo Butuh Uang]: Supabase belum dikonfigurasi. Menggunakan Mode Mock Offline.');
      return;
    }

    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );
      debugPrint('✅ [Warmindo Butuh Uang]: Supabase terhubung!');
    } catch (e) {
      debugPrint('⚠️ [Warmindo Butuh Uang]: Gagal menginisialisasi Supabase: $e');
    }
  }

  static SupabaseClient? get client {
    if (!isConfigured) return null;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  /// Mendapatkan user yang sedang login (null jika belum login)
  static User? get currentUser => client?.auth.currentUser;

  /// Cek apakah ada user yang sedang login
  static bool get isLoggedIn => currentUser != null;
}
