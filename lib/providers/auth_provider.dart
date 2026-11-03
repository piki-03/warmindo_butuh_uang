import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/config/supabase_config.dart';

/// State untuk autentikasi admin
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _checkCurrentSession();
  }

  /// Cek session yang sudah ada saat inisialisasi
  void _checkCurrentSession() {
    final user = SupabaseConfig.currentUser;
    if (user != null) {
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  /// Login menggunakan email & password Supabase Auth
  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final client = SupabaseConfig.client;
      if (client == null) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Supabase belum terhubung. Periksa konfigurasi.',
        );
        return;
      }

      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        state = AuthState(
          status: AuthStatus.authenticated,
          user: response.user,
        );
        debugPrint('✅ Admin login berhasil: ${response.user!.email}');
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Login gagal. Coba lagi.',
        );
      }
    } on AuthException catch (e) {
      String message;
      switch (e.statusCode) {
        case '400':
          message = 'Email atau password salah.';
          break;
        case '422':
          message = 'Format email tidak valid.';
          break;
        default:
          message = e.message;
      }
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: message,
      );
      debugPrint('⚠️ Auth error: ${e.message}');
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Terjadi kesalahan jaringan. Pastikan terhubung ke internet.',
      );
      debugPrint('⚠️ Login error: $e');
    }
  }

  /// Logout admin
  Future<void> logout() async {
    try {
      await SupabaseConfig.client?.auth.signOut();
    } catch (_) {}
    state = const AuthState(status: AuthStatus.unauthenticated);
    debugPrint('ℹ️ Admin telah logout.');
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
