# myportofolio_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


### Tugas 7 
1. Widget tree adalah struktur hierarki yang menggambarkan hubungan antar-widget dalam aplikasi Flutter. Setiap widget dapat memiliki widget lain sebagai anak (child) untuk membentuk tampilan aplikasi. Widget yang berada di posisi atas disebut parent, sedangkan widget yang berada di bawahnya disebut child. Hubungan parent-child menentukan bagaimana tampilan aplikasi disusun. Sebagai contoh, widget Scaffold menjadi parent yang memiliki AppBar dan Padding sebagai bagian dari tampilannya. Widget Padding kemudian memiliki Column sebagai child yang berisi beberapa widget lain, seperti Row, Text, dan GridView.
2. 
3. MaterialApp merupakan widget utama yang digunakan untuk mengatur konfigurasi aplikasi Flutter dengan desain Material Design. Widget ini menyediakan berbagai fasilitas, seperti pengaturan tema, judul aplikasi, navigasi halaman, dan konfigurasi tampilan secara keseluruhan.
MaterialApp umumnya digunakan sebagai root widget karena menjadi titik awal yang membungkus seluruh struktur widget aplikasi. Dengan demikian, widget lain yang berada di bawahnya dapat mengakses konfigurasi yang telah ditentukan.Pada proyek MyPortfolio, MaterialApp digunakan untuk mengatur judul aplikasi, tema warna, dan halaman utama yang ditampilkan.