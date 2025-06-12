// ... (import lainnya)
import 'package:flutter/material.dart';
import 'package:saf_e_locker/services/auth_service.dart'; // Impor AuthService

// import 'package:provider/provider.dart'; // Jika menggunakan Provider
class ControlPage extends StatefulWidget {
  // Tidak perlu callback onLogin lagi karena MyApp memantau authStateChanges
  const ControlPage({Key? key}) : super(key: key);

  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  // ... (kode lainnya)

  Future<void> _performLogout() async {
    // Jika menggunakan Provider:
    // final authService = Provider.of<AuthService>(context, listen: false);
    final authService = AuthService(); // Atau dapatkan dari Provider

    await authService.signOut();
    // Navigasi akan ditangani oleh StreamBuilder di MyApp
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Lock Control'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _performLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      // ... (sisa body widget)
      // Pastikan tombol "Change Device Password" tetap ada jika masih relevan
    );
  }
}
