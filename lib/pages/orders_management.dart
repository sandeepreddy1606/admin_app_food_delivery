import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/restaurant.dart';
import '../services/firestore_service.dart';

class OrdersManagement extends StatelessWidget {
  const OrdersManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F7FA),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 768;
          if (isMobile) {
            return _buildMobileLayout(context);
          } else {
            return _buildDesktopLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMobileHeader(context),
          const SizedBox(height: 16),
          _buildMobileStatsGrid(),
          const SizedBox(height: 16),
          _buildOrdersList(true),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildDesktopHeader(context),
          const SizedBox(height: 24),
          _buildDesktopStatsRow(),
          const SizedBox(height: 24),
          _buildOrdersList(false),
        ],
      ),
    );
  }

  Widget _buildMobileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  size: 24,
                  color: Colors.green[600],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Orders Management',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E3A47),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Track, manage, and analyze all customer orders in real-time',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 32,
              color: Colors.green[600],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Orders Management',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E3A47),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Track, manage, and analyze all customer orders in real-time',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileStatsGrid() {
    return StreamBuilder<List<FoodOrder>>(
      stream: FirestoreService.streamOrders(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = snapshot.data!;
        final totalOrders = orders.length;
        final pendingOrders = orders.where((o) => o.status == OrderStatus.pending).length;
        final completedOrders = orders.where((o) => o.status == OrderStatus.delivered).length;
        final cancelledOrders = orders.where((o) => o.status == OrderStatus.cancelled).length;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _buildMobileStatCard('Total Orders', '$totalOrders', Icons.receipt_long, Colors.blue),
            _buildMobileStatCard('Pending', '$pendingOrders', Icons.pending, Colors.orange),
            _buildMobileStatCard('Completed', '$completedOrders', Icons.check_circle, Colors.green),
            _buildMobileStatCard('Cancelled', '$cancelledOrders', Icons.cancel, Colors.red),
          ],
        );
      },
    );
  }

  Widget _buildDesktopStatsRow() {
    return StreamBuilder<List<FoodOrder>>(
      stream: FirestoreService.streamOrders(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = snapshot.data!;
        final totalOrders = orders.length;
        final pendingOrders = orders.where((o) => o.status == OrderStatus.pending).length;
        final completedOrders = orders.where((o) => o.status == OrderStatus.delivered).length;
        final cancelledOrders = orders.where((o) => o.status == OrderStatus.cancelled).length;

        return Row(
          children: [
            _buildDesktopStatCard('Total Orders', '$totalOrders', Icons.receipt_long, Colors.blue, 'All time'),
            const SizedBox(width: 16),
            _buildDesktopStatCard('Pending', '$pendingOrders', Icons.pending, Colors.orange, 'Active now'),
            const SizedBox(width: 16),
            _buildDesktopStatCard('Completed', '$completedOrders', Icons.check_circle, Colors.green, 'This month'),
            const SizedBox(width: 16),
            _buildDesktopStatCard('Cancelled', '$cancelledOrders', Icons.cancel, Colors.red, 'This month'),
          ],
        );
      },
    );
  }

  Widget _buildMobileStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E3A47),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopStatCard(String label, String value, IconData icon, Color color, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 9,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2E3A47),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(bool isMobile) {
    return StreamBuilder<List<FoodOrder>>(
      stream: FirestoreService.streamOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState();
        }

        final orders = snapshot.data!;

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
                    Text(
                      'Recent Orders',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: const Color(0xFF2E3A47),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${orders.length} total',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              for (int i = 0; i < (orders.length > 20 ? 20 : orders.length); i++)
                _buildOrderItem(orders[i], isMobile),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderItem(FoodOrder order, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.id.substring(0, 8)}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: isMobile ? 14 : 16,
                        color: const Color(0xFF2E3A47),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.restaurantName,
                      style: GoogleFonts.poppins(
                        fontSize: isMobile ? 12 : 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(order.status),
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: _getStatusColor(order.status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 14 : 16,
                  color: const Color(0xFF2E3A47),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${order.items.length} items',
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 12 : 14,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              DropdownButton<OrderStatus>(
                value: order.status,
                underline: Container(),
                items: OrderStatus.values.map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(
                    _getStatusText(status),
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                )).toList(),
                onChanged: (newStatus) {
                  if (newStatus != null) {
                    _updateOrderStatus(order, newStatus);
                  }
                },
              ),
            ],
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
            Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No orders found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Orders will appear here once customers start placing them',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.purple;
      case OrderStatus.ready:
        return Colors.teal;
      case OrderStatus.outForDelivery:
        return Colors.indigo;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  void _updateOrderStatus(FoodOrder order, OrderStatus newStatus) async {
    try {
      await FirestoreService.updateOrderStatus(order.id, newStatus);
      await FirestoreService.addActivity(
        'Order #${order.id.substring(0, 8)} status changed to ${_getStatusText(newStatus)}',
        'order_status_updated',
      );
    } catch (e) {
      debugPrint('Error updating order status: $e');
    }
  }
}