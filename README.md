# Safepedia Drilling App

## Penjelasan Singkat
**Safepedia Drilling App** adalah aplikasi mobile berbasis Flutter yang dirancang untuk melakukan pencatatan dan pelaporan aktivitas pengeboran (drilling). Aplikasi ini dilengkapi dengan berbagai fitur esensial lapangan seperti pencatatan tanggal, Hole ID, pembacaan data sensor hardware (Accelerometer & Gyroscope), serta pengambilan foto lokasi yang otomatis dikompresi agar berukuran di bawah 250 KB. 

Aplikasi memiliki fitur penyimpanan lokal (Draft) agar pengguna tetap dapat mengisi form meskipun tidak ada koneksi internet, lalu menyimpannya sebagai status Submitted. Aplikasi ini juga telah dioptimalkan agar responsif dan nyaman digunakan baik pada perangkat smartphone maupun tablet.

## Versi Flutter
Aplikasi ini dikembangkan menggunakan **Flutter versi 3.38.9** (Dart 3.10.8).

## Struktur Project & Arsitektur
Project ini menggunakan arsitektur **Feature-First** yang digabungkan dengan **GetX Pattern** untuk manajemen state, dependensi, dan navigasi. Hal ini membuat kode menjadi sangat modular, rapi, dan mudah di-_maintain_.

```text
lib/
├── config/                  # Konfigurasi global (Routing, Colors, Fonts, Pages)
├── features/                # Modul-modul fitur utama aplikasi
│   ├── activity_detail/     # Halaman detail untuk aktivitas yang telah disubmit
│   ├── drilling_form/       # Form input/edit aktivitas drilling & akses hardware
│   ├── home/                # Halaman utama (List Draft & Submitted)
│   └── splash/              # Halaman Splash Screen awal
├── services/                # Layanan eksternal / global (Database SQLite)
└── main.dart                # Entry point aplikasi
```
*Setiap fitur di dalam folder `features/` dipecah lagi menjadi komponen MVC yang lebih kecil seperti `controller/`, `models/`, dan `view/` (ui & components).*

## Alur Aplikasi
1. **Splash Screen:** Halaman pembuka saat aplikasi pertama kali dijalankan.
2. **Home Screen:** Halaman utama yang menampilkan dua Tab:
   - **Draft:** Menampilkan aktivitas yang belum disubmit (disimpan lokal). Card draft dapat di-tap untuk masuk ke mode **Edit Draft**.
   - **Submitted:** Menampilkan aktivitas yang sudah selesai/disubmit. Card dapat di-tap untuk melihat **Activity Detail** (Read-Only).
3. **Drilling Form:** Diakses dari tombol "Aktivitas Baru" atau saat meng-edit draft. Pada halaman ini, pengguna bisa:
   - Mengisi Hole ID & Tanggal.
   - Membaca data sensor _Accelerometer_ dan _Gyroscope_.
   - Mengambil foto lokasi (langsung dikompresi).
   - Memilih status (Complete / Not Complete).
   - Menyimpan sebagai Draft atau langsung Submit.
4. **Activity Detail:** Halaman informatif (Read-Only) yang merangkum keseluruhan data aktivitas dari form yang telah berstatus Submitted.

## Catatan Tambahan
- **Database:** Menggunakan SQLite (`sqflite`) untuk menyimpan data aktivitas secara persisten di _local storage_.
- **Hardware & Sensor:** Pengambilan foto menggunakan package `image_picker` dengan kompresi `flutter_image_compress`. Sensor dibaca menggunakan package `sensors_plus`.
- **Responsivitas:** UI akan otomatis menyesuaikan diri (contoh: Grid 2 kolom di tablet, List 1 kolom di HP, serta pembatasan lebar maksimal pada form) ketika dibuka di layar yang lebih lebar (>= 600px).
