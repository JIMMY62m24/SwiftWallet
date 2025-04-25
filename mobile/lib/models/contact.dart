class Contact {
  final String name;
  final String phoneNumber;
  final bool isFavorite;

  Contact({
    required this.name,
    required this.phoneNumber,
    this.isFavorite = false,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'isFavorite': isFavorite,
    };
  }
}
