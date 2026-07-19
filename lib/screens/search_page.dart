import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sehaty/core/appcolors.dart';
import 'package:sehaty/models/doctor_model.dart';
import 'package:sehaty/screens/booking_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Doctor> _allDoctors = [];
  List<Doctor> _filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
    _searchController.addListener(_filterDoctors);
  }

  Future<void> _fetchDoctors() async {
    try {
      final snapshot = await _firestore.collection('doctors').get();
      final doctors = snapshot.docs.map((doc) {
        return Doctor.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      setState(() {
        _allDoctors = doctors;
        _filteredDoctors = doctors;
      });
    } catch (e) {
      // handle error
    }
  }

  void _filterDoctors() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDoctors = _allDoctors.where((doctor) {
        return doctor.name.toLowerCase().contains(query) ||
            doctor.specialty.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'ابحث بالاسم أو التخصص',
              prefixIcon: Icon(Icons.search, color: AppColors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.white2,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _filteredDoctors.isEmpty
                ? const Center(child: Text('لا يوجد أطباء'))
                : ListView.builder(
                    itemCount: _filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = _filteredDoctors[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: Text(
                              doctor.name[0],
                              style: TextStyle(color: AppColors.white),
                            ),
                          ),
                          title: Text(doctor.name),
                          subtitle: Text(doctor.specialty),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              Text('${doctor.rating}'),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingPage(doctor: doctor),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
