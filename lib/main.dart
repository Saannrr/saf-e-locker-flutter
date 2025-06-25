// lib/main.dart (Corrected)

import 'package:flutter/material.dart';
import 'package:saf_e_locker/screens/welcome_screen.dart';
import 'package:saf_e_locker/screens/login_screen.dart';
import 'package:saf_e_locker/screens/register_screen.dart';
import 'package:saf_e_locker/screens/admin_screen.dart';
import 'package:saf_e_locker/screens/splash_screen.dart';
import 'package:saf_e_locker/screens/account_screen.dart';
import 'package:saf_e_locker/screens/account_info_screen.dart';
import 'package:saf_e_locker/screens/transaction_history_screen.dart';

void main() {
  runApp(const SafELockerApp());
}

class SafELockerApp extends StatelessWidget {
  const SafELockerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saf-e Locker',
      debugShowCheckedModeBanner: false,
      // FIX: Using a more robust Theme definition
      theme: _buildTheme(),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/admin': (context) => const AdminScreen(),
        '/account': (context) => const AccountScreen(),
        '/account-info': (context) => const AccountInfoScreen(),
        '/transaction-history': (context) => const TransactionHistoryScreen(),
      },
    );
  }

  ThemeData _buildTheme() {
    final baseTheme = ThemeData(
      // Use fromSeed for a modern, consistent color scheme
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      fontFamily: 'Inter',
      scaffoldBackgroundColor: Colors.white,
    );

    return baseTheme.copyWith(
      // Explicitly set text colors to avoid the white text issue
      textTheme: baseTheme.textTheme.apply(
        bodyColor: Colors.black, // Default text color
        displayColor: Colors.black, // Headline text color
      ).copyWith(
        // You can still override specific styles
        headlineMedium: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        bodyLarge: const TextStyle(fontSize: 16, color: Colors.grey),
        labelLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }
}