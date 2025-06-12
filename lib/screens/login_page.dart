import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saf_e_locker/services/auth_service.dart'; // Impor AuthService
// import 'package:provider/provider.dart'; // Jika menggunakan Provider

class LoginPage extends StatefulWidget {
  // Tidak perlu callback onLogin lagi karena MyApp memantau authStateChanges
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Untuk validasi form

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _performLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return; // Jangan lakukan apa-apa jika form tidak valid
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Jika menggunakan Provider:
    // final authService = Provider.of<AuthService>(context, listen: false);
    // Jika tidak, Anda perlu instance AuthService, mungkin di-pass atau singleton
    final authService = AuthService(); // Atau dapatkan dari Provider

    try {
      await authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      // Navigasi tidak diperlukan di sini karena StreamBuilder di MyApp akan menanganinya
    } on FirebaseAuthException catch (e) {
      setState(() {
        // Pesan error yang lebih user-friendly
        if (e.code == 'user-not-found') {
          _errorMessage = 'User dengan email ini tidak ditemukan.';
        } else if (e.code == 'wrong-password') {
          _errorMessage = 'Password salah.';
        } else if (e.code == 'invalid-email') {
          _errorMessage = 'Format email tidak valid.';
        } else {
          _errorMessage = 'Terjadi kesalahan: ${e.message}';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan yang tidak diketahui.';
      });
    } finally {
      if (mounted) {
        // Pastikan widget masih ada di tree
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Fungsi untuk registrasi (opsional)
  Future<void> _performSignUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final authService = AuthService();
    try {
      await authService.signUpWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      // Tambahkan feedback atau navigasi jika perlu setelah sign up
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi berhasil! Silakan login.')),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = 'Registrasi gagal: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan registrasi.';
      });
    } finally {
      if (mounted)
        setState(() {
          _isLoading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login SAF-E Locker')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'SAF-E LOCKER',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Masukkan format email yang valid';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: 10),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _performLogin,
                        child: Text('Login'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                SizedBox(height: 20),
                // Tombol Registrasi (opsional)
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          // Anda bisa navigasi ke halaman registrasi terpisah atau
                          // gunakan dialog/form yang sama untuk registrasi.
                          // Untuk contoh, kita tambahkan fungsi sign up sederhana.
                          _performSignUp();
                        },
                  child: Text('Belum punya akun? Daftar di sini'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
