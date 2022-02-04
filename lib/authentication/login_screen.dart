import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/authentication/signup_screen.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/splashScreen/splash_screen.dart';
import 'package:users_app/widgets/dialog_widgets.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void loginDriverNow() async {
    if (emailController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Email can't be empty");
    } else if (!emailController.text.contains('@')) {
      Fluttertoast.showToast(msg: 'Please enter valid email');
    } else if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password can't be empty");
    } else if (passwordController.text.length < 6) {
      Fluttertoast.showToast(msg: "Password should be atleast 6 character");
    } else {
      showDialog(
        context: context,
        builder: (context) => const ProgressDialog(
          msg: 'Logging please wait...',
        ),
      );
      final User? firebaseUser = (await fAuth
              .signInWithEmailAndPassword(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim())
              .catchError((msg) {
        print(msg);
        Navigator.pop(context);
        Fluttertoast.showToast(msg: msg.toString());
      }))
          .user;

      if (firebaseUser != null) {
        currentFirebaseUser = firebaseUser;
        Fluttertoast.showToast(msg: 'Logged In Successfully');
        Navigator.restorablePushNamedAndRemoveUntil(
            context, MySplashScreen.routeName, (Route<dynamic> route) => false);
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'Error Occured during logging');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 15),
              Image.asset('assets/images/splash.png'),
              const SizedBox(height: 15),
              const Center(
                child: Text(
                  'Login as a User',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    hintText: 'Enter your email.',
                    labelText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                        borderSide: BorderSide(color: Colors.grey))),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                style: const TextStyle(color: Colors.black),
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: 'Enter your password.',
                    labelText: 'Password',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                        borderSide: BorderSide(color: Colors.grey))),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => loginDriverNow(),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // <-- Radius
                    ),
                    onPrimary: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                child: const Text(
                  'Login',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.black54),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: TextButton(
                        onPressed: () => Navigator.restorablePushNamed(
                            context, SignUpScreen.routeName),
                        child: const Text(
                          'SignUp',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.deepPurple,
                          ),
                        )),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
