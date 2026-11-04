import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/config/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SemanticsBinding.instance.ensureSemantics();

  await initializeDateFormatting('id_ID', null);

  // Inisialisasi Supabase (Otomatis beralih ke Mock Mode jika belum diisi)
  await SupabaseConfig.initialize();

  runApp(
    const ProviderScope(
      child: WarmindoButuhUangApp(),
    ),
  );
}

class WarmindoButuhUangApp extends StatelessWidget {
  const WarmindoButuhUangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warmindo Butuh Uang',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavigationScreen(),
    );
  }
}
