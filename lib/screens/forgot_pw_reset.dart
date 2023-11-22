import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class forgotPasswordPage extends StatefulWidget {
  const forgotPasswordPage({super.key});

  @override
  State<forgotPasswordPage> createState() => _forgotPasswordPageState();
}

class _forgotPasswordPageState extends State<forgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
                'لقد تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الالكتروني'),
          );
        },
      );
    } on FirebaseException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          title: Image.asset(
            'images/IMG_1270.jpg',
            fit: BoxFit.fitWidth,
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.1,
          ),
         
        ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'قم بإدخال بريدك الإلكتروني لإعادة تعيين كلمة المرور',
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 10),
          // email
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              controller: _emailController,
              //validator: validateEmail,
              keyboardType: TextInputType.emailAddress,

              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  labelText: "البريد الإلكتروني",

                  // ignore: prefer_const_constructors
                  prefixIcon: Icon(Icons.email)),
              // ignore: body_might_complete_normally_nullable
              validator: (value) {
                if (value!.isEmpty) {
                  return 'ادخل عنوان البريد إلكتروني ';
                } else if ((value.isNotEmpty) &&
                    !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                        .hasMatch(value)) {
                  return "الرجاء اخال عنوان بريد إلكتروني صالح";
                }
              },
            ),
          ),
          SizedBox(height: 10),

 MaterialButton(
  onPressed: passwordReset,
  child: Text(
    'إعادة تعيين كلمة المرور',
    style: TextStyle(color: Colors.white),
  ),
  color: Color.fromARGB(255, 43, 138, 159),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(9), // Adjust the radius as needed
  ),
)

        ],
      ),
    );
  }
}
