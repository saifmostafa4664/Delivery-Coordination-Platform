import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:efdal/logincallcenter.dart';
import 'package:efdal/logindeliveryman.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: Scaffold(
        // تمديد الخلفية وراء شريط العنوان
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            // الخلفية المتدرجة
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1d375a), Color(0xFF011f4b)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // المحتوى في منتصف الشاشة
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // نص ترحيبي كبير
                    const Text(
                      'اهلا بيك',
                      style: TextStyle(
                        fontSize: 36,
                        color: Color(0xFFF2CB05),
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black26,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // بطاقة خيار "مندوب" مع تأثير الزجاج
                    _buildGlassCard(
                      title: 'مندوب',
                      imagePath: 'images/fast-delivery.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const logindeliveryman(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    // بطاقة خيار "خدمه العملاء" مع تأثير الزجاج
                    _buildGlassCard(
                      title: 'خدمه العملاء',
                      imagePath: 'images/help-desk.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginOne(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة لبناء بطاقة بخاصية الزجاج (Glassmorphism)
  Widget _buildGlassCard({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // أيقونة الخيار
                Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                ),
                const SizedBox(width: 20),
                // عنوان الخيار
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
