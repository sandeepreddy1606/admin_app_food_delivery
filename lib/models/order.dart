import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus { pending, confirmed, preparing, ready, outForDelivery, delivered, cancelled }

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending: return 'Pending';
      case OrderStatus.confirmed: return 'Confirmed';
      case OrderStatus.preparing: return 'Preparing';
      case OrderStatus.ready: return 'Ready';
      case OrderStatus.outForDelivery: return 'Out for Delivery';
      case OrderStatus.delivered: return 'Delivered';
      case OrderStatus.cancelled: return 'Cancelled';
    }
  }

  static OrderStatus fromString(String value) {
    final normalizedValue = value.toLowerCase().trim();
    return OrderStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == normalizedValue,
      orElse: () => OrderStatus.pending,
    );
  }

  String get nameValue => name;
}

class OrderItem {
  final String id;
  final String menuItemId;
  final String name;
  final double price;
  final int quantity;
  final double totalPrice;
  final String? description;
  final String? imageUrl;

  OrderItem({
    required this.id,
    required this.menuItemId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.totalPrice,
    this.description,
    this.imageUrl,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    // Handle your actual data structure
    final menuItem = json['menuItem'] as Map<String, dynamic>? ?? {};
    
    return OrderItem(
      id: json['id']?.toString() ?? '',
      menuItemId: menuItem['id']?.toString() ?? '',
      name: menuItem['name']?.toString() ?? 'Unknown Item',
      price: _parseDouble(menuItem['price'] ?? 0),
      quantity: _parseInt(json['quantity'] ?? 1),
      totalPrice: _parseDouble(json['totalPrice'] ?? 0),
      description: menuItem['description']?.toString(),
      imageUrl: menuItem['imageUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menuItem': {
        'id': menuItemId,
        'name': name,
        'price': price,
        'description': description,
        'imageUrl': imageUrl,
      },
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }

  // Helper methods for parsing
  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class OrderAddress {
  final String id;
  final String label;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final double? latitude;
  final double? longitude;

  OrderAddress({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    this.latitude,
    this.longitude,
  });

  factory OrderAddress.fromJson(Map<String, dynamic> json) {
    return OrderAddress(
      id: json['id']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      street: json['street']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      zipCode: json['zipCode']?.toString() ?? '',
      latitude: OrderItem._parseDouble(json['latitude']),
      longitude: OrderItem._parseDouble(json['longitude']),
    );
  }

  String get fullAddress => '$street, $city, $state $zipCode';
}

class PaymentInfo {
  final String id;
  final String displayName;
  final String type;
  final String? lastFourDigits;

  PaymentInfo({
    required this.id,
    required this.displayName,
    required this.type,
    this.lastFourDigits,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      id: json['id']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      lastFourDigits: json['lastFourDigits']?.toString(),
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
  final double tax;
  final double total;
  final OrderStatus status;
  final OrderAddress address;
  final PaymentInfo payment;
  final String customerPhone;
  final String customerName;
  final DateTime placedAt;

  FoodOrder({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.status,
    required this.address,
    required this.payment,
    required this.customerPhone,
    required this.customerName,
    required this.placedAt,
  });

  factory FoodOrder.fromJson(Map<String, dynamic> json) {
    print('Parsing order: ${json.keys.join(', ')}'); // Debug
    
    return FoodOrder(
      id: json['id']?.toString() ?? '',
      // Since these fields don't exist in your data, we'll use defaults or derive them
      userId: json['userId']?.toString() ?? 'unknown_user',
      restaurantId: json['restaurantId']?.toString() ?? 'unknown_restaurant',
      restaurantName: json['restaurantName']?.toString() ?? _getRestaurantNameFromItems(json['items']),
      items: _parseOrderItems(json['items'] ?? []),
      subtotal: OrderItem._parseDouble(json['subtotal'] ?? 0),
      deliveryFee: OrderItem._parseDouble(json['deliveryFee'] ?? 0),
      tax: OrderItem._parseDouble(json['tax'] ?? 0),
      total: OrderItem._parseDouble(json['total'] ?? 0),
      status: OrderStatusExtension.fromString(json['status']?.toString() ?? 'pending'),
      address: OrderAddress.fromJson(json['address'] as Map<String, dynamic>? ?? {}),
      payment: PaymentInfo.fromJson(json['payment'] as Map<String, dynamic>? ?? {}),
      customerPhone: json['customerPhone']?.toString() ?? 'N/A',
      customerName: json['customerName']?.toString() ?? 'Customer',
      placedAt: _parseDateTime(json['placedAt']),
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
      'tax': tax,
      'total': total,
      'status': status.name,
      'address': {
        'id': address.id,
        'label': address.label,
        'street': address.street,
        'city': address.city,
        'state': address.state,
        'zipCode': address.zipCode,
        'latitude': address.latitude,
        'longitude': address.longitude,
      },
      'payment': {
        'id': payment.id,
        'displayName': payment.displayName,
        'type': payment.type,
        'lastFourDigits': payment.lastFourDigits,
      },
      'customerPhone': customerPhone,
      'customerName': customerName,
      'placedAt': Timestamp.fromDate(placedAt),
    };
  }

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  
  // For backward compatibility
  DateTime get createdAt => placedAt;
  String get deliveryAddress => address.fullAddress;

  // Helper methods
  static List<OrderItem> _parseOrderItems(dynamic itemsData) {
    if (itemsData is! List) return [];
    
    return itemsData.map<OrderItem>((item) {
      if (item is Map<String, dynamic>) {
        return OrderItem.fromJson(item);
      }
      return OrderItem(
        id: '',
        menuItemId: '',
        name: 'Unknown Item',
        price: 0.0,
        quantity: 1,
        totalPrice: 0.0,
      );
    }).toList();
  }

  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();
    
    if (dateValue is Timestamp) {
      return dateValue.toDate();
    }
    
    if (dateValue is String) {
      try {
        return DateTime.parse(dateValue);
      } catch (_) {
        return DateTime.now();
      }
    }
    
    return DateTime.now();
  }

  static String _getRestaurantNameFromItems(dynamic itemsData) {
    // Try to extract restaurant name from items if available
    if (itemsData is List && itemsData.isNotEmpty) {
      final firstItem = itemsData[0];
      if (firstItem is Map && firstItem['restaurantName'] != null) {
        return firstItem['restaurantName'].toString();
      }
    }
    return 'Unknown Restaurant';
  }
}
