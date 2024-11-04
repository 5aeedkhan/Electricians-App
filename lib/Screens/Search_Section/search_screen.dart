import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchElectriciansScreen extends StatefulWidget {
  const SearchElectriciansScreen({super.key});

  @override
  _SearchElectriciansScreenState createState() =>
      _SearchElectriciansScreenState();
}

class _SearchElectriciansScreenState extends State<SearchElectriciansScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _results = [];

  Future<void> _searchElectricians() async {
    String searchQuery = _searchController.text.trim();
    print('Search query: $searchQuery'); // Debugging statement
    if (searchQuery.isNotEmpty) {
      QuerySnapshot querySnapshot = await _firestore
          .collection('electricians')
          .where('skills', arrayContains: searchQuery)
          .get();

      print(
          'Query snapshot: ${querySnapshot.docs.length} results found'); // Debugging statement

      setState(() {
        _results = querySnapshot.docs;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Electricians'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter location or skills',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchElectricians,
                ),
              ),
              onSubmitted: (_) => _searchElectricians(),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  var electrician = _results[index];

                  // Check if the expected fields exist in the document
                  String name = electrician['name'] ?? 'Unknown';
                  String phone = electrician['phone'] ?? 'N/A';
                  String location = electrician['location'] ?? 'N/A';
                  List<dynamic> skills = electrician['skills'] ?? [];
                  String skillsString = skills.join(', ');

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: ClipOval(
                        child: (electrician['profileImagePath'] != null &&
                                electrician['profileImagePath'].isNotEmpty)
                            ? Image.file(
                                File(electrician['profileImagePath']),
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
                          Text('Location: $location'),
                          Text('Skills: $skillsString'),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
