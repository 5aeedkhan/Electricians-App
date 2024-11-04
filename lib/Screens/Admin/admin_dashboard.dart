import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electriciansapp/Screens/Auth/login_screen.dart';
import 'package:electriciansapp/Screens/role_selection_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('electricians').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              var userData = user.data() as Map<String, dynamic>;

              String name = userData['name'] ?? 'No Name Provided';
              String phone = userData['phone'] ?? 'No Phone Provided';
              String profileImagePath = userData['profileImagePath'] ?? '';
              bool isActive = userData['isActive'] ?? false;
              bool isAvailable = userData['isAvailable'] ?? false;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: ClipOval(
                    child: profileImagePath.isNotEmpty
                        ? Image.file(
                            File(profileImagePath),
                            width: 60,
                            height: 60,
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                ),
                                child: const Icon(Icons.error,
                                    size: 30, color: Colors.red),
                              );
                            },
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                            ),
                            child: const Icon(Icons.person, size: 30),
                          ),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Phone: $phone'),
                      SwitchListTile(
                        title: const Text('Active Status'),
                        value: isActive,
                        onChanged: (value) {
                          setState(() {
                            isActive = value;
                            _firestore
                                .collection('electricians')
                                .doc(user.id)
                                .update({'isActive': isActive});
                          });
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Available Status'),
                        value: isAvailable,
                        onChanged: (value) {
                          setState(() {
                            isAvailable = value;
                            _firestore
                                .collection('electricians')
                                .doc(user.id)
                                .update({'isAvailable': isAvailable});
                          });
                        },
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _firestore
                          .collection('electricians')
                          .doc(user.id)
                          .delete();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);

    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
    );
  }
}
