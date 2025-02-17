import 'package:efdal/api/splashscreen.dart';
import 'package:efdal/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // تأكد من استيراد GetX

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // استبدل MaterialApp بـ GetMaterialApp
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Montserrat', // استخدام الفونت في التطبيق بالكامل
        primaryColor: Color(0xFF1d375a),
        hintColor: Color(0xFFd33452),
        useMaterial3: true,
      ),
      home: SplashBody(),
    );
  }
}
