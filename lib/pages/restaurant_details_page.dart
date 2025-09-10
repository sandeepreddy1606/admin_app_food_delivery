import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../models/menu_item.dart';
import '../services/firestore_service.dart';
import 'add_edit_restaurant_page.dart';
import 'add_edit_menu_item_page.dart';

class RestaurantDetailsPage extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantDetailsPage({super.key, required this.restaurant});
  @override
  State<RestaurantDetailsPage> createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.name),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddEditRestaurantPage(restaurant: widget.restaurant),
              ),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'delete', child: Text('Delete Restaurant')),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Details'),
            Tab(text: 'Menu'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDetailsTab(),
          _buildMenuTab(),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.restaurant.imageUrl.isNotEmpty 
                  ? widget.restaurant.imageUrl 
                  : 'https://via.placeholder.com/400x200?text=No+Image',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.grey[300],
                child: const Icon(Icons.restaurant, size: 64, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: widget.restaurant.isOpen ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.restaurant.isOpen ? 'Open Now' : 'Closed',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  Text(' ${widget.restaurant.rating} Rating', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          _buildInfoCard('Description', widget.restaurant.description),
          
          // Basic Info
          _buildInfoCard('Cuisine Type', widget.restaurant.cuisineType),
          
          // Delivery Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Delivery Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text('${widget.restaurant.deliveryTime} minutes'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.delivery_dining, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text('\$${widget.restaurant.deliveryFee} delivery fee'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Contact Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Contact Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(child: Text(widget.restaurant.address)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(widget.restaurant.phoneNumber),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.email, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(widget.restaurant.ownerEmail),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTab() {
    return Column(
      children: [
        // Add Menu Item Button
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddEditMenuItemPage(restaurantId: widget.restaurant.id),
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Menu Item'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          ),
        ),
        
        // Category Filter
        StreamBuilder<List<String>>(
          stream: FirestoreService.getMenuCategories(widget.restaurant.id).asStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();
            final categories = ['All', ...snapshot.data!];
            return Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = category == _selectedCategory;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedCategory = category);
                      },
                      selectedColor: Colors.orange[100],
                      checkmarkColor: Colors.orange,
                    ),
                  );
                },
              ),
            );
          },
        ),

        // Menu Items
        Expanded(
          child: StreamBuilder<List<MenuItem>>(
            stream: FirestoreService.getMenuItems(widget.restaurant.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No menu items found', style: TextStyle(fontSize: 18, color: Colors.grey)),
                    ],
                  ),
                );
              }

              final menuItems = snapshot.data!.where((item) {
                if (_selectedCategory == 'All') return true;
                return item.category == _selectedCategory;
              }).toList();

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final menuItem = menuItems[index];
                  return _buildMenuItemCard(menuItem);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(content, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemCard(MenuItem menuItem) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            menuItem.imageUrl.isNotEmpty 
                ? menuItem.imageUrl 
                : 'https://via.placeholder.com/60x60?text=No+Image',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[300],
              child: const Icon(Icons.fastfood, color: Colors.grey),
            ),
          ),
        ),
        title: Text(menuItem.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(menuItem.description, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(menuItem.category, style: TextStyle(fontSize: 10, color: Colors.blue[800])),
                ),
                const SizedBox(width: 8),
                if (menuItem.isVegetarian) 
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('Veg', style: TextStyle(fontSize: 10, color: Colors.green[800])),
                  ),
                if (menuItem.isSpicy) 
                  Container(
                    margin: const EdgeInsets.only(left: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('Spicy', style: TextStyle(fontSize: 10, color: Colors.red[800])),
                  ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('\$${menuItem.price}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditMenuItemPage(
                        restaurantId: widget.restaurant.id,
                        menuItem: menuItem,
                      ),
                    ),
                  );
                } else if (value == 'delete') {
                  _showDeleteMenuItemDialog(menuItem);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Restaurant'),
        content: Text('Are you sure you want to delete "${widget.restaurant.name}"? This will also delete all menu items.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await FirestoreService.deleteRestaurant(widget.restaurant.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to restaurants list
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteMenuItemDialog(MenuItem menuItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Menu Item'),
        content: Text('Are you sure you want to delete "${menuItem.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await FirestoreService.deleteMenuItem(widget.restaurant.id, menuItem.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
