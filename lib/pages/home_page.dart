import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'restaurants_page.dart';
import 'orders_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardCard(
              context,
              'Restaurants',
              Icons.restaurant,
              Colors.orange,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RestaurantsPage()),
              ),
            ),
            _buildDashboardCard(
              context,
              'Orders',
              Icons.receipt_long,
              Colors.green,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrdersPage()),
              ),
            ),
            _buildDashboardCard(
              context,
              'Analytics',
              Icons.analytics,
              Colors.purple,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Analytics coming soon!')),
                );
              },
            ),
            _buildDashboardCard(
              context,
              'Settings',
              Icons.settings,
              Colors.grey,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
