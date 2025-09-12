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
  bool _isDebugging = false;

  @override
  void initState() {
    super.initState();
    // Debug the orders collection on page load
    _debugOrders();
  }

  Future<void> _debugOrders() async {
    setState(() => _isDebugging = true);
    await FirestoreService.debugOrdersCollection();
    if (mounted) setState(() => _isDebugging = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: _debugOrders,
            tooltip: 'Debug Orders',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Debug indicator
          if (_isDebugging)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.orange[100],
              child: const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Debugging orders collection...'),
                ],
              ),
            ),
          
          // Filter by status
          Container(
            height: 60,
            padding: const EdgeInsets.all(8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildStatusFilter('All', null),
                ...OrderStatus.values.map((status) => 
                    _buildStatusFilter(status.displayName, status)),
              ],
            ),
          ),
          
          // Orders list
          Expanded(
            child: StreamBuilder<List<FoodOrder>>(
              stream: FirestoreService.getOrders(),
              builder: (context, snapshot) {
                // Loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading orders...'),
                      ],
                    ),
                  );
                }
                
                // Error state
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text('Error loading orders', 
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('${snapshot.error}', textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => setState(() {}),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed: _debugOrders,
                              icon: const Icon(Icons.bug_report),
                              label: const Text('Debug'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                
                // No data state
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text('No orders found', 
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                        const SizedBox(height: 8),
                        const Text('Orders from your customer app will appear here', 
                            style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => setState(() {}),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Refresh'),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed: _debugOrders,
                              icon: const Icon(Icons.bug_report),
                              label: const Text('Debug'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }

                // Filter orders by selected status
                final orders = snapshot.data!.where((order) {
                  if (_selectedStatus == null) return true;
                  return order.status == _selectedStatus;
                }).toList();

                // Show orders list
                return Column(
                  children: [
                    // Orders count info
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: Colors.green[50],
                      child: Row(
                        children: [
                          Icon(Icons.info, color: Colors.green[700], size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Found ${orders.length} order${orders.length != 1 ? 's' : ''}${_selectedStatus != null ? ' (${_selectedStatus!.displayName})' : ''}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              color: Colors.green[700]
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Orders list
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return _buildOrderCard(order);
                        },
                      ),
                    ),
                  ],
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
    IconData statusIcon = Icons.schedule;
    
    switch (order.status) {
      case OrderStatus.delivered:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case OrderStatus.cancelled:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case OrderStatus.preparing:
        statusColor = Colors.blue;
        statusIcon = Icons.restaurant;
        break;
      case OrderStatus.outForDelivery:
        statusColor = Colors.purple;
        statusIcon = Icons.delivery_dining;
        break;
      case OrderStatus.ready:
        statusColor = Colors.amber;
        statusIcon = Icons.done;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OrderDetailsPage(orderId: order.id)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(statusIcon, color: statusColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.id.substring(0, 8).toUpperCase()}', 
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          order.restaurantName,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order.status.displayName,
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Customer and order details
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(order.customerName),
                  const SizedBox(width: 16),
                  Icon(Icons.shopping_bag, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text('${order.totalItems} item${order.totalItems != 1 ? 's' : ''}'),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Date and total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year} ${order.createdAt.hour}:${order.createdAt.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  Text(
                    '\$${order.total.toStringAsFixed(2)}', 
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
