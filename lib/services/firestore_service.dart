<<<<<<< HEAD
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/restaurant.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Initialize sample data
  static Future<void> createSampleData() async {
    try {
      final restaurantsSnapshot = await _db.collection('restaurants').get();
      if (restaurantsSnapshot.docs.isEmpty) {
        await _createSampleRestaurants();
      }

      final ordersSnapshot = await _db.collection('orders').get();
      if (ordersSnapshot.docs.isEmpty) {
        await _createSampleOrders();
      }
    } catch (e) {
      debugPrint('Error creating sample data: $e');
    }
  }

  static Future<void> _createSampleRestaurants() async {
    final sampleRestaurants = [
      {
        'name': 'Burger Palace',
        'description': 'Delicious gourmet burgers made with fresh ingredients',
        'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=300&fit=crop',
        'rating': 4.7,
        'cuisineType': 'American',
        'deliveryTime': 30,
        'deliveryFee': 2.99,
        'isOpen': true,
        'address': '123 Burger Street, Downtown City',
        'phoneNumber': '+1-555-0101',
        'ownerEmail': 'owner@burgerpalace.com',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'categories': ['burgers', 'american'],
      },
      {
        'name': 'Sushi Haven',
        'description': 'Authentic Japanese sushi prepared by expert chefs',
        'imageUrl': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400&h=300&fit=crop',
        'rating': 4.9,
        'cuisineType': 'Japanese',
        'deliveryTime': 45,
        'deliveryFee': 3.49,
        'isOpen': true,
        'address': '456 Sushi Lane, Japantown',
        'phoneNumber': '+1-555-0102',
        'ownerEmail': 'owner@sushihaven.com',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'categories': ['sushi', 'japanese'],
      },
      {
        'name': 'Pizza Corner',
        'description': 'Wood-fired Italian pizzas with authentic toppings',
        'imageUrl': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&h=300&fit=crop',
        'rating': 4.5,
        'cuisineType': 'Italian',
        'deliveryTime': 25,
        'deliveryFee': 1.99,
        'isOpen': true,
        'address': '789 Pizza Blvd, Little Italy',
        'phoneNumber': '+1-555-0103',
        'ownerEmail': 'owner@pizzacorner.com',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'categories': ['pizza', 'italian'],
      },
    ];

    for (final restaurant in sampleRestaurants) {
      await _db.collection('restaurants').add(restaurant);
    }
    debugPrint('Sample restaurants created');
  }

  static Future<void> _createSampleOrders() async {
    final sampleOrders = [
      {
        'userId': 'user1',
        'restaurantId': 'rest1',
        'restaurantName': 'Burger Palace',
        'items': [
          {
            'menuItemId': 'item1',
            'name': 'Classic Burger',
            'price': 12.99,
            'quantity': 2,
          }
        ],
        'subtotal': 25.98,
        'deliveryFee': 2.99,
        'total': 28.97,
        'status': 'pending',
        'deliveryAddress': '123 Main St, City',
        'customerPhone': '+1-555-1234',
        'customerName': 'John Doe',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'userId': 'user2',
        'restaurantId': 'rest2',
        'restaurantName': 'Sushi Haven',
        'items': [
          {
            'menuItemId': 'item2',
            'name': 'California Roll',
            'price': 8.99,
            'quantity': 3,
          }
        ],
        'subtotal': 26.97,
        'deliveryFee': 3.49,
        'total': 30.46,
        'status': 'delivered',
        'deliveryAddress': '456 Oak Ave, City',
        'customerPhone': '+1-555-5678',
        'customerName': 'Jane Smith',
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    for (final order in sampleOrders) {
      await _db.collection('orders').add(order);
    }
    debugPrint('Sample orders created');
  }

  // Restaurants Collection
  static Stream<List<Restaurant>> streamRestaurants() {
    return _db
        .collection('restaurants')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Restaurant.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  static Future<void> addRestaurant(Restaurant restaurant) async {
    final data = restaurant.toJson();
    data.remove('id');
    await _db.collection('restaurants').add(data);
  }

  static Future<void> updateRestaurant(Restaurant restaurant) async {
    final data = restaurant.toJson();
    data.remove('id');
    await _db.collection('restaurants').doc(restaurant.id).update(data);
  }

  static Future<void> deleteRestaurant(String id) async {
    final menuItemsSnapshot = await _db
        .collection('restaurants')
        .doc(id)
        .collection('menuItems')
        .get();
    
    for (var doc in menuItemsSnapshot.docs) {
      await doc.reference.delete();
    }
    
    await _db.collection('restaurants').doc(id).delete();
  }

  static Stream<List<Restaurant>> searchRestaurants(String query) {
    if (query.isEmpty) {
      return streamRestaurants();
    }
    
    return streamRestaurants().map((restaurants) => restaurants
        .where((r) =>
            r.name.toLowerCase().contains(query.toLowerCase()) ||
            r.cuisineType.toLowerCase().contains(query.toLowerCase()) ||
            r.address.toLowerCase().contains(query.toLowerCase()))
        .toList());
  }

  // Menu Items Collection
  static Stream<List<MenuItem>> streamMenuItems(String restaurantId) {
    return _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menuItems')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MenuItem.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  static Future<void> addMenuItem(String restaurantId, MenuItem menuItem) async {
    final data = menuItem.toJson();
    data.remove('id');
    await _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menuItems')
        .add(data);
  }

  static Future<void> updateMenuItem(String restaurantId, MenuItem menuItem) async {
    final data = menuItem.toJson();
    data.remove('id');
    await _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menuItems')
        .doc(menuItem.id)
        .update(data);
  }

  static Future<void> deleteMenuItem(String restaurantId, String menuItemId) async {
    await _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menuItems')
        .doc(menuItemId)
        .delete();
  }

  // Orders Collection
  static Stream<List<FoodOrder>> streamOrders() {
    return _db
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FoodOrder.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  static Future<void> addOrder(FoodOrder order) async {
    final data = order.toJson();
    data.remove('id');
    await _db.collection('orders').add(data);
  }

  static Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _db.collection('orders').doc(orderId).update({'status': status.name});
  }

  static Future<void> deleteOrder(String orderId) async {
    await _db.collection('orders').doc(orderId).delete();
  }

  // Dashboard Statistics
  static Stream<Map<String, dynamic>> streamDashboardStats() {
    return _db.collection('restaurants').snapshots().asyncMap((restaurantSnapshot) async {
      final orderSnapshot = await _db.collection('orders').get();
      
      final restaurants = restaurantSnapshot.docs.length;
      final openRestaurants = restaurantSnapshot.docs
          .where((doc) => doc.data()['isOpen'] == true)
          .length;
      
      final orders = orderSnapshot.docs;
      final totalOrders = orders.length;
      final pendingOrders = orders.where((doc) => doc.data()['status'] == 'pending').length;
      
      double totalRevenue = 0.0;
      for (var doc in orders) {
        if (doc.data()['status'] == 'delivered') {
          totalRevenue += (doc.data()['total'] ?? 0.0).toDouble();
        }
      }
      
      double averageRating = 0.0;
      if (restaurants > 0) {
        double ratingSum = 0.0;
        for (var doc in restaurantSnapshot.docs) {
          ratingSum += (doc.data()['rating'] ?? 0.0).toDouble();
        }
        averageRating = ratingSum / restaurants;
      }
      
      return {
        'totalRestaurants': restaurants,
        'activeRestaurants': openRestaurants,
        'totalOrders': totalOrders,
        'pendingOrders': pendingOrders,
        'totalRevenue': totalRevenue,
        'averageRating': averageRating,
      };
    });
  }

  // Recent Activity
  static Stream<List<Map<String, dynamic>>> streamRecentActivity() {
    return _db
        .collection('activity')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {...doc.data(), 'id': doc.id})
            .toList());
  }

  static Future<void> addActivity(String message, String type, {Map<String, dynamic>? data}) async {
    await _db.collection('activity').add({
      'message': message,
      'type': type,
      'timestamp': FieldValue.serverTimestamp(),
      'data': data ?? {},
    });
  }
}
=======
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/restaurant.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Initialize sample data
  static Future<void> createSampleData() async {
    try {
      final restaurantsSnapshot = await _db.collection('restaurants').get();
      if (restaurantsSnapshot.docs.isEmpty) {
        await _createSampleRestaurants();
      }

      final ordersSnapshot = await _db.collection('orders').get();
      if (ordersSnapshot.docs.isEmpty) {
        await _createSampleOrders();
      }
    } catch (e) {
      debugPrint('Error creating sample data: $e');
    }
  }

  static Future<void> _createSampleRestaurants() async {
    final sampleRestaurants = [
      {
        'name': 'Burger Palace',
        'description': 'Delicious gourmet burgers made with fresh ingredients',
        'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=300&fit=crop',
        'rating': 4.7,
        'cuisineType': 'American',
        'deliveryTime': 30,
        'deliveryFee': 2.99,
        'isOpen': true,
        'address': '123 Burger Street, Downtown City',
        'phoneNumber': '+1-555-0101',
        'ownerEmail': 'owner@burgerpalace.com',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'categories': ['burgers', 'american'],
      },
      {
        'name': 'Sushi Haven',
        'description': 'Authentic Japanese sushi prepared by expert chefs',
        'imageUrl': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400&h=300&fit=crop',
        'rating': 4.9,
        'cuisineType': 'Japanese',
        'deliveryTime': 45,
        'deliveryFee': 3.49,
        'isOpen': true,
        'address': '456 Sushi Lane, Japantown',
        'phoneNumber': '+1-555-0102',
        'ownerEmail': 'owner@sushihaven.com',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'categories': ['sushi', 'japanese'],
      },
      {
        'name': 'Pizza Corner',
        'description': 'Wood-fired Italian pizzas with authentic toppings',
        'imageUrl': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&h=300&fit=crop',
        'rating': 4.5,
        'cuisineType': 'Italian',
        'deliveryTime': 25,
        'deliveryFee': 1.99,
        'isOpen': true,
        'address': '789 Pizza Blvd, Little Italy',
        'phoneNumber': '+1-555-0103',
        'ownerEmail': 'owner@pizzacorner.com',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'categories': ['pizza', 'italian'],
      },
    ];

    for (final restaurant in sampleRestaurants) {
      await _db.collection('restaurants').add(restaurant);
    }
    debugPrint('Sample restaurants created');
  }

  static Future<void> _createSampleOrders() async {
    final sampleOrders = [
      {
        'userId': 'user1',
        'restaurantId': 'rest1',
        'restaurantName': 'Burger Palace',
        'items': [
          {
            'menuItemId': 'item1',
            'name': 'Classic Burger',
            'price': 12.99,
            'quantity': 2,
          }
        ],
        'subtotal': 25.98,
        'deliveryFee': 2.99,
        'total': 28.97,
        'status': 'pending',
        'deliveryAddress': '123 Main St, City',
        'customerPhone': '+1-555-1234',
        'customerName': 'John Doe',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'userId': 'user2',
        'restaurantId': 'rest2',
        'restaurantName': 'Sushi Haven',
        'items': [
          {
            'menuItemId': 'item2',
            'name': 'California Roll',
            'price': 8.99,
            'quantity': 3,
          }
        ],
        'subtotal': 26.97,
        'deliveryFee': 3.49,
        'total': 30.46,
        'status': 'delivered',
        'deliveryAddress': '456 Oak Ave, City',
        'customerPhone': '+1-555-5678',
        'customerName': 'Jane Smith',
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    for (final order in sampleOrders) {
      await _db.collection('orders').add(order);
    }
    debugPrint('Sample orders created');
  }

  // Restaurants Collection
  static Stream<List<Restaurant>> streamRestaurants() {
    return _db
        .collection('restaurants')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Restaurant.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  static Future<void> addRestaurant(Restaurant restaurant) async {
    final data = restaurant.toJson();
    data.remove('id');
    await _db.collection('restaurants').add(data);
  }

  static Future<void> updateRestaurant(Restaurant restaurant) async {
    final data = restaurant.toJson();
    data.remove('id');
    await _db.collection('restaurants').doc(restaurant.id).update(data);
  }

  static Future<void> deleteRestaurant(String id) async {
    final menuItemsSnapshot = await _db
        .collection('restaurants')
        .doc(id)
        .collection('menuItems')
        .get();
    
    for (var doc in menuItemsSnapshot.docs) {
      await doc.reference.delete();
    }
    
    await _db.collection('restaurants').doc(id).delete();
  }

  static Stream<List<Restaurant>> searchRestaurants(String query) {
    if (query.isEmpty) {
      return streamRestaurants();
    }
    
    return streamRestaurants().map((restaurants) => restaurants
        .where((r) =>
            r.name.toLowerCase().contains(query.toLowerCase()) ||
            r.cuisineType.toLowerCase().contains(query.toLowerCase()) ||
            r.address.toLowerCase().contains(query.toLowerCase()))
        .toList());
  }

  // Menu Items Collection
  static Stream<List<MenuItem>> streamMenuItems(String restaurantId) {
    return _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menuItems')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MenuItem.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  static Future<void> addMenuItem(String restaurantId, MenuItem menuItem) async {
    final data = menuItem.toJson();
    data.remove('id');
    await _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menuItems')
        .add(data);
  }

  static Future<void> updateMenuItem(String restaurantId, MenuItem menuItem) async {
    final data = menuItem.toJson();
    data.remove('id');
    await _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menuItems')
        .doc(menuItem.id)
        .update(data);
  }

  static Future<void> deleteMenuItem(String restaurantId, String menuItemId) async {
    await _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menuItems')
        .doc(menuItemId)
        .delete();
  }

  // Orders Collection
  static Stream<List<FoodOrder>> streamOrders() {
    return _db
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FoodOrder.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  static Future<void> addOrder(FoodOrder order) async {
    final data = order.toJson();
    data.remove('id');
    await _db.collection('orders').add(data);
  }

  static Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _db.collection('orders').doc(orderId).update({'status': status.name});
  }

  static Future<void> deleteOrder(String orderId) async {
    await _db.collection('orders').doc(orderId).delete();
  }

  // Dashboard Statistics
  static Stream<Map<String, dynamic>> streamDashboardStats() {
    return _db.collection('restaurants').snapshots().asyncMap((restaurantSnapshot) async {
      final orderSnapshot = await _db.collection('orders').get();
      
      final restaurants = restaurantSnapshot.docs.length;
      final openRestaurants = restaurantSnapshot.docs
          .where((doc) => doc.data()['isOpen'] == true)
          .length;
      
      final orders = orderSnapshot.docs;
      final totalOrders = orders.length;
      final pendingOrders = orders.where((doc) => doc.data()['status'] == 'pending').length;
      
      double totalRevenue = 0.0;
      for (var doc in orders) {
        if (doc.data()['status'] == 'delivered') {
          totalRevenue += (doc.data()['total'] ?? 0.0).toDouble();
        }
      }
      
      double averageRating = 0.0;
      if (restaurants > 0) {
        double ratingSum = 0.0;
        for (var doc in restaurantSnapshot.docs) {
          ratingSum += (doc.data()['rating'] ?? 0.0).toDouble();
        }
        averageRating = ratingSum / restaurants;
      }
      
      return {
        'totalRestaurants': restaurants,
        'activeRestaurants': openRestaurants,
        'totalOrders': totalOrders,
        'pendingOrders': pendingOrders,
        'totalRevenue': totalRevenue,
        'averageRating': averageRating,
      };
    });
  }

  // Recent Activity
  static Stream<List<Map<String, dynamic>>> streamRecentActivity() {
    return _db
        .collection('activity')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {...doc.data(), 'id': doc.id})
            .toList());
  }

  static Future<void> addActivity(String message, String type, {Map<String, dynamic>? data}) async {
    await _db.collection('activity').add({
      'message': message,
      'type': type,
      'timestamp': FieldValue.serverTimestamp(),
      'data': data ?? {},
    });
  }
}
>>>>>>> a330a6beaf92aaae151a5a3470617d41e51bbcdf
