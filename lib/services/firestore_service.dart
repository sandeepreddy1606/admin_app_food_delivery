import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
          debugPrint('Retrieved ${snapshot.docs.length} restaurants');
          return snapshot.docs
              .map((doc) {
                try {
                  return Restaurant.fromJson({...doc.data(), 'id': doc.id});
                } catch (e) {
                  debugPrint('Error parsing restaurant ${doc.id}: $e');
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
    final menuItems = await _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menuItems')
        .get();
    
    for (var doc in menuItems.docs) {
      await doc.reference.delete();
    }
    
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

  // ============ MENU ITEM OPERATIONS (ENHANCED WITH DEBUGGING) ============

  /// Get menu items for a restaurant with enhanced debugging
  static Stream<List<MenuItem>> getMenuItems(String restaurantId) {
    debugPrint('=== FETCHING MENU ITEMS ===');
    debugPrint('Restaurant ID: $restaurantId');
    debugPrint('Query path: restaurants/$restaurantId/menuItems');
    
    return _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menuItems')
        .snapshots()
        .asyncMap((snapshot) async {
          debugPrint('Retrieved ${snapshot.docs.length} menu items for restaurant $restaurantId');
          
          if (snapshot.docs.isEmpty) {
            debugPrint('No menu items found. Checking if restaurant exists...');
            final restaurantDoc = await _db.collection('restaurants').doc(restaurantId).get();
            debugPrint('Restaurant exists: ${restaurantDoc.exists}');
            
            // Also check if there are any subcollections
            debugPrint('Checking for subcollections...');
            await _debugRestaurantSubcollections(restaurantId);
          }
          
          final menuItems = <MenuItem>[];
          
          for (var doc in snapshot.docs) {
            try {
              final data = doc.data();
              debugPrint('Processing menu item ${doc.id}');
              debugPrint('Menu item fields: ${data.keys.join(', ')}');
              debugPrint('Sample data: name=${data['name']}, price=${data['price']}, category=${data['category']}');
              
              final menuItem = MenuItem.fromJson({...data, 'id': doc.id});
              menuItems.add(menuItem);
              debugPrint('Successfully parsed menu item: ${menuItem.name}');
              
            } catch (e, stackTrace) {
              debugPrint('Error parsing menu item ${doc.id}: $e');
              debugPrint('Stack trace: $stackTrace');
              debugPrint('Raw menu item data: ${doc.data()}');
            }
          }
          
          debugPrint('Successfully parsed ${menuItems.length} menu items');
          return menuItems..sort((a, b) => a.category.compareTo(b.category));
        })
        .handleError((error, stackTrace) {
          debugPrint('Stream error while fetching menu items: $error');
          debugPrint('Stack trace: $stackTrace');
        });
  }

  /// Debug method to check restaurant subcollections
  static Future<void> _debugRestaurantSubcollections(String restaurantId) async {
    try {
      // Check different possible collection names
      final possibleCollections = ['menuItems', 'menu_items', 'menu', 'items'];
      
      for (String collectionName in possibleCollections) {
        debugPrint('Checking collection: $collectionName');
        final snapshot = await _db
            .collection('restaurants')
            .doc(restaurantId)
            .collection(collectionName)
            .limit(1)
            .get();
        
        debugPrint('$collectionName has ${snapshot.docs.length} documents');
        if (snapshot.docs.isNotEmpty) {
          debugPrint('Found data in $collectionName: ${snapshot.docs.first.data().keys.join(', ')}');
        }
      }
    } catch (e) {
      debugPrint('Error checking subcollections: $e');
    }
  }

  /// Add menu item with enhanced debugging
  static Future<void> addMenuItem(String restaurantId, MenuItem menuItem) async {
    debugPrint('Adding menu item to restaurant $restaurantId');
    debugPrint('Menu item: ${menuItem.name} - ${menuItem.category} - \$${menuItem.price}');
    
    try {
      final data = menuItem.toJson();
      data.remove('id');
      data['restaurantId'] = restaurantId;
      data['createdAt'] = FieldValue.serverTimestamp();
      
      debugPrint('Menu item data to save: ${data.keys.join(', ')}');
      
      final docRef = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menuItems')
          .add(data);
          
      debugPrint('Menu item added successfully with ID: ${docRef.id}');
    } catch (e) {
      debugPrint('Error adding menu item: $e');
      rethrow;
    }
  }

  /// Update menu item
  static Future<void> updateMenuItem(String restaurantId, MenuItem menuItem) async {
    debugPrint('Updating menu item ${menuItem.id} in restaurant $restaurantId');
    
    try {
      final data = menuItem.toJson();
      data.remove('id');
      data['updatedAt'] = FieldValue.serverTimestamp();
      
      await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menuItems')
          .doc(menuItem.id)
          .update(data);
          
      debugPrint('Menu item updated successfully');
    } catch (e) {
      debugPrint('Error updating menu item: $e');
      rethrow;
    }
  }

  /// Delete menu item
  static Future<void> deleteMenuItem(String restaurantId, String menuItemId) async {
    debugPrint('Deleting menu item $menuItemId from restaurant $restaurantId');
    
    try {
      await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menuItems')
          .doc(menuItemId)
          .delete();
          
      debugPrint('Menu item deleted successfully');
    } catch (e) {
      debugPrint('Error deleting menu item: $e');
      rethrow;
    }
  }

  /// Get categories for a restaurant with debugging
  static Future<List<String>> getMenuCategories(String restaurantId) async {
    debugPrint('Fetching menu categories for restaurant $restaurantId');
    
    try {
      final snapshot = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menuItems')
          .get();
      
      debugPrint('Found ${snapshot.docs.length} menu items for categories');
      
      final categories = <String>{};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data['category'] != null) {
          categories.add(data['category']);
        }
      }
      
      final categoryList = categories.toList()..sort();
      debugPrint('Categories found: ${categoryList.join(', ')}');
      return categoryList;
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      return [];
    }
  }

  /// Debug method to check menu items structure
  static Future<void> debugMenuItems(String restaurantId) async {
    try {
      debugPrint('=== DEBUGGING MENU ITEMS FOR RESTAURANT $restaurantId ===');
      
      // First check if restaurant exists
      final restaurantDoc = await _db.collection('restaurants').doc(restaurantId).get();
      debugPrint('Restaurant exists: ${restaurantDoc.exists}');
      if (restaurantDoc.exists) {
        debugPrint('Restaurant data: ${restaurantDoc.data()}');
      }
      
      // Check menu items
      final snapshot = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menuItems')
          .limit(5)
          .get();
          
      debugPrint('Total menu items found: ${snapshot.docs.length}');
      
      if (snapshot.docs.isEmpty) {
        debugPrint('No menu items found. Checking alternative structures...');
        await _debugRestaurantSubcollections(restaurantId);
        return;
      }
      
      for (int i = 0; i < snapshot.docs.length; i++) {
        final doc = snapshot.docs[i];
        debugPrint('--- Menu Item ${i + 1} ---');
        debugPrint('Menu Item ID: ${doc.id}');
        debugPrint('Available fields: ${doc.data().keys.join(', ')}');
        
        final data = doc.data();
        debugPrint('Menu Item Details:');
        debugPrint('  name: ${data['name']}');
        debugPrint('  description: ${data['description']}');
        debugPrint('  price: ${data['price']}');
        debugPrint('  category: ${data['category']}');
        debugPrint('  isAvailable: ${data['isAvailable']}');
        debugPrint('  imageUrl: ${data['imageUrl']}');
        debugPrint('');
      }
      debugPrint('=== END MENU ITEMS DEBUG ===');
    } catch (e) {
      debugPrint('Error debugging menu items: $e');
    }
  }

  // ============ ORDER OPERATIONS ============
  
  /// Get all orders as stream
  static Stream<List<FoodOrder>> getOrders() {
    debugPrint('Starting to fetch orders from Firestore...');
    
    return _db
        .collection('orders')
        .orderBy('placedAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          debugPrint('Retrieved ${snapshot.docs.length} order documents from Firestore');
          
          final orders = <FoodOrder>[];
          
          for (var doc in snapshot.docs) {
            try {
              final data = doc.data();
              debugPrint('Processing order ${doc.id}');
              
              final order = FoodOrder.fromJson({...data, 'id': doc.id});
              orders.add(order);
              
            } catch (e, stackTrace) {
              debugPrint('Error parsing order ${doc.id}: $e');
              debugPrint('Raw order data: ${doc.data()}');
            }
          }
          
          debugPrint('Successfully parsed ${orders.length} orders out of ${snapshot.docs.length} documents');
          return orders;
        })
        .handleError((error, stackTrace) {
          debugPrint('Stream error while fetching orders: $error');
        });
  }

  /// Update order status
  static Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _db.collection('orders').doc(orderId).update({
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('Successfully updated order $orderId status to ${status.name}');
    } catch (e) {
      debugPrint('Error updating order status: $e');
      rethrow;
    }
  }

  /// Get order by ID
  static Future<FoodOrder?> getOrder(String orderId) async {
    try {
      debugPrint('Fetching order details for: $orderId');
      final doc = await _db.collection('orders').doc(orderId).get();
      
      if (doc.exists) {
        debugPrint('Found order $orderId');
        return FoodOrder.fromJson({...doc.data()!, 'id': doc.id});
      } else {
        debugPrint('Order $orderId not found');
      }
    } catch (e) {
      debugPrint('Error getting order $orderId: $e');
    }
    return null;
  }

  /// Debug method to check orders collection structure
  static Future<void> debugOrdersCollection() async {
    try {
      debugPrint('=== DEBUGGING ORDERS COLLECTION ===');
      final snapshot = await _db.collection('orders').limit(3).get();
      debugPrint('Total orders in collection: ${snapshot.docs.length}');
      
      if (snapshot.docs.isEmpty) {
        debugPrint('No orders found in the collection');
        return;
      }
      
      for (int i = 0; i < snapshot.docs.length; i++) {
        final doc = snapshot.docs[i];
        debugPrint('--- Order ${i + 1} ---');
        debugPrint('Order ID: ${doc.id}');
        debugPrint('Available fields: ${doc.data().keys.join(', ')}');
        
        final data = doc.data();
        debugPrint('Order Details:');
        debugPrint('  status: ${data['status']}');
        debugPrint('  total: ${data['total']}');
        debugPrint('  subtotal: ${data['subtotal']}');
        debugPrint('  deliveryFee: ${data['deliveryFee']}');
        debugPrint('  tax: ${data['tax']}');
        debugPrint('  placedAt: ${data['placedAt']}');
        
        if (data['address'] != null) {
          final addr = data['address'] as Map<String, dynamic>;
          debugPrint('  address: ${addr['street']}, ${addr['city']}, ${addr['state']}');
        }
        
        if (data['payment'] != null) {
          final payment = data['payment'] as Map<String, dynamic>;
          debugPrint('  payment: ${payment['displayName']} (${payment['type']})');
        }
        
        if (data['items'] != null) {
          final items = data['items'] as List;
          debugPrint('  items (${items.length}):');
          for (int j = 0; j < items.length; j++) {
            final item = items[j] as Map<String, dynamic>;
            final menuItem = item['menuItem'] as Map<String, dynamic>? ?? {};
            debugPrint('    ${j + 1}. ${menuItem['name']} x${item['quantity']} = \$${item['totalPrice']}');
          }
        }
        debugPrint('');
      }
      debugPrint('=== END DEBUG ===');
    } catch (e) {
      debugPrint('Error debugging orders collection: $e');
    }
  }

  // ============ EXISTING METHODS ============
  
  static Future<void> addData(String collection, Map<String, dynamic> data) async {
    await _db.collection(collection).add(data);
  }

  static Stream<QuerySnapshot> streamData(String collection) {
    return _db.collection(collection).snapshots();
  }
}
