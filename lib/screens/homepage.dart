import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sehaty/core/appcolors.dart';
import 'package:sehaty/models/doctor_model.dart';
import 'package:sehaty/screens/search_page.dart';
import 'package:sehaty/screens/profile_page.dart';
import 'package:sehaty/screens/settings_page.dart';
import 'package:sehaty/screens/booking_page.dart';
import 'package:sehaty/screens/bookings_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  int _selectedIndex = 0;

  final List<String> _defaultSpecialties = [
    'دكتور قلب',
    'جراحة عامة',
    'عظام',
    'جلدية',
    'أطفال',
  ];

  final List<Doctor> _defaultDoctors = [
    Doctor(id: '1', name: 'على محمد علي', specialty: 'دكتور قلب', rating: 5.0),
    Doctor(id: '2', name: 'فاروق جويدم', specialty: 'جراحة عامة', rating: 4.5),
    Doctor(
      id: '3',
      name: 'خالد علي عبدالله',
      specialty: 'دكتور قلب',
      rating: 4.0,
    ),
  ];

  final Map<String, IconData> specialtyIcons = {
    'دكتور قلب': Icons.favorite,
    'جراحة عامة': Icons.medical_services,
    'عظام': Icons.accessibility,
    'جلدية': Icons.face,
    'أطفال': Icons.child_friendly,
    'أنف وأذن وحنجرة': Icons.hearing,
    'نساء وتوليد': Icons.pregnant_woman,
    'نفسي': Icons.psychology,
    'عيون': Icons.visibility,
    'أسنان': Icons.health_and_safety,
  };

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildHomeContent(),
      const SearchPage(),
      const ProfilePage(),
      const BookingsListPage(),
      const SettingsPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: IndexedStack(index: _selectedIndex, children: _pages),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    String title = 'صحتي';
    List<Widget> actions = [];

    switch (_selectedIndex) {
      case 0: // الرئيسية
        title = 'صحتي';

        break;
      case 1:
        title = 'البحث عن دكتور';
        actions = [];
        break;
      case 2: // حسابي
        title = 'الحساب الشخصي';
        actions = [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.white),
            onPressed: () {
              // فتح تعديل الملف الشخصي
            },
          ),
        ];
        break;
      case 3: // مواعيد الحجز
        title = 'مواعيد الحجز';
        actions = [];
        break;
      case 4: // الإعدادات
        title = 'الإعدادات';
        actions = [];
        break;
    }

    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 2,
      shadowColor: AppColors.primary.withOpacity(0.3),
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      centerTitle: true,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(
          height: 4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.white, AppColors.white.withOpacity(0)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 11,
        ),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 26),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 26),
            label: 'البحث',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 26),
            label: 'حسابي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today, size: 26),
            label: 'الحجوزات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 26),
            label: 'الإعدادات',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHomeContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة الترحيب
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.12),
                    AppColors.white,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                    child: Icon(
                      Icons.health_and_safety,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مرحبا، ${currentUser?.displayName ?? 'سيد عبدالعزيز'}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'احجز الآن وكن جزءاً من رحلتك الصحية.',
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 15,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            GestureDetector(
              onTap: () => _onItemTapped(1),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white2,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.grey,
                      size: 16,
                    ),
                    const Spacer(),
                    Text(
                      'ابحث عن دكتور',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.search, color: AppColors.primary, size: 24),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'التخصصات',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                TextButton(
                  onPressed: () => _onItemTapped(1),
                  child: Text(
                    'عرض الكل',
                    style: TextStyle(color: AppColors.primary, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 100,
              child: FutureBuilder<QuerySnapshot>(
                future: _firestore.collection('specialties').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildSpecialtiesList(_defaultSpecialties);
                  }
                  if (snapshot.hasError ||
                      snapshot.data == null ||
                      snapshot.data!.docs.isEmpty) {
                    return _buildSpecialtiesList(_defaultSpecialties);
                  }
                  final specialties = snapshot.data!.docs
                      .map((doc) => doc['name'] as String)
                      .toList();
                  return specialties.isEmpty
                      ? _buildSpecialtiesList(_defaultSpecialties)
                      : _buildSpecialtiesList(specialties);
                },
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'الأعلى تقييماً',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 12),

            FutureBuilder<QuerySnapshot>(
              future: _firestore
                  .collection('doctors')
                  .orderBy('rating', descending: true)
                  .limit(10)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildDoctorsList(_defaultDoctors);
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return _buildDoctorsList(_defaultDoctors);
                }
                final doctors = snapshot.data!.docs.map((doc) {
                  return Doctor.fromMap(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                  );
                }).toList();
                return doctors.isEmpty
                    ? _buildDoctorsList(_defaultDoctors)
                    : _buildDoctorsList(doctors);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialtiesList(List<String> specialties) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: specialties.length,
      itemBuilder: (context, index) {
        final specialty = specialties[index];
        final icon = specialtyIcons[specialty] ?? Icons.medical_services;
        return Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.white2,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  specialty,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDoctorsList(List<Doctor> doctors) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: AppColors.white2, width: 1),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.15),
              radius: 28,
              child: Text(
                doctor.name[0],
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              doctor.name,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.black,
                fontSize: 16,
              ),
              textAlign: TextAlign.right,
            ),
            subtitle: Text(
              doctor.specialty,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    doctor.rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.star, color: Colors.amber, size: 18),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookingPage(doctor: doctor)),
              );
            },
          ),
        );
      },
    );
  }
}
