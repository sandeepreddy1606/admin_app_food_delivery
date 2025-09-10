import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/firestore_service.dart';
import 'order_details_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  OrderStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filter by status
          Container(
            height: 60,
            padding: const EdgeInsets.all(8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildStatusFilter('All', null),
                ...OrderStatus.values.map((status) => _buildStatusFilter(status.displayName, status)),
              ],
            ),
          ),
          // Orders list
          Expanded(
            child: StreamBuilder<List<FoodOrder>>(
              stream: FirestoreService.getOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No orders found', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ],
                    ),
                  );
                }

                final orders = snapshot.data!.where((order) {
                  if (_selectedStatus == null) return true;
                  return order.status == _selectedStatus;
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _buildOrderCard(order);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter(String label, OrderStatus? status) {
    final isSelected = _selectedStatus == status;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedStatus = selected ? status : null);
        },
        selectedColor: Colors.green[100],
        checkmarkColor: Colors.green,
      ),
    );
  }

  Widget _buildOrderCard(FoodOrder order) {
    Color statusColor = Colors.orange;
    switch (order.status) {
      case OrderStatus.delivered:
        statusColor = Colors.green;
        break;
      case OrderStatus.cancelled:
        statusColor = Colors.red;
        break;
      case OrderStatus.preparing:
        statusColor = Colors.blue;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OrderDetailsPage(orderId: order.id)),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.receipt_long, color: statusColor),
        ),
        title: Text('Order #${order.id.substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order.restaurantName),
            Text('${order.customerName} • ${order.totalItems} items'),
            Text('${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('\$${order.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                order.status.displayName,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
