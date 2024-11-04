import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electriciansapp/Reusable_Code/round_button.dart';
import 'package:electriciansapp/Screens/Auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for user input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  File? _profileImage; // To hold the selected image

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Save the image locally
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String newPath =
          path.join(appDocDir.path, path.basename(pickedFile.path));

      // Copy the picked file to the new path
      await File(pickedFile.path).copy(newPath);

      setState(() {
        _profileImage = File(newPath); // Store the picked image
      });
    }
  }

  Future<void> _handleSignup() async {
    try {
      // Create user with Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Collect user data
      String uid = userCredential.user!.uid;
      String name = nameController.text;
      String phone = phoneController.text;
      List<String> skills =
          skillsController.text.split(',').map((s) => s.trim()).toList();
      String location = locationController.text;

      // Save user data in Firestore
      await _firestore.collection('electricians').doc(uid).set({
        'name': name,
        'phone': phone,
        'skills': skills,
        'location': location,
        'profileImagePath': _profileImage?.path, // Save local image path
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup successful!')),
      );

      // Navigate to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const AssetImage('images/placeholder.png')
                          as ImageProvider,
                  child: _profileImage == null
                      ? const Icon(Icons.camera_alt, size: 30)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField("Name", nameController),
            _buildTextField("Phone", phoneController,
                keyboardType: TextInputType.phone),
            _buildTextField("Email", emailController,
                keyboardType: TextInputType.emailAddress),
            _buildTextField("Password", passwordController, obscureText: true),
            _buildTextField("Skills", skillsController),
            _buildTextField("Location", locationController),
            const SizedBox(height: 20),
            RoundButton(
              title: 'SignUp',
              onTap: _handleSignup,
              iconPath: 'images/login.png',
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text("Already have an account? Log In"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    skillsController.dispose();
    locationController.dispose();
    super.dispose();
  }
}
