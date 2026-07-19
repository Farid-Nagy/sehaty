import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sehaty/core/appcolors.dart';
import 'package:sehaty/models/doctor_model.dart';
import 'package:sehaty/models/booking_model.dart';
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  final Doctor doctor;
  const BookingPage({super.key, required this.doctor});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _bookAppointment() async {
    if (_patientNameController.text.isEmpty || _cityController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى ملء جميع الحقول')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('غير مسجل دخول');

      final booking = Booking(
        id: '',
        doctorId: widget.doctor.id,
        patientName: _patientNameController.text.trim(),
        city: _cityController.text.trim(),
        date: _selectedDate,
        time: _selectedTime.format(context),
        userId: user.uid,
      );

      await _firestore.collection('bookings').add(booking.toMap());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم الحجز بنجاح')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مواعيد الحجز'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.doctor.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.doctor.specialty),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: Icon(Icons.calendar_today),
                    label: Text(
                      DateFormat('dd MMM yyyy').format(_selectedDate),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white2,
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _selectTime(context),
                    icon: Icon(Icons.access_time),
                    label: Text(_selectedTime.format(context)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white2,
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _patientNameController,
              decoration: InputDecoration(
                labelText: 'اسم المريض',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: AppColors.white2,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'المدينة',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: AppColors.white2,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _bookAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'حدد الحجز',
                        style: TextStyle(color: AppColors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
