<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'login_page.dart';
import 'dashboard_page.dart';
import 'restaurant_management.dart';
import 'menu_management.dart';
import 'orders_management.dart';
import 'analytics_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    const DashboardPage(),
    const RestaurantManagement(),
    const MenuManagement(),
    const OrdersManagement(),
    const AnalyticsPage(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    NavigationItem(icon: Icons.restaurant_rounded, label: 'Restaurants'),
    NavigationItem(icon: Icons.menu_book_rounded, label: 'Menus'),
    NavigationItem(icon: Icons.receipt_long_rounded, label: 'Orders'),
    NavigationItem(icon: Icons.analytics_rounded, label: 'Analytics'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        
        if (isMobile) {
          return _buildMobileLayout();
        } else {
          return _buildDesktopLayout();
        }
      },
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_navigationItems[_currentIndex].label),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => _showProfileDialog(),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex > 3 ? 0 : _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4A90E2),
        unselectedItemColor: Colors.grey,
        items: _navigationItems.take(4).map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      key: _scaffoldKey,
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _pages,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90E2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.restaurant, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'Foodie Admin',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E3A47),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _navigationItems.length,
              itemBuilder: (context, index) {
                final item = _navigationItems[index];
                final isSelected = _currentIndex == index;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(
                      item.icon,
                      color: isSelected ? const Color(0xFF4A90E2) : Colors.grey[600],
                    ),
                    title: Text(
                      item.label,
                      style: GoogleFonts.poppins(
                        color: isSelected ? const Color(0xFF4A90E2) : Colors.grey[700],
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: const Color(0xFF4A90E2).withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    onTap: () => setState(() => _currentIndex = index),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text('Sign Out', style: GoogleFonts.poppins(color: Colors.red)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              onTap: _handleSignOut,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            _navigationItems[_currentIndex].label,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E3A47),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => _showProfileDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF4A90E2)),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.restaurant, color: Color(0xFF4A90E2), size: 28),
                ),
                const SizedBox(width: 16),
                Text(
                  'Foodie Admin',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _navigationItems.length,
              itemBuilder: (context, index) {
                final item = _navigationItems[index];
                final isSelected = _currentIndex == index;
                
                return ListTile(
                  leading: Icon(
                    item.icon,
                    color: isSelected ? const Color(0xFF4A90E2) : Colors.grey[600],
                  ),
                  title: Text(
                    item.label,
                    style: GoogleFonts.poppins(
                      color: isSelected ? const Color(0xFF4A90E2) : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  onTap: () {
                    setState(() => _currentIndex = index);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text('Sign Out', style: GoogleFonts.poppins(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _handleSignOut();
            },
          ),
        ],
      ),
    );
  }

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Profile', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: FutureBuilder<Map<String, dynamic>?>(
          future: AuthService.getCurrentUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            final profile = snapshot.data;
            final user = AuthService.currentUser;
            
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFF4A90E2),
                  child: Text(
                    (profile?['name'] ?? user?.displayName ?? 'A')[0].toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  profile?['name'] ?? user?.displayName ?? 'Admin User',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  user?.email ?? 'No email',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    profile?['role'] ?? 'admin',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleSignOut();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Sign Out', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _handleSignOut() async {
    try {
      await AuthService.signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing out: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class NavigationItem {
  final IconData icon;
  final String label;

  NavigationItem({required this.icon, required this.label});
}
=======
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'login_page.dart';
import 'dashboard_page.dart';
import 'restaurant_management.dart';
import 'menu_management.dart';
import 'orders_management.dart';
import 'analytics_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    const DashboardPage(),
    const RestaurantManagement(),
    const MenuManagement(),
    const OrdersManagement(),
    const AnalyticsPage(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    NavigationItem(icon: Icons.restaurant_rounded, label: 'Restaurants'),
    NavigationItem(icon: Icons.menu_book_rounded, label: 'Menus'),
    NavigationItem(icon: Icons.receipt_long_rounded, label: 'Orders'),
    NavigationItem(icon: Icons.analytics_rounded, label: 'Analytics'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        
        if (isMobile) {
          return _buildMobileLayout();
        } else {
          return _buildDesktopLayout();
        }
      },
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_navigationItems[_currentIndex].label),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => _showProfileDialog(),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex > 3 ? 0 : _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4A90E2),
        unselectedItemColor: Colors.grey,
        items: _navigationItems.take(4).map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      key: _scaffoldKey,
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _pages,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90E2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.restaurant, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'Foodie Admin',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E3A47),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _navigationItems.length,
              itemBuilder: (context, index) {
                final item = _navigationItems[index];
                final isSelected = _currentIndex == index;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(
                      item.icon,
                      color: isSelected ? const Color(0xFF4A90E2) : Colors.grey[600],
                    ),
                    title: Text(
                      item.label,
                      style: GoogleFonts.poppins(
                        color: isSelected ? const Color(0xFF4A90E2) : Colors.grey[700],
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: const Color(0xFF4A90E2).withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    onTap: () => setState(() => _currentIndex = index),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text('Sign Out', style: GoogleFonts.poppins(color: Colors.red)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              onTap: _handleSignOut,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            _navigationItems[_currentIndex].label,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E3A47),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => _showProfileDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF4A90E2)),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.restaurant, color: Color(0xFF4A90E2), size: 28),
                ),
                const SizedBox(width: 16),
                Text(
                  'Foodie Admin',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _navigationItems.length,
              itemBuilder: (context, index) {
                final item = _navigationItems[index];
                final isSelected = _currentIndex == index;
                
                return ListTile(
                  leading: Icon(
                    item.icon,
                    color: isSelected ? const Color(0xFF4A90E2) : Colors.grey[600],
                  ),
                  title: Text(
                    item.label,
                    style: GoogleFonts.poppins(
                      color: isSelected ? const Color(0xFF4A90E2) : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  onTap: () {
                    setState(() => _currentIndex = index);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text('Sign Out', style: GoogleFonts.poppins(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _handleSignOut();
            },
          ),
        ],
      ),
    );
  }

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Profile', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: FutureBuilder<Map<String, dynamic>?>(
          future: AuthService.getCurrentUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            final profile = snapshot.data;
            final user = AuthService.currentUser;
            
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFF4A90E2),
                  child: Text(
                    (profile?['name'] ?? user?.displayName ?? 'A')[0].toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  profile?['name'] ?? user?.displayName ?? 'Admin User',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  user?.email ?? 'No email',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    profile?['role'] ?? 'admin',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleSignOut();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Sign Out', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _handleSignOut() async {
    try {
      await AuthService.signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing out: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class NavigationItem {
  final IconData icon;
  final String label;

  NavigationItem({required this.icon, required this.label});
}
>>>>>>> a330a6beaf92aaae151a5a3470617d41e51bbcdf
