import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String doctorId;
  final String patientName;
  final String city;
  final DateTime date;
  final String time;
  final String userId;

  Booking({
    required this.id,
    required this.doctorId,
    required this.patientName,
    required this.city,
    required this.date,
    required this.time,
    required this.userId,
  });

  factory Booking.fromMap(Map<String, dynamic> map, String id) {
    return Booking(
      id: id,
      doctorId: map['doctorId'] ?? '',
      patientName: map['patientName'] ?? '',
      city: map['city'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      time: map['time'] ?? '',
      userId: map['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'patientName': patientName,
      'city': city,
      'date': Timestamp.fromDate(date),
      'time': time,
      'userId': userId,
    };
  }
}
