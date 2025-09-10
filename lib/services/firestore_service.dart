import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant.dart';
import '../models/menu_item.dart';
import '../models/order.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;

  // ============ RESTAURANT OPERATIONS ============
  
  /// Get all restaurants as stream
  static Stream<List<Restaurant>> getRestaurants() {
    return _db
        .collection('restaurants')
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
          print('Retrieved ${snapshot.docs.length} restaurants'); // Debug log
          return snapshot.docs
              .map((doc) {
                try {
                  return Restaurant.fromJson({...doc.data(), 'id': doc.id});
                } catch (e) {
                  print('Error parsing restaurant ${doc.id}: $e');
                  return null;
                }
              })
              .where((restaurant) => restaurant != null)
              .cast<Restaurant>()
              .toList();
        });
  }

  /// Add new restaurant
  static Future<void> addRestaurant(Restaurant restaurant) async {
    final data = restaurant.toJson();
    data.remove('id');
    await _db.collection('restaurants').add(data);
  }

  /// Update restaurant
  static Future<void> updateRestaurant(Restaurant restaurant) async {
    final data = restaurant.toJson();
    data.remove('id');
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _db.collection('restaurants').doc(restaurant.id).update(data);
  }

  /// Delete restaurant
  static Future<void> deleteRestaurant(String restaurantId) async {
    // Delete all menu items first
    final menuItems = await _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menuItems')
        .get();
    
    for (var doc in menuItems.docs) {
      await doc.reference.delete();
    }
    
    // Delete restaurant
    await _db.collection('restaurants').doc(restaurantId).delete();
  }

  /// Get single restaurant
  static Future<Restaurant?> getRestaurant(String restaurantId) async {
    final doc = await _db.collection('restaurants').doc(restaurantId).get();
    if (doc.exists) {
      return Restaurant.fromJson({...doc.data()!, 'id': doc.id});
    }
    return null;
  }

  // ============ MENU ITEM OPERATIONS ============

  /// Get menu items for a restaurant
  static Stream<List<MenuItem>> getMenuItems(String restaurantId) {
    return _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menuItems')
        .orderBy('category')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MenuItem.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Add menu item
  static Future<void> addMenuItem(String restaurantId, MenuItem menuItem) async {
    final data = menuItem.toJson();
    data.remove('id');
    data['restaurantId'] = restaurantId;
    await _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menuItems')
        .add(data);
  }

  /// Update menu item
  static Future<void> updateMenuItem(String restaurantId, MenuItem menuItem) async {
    final data = menuItem.toJson();
    data.remove('id');
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menuItems')
        .doc(menuItem.id)
        .update(data);
  }

  /// Delete menu item
  static Future<void> deleteMenuItem(String restaurantId, String menuItemId) async {
    await _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menuItems')
        .doc(menuItemId)
        .delete();
  }

  /// Get categories for a restaurant
  static Future<List<String>> getMenuCategories(String restaurantId) async {
    final snapshot = await _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menuItems')
        .get();
    
    final categories = <String>{};
    for (var doc in snapshot.docs) {
      final data = doc.data();
      if (data['category'] != null) {
        categories.add(data['category']);
      }
    }
    return categories.toList()..sort();
  }

  // ============ ORDER OPERATIONS ============

  /// Get all orders as stream
  static Stream<List<FoodOrder>> getOrders() {
    return _db
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FoodOrder.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Update order status
  static Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _db.collection('orders').doc(orderId).update({
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get order by ID
  static Future<FoodOrder?> getOrder(String orderId) async {
    final doc = await _db.collection('orders').doc(orderId).get();
    if (doc.exists) {
      return FoodOrder.fromJson({...doc.data()!, 'id': doc.id});
    }
    return null;
  }

  // ============ EXISTING METHODS ============
  
  static Future<void> addData(String collection, Map<String, dynamic> data) async {
    await _db.collection(collection).add(data);
  }

  static Stream<QuerySnapshot> streamData(String collection) {
    return _db.collection(collection).snapshots();
  }
}
