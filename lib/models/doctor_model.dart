class Doctor {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final String? imageUrl;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    this.imageUrl,
  });

  factory Doctor.fromMap(Map<String, dynamic> map, String id) {
    return Doctor(
      id: id,
      name: map['name'] ?? '',
      specialty: map['specialty'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialty': specialty,
      'rating': rating,
      'imageUrl': imageUrl,
    };
  }
}
