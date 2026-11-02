import 'package:flutter/material.dart';

class AppColors {
  // Brand Warmindo Butuh Uang (Warm, Energetic, Street-food style)
  static const Color primaryYellow = Color(0xFFFFB800); // Kuning telur / kuah kari
  static const Color secondaryOrange = Color(0xFFFF6B00); // Oranye sambal
  static const Color accentRed = Color(0xFFE53935); // Merah cabai rawit pedas
  
  // Backgrounds
  static const Color darkBg = Color(0xFF141517); // Latar belakang utama
  static const Color cardBg = Color(0xFF1F2226); // Kartu menu & container
  static const Color cardElevated = Color(0xFF2A2E33);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFF8F9FA);
  static const Color textSecondary = Color(0xFFA0A6AC);
  static const Color textMuted = Color(0xFF6C757D);
  
  // Status Colors
  static const Color statusPending = Color(0xFFFFC107); // Kuning
  static const Color statusCooking = Color(0xFF29B6F6); // Biru muda wajan
  static const Color statusReady = Color(0xFF4CAF50); // Hijau siap antar
  static const Color statusCompleted = Color(0xFF9E9E9E); // Abu selesai
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryYellow, secondaryOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient redSpicyGradient = LinearGradient(
    colors: [Color(0xFFFF5252), accentRed],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
