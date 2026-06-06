import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safepedia_drilling_app/config/app_pages.dart';
import 'package:safepedia_drilling_app/config/app_routes.dart';
import 'package:safepedia_drilling_app/core/database/db_provider.dart';

void main() async {
  // Pastikan binding Flutter sudah terinisialisasi sebelum mengakses hardware/database
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Database SQLite
  await DbProvider.initDb();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Safepedia Drilling App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      // Nanti kita arahkan ke AppPages.INITIAL (Splash/Home)
      initialRoute: AppRoutes.splash,
      getPages: AppPages.getPages(),
    );
  }
}
