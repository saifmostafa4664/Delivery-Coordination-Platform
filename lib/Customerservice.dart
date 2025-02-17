import 'dart:ui';
import 'package:efdal/Orderconfirmationpage.dart';
import 'package:flutter/material.dart';

class CustomerService extends StatefulWidget {
  const CustomerService({super.key});

  @override
  State<CustomerService> createState() => _CustomerServiceState();
}

class _CustomerServiceState extends State<CustomerService>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // الحصول على أبعاد الشاشة لضبط الاستجابة
    final size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primaryColor: const Color(0xFF1d375a),
        hintColor: const Color(0xFFd33452),
      ),
      home: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "خدمة العملاء",
            style: TextStyle(
              color: Color(0xFFF2CB05),
              fontSize: 24,
              fontWeight: FontWeight.bold,
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
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.02,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.08),
                      // بطاقة "استعلام" بتأثير الزجاج
                      _buildGlassCard(
                        title: "استعلام",
                        image: 'images/search.png',
                        onTap: () {},
                        size: size,
                      ),
                      SizedBox(height: size.height * 0.03),
                      // بطاقة "تأكيد الطلب"
                      _buildGlassCard(
                        title: "تأكيد الطلب",
                        image: 'images/shopping-bag.png',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const Orderconfirmationpage(),
                            ),
                          );
                        },
                        size: size,
                      ),
                      SizedBox(height: size.height * 0.03),
                      // بطاقة "موظفين التوصيل المتاحين"
                      _buildGlassCard(
                        title: "موظفين التوصيل المتاحين",
                        image: 'images/logistics.png',
                        onTap: () {},
                        size: size,
                      ),
                      SizedBox(height: size.height * 0.03),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // دالة لبناء بطاقة بخاصية Glassmorphism
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
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
                  width: size.width * 0.35,
                  height: size.height * 0.15,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: size.height * 0.02),
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
