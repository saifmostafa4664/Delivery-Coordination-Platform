import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:efdal/Deliveryworkers.dart';
import 'package:efdal/MyHomePage.dart';
import 'package:flutter/material.dart';

class logindeliveryman extends StatefulWidget {
  const logindeliveryman({super.key});

  @override
  State<logindeliveryman> createState() => _logindeliverymanState();
}

class _logindeliverymanState extends State<logindeliveryman> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String mserror = "";

  Future<void> _signin() async {
    String inputID = _email.text;
    String inputPassword = _password.text;

    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('delivery').get();

      print("Documents fetched: ${querySnapshot.docs.length}");

      bool userExists = querySnapshot.docs.any((doc) {
        print(
            "Checking document with ID: ${doc['ID']} and Password: ${doc['Password']}");
        return doc['ID'] == inputID && doc['Password'] == inputPassword;
      });

      if (userExists) {
        String deliveryManID =
            querySnapshot.docs.firstWhere((doc) => doc['ID'] == inputID)['ID'];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Deliveryworkers(inputID: deliveryManID)),
        );
      } else {
        print("User not found, showing error message.");
        setState(() {
          mserror = "ID أو كلمة المرور غير صحيحة.";
        });
      }
    } catch (e) {
      print("Error during sign in: $e");
      setState(() {
        mserror = "حدث خطأ أثناء محاولة تسجيل الدخول.";
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primaryColor: const Color(0xFF1d375a), // الأزرق الداكن
        hintColor: const Color(0xFFd33452), // وردي
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: const Color(0xFF1d375a)),
        ),
      ),
      home: Center(
        child: Scaffold(
          backgroundColor: const Color(0xFFF0F0F0), // لون خلفية فاتح
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 150, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('images/efdal.png', width: 200),
                    const SizedBox(height: 80),
                    AnimatedOpacity(
                      duration: const Duration(seconds: 1),
                      opacity: 1.0,
                      child: const Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                          fontSize: 32,
                          color: Color(0xFF1d375a),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'ادخل اسم المستخدم',
                        hintStyle: const TextStyle(color: Color(0xFFd33452)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        suffixIcon: const Icon(Icons.perm_identity_outlined),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _password,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'ادخل كلمه السر',
                        hintStyle: const TextStyle(color: Color(0xFFd33452)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        suffixIcon: const Icon(Icons.password),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _signin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFd33452),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 100.0,
                          vertical: 20.0,
                        ),
                      ),
                      child: const Text(
                        'دخول',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyHomePage(),
                          ),
                        );
                      },
                      child: const Text(
                        "نسيت كلمه المرور",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFd33452),
                        ),
                      ),
                    ),
                    if (mserror.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          mserror,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
