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
  final bool isActive;
  final Map<String, dynamic>? operatingHours;
  final List<String> categories;

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
    this.isActive = true,
    this.operatingHours,
    this.categories = const [],
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
      isOpen: json['isOpen'] ?? false,
      address: json['address'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      ownerEmail: json['ownerEmail'] ?? '',
      createdAt: json['createdAt'] != null 
          ? (json['createdAt'] is Timestamp 
              ? (json['createdAt'] as Timestamp).toDate()
              : DateTime.parse(json['createdAt']))
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? (json['updatedAt'] is Timestamp 
              ? (json['updatedAt'] as Timestamp).toDate()
              : DateTime.parse(json['updatedAt']))
          : DateTime.now(),
      isActive: json['isActive'] ?? true,
      operatingHours: json['operatingHours'] as Map<String, dynamic>?,
      categories: List<String>.from(json['categories'] ?? []),
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
      'isActive': isActive,
      'operatingHours': operatingHours,
      'categories': categories,
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
    bool? isActive,
    Map<String, dynamic>? operatingHours,
    List<String>? categories,
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
      isActive: isActive ?? this.isActive,
      operatingHours: operatingHours ?? this.operatingHours,
      categories: categories ?? this.categories,
    );
  }
}

class MenuItem {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isAvailable;
  final bool isVegetarian;
  final bool isSpicy;
  final double rating;
  final int calories;
  final int preparationTime;
  final List<String> ingredients;
  final DateTime createdAt;
  final DateTime updatedAt;

  MenuItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.isAvailable,
    required this.isVegetarian,
    required this.isSpicy,
    required this.rating,
    required this.calories,
    required this.preparationTime,
    required this.ingredients,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] ?? '',
      restaurantId: json['restaurantId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      isVegetarian: json['isVegetarian'] ?? false,
      isSpicy: json['isSpicy'] ?? false,
      rating: (json['rating'] ?? 0.0).toDouble(),
      calories: json['calories'] ?? 0,
      preparationTime: json['preparationTime'] ?? 15,
      ingredients: List<String>.from(json['ingredients'] ?? []),
      createdAt: json['createdAt'] != null 
          ? (json['createdAt'] is Timestamp 
              ? (json['createdAt'] as Timestamp).toDate()
              : DateTime.parse(json['createdAt']))
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? (json['updatedAt'] is Timestamp 
              ? (json['updatedAt'] as Timestamp).toDate()
              : DateTime.parse(json['updatedAt']))
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurantId': restaurantId,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isAvailable': isAvailable,
      'isVegetarian': isVegetarian,
      'isSpicy': isSpicy,
      'rating': rating,
      'calories': calories,
      'preparationTime': preparationTime,
      'ingredients': ingredients,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  MenuItem copyWith({
    String? id,
    String? restaurantId,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    bool? isAvailable,
    bool? isVegetarian,
    bool? isSpicy,
    double? rating,
    int? calories,
    int? preparationTime,
    List<String>? ingredients,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MenuItem(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isSpicy: isSpicy ?? this.isSpicy,
      rating: rating ?? this.rating,
      calories: calories ?? this.calories,
      preparationTime: preparationTime ?? this.preparationTime,
      ingredients: ingredients ?? this.ingredients,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class FoodOrder {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final OrderStatus status;
  final String deliveryAddress;
  final String customerPhone;
  final String customerName;
  final DateTime createdAt;
  final DateTime? estimatedDeliveryTime;

  FoodOrder({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.deliveryAddress,
    required this.customerPhone,
    required this.customerName,
    required this.createdAt,
    this.estimatedDeliveryTime,
  });

  factory FoodOrder.fromJson(Map<String, dynamic> json) {
    return FoodOrder(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      restaurantId: json['restaurantId'] ?? '',
      restaurantName: json['restaurantName'] ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
      deliveryFee: (json['deliveryFee'] ?? 0.0).toDouble(),
      total: (json['total'] ?? 0.0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      deliveryAddress: json['deliveryAddress'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      customerName: json['customerName'] ?? '',
      createdAt: json['createdAt'] != null 
          ? (json['createdAt'] is Timestamp 
              ? (json['createdAt'] as Timestamp).toDate()
              : DateTime.parse(json['createdAt']))
          : DateTime.now(),
      estimatedDeliveryTime: json['estimatedDeliveryTime'] != null
          ? (json['estimatedDeliveryTime'] is Timestamp 
              ? (json['estimatedDeliveryTime'] as Timestamp).toDate()
              : DateTime.parse(json['estimatedDeliveryTime']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'status': status.name,
      'deliveryAddress': deliveryAddress,
      'customerPhone': customerPhone,
      'customerName': customerName,
      'createdAt': Timestamp.fromDate(createdAt),
      'estimatedDeliveryTime': estimatedDeliveryTime != null 
          ? Timestamp.fromDate(estimatedDeliveryTime!) 
          : null,
    };
  }
}

class OrderItem {
  final String menuItemId;
  final String name;
  final double price;
  final int quantity;
  final String? specialInstructions;

  OrderItem({
    required this.menuItemId,
    required this.name,
    required this.price,
    required this.quantity,
    this.specialInstructions,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuItemId: json['menuItemId'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 1,
      specialInstructions: json['specialInstructions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuItemId': menuItemId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'specialInstructions': specialInstructions,
    };
  }
}

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  outForDelivery,
  delivered,
  cancelled,
}