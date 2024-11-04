import 'package:electriciansapp/Constants/constants.dart';
import 'package:electriciansapp/Reusable_Code/round_button.dart';
import 'package:electriciansapp/Screens/Admin/admin_login.dart';
import 'package:electriciansapp/Screens/Auth/login_screen.dart';
import 'package:electriciansapp/Screens/Search_Section/search_screen.dart';
import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Welcome to XYZ',
          style: kTextStyle,
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff67CFE7), Color(0x00000ffa)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminLoginScreen()),
              );
            },
            icon: const Icon(Icons.admin_panel_settings),
          ),
        ],
      ),
      body: Column(
        children: [
          // Image section
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                Image(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  image: const AssetImage('images/electric.jpg'),
                ),
                Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ],
            ),
          ),

          // Role selection section
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: const BorderRadius.only(
                  //   topLeft: Radius.circular(25),
                  //   topRight: Radius.circular(25),
                  // ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xffA7C7E7).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'With XYZ, you can easily connect and negotiate with Electricians directly',
                          style: kTextStyle.copyWith(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 32, 104, 175),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24), // Adjusted spacing

                      // User Registration Section
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffA7C7E7)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Click here if you want to register with us',
                              style: kTextStyle.copyWith(
                                fontSize: 16,
                                color: const Color.fromARGB(255, 32, 104, 175),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            RoundButton(
                              iconPath: 'images/profile.png',
                              title: 'USER',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24), // Adjusted spacing

                      // Search Electricians Section
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffA7C7E7)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Click here if you want to search electricians',
                              style: kTextStyle.copyWith(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            RoundButton(
                              iconPath: 'images/search-engine.png',
                              title: 'SEARCH',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SearchElectriciansScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
