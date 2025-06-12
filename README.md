# Proyek Skripsi: SAF-E LOCKER

Aplikasi sistem kunci otomatis berbasis Android dengan keamanan enkripsi AES.

## 🚀 Instruksi Setup untuk Developer

1.  **Clone Repository**

    ```bash
    git clone https://github.com/Saannrr/saf-e-locker-flutter.git
    cd saf-e-locker-flutter
    ```

2.  **Dapatkan File Konfigurasi**
    Proyek ini menggunakan Firebase. Anda memerlukan file konfigurasi berikut yang tidak disimpan di dalam repository Git. **Minta file-file ini dari anggota tim lain:**

    - `google-services.json`
    - `lib/firebase_options.dart`

3.  **Tempatkan File Konfigurasi**
    Letakkan file yang sudah Anda dapatkan di lokasi berikut:

    - Taruh `google-services.json` di dalam direktori `android/app/`.
    - Taruh `firebase_options.dart` di dalam direktori `lib/`.
    - Taruh `GoogleService-Info.plist` di dalam direktori `/ios/Runner/`.

4.  **Instal Dependensi**

    ```bash
    flutter pub get
    ```

5.  **Jalankan Aplikasi**
    Pastikan emulator atau perangkat fisik sudah terhubung, lalu jalankan:
    ```bash
    flutter run
    ```
