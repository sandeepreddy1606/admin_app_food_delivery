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
    return OrderStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => OrderStatus.pending,
    );
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

  double get totalPrice => price * quantity;
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
  final String? paymentMethod;
  final String? notes;
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
    this.paymentMethod,
    this.notes,
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
      status: OrderStatusExtension.fromString(json['status'] ?? 'pending'),
      deliveryAddress: json['deliveryAddress'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      customerName: json['customerName'] ?? '',
      paymentMethod: json['paymentMethod'],
      notes: json['notes'],
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      estimatedDeliveryTime: json['estimatedDeliveryTime'] is Timestamp
          ? (json['estimatedDeliveryTime'] as Timestamp).toDate()
          : (json['estimatedDeliveryTime'] != null
              ? DateTime.parse(json['estimatedDeliveryTime'])
              : null),
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
      'paymentMethod': paymentMethod,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'estimatedDeliveryTime': estimatedDeliveryTime != null
          ? Timestamp.fromDate(estimatedDeliveryTime!)
          : null,
    };
  }

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
}
