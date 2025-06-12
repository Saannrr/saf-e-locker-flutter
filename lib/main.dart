import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:saf_e_locker/firebase_options.dart';
import 'package:saf_e_locker/screens/control_page.dart';
import 'package:saf_e_locker/screens/login_page.dart';
import 'package:saf_e_locker/services/notification_service.dart';
import 'package:saf_e_locker/services/auth_service.dart'; // Impor AuthService
// import 'package:provider/provider.dart'; // Jika Anda menggunakan Provider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Menggunakan firebase_options.dart
  );

  // Inisialisasi service-service lain
  final NotificationService notificationService = NotificationService();
  // Panggil initialize setelah pengguna login atau jika ada pengguna yang sudah login
  // Kita akan memanggilnya setelah mendapatkan status auth.

  final AuthService authService = AuthService();

  runApp(
    MyApp(authService: authService, notificationService: notificationService),
  );
  // Atau jika menggunakan Provider:
  // runApp(
  //   MultiProvider(
  //     providers: [
  //       Provider<AuthService>(create: (_) => AuthService()),
  //       Provider<NotificationService>(create: (_) => NotificationService()),
  //       // StreamProvider untuk auth state jika diperlukan di banyak tempat
  //       StreamProvider<User?>(
  //         create: (context) => context.read<AuthService>().authStateChanges,
  //         initialData: null,
  //       ),
  //     ],
  //     child: MyApp(),
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final NotificationService notificationService;

  const MyApp({
    Key? key,
    required this.authService,
    required this.notificationService,
  }) : super(key: key);

  // Jika menggunakan Provider, Anda tidak perlu meneruskan service via constructor
  // const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Jika menggunakan Provider:
    // final authService = Provider.of<AuthService>(context, listen: false);
    // final notificationService = Provider.of<NotificationService>(context, listen: false);

    return MaterialApp(
      title: 'Smart Lock Control',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: authService.authStateChanges, // Pantau status autentikasi
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ), // Tampilan loading awal
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            // Pengguna sudah login
            // Inisialisasi NotificationService di sini setelah user terautentikasi
            // agar bisa mendapatkan user UID dengan benar untuk saveTokenToDatabase.
            // Pastikan ini hanya dijalankan sekali atau dengan cara yang idempotent.
            if (authService.currentUser != null) {
              // Panggil initialize dengan cara yang aman jika dipanggil berkali-kali
              // atau pindahkan panggilan saveTokenToDatabase ke setelah login berhasil
              // dan saat startup jika user sudah login.
              notificationService.initializeAndSaveToken();
            }
            return ControlPage(); // Arahkan ke halaman utama
          }
          // Pengguna belum login
          return LoginPage(); // Arahkan ke halaman login
        },
      ),
    );
  }
}
