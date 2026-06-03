import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Klassdan ob'ekt olmaslik uchun konstruktorni yopamiz

  // ==========================================
  // BRAND & LOGO RANGOYI (Asosiy ranglar)
  // ==========================================
  static const Color primaryLight = Color(0xFF6200EE);  // Light rejim uchun asosiy binafsha
  static const Color primaryDark = Color(0xFFBB86FC);   // Dark rejim uchun yumshoq binafsha
  static const Color secondary = Color(0xFF03DAC6);     // Yordamchi firuza rang

  // ==========================================
  // LIGHT MODE BACKGROUNDS (Yorqin rejim fonlari)
  // ==========================================
  static const Color bgLight = Color(0xFFF8F9FA);       // Ekran fon rangi
  static const Color surfaceLight = Color(0xFFFFFFFF);  // Card, Dialog va BottomSheet foni
  static const Color inputLight = Color(0xFFF1F3F4);    // TextField ichki foni

  // ==========================================
  // DARK MODE BACKGROUNDS (To'q rejim fonlari)
  // ==========================================
  static const Color bgDark = Color(0xFF121212);        // Ekran to'q foni
  static const Color surfaceDark = Color(0xFF1E1E1E);   // Card va Dialog to'q foni
  static const Color inputDark = Color(0xFF2C2C2C);     // TextField to'q foni

  // ==========================================
  // MATNLAR VA CHEGARALAR (Text & Borders)
  // ==========================================
  static const Color textDark = Color(0xFF1C1B1F);      // Oq fondagi qora matn
  static const Color textLight = Color(0xFFFFFFFF);     // To'q fondagi oq matn
  static const Color textGrey = Color(0xFF757575);      // Kulrang matn (subtitles)
  
  static const Color borderLight = Color(0xFFE0E0E0);   // Light rejim liniyalari
  static const Color borderDark = Color(0xFF383838);    // Dark rejim liniyalari

  // ==========================================
  // SIZTEMA RANGOYI (Status & Alerts)
  // ==========================================
  static const Color success = Color(0xFF4CAF50);       // Yashil (Muvaffaqiyatli)
  static const Color warning = Color(0xFFFFC107);       // Sariq (Ogohlantirish)
  static const Color errorLight = Color(0xFFB00020);    // Qizil xatolik (Light)
  static const Color errorDark = Color(0xFFCF6679);     // Qizil xatolik (Dark)
}
class AppTheme {
  AppTheme._();

  // LIGHT THEME
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.bgLight, // Konstantadan olindi
    
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.textLight,
      secondary: AppColors.secondary,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textDark,
      error: AppColors.errorLight,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceLight,
      foregroundColor: AppColors.textDark,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputLight,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
    ),
    // ... qolgan komponentlar ham xuddi shu zaylda bog'lanadi
  );

  // DARK THEME
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgDark, // Konstantadan olindi
    
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      onPrimary: AppColors.textDark,
      secondary: AppColors.secondary,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textLight,
      error: AppColors.errorDark,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.textLight,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputDark,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
    ),
  );
}
