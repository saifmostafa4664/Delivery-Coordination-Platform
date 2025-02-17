import 'dart:ui';
import 'package:efdal/Listofrequests.dart';
import 'package:flutter/material.dart';

class Deliveryworkers extends StatefulWidget {
  final String inputID;
  const Deliveryworkers({super.key, required this.inputID});

  @override
  State<Deliveryworkers> createState() => _DeliveryworkersState();
}

class _DeliveryworkersState extends State<Deliveryworkers> {
  @override
  Widget build(BuildContext context) {
    // الحصول على أبعاد الشاشة
    final size = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primaryColor: const Color(0xFF1d375a),
        hintColor: const Color(0xFFd33452),
      ),
      home: Scaffold(
        // تمديد المحتوى خلف شريط التطبيق
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "المنديب",
            style: TextStyle(
              color: Color(0xFFF2CB05),
              fontSize: 24,
            ),
          ),
        ),
        body: Stack(
          children: [
            // خلفية متدرجة أنيقة
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1d375a), Color(0xFF011f4b)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: size.height * 0.02,
                ),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.02),
                    // بطاقة "استعلام" بنمط الزجاج
                    _buildGlassCard(
                      title: "استعلام",
                      image: 'images/search.png',
                      onTap: () {},
                      size: size,
                    ),
                    SizedBox(height: size.height * 0.03),
                    // بطاقة "قائمه الطلبات"
                    _buildGlassCard(
                      title: "قائمه الطلبات",
                      image: 'images/shopping-bag.png',
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Listofrequests(
                              inputID: widget.inputID,
                            ),
                          ),
                        );
                      },
                      size: size,
                    ),
                    SizedBox(height: size.height * 0.03),
                    // بطاقة "الطلبات اللي تم تسلمهاا"
                    _buildGlassCard(
                      title: "الطلبات اللي تم تسلمها",
                      image: 'images/logistics.png',
                      onTap: () {},
                      size: size,
                    ),
                    SizedBox(height: size.height * 0.02),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassCard({
    required String title,
    required String image,
    required VoidCallback onTap,
    required Size size,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.03,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  image,
                  width: size.width * 0.4,
                  height: size.height * 0.15,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: size.height * 0.015),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
