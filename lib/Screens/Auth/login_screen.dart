import 'package:electriciansapp/Reusable_Code/round_button.dart';
import 'package:electriciansapp/Reusable_Code/textfield.dart';
import 'package:electriciansapp/Screens/Auth/signup_screen.dart';
import 'package:electriciansapp/Screens/Users_Section/users_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ReusableTextfield(
                hintText: 'Enter Your Email', controller: emailController),
            ReusableTextfield(
                hintText: 'Enter your Password',
                controller: passwordController),
            RoundButton(
              title: 'Login',
              onTap: _loginUser,
              iconPath: 'images/login.png',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Not a user?'),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen()));
                    },
                    child: const Text('SignUp'))
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _loginUser() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()));
      print('Login successful: ${userCredential.user?.uid}');

      // Navigate to another screen on successful login
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      print('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
