import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/firestore_service.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderId;
  const OrderDetailsPage({super.key, required this.orderId});
  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FoodOrder?>(
      future: FirestoreService.getOrder(widget.orderId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: Text('Order not found')));
        }

        final order = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text('Order #${order.id.substring(0, 8)}'),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            actions: [
              PopupMenuButton<OrderStatus>(
                onSelected: (status) async {
                  await FirestoreService.updateOrderStatus(order.id, status);
                  setState(() {});
                },
                itemBuilder: (context) => OrderStatus.values
                    .map((status) => PopupMenuItem(
                          value: status,
                          child: Text(status.displayName),
                        ))
                    .toList(),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Status
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(order.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            order.status.displayName,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Customer Info
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Customer Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(order.customerName),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.phone, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(order.customerPhone),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(child: Text(order.deliveryAddress)),
                          ],
                        ),
                        if (order.notes?.isNotEmpty == true) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.note, color: Colors.grey),
                              const SizedBox(width: 8),
                              Expanded(child: Text(order.notes!)),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Restaurant Info
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Restaurant', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.restaurant, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(order.restaurantName),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Order Items
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Order Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ...order.items.map((item) => _buildOrderItem(item)),
                      ],
                    ),
                  ),
                ),

                // Order Summary
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal:'),
                            Text('\$${order.subtotal.toStringAsFixed(2)}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Delivery Fee:'),
                            Text('\$${order.deliveryFee.toStringAsFixed(2)}'),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('\$${order.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        if (order.paymentMethod != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Payment Method:'),
                              Text(order.paymentMethod!),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Order Timeline
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Order Timeline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.schedule, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text('Ordered: ${_formatDateTime(order.createdAt)}'),
                          ],
                        ),
                        if (order.estimatedDeliveryTime != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.delivery_dining, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text('Estimated Delivery: ${_formatDateTime(order.estimatedDeliveryTime!)}'),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('${item.quantity}x', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name),
                if (item.specialInstructions?.isNotEmpty == true)
                  Text('Note: ${item.specialInstructions}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          Text('\$${item.totalPrice.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.preparing:
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
