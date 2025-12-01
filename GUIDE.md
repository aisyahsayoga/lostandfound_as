# Panduan Menjalankan Proyek Lost & Found di Android Studio Emulator

Panduan ini akan membantu Anda menjalankan aplikasi Lost & Found yang dibuat dengan Flutter di emulator Android Studio dengan sukses.

## Prasyarat

Sebelum memulai, pastikan Anda memiliki:

1. **Android Studio** terinstal (versi terbaru direkomendasikan)
2. **Flutter SDK** terinstal dan dikonfigurasi
3. **Java Development Kit (JDK)** terinstal (versi 8 atau lebih tinggi)
4. **Android SDK** terinstal melalui Android Studio

## Langkah 1: Verifikasi Instalasi Flutter

1. Buka terminal atau command prompt
2. Jalankan perintah berikut untuk memeriksa instalasi Flutter:
   ```
   flutter doctor
   ```
3. Pastikan semua komponen terdeteksi dengan benar. Jika ada masalah, ikuti instruksi yang diberikan oleh `flutter doctor`.

## Langkah 2: Konfigurasi Android Studio

1. Buka Android Studio
2. Pergi ke **File > Settings > Appearance & Behavior > System Settings > Android SDK**
3. Pastikan SDK Platforms dan SDK Tools terinstal dengan benar
4. Instal Android Emulator jika belum ada

## Langkah 3: Membuat dan Mengkonfigurasi Emulator

1. Di Android Studio, buka **AVD Manager** (Android Virtual Device Manager):
   - Klik ikon **AVD Manager** di toolbar, atau
   - Pergi ke **Tools > AVD Manager**

2. Klik **Create Virtual Device**

3. Pilih perangkat (misalnya: Pixel 4 atau Nexus 6)

4. Pilih System Image:
   - Pilih **API Level 30** atau lebih tinggi (misalnya: R atau S)
   - Klik **Download** jika belum terinstal
   - Klik **Next**

5. Konfigurasi AVD:
   - Berikan nama untuk emulator (misalnya: "LostAndFoundEmulator")
   - Biarkan pengaturan default lainnya
   - Klik **Finish**

## Langkah 4: Membuka Proyek di Android Studio

1. Buka Android Studio
2. Pilih **Open an existing Android Studio project**
3. Navigasi ke folder proyek Lost & Found (folder yang berisi file `pubspec.yaml`)
4. Klik **OK** untuk membuka proyek

## Langkah 5: Menginstal Dependensi Flutter

1. Di Android Studio, buka terminal terintegrasi (View > Tool Windows > Terminal)
2. Jalankan perintah berikut untuk menginstal dependensi:
   ```
   flutter pub get
   ```
3. Tunggu hingga proses selesai. Ini akan mengunduh semua paket yang diperlukan.

## Langkah 6: Menjalankan Emulator

1. Di Android Studio, buka AVD Manager
2. Klik tombol **Play** (▶️) di sebelah emulator yang Anda buat
3. Tunggu hingga emulator boot sepenuhnya (bisa memakan waktu beberapa menit pada pertama kali)

## Langkah 7: Menjalankan Aplikasi

1. Pastikan emulator sudah berjalan
2. Di Android Studio, klik tombol **Run** (hijau dengan ikon play) di toolbar, atau
3. Pergi ke **Run > Run 'main.dart'**
4. Pilih target sebagai emulator Android yang sedang berjalan
5. Klik **OK**

Aplikasi akan dikompilasi dan diinstal di emulator. Proses ini mungkin memakan waktu beberapa menit pada pertama kali.

## Langkah 8: Menggunakan Aplikasi

Setelah aplikasi berhasil dijalankan:

1. **Onboarding**: Aplikasi akan dimulai dengan layar onboarding. Geser untuk melihat penjelasan aplikasi.
2. **Demo Home**: Klik tombol untuk menjelajahi berbagai layar:
   - Onboarding
   - Home Dashboard
   - Lost Item Report
   - Found Item Upload
   - Item Details
   - Map View
   - Profile Settings

## Troubleshooting

### Masalah Umum dan Solusi

1. **Emulator tidak bisa boot**:
   - Restart Android Studio
   - Hapus dan buat ulang AVD
   - Pastikan RAM komputer cukup (minimal 8GB)

2. **Flutter doctor menunjukkan error**:
   - Pastikan PATH Flutter dan Dart sudah benar
   - Instal ulang Flutter SDK jika perlu

3. **Build gagal**:
   - Jalankan `flutter clean` kemudian `flutter pub get`
   - Periksa versi Flutter (gunakan versi stabil terbaru)

4. **Emulator lambat**:
   - Gunakan emulator dengan API level yang lebih rendah
   - Aktifkan hardware acceleration di BIOS (Intel HAXM atau AMD SVM)

5. **Aplikasi crash**:
   - Periksa log di Android Studio (View > Tool Windows > Logcat)
   - Pastikan semua dependensi terinstal dengan benar

### Tips untuk Performa

- Gunakan emulator dengan RAM 2GB atau lebih
- Aktifkan Cold Boot untuk emulator
- Gunakan perangkat fisik jika memungkinkan untuk performa yang lebih baik

## Dukungan Tambahan

Jika Anda mengalami masalah yang tidak tercakup dalam panduan ini:

1. Periksa dokumentasi resmi Flutter: https://flutter.dev/docs
2. Forum komunitas Flutter: https://flutter.dev/community
3. Dokumentasi Android Studio: https://developer.android.com/studio

Dengan mengikuti panduan ini, Anda seharusnya dapat menjalankan aplikasi Lost & Found dengan sukses di emulator Android Studio.
