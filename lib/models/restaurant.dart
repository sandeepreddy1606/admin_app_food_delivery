import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final String cuisineType;
  final int deliveryTime;
  final double deliveryFee;
  final bool isOpen;
  final String address;
  final String phoneNumber;
  final String ownerEmail;
  final DateTime createdAt;
  final DateTime updatedAt;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.cuisineType,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.isOpen,
    required this.address,
    required this.phoneNumber,
    required this.ownerEmail,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      cuisineType: json['cuisineType'] ?? '',
      deliveryTime: json['deliveryTime'] ?? 30,
      deliveryFee: (json['deliveryFee'] ?? 0.0).toDouble(),
      isOpen: json['isOpen'] ?? true,
      address: json['address'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      ownerEmail: json['ownerEmail'] ?? '',
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'cuisineType': cuisineType,
      'deliveryTime': deliveryTime,
      'deliveryFee': deliveryFee,
      'isOpen': isOpen,
      'address': address,
      'phoneNumber': phoneNumber,
      'ownerEmail': ownerEmail,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Restaurant copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    double? rating,
    String? cuisineType,
    int? deliveryTime,
    double? deliveryFee,
    bool? isOpen,
    String? address,
    String? phoneNumber,
    String? ownerEmail,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      cuisineType: cuisineType ?? this.cuisineType,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      isOpen: isOpen ?? this.isOpen,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
