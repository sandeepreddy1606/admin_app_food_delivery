<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/restaurant.dart';
import '../services/firestore_service.dart';

class RestaurantManagement extends StatefulWidget {
  const RestaurantManagement({super.key});

  @override
  State<RestaurantManagement> createState() => _RestaurantManagementState();
}

class _RestaurantManagementState extends State<RestaurantManagement> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          if (isMobile) {
            return _buildMobileLayout();
          } else {
            return _buildDesktopLayout();
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSearchAndAddSection(),
          const SizedBox(height: 16),
          _buildRestaurantsList(true),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildSearchAndAddSection(),
          const SizedBox(height: 24),
          _buildRestaurantsList(false),
        ],
      ),
    );
  }

  Widget _buildSearchAndAddSection() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search restaurants...',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () => _showAddRestaurantDialog(),
          icon: const Icon(Icons.add, color: Colors.white, size: 18),
          label: Text(
            'Add Restaurant',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A90E2),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurantsList(bool isMobile) {
    return StreamBuilder<List<Restaurant>>(
      stream: _searchQuery.isEmpty
          ? FirestoreService.streamRestaurants()
          : FirestoreService.searchRestaurants(_searchQuery),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState();
        }

        final restaurants = snapshot.data!;

        if (isMobile) {
          return Column(
            children: restaurants
                .map((restaurant) => _buildRestaurantCard(restaurant))
                .toList(),
          );
        } else {
          return _buildRestaurantTable(restaurants);
        }
      },
    );
  }

  Widget _buildRestaurantCard(Restaurant restaurant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  restaurant.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[200],
                      child: const Icon(Icons.restaurant, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: const Color(0xFF2E3A47),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      restaurant.address,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: restaurant.isOpen ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  restaurant.isOpen ? 'Open' : 'Closed',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showRestaurantDetails(restaurant),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: Text(
                    'View',
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showEditRestaurantDialog(restaurant),
                  icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                  label: Text(
                    'Edit',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _toggleRestaurantStatus(restaurant),
                icon: Icon(
                  restaurant.isOpen ? Icons.pause_circle : Icons.play_circle,
                  color: restaurant.isOpen ? Colors.orange : Colors.green,
                ),
                tooltip: restaurant.isOpen ? 'Close' : 'Open',
              ),
              IconButton(
                onPressed: () => _showDeleteConfirmDialog(restaurant),
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Delete',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantTable(List<Restaurant> restaurants) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  child: Text(
                    'Restaurant',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: const Color(0xFF2E3A47),
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    'Cuisine',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: const Color(0xFF2E3A47),
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'Rating',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: const Color(0xFF2E3A47),
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'Status',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: const Color(0xFF2E3A47),
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    'Actions',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: const Color(0xFF2E3A47),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...restaurants.asMap().entries.map((entry) {
            final index = entry.key;
            final restaurant = entry.value;
            return _buildTableRow(restaurant, index);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTableRow(Restaurant restaurant, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
        color: index % 2 == 0 ? null : Colors.grey[25],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    restaurant.imageUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 40,
                        height: 40,
                        color: Colors.grey[200],
                        child: const Icon(Icons.restaurant, color: Colors.grey, size: 20),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: const Color(0xFF2E3A47),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        restaurant.address,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: Container(
              width: 80,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getCuisineColor(restaurant.cuisineType).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                restaurant.cuisineType,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: _getCuisineColor(restaurant.cuisineType),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  restaurant.rating.toStringAsFixed(1),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: const Color(0xFF2E3A47),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: restaurant.isOpen ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                restaurant.isOpen ? 'Open' : 'Closed',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.blue, size: 18),
                  onPressed: () => _showRestaurantDetails(restaurant),
                  tooltip: 'View Details',
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange, size: 18),
                  onPressed: () => _showEditRestaurantDialog(restaurant),
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: Icon(
                    restaurant.isOpen ? Icons.pause_circle : Icons.play_circle,
                    color: restaurant.isOpen ? Colors.orange : Colors.green,
                    size: 18,
                  ),
                  onPressed: () => _toggleRestaurantStatus(restaurant),
                  tooltip: restaurant.isOpen ? 'Close' : 'Open',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                  onPressed: () => _showDeleteConfirmDialog(restaurant),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'No restaurants found' : 'No results for "$_searchQuery"',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty ? 'Click "Add Restaurant" to get started' : 'Try a different search term',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCuisineColor(String cuisine) {
    switch (cuisine.toLowerCase()) {
      case 'american': return Colors.blue;
      case 'japanese': return Colors.red;
      case 'italian': return Colors.green;
      case 'mexican': return Colors.orange;
      case 'indian': return Colors.purple;
      case 'chinese': return Colors.teal;
      default: return Colors.grey;
    }
  }

  void _showAddRestaurantDialog() {
    _showRestaurantDialog();
  }

  void _showEditRestaurantDialog(Restaurant restaurant) {
    _showRestaurantDialog(restaurant: restaurant);
  }

  void _showRestaurantDialog({Restaurant? restaurant}) {
    final isEditing = restaurant != null;
    final nameController = TextEditingController(text: restaurant?.name ?? '');
    final descriptionController = TextEditingController(text: restaurant?.description ?? '');
    final imageUrlController = TextEditingController(text: restaurant?.imageUrl ?? '');
    final addressController = TextEditingController(text: restaurant?.address ?? '');
    final phoneController = TextEditingController(text: restaurant?.phoneNumber ?? '');
    final emailController = TextEditingController(text: restaurant?.ownerEmail ?? '');
    final deliveryTimeController = TextEditingController(text: restaurant?.deliveryTime.toString() ?? '30');
    final deliveryFeeController = TextEditingController(text: restaurant?.deliveryFee.toString() ?? '2.99');

    String selectedCuisine = restaurant?.cuisineType ?? 'American';
    final cuisines = ['American', 'Italian', 'Chinese', 'Japanese', 'Mexican', 'Indian', 'Thai', 'French'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isEditing ? 'Edit Restaurant' : 'Add Restaurant',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Restaurant Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: imageUrlController,
                  decoration: InputDecoration(
                    labelText: 'Image URL',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCuisine,
                  decoration: InputDecoration(
                    labelText: 'Cuisine Type',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: cuisines.map((cuisine) => DropdownMenuItem(
                    value: cuisine,
                    child: Text(cuisine),
                  )).toList(),
                  onChanged: (value) => selectedCuisine = value!,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Owner Email',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: deliveryTimeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Delivery Time (min)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: deliveryFeeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Delivery Fee (\$)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter restaurant name')),
                );
                return;
              }

              final newRestaurant = Restaurant(
                id: restaurant?.id ?? '',
                name: nameController.text,
                description: descriptionController.text,
                imageUrl: imageUrlController.text.isEmpty
                    ? 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400&h=300&fit=crop'
                    : imageUrlController.text,
                rating: restaurant?.rating ?? 4.5,
                cuisineType: selectedCuisine,
                deliveryTime: int.tryParse(deliveryTimeController.text) ?? 30,
                deliveryFee: double.tryParse(deliveryFeeController.text) ?? 2.99,
                isOpen: restaurant?.isOpen ?? true,
                address: addressController.text,
                phoneNumber: phoneController.text,
                ownerEmail: emailController.text,
                createdAt: restaurant?.createdAt ?? DateTime.now(),
                updatedAt: DateTime.now(),
              );

              try {
                if (isEditing) {
                  await FirestoreService.updateRestaurant(newRestaurant);
                  await FirestoreService.addActivity(
                    '${newRestaurant.name} restaurant updated',
                    'restaurant_updated',
                  );
                } else {
                  await FirestoreService.addRestaurant(newRestaurant);
                  await FirestoreService.addActivity(
                    'New restaurant ${newRestaurant.name} added',
                    'restaurant_added',
                  );
                }

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEditing ? 'Restaurant updated successfully!' : 'Restaurant added successfully!',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(
              isEditing ? 'Update' : 'Add',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showRestaurantDetails(Restaurant restaurant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          restaurant.name,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                restaurant.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    color: Colors.grey[200],
                    child: const Icon(Icons.restaurant, size: 40, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text('Cuisine: ${restaurant.cuisineType}', style: GoogleFonts.poppins()),
            Text('Rating: ${restaurant.rating}/5', style: GoogleFonts.poppins()),
            Text('Delivery: ${restaurant.deliveryTime} min', style: GoogleFonts.poppins()),
            Text('Fee: \$${restaurant.deliveryFee}', style: GoogleFonts.poppins()),
            Text('Status: ${restaurant.isOpen ? "Open" : "Closed"}', style: GoogleFonts.poppins()),
            const SizedBox(height: 8),
            Text(restaurant.description, style: GoogleFonts.poppins(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  void _toggleRestaurantStatus(Restaurant restaurant) async {
    try {
      final updatedRestaurant = restaurant.copyWith(
        isOpen: !restaurant.isOpen,
        updatedAt: DateTime.now(),
      );
      
      await FirestoreService.updateRestaurant(updatedRestaurant);
      await FirestoreService.addActivity(
        '${restaurant.name} is now ${restaurant.isOpen ? "Closed" : "Open"}',
        'restaurant_status_changed',
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${restaurant.name} is now ${restaurant.isOpen ? "Closed" : "Open"}',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: restaurant.isOpen ? Colors.red : Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteConfirmDialog(Restaurant restaurant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Restaurant',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete "${restaurant.name}"? This action cannot be undone.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirestoreService.deleteRestaurant(restaurant.id);
                await FirestoreService.addActivity(
                  'Restaurant ${restaurant.name} deleted',
                  'restaurant_deleted',
                );
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Restaurant deleted successfully!',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error deleting restaurant: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
=======
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/restaurant.dart';
import '../services/firestore_service.dart';

class RestaurantManagement extends StatefulWidget {
  const RestaurantManagement({super.key});

  @override
  State<RestaurantManagement> createState() => _RestaurantManagementState();
}

class _RestaurantManagementState extends State<RestaurantManagement> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          if (isMobile) {
            return _buildMobileLayout();
          } else {
            return _buildDesktopLayout();
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSearchAndAddSection(),
          const SizedBox(height: 16),
          _buildRestaurantsList(true),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildSearchAndAddSection(),
          const SizedBox(height: 24),
          _buildRestaurantsList(false),
        ],
      ),
    );
  }

  Widget _buildSearchAndAddSection() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search restaurants...',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () => _showAddRestaurantDialog(),
          icon: const Icon(Icons.add, color: Colors.white, size: 18),
          label: Text(
            'Add Restaurant',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A90E2),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurantsList(bool isMobile) {
    return StreamBuilder<List<Restaurant>>(
      stream: _searchQuery.isEmpty
          ? FirestoreService.streamRestaurants()
          : FirestoreService.searchRestaurants(_searchQuery),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState();
        }

        final restaurants = snapshot.data!;

        if (isMobile) {
          return Column(
            children: restaurants
                .map((restaurant) => _buildRestaurantCard(restaurant))
                .toList(),
          );
        } else {
          return _buildRestaurantTable(restaurants);
        }
      },
    );
  }

  Widget _buildRestaurantCard(Restaurant restaurant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  restaurant.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[200],
                      child: const Icon(Icons.restaurant, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: const Color(0xFF2E3A47),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      restaurant.address,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: restaurant.isOpen ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  restaurant.isOpen ? 'Open' : 'Closed',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showRestaurantDetails(restaurant),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: Text(
                    'View',
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showEditRestaurantDialog(restaurant),
                  icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                  label: Text(
                    'Edit',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _toggleRestaurantStatus(restaurant),
                icon: Icon(
                  restaurant.isOpen ? Icons.pause_circle : Icons.play_circle,
                  color: restaurant.isOpen ? Colors.orange : Colors.green,
                ),
                tooltip: restaurant.isOpen ? 'Close' : 'Open',
              ),
              IconButton(
                onPressed: () => _showDeleteConfirmDialog(restaurant),
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Delete',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantTable(List<Restaurant> restaurants) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  child: Text(
                    'Restaurant',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: const Color(0xFF2E3A47),
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    'Cuisine',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: const Color(0xFF2E3A47),
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'Rating',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: const Color(0xFF2E3A47),
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'Status',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: const Color(0xFF2E3A47),
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    'Actions',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: const Color(0xFF2E3A47),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...restaurants.asMap().entries.map((entry) {
            final index = entry.key;
            final restaurant = entry.value;
            return _buildTableRow(restaurant, index);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTableRow(Restaurant restaurant, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
        color: index % 2 == 0 ? null : Colors.grey[25],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    restaurant.imageUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 40,
                        height: 40,
                        color: Colors.grey[200],
                        child: const Icon(Icons.restaurant, color: Colors.grey, size: 20),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: const Color(0xFF2E3A47),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        restaurant.address,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: Container(
              width: 80,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getCuisineColor(restaurant.cuisineType).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                restaurant.cuisineType,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: _getCuisineColor(restaurant.cuisineType),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  restaurant.rating.toStringAsFixed(1),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: const Color(0xFF2E3A47),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: restaurant.isOpen ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                restaurant.isOpen ? 'Open' : 'Closed',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.blue, size: 18),
                  onPressed: () => _showRestaurantDetails(restaurant),
                  tooltip: 'View Details',
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange, size: 18),
                  onPressed: () => _showEditRestaurantDialog(restaurant),
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: Icon(
                    restaurant.isOpen ? Icons.pause_circle : Icons.play_circle,
                    color: restaurant.isOpen ? Colors.orange : Colors.green,
                    size: 18,
                  ),
                  onPressed: () => _toggleRestaurantStatus(restaurant),
                  tooltip: restaurant.isOpen ? 'Close' : 'Open',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                  onPressed: () => _showDeleteConfirmDialog(restaurant),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'No restaurants found' : 'No results for "$_searchQuery"',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty ? 'Click "Add Restaurant" to get started' : 'Try a different search term',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCuisineColor(String cuisine) {
    switch (cuisine.toLowerCase()) {
      case 'american': return Colors.blue;
      case 'japanese': return Colors.red;
      case 'italian': return Colors.green;
      case 'mexican': return Colors.orange;
      case 'indian': return Colors.purple;
      case 'chinese': return Colors.teal;
      default: return Colors.grey;
    }
  }

  void _showAddRestaurantDialog() {
    _showRestaurantDialog();
  }

  void _showEditRestaurantDialog(Restaurant restaurant) {
    _showRestaurantDialog(restaurant: restaurant);
  }

  void _showRestaurantDialog({Restaurant? restaurant}) {
    final isEditing = restaurant != null;
    final nameController = TextEditingController(text: restaurant?.name ?? '');
    final descriptionController = TextEditingController(text: restaurant?.description ?? '');
    final imageUrlController = TextEditingController(text: restaurant?.imageUrl ?? '');
    final addressController = TextEditingController(text: restaurant?.address ?? '');
    final phoneController = TextEditingController(text: restaurant?.phoneNumber ?? '');
    final emailController = TextEditingController(text: restaurant?.ownerEmail ?? '');
    final deliveryTimeController = TextEditingController(text: restaurant?.deliveryTime.toString() ?? '30');
    final deliveryFeeController = TextEditingController(text: restaurant?.deliveryFee.toString() ?? '2.99');

    String selectedCuisine = restaurant?.cuisineType ?? 'American';
    final cuisines = ['American', 'Italian', 'Chinese', 'Japanese', 'Mexican', 'Indian', 'Thai', 'French'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isEditing ? 'Edit Restaurant' : 'Add Restaurant',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Restaurant Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: imageUrlController,
                  decoration: InputDecoration(
                    labelText: 'Image URL',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCuisine,
                  decoration: InputDecoration(
                    labelText: 'Cuisine Type',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: cuisines.map((cuisine) => DropdownMenuItem(
                    value: cuisine,
                    child: Text(cuisine),
                  )).toList(),
                  onChanged: (value) => selectedCuisine = value!,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Owner Email',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: deliveryTimeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Delivery Time (min)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: deliveryFeeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Delivery Fee (\$)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter restaurant name')),
                );
                return;
              }

              final newRestaurant = Restaurant(
                id: restaurant?.id ?? '',
                name: nameController.text,
                description: descriptionController.text,
                imageUrl: imageUrlController.text.isEmpty
                    ? 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400&h=300&fit=crop'
                    : imageUrlController.text,
                rating: restaurant?.rating ?? 4.5,
                cuisineType: selectedCuisine,
                deliveryTime: int.tryParse(deliveryTimeController.text) ?? 30,
                deliveryFee: double.tryParse(deliveryFeeController.text) ?? 2.99,
                isOpen: restaurant?.isOpen ?? true,
                address: addressController.text,
                phoneNumber: phoneController.text,
                ownerEmail: emailController.text,
                createdAt: restaurant?.createdAt ?? DateTime.now(),
                updatedAt: DateTime.now(),
              );

              try {
                if (isEditing) {
                  await FirestoreService.updateRestaurant(newRestaurant);
                  await FirestoreService.addActivity(
                    '${newRestaurant.name} restaurant updated',
                    'restaurant_updated',
                  );
                } else {
                  await FirestoreService.addRestaurant(newRestaurant);
                  await FirestoreService.addActivity(
                    'New restaurant ${newRestaurant.name} added',
                    'restaurant_added',
                  );
                }

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEditing ? 'Restaurant updated successfully!' : 'Restaurant added successfully!',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(
              isEditing ? 'Update' : 'Add',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showRestaurantDetails(Restaurant restaurant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          restaurant.name,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                restaurant.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    color: Colors.grey[200],
                    child: const Icon(Icons.restaurant, size: 40, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text('Cuisine: ${restaurant.cuisineType}', style: GoogleFonts.poppins()),
            Text('Rating: ${restaurant.rating}/5', style: GoogleFonts.poppins()),
            Text('Delivery: ${restaurant.deliveryTime} min', style: GoogleFonts.poppins()),
            Text('Fee: \$${restaurant.deliveryFee}', style: GoogleFonts.poppins()),
            Text('Status: ${restaurant.isOpen ? "Open" : "Closed"}', style: GoogleFonts.poppins()),
            const SizedBox(height: 8),
            Text(restaurant.description, style: GoogleFonts.poppins(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  void _toggleRestaurantStatus(Restaurant restaurant) async {
    try {
      final updatedRestaurant = restaurant.copyWith(
        isOpen: !restaurant.isOpen,
        updatedAt: DateTime.now(),
      );
      
      await FirestoreService.updateRestaurant(updatedRestaurant);
      await FirestoreService.addActivity(
        '${restaurant.name} is now ${restaurant.isOpen ? "Closed" : "Open"}',
        'restaurant_status_changed',
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${restaurant.name} is now ${restaurant.isOpen ? "Closed" : "Open"}',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: restaurant.isOpen ? Colors.red : Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteConfirmDialog(Restaurant restaurant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Restaurant',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete "${restaurant.name}"? This action cannot be undone.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirestoreService.deleteRestaurant(restaurant.id);
                await FirestoreService.addActivity(
                  'Restaurant ${restaurant.name} deleted',
                  'restaurant_deleted',
                );
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Restaurant deleted successfully!',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error deleting restaurant: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
>>>>>>> a330a6beaf92aaae151a5a3470617d41e51bbcdf
}