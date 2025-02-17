import 'package:efdal/MyHomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({super.key});

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fading;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    fading = Tween<double>(begin: 0.2, end: 1).animate(animationController);

    /// تأخير التنقل حتى يكتمل بناء الواجهة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          Get.off(() => const MyHomePage(), transition: Transition.fade);
        }
      });
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1d375a),
      body: Center(
        child: FadeTransition(
          opacity: fading,
          child: Image.asset(
            'images/1.png',
            width: 200,
          ),
        ),
      ),
    );
  }
}
