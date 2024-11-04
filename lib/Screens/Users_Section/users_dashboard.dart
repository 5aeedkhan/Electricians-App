import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electriciansapp/Screens/Auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for user input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  DocumentSnapshot? userData;
  File? _profileImage; // To hold the selected image

  bool isActive = false; // To manage active status
  bool isAvailable = false; // To manage available status

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    String uid = _auth.currentUser!.uid;
    userData = await _firestore.collection('electricians').doc(uid).get();

    if (userData != null && userData!.exists) {
      nameController.text = userData!['name'];
      emailController.text = userData!['email'] ?? 'No Email Provided';
      phoneController.text = userData!['phone'];
      skillsController.text = userData!['skills'].join(', ') ?? '';
      locationController.text = userData!['location'] ?? '';

      if (userData!['profileImagePath'] != null) {
        _profileImage = File(userData!['profileImagePath']);
      }

      // Set initial values for active and available statuses
      isActive = userData!['isActive'] ?? false;
      isAvailable = userData!['isAvailable'] ?? false;
    } else {
      print("User data does not exist for UID: $uid");
    }
    setState(() {}); // Refresh UI after data is fetched
  }

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

  Future<void> _updateUserProfile() async {
    String uid = _auth.currentUser!.uid;

    try {
      await _firestore.collection('electricians').doc(uid).set(
          {
            'name': nameController.text,
            'email': emailController.text,
            'phone': phoneController.text,
            'skills':
                skillsController.text.split(',').map((s) => s.trim()).toList(),
            'location': locationController.text,
            'profileImagePath': _profileImage?.path, // Save local image path
            'isActive': isActive, // Update active status
            'isAvailable': isAvailable // Update available status
          },
          SetOptions(
              merge:
                  true)); // Use merge to avoid overwriting the whole document

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      print("Error updating user profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
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
            _buildTextField("Email", emailController),
            _buildTextField("Phone", phoneController,
                keyboardType: TextInputType.phone),
            _buildTextField("Skills", skillsController),
            _buildTextField("Location", locationController),
            const SizedBox(height: 20),

            // Switch for Active Status
            SwitchListTile(
              title: const Text('Active Status'),
              value: isActive,
              onChanged: (value) {
                setState(() {
                  isActive = value;
                });
              },
            ),

            // Switch for Available Status
            SwitchListTile(
              title: const Text('Available Status'),
              value: isAvailable,
              onChanged: (value) {
                setState(() {
                  isAvailable = value;
                });
              },
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUserProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
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
    emailController.dispose();
    phoneController.dispose();
    skillsController.dispose();
    locationController.dispose();
    super.dispose();
  }
}
