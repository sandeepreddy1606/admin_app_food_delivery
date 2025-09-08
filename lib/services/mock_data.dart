import 'package:flutter/material.dart';
import '../models/restaurant.dart';

class MockData {
  // Mock Restaurants
  static final List<Restaurant> restaurants = [
    Restaurant(
      id: '1',
      name: 'Burger Palace',
      description: 'Delicious gourmet burgers made with fresh ingredients and served with crispy fries',
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=300&fit=crop',
      rating: 4.7,
      cuisineType: 'American',
      deliveryTime: 30,
      deliveryFee: 2.99,
      isOpen: true,
      address: '123 Burger Street, Downtown City',
      phoneNumber: '+1-555-0101',
      ownerEmail: 'owner@burgerpalace.com',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      isActive: true,
      categories: ['burgers', 'american'],
      operatingHours: {
        'monday': {'open': '10:00', 'close': '22:00'},
        'tuesday': {'open': '10:00', 'close': '22:00'},
        'wednesday': {'open': '10:00', 'close': '22:00'},
        'thursday': {'open': '10:00', 'close': '22:00'},
        'friday': {'open': '10:00', 'close': '23:00'},
        'saturday': {'open': '10:00', 'close': '23:00'},
        'sunday': {'open': '11:00', 'close': '21:00'},
      },
    ),
    Restaurant(
      id: '2',
      name: 'Sushi Haven',
      description: 'Authentic Japanese sushi and sashimi prepared by expert chefs with fresh fish',
      imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400&h=300&fit=crop',
      rating: 4.9,
      cuisineType: 'Japanese',
      deliveryTime: 45,
      deliveryFee: 3.49,
      isOpen: true,
      address: '456 Sushi Lane, Japantown',
      phoneNumber: '+1-555-0102',
      ownerEmail: 'owner@sushihaven.com',
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      isActive: true,
      categories: ['sushi', 'japanese'],
      operatingHours: {
        'monday': {'open': '11:00', 'close': '21:00'},
        'tuesday': {'open': '11:00', 'close': '21:00'},
        'wednesday': {'open': '11:00', 'close': '21:00'},
        'thursday': {'open': '11:00', 'close': '21:00'},
        'friday': {'open': '11:00', 'close': '22:00'},
        'saturday': {'open': '11:00', 'close': '22:00'},
        'sunday': {'open': '12:00', 'close': '20:00'},
      },
    ),
    Restaurant(
      id: '3',
      name: 'Pizza Corner',
      description: 'Wood-fired Italian pizzas with authentic toppings and homemade dough',
      imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&h=300&fit=crop',
      rating: 4.5,
      cuisineType: 'Italian',
      deliveryTime: 25,
      deliveryFee: 1.99,
      isOpen: true,
      address: '789 Pizza Blvd, Little Italy',
      phoneNumber: '+1-555-0103',
      ownerEmail: 'owner@pizzacorner.com',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      isActive: true,
      categories: ['pizza', 'italian'],
      operatingHours: {
        'monday': {'open': '11:00', 'close': '23:00'},
        'tuesday': {'open': '11:00', 'close': '23:00'},
        'wednesday': {'open': '11:00', 'close': '23:00'},
        'thursday': {'open': '11:00', 'close': '23:00'},
        'friday': {'open': '11:00', 'close': '00:00'},
        'saturday': {'open': '11:00', 'close': '00:00'},
        'sunday': {'open': '12:00', 'close': '22:00'},
      },
    ),
    Restaurant(
      id: '4',
      name: 'Taco Fiesta',
      description: 'Authentic Mexican street tacos with fresh salsa and handmade tortillas',
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
      rating: 4.6,
      cuisineType: 'Mexican',
      deliveryTime: 20,
      deliveryFee: 2.49,
      isOpen: true,
      address: '321 Taco Street, Mexican Quarter',
      phoneNumber: '+1-555-0104',
      ownerEmail: 'owner@tacofiesta.com',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
      isActive: true,
      categories: ['tacos', 'mexican'],
      operatingHours: {
        'monday': {'open': '10:00', 'close': '22:00'},
        'tuesday': {'open': '10:00', 'close': '22:00'},
        'wednesday': {'open': '10:00', 'close': '22:00'},
        'thursday': {'open': '10:00', 'close': '22:00'},
        'friday': {'open': '10:00', 'close': '23:00'},
        'saturday': {'open': '10:00', 'close': '23:00'},
        'sunday': {'open': '11:00', 'close': '21:00'},
      },
    ),
    Restaurant(
      id: '5',
      name: 'Curry House',
      description: 'Traditional Indian curries and freshly baked naan bread with aromatic spices',
      imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400&h=300&fit=crop',
      rating: 4.8,
      cuisineType: 'Indian',
      deliveryTime: 35,
      deliveryFee: 2.99,
      isOpen: true,
      address: '654 Curry Lane, Spice District',
      phoneNumber: '+1-555-0105',
      ownerEmail: 'owner@curryhouse.com',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 45)),
      isActive: true,
      categories: ['curry', 'indian'],
      operatingHours: {
        'monday': {'open': '11:30', 'close': '21:30'},
        'tuesday': {'open': '11:30', 'close': '21:30'},
        'wednesday': {'open': '11:30', 'close': '21:30'},
        'thursday': {'open': '11:30', 'close': '21:30'},
        'friday': {'open': '11:30', 'close': '22:00'},
        'saturday': {'open': '11:30', 'close': '22:00'},
        'sunday': {'open': '12:00', 'close': '21:00'},
      },
    ),
    Restaurant(
      id: '6',
      name: 'Dragon Wok',
      description: 'Fresh Chinese stir-fry dishes and dim sum made with traditional recipes',
      imageUrl: 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=400&h=300&fit=crop',
      rating: 4.4,
      cuisineType: 'Chinese',
      deliveryTime: 30,
      deliveryFee: 2.99,
      isOpen: false,
      address: '987 Dragon Way, Chinatown',
      phoneNumber: '+1-555-0106',
      ownerEmail: 'owner@dragonwok.com',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
      isActive: true,
      categories: ['chinese', 'stir-fry'],
      operatingHours: {
        'monday': {'open': '11:00', 'close': '21:00'},
        'tuesday': {'open': '11:00', 'close': '21:00'},
        'wednesday': {'open': '11:00', 'close': '21:00'},
        'thursday': {'open': '11:00', 'close': '21:00'},
        'friday': {'open': '11:00', 'close': '22:00'},
        'saturday': {'open': '11:00', 'close': '22:00'},
        'sunday': {'open': '12:00', 'close': '20:00'},
      },
    ),
  ];

  // Dashboard Statistics
  static Map<String, dynamic> getDashboardStats() {
    return {
      'totalRestaurants': restaurants.length,
      'activeRestaurants': restaurants.where((r) => r.isOpen).length,
      'totalOrders': 42,
      'pendingOrders': 12,
      'totalRevenue': 15420.50,
      'averageRating': restaurants.fold<double>(0, (sum, r) => sum + r.rating) / restaurants.length,
    };
  }

  // Search restaurants
  static List<Restaurant> searchRestaurants(String query) {
    final lowercaseQuery = query.toLowerCase();
    return restaurants.where((restaurant) {
      return restaurant.name.toLowerCase().contains(lowercaseQuery) ||
             restaurant.cuisineType.toLowerCase().contains(lowercaseQuery) ||
             restaurant.address.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Recent activity for dashboard
  static List<Map<String, dynamic>> getRecentActivity() {
    return [
      {
        'type': 'order',
        'message': 'New order from Burger Palace',
        'time': DateTime.now().subtract(const Duration(minutes: 5)),
        'icon': Icons.receipt_long,
        'color': Colors.blue,
      },
      {
        'type': 'restaurant',
        'message': 'Sushi Haven updated menu',
        'time': DateTime.now().subtract(const Duration(minutes: 12)),
        'icon': Icons.menu_book,
        'color': Colors.green,
      },
      {
        'type': 'order',
        'message': 'Order delivered to customer',
        'time': DateTime.now().subtract(const Duration(minutes: 18)),
        'icon': Icons.delivery_dining,
        'color': Colors.purple,
      },
      {
        'type': 'restaurant',
        'message': 'New restaurant Pizza Corner added',
        'time': DateTime.now().subtract(const Duration(hours: 1)),
        'icon': Icons.store,
        'color': Colors.orange,
      },
    ];
  }
}
