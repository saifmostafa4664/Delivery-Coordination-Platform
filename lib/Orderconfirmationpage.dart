import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Orderconfirmationpage extends StatefulWidget {
  const Orderconfirmationpage({super.key});

  @override
  State<Orderconfirmationpage> createState() => _OrderconfirmationpageState();
}

class _OrderconfirmationpageState extends State<Orderconfirmationpage>
    with TickerProviderStateMixin {
  // Controllers للحقول
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phon = TextEditingController();
  final TextEditingController _area = TextEditingController();
  final TextEditingController _adress = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _prodect = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _pageAnimation;
  // انميشن متدرج لكل حقل في النموذج
  late Animation<double> _field1Animation;
  late Animation<double> _field2Animation;
  late Animation<double> _field3Animation;
  late Animation<double> _field4Animation;
  late Animation<double> _field5Animation;
  late Animation<double> _field6Animation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    // مدة الانميشن الرئيسية: 1200 مللي ثانية
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // انميشن لظهور الصفحة كاملة
    _pageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // انميشن لكل عنصر باستخدام Intervals متتالية
    _field1Animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.1, 0.2, curve: Curves.easeIn)),
    );
    _field2Animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.2, 0.3, curve: Curves.easeIn)),
    );
    _field3Animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.3, 0.4, curve: Curves.easeIn)),
    );
    _field4Animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.4, 0.5, curve: Curves.easeIn)),
    );
    _field5Animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.5, 0.6, curve: Curves.easeIn)),
    );
    _field6Animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.6, 0.7, curve: Curves.easeIn)),
    );
    _buttonAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.7, 1.0, curve: Curves.easeIn)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _name.dispose();
    _phon.dispose();
    _area.dispose();
    _adress.dispose();
    _price.dispose();
    _prodect.dispose();
    super.dispose();
  }

  // دالة لإرسال البيانات إلى Firestore وإنشاء الطلب
  Future<void> fetchDeliveryAndCreateOrder(
      String region, Map<String, dynamic> orderData) async {
    try {
      final deliveryCollection =
          FirebaseFirestore.instance.collection('delivery');

      final querySnapshot =
          await deliveryCollection.where('area', isEqualTo: region).get();

      if (querySnapshot.docs.isNotEmpty) {
        final deliveryDoc = querySnapshot.docs.first;
        final ordersCollection = deliveryDoc.reference.collection('Orders');

        await ordersCollection.add(orderData);

        print('تم إنشاء الطلب بنجاح!');

        // إرسال إشعار باستخدام Firebase Cloud Messaging
        await FirebaseFirestore.instance.collection('notifications').add({
          'title': 'طلب جديد',
          'body': 'تمت إضافة طلب جديد في منطقتك.',
          'timestamp': FieldValue.serverTimestamp(),
        });

        _clearForm();
        _showSuccessDialog();
      } else {
        print('لا يوجد موظف توصيل في المنطقة المطلوبة.');
      }
    } catch (e) {
      print('حدث خطأ: $e');
    }
  }

  // إعادة تعيين الحقول
  void _clearForm() {
    _name.clear();
    _phon.clear();
    _area.clear();
    _adress.clear();
    _price.clear();
    _prodect.clear();
  }

  // عرض رسالة تأكيد عند نجاح إضافة الطلب
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تم إضافة الطلب'),
          content: const Text('تم إضافة طلبك بنجاح!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الحوار
              },
              child: const Text('موافق'),
            ),
          ],
        );
      },
    );
  }

  // ويدجت لبناء تأثير الزجاج (Glassmorphism) للحقول
  Widget _buildGlassTextField({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: child,
        ),
      ),
    );
  }

  // ويدجت لبناء العنصر مع انميشن FadeTransition
  Widget _buildAnimatedField({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF1d375a),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          // خلفية متدرجة أنيقة
          gradient: LinearGradient(
            colors: [Color(0xFF1d375a), Color(0xFF011f4b)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: FadeTransition(
              opacity: _pageAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "تأكد الطلب",
                    style: TextStyle(
                      fontSize: size.width * 0.08,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFF2CB05),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // حقل اسم العميل
                  _buildAnimatedField(
                    animation: _field1Animation,
                    child: _buildGlassTextField(
                      child: TextField(
                        controller: _name,
                        decoration: InputDecoration(
                          hintText: 'اسم العميل',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 149, 146, 146)),
                          suffixIcon: const Icon(
                            Icons.perm_identity_outlined,
                            color: Colors.white70,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 19.0),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                            fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // حقل رقم العميل
                  _buildAnimatedField(
                    animation: _field2Animation,
                    child: _buildGlassTextField(
                      child: TextField(
                        controller: _phon,
                        decoration: InputDecoration(
                          hintText: 'رقم العميل',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 149, 146, 146)),
                          suffixIcon: const Icon(
                            Icons.phone,
                            color: Colors.white70,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 19.0),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                            fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // حقل اختيار المنطقة عبر Dropdown
                  _buildAnimatedField(
                    animation: _field3Animation,
                    child: _buildGlassTextField(
                      child: DropdownButtonFormField<String>(
                        value: null,
                        items: const [
                          DropdownMenuItem(
                            value: 'القاهرة',
                            child: Text(
                              'القاهرة',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'الجيزة',
                            child: Text('الجيزة',
                                style: TextStyle(color: Colors.black)),
                          ),
                          DropdownMenuItem(
                            value: 'الإسكندرية',
                            child: Text('الإسكندرية',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            _area.text = value;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'اختر المنطقة',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 149, 146, 146)),
                          suffixIcon: const Icon(
                            Icons.location_on,
                            color: Colors.white70,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 19.0),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                            fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // حقل العنوان
                  _buildAnimatedField(
                    animation: _field4Animation,
                    child: _buildGlassTextField(
                      child: TextField(
                        controller: _adress,
                        decoration: InputDecoration(
                          hintText: 'العنوان',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 149, 146, 146)),
                          suffixIcon: const Icon(
                            Icons.home,
                            color: Colors.white70,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 19.0),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                            fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // حقل السعر
                  _buildAnimatedField(
                    animation: _field5Animation,
                    child: _buildGlassTextField(
                      child: TextField(
                        controller: _price,
                        decoration: InputDecoration(
                          hintText: 'السعر',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 149, 146, 146)),
                          suffixIcon: const Icon(
                            Icons.money,
                            color: Colors.white70,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 19.0),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                            fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // حقل اسم المنتج
                  _buildAnimatedField(
                    animation: _field6Animation,
                    child: _buildGlassTextField(
                      child: TextField(
                        controller: _prodect,
                        decoration: InputDecoration(
                          hintText: 'اسم المنتج',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 149, 146, 146)),
                          suffixIcon: const Icon(
                            Icons.shopping_cart,
                            color: Colors.white70,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 19.0),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                            fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // زر تأكيد الطلب مع انميشن
                  _buildAnimatedField(
                    animation: _buttonAnimation,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_name.text.isEmpty ||
                            _phon.text.isEmpty ||
                            _area.text.isEmpty ||
                            _adress.text.isEmpty ||
                            _price.text.isEmpty ||
                            _prodect.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('يرجى ملء جميع الحقول.')),
                          );
                        } else {
                          final region = _area.text;
                          final orderData = {
                            'customerName': _name.text,
                            'address': _adress.text,
                            'totalPrice': _price.text,
                            'orderTime': FieldValue.serverTimestamp(),
                            'customerphon': _phon.text,
                            'prodectnane': _prodect.text,
                          };

                          fetchDeliveryAndCreateOrder(region, orderData);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFd33452),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.25,
                          vertical: 20,
                        ),
                      ),
                      child: const Text(
                        'تأكيد الطلب',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
