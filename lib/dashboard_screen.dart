import 'package:flutter/material.dart';
import 'package:wellness/auth_service.dart';
import 'package:wellness/change_password_screen.dart';
import 'package:wellness/add_category_screen.dart';
import 'package:wellness/add_quote.dart';
import 'package:wellness/add_health_tips_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required dashboardViewModel});

  Future<void> _logout(BuildContext context) async {
    final AuthService _authService = AuthService(); // Local instantiation
    await _authService.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully.')),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onAddNew,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 30, color: Colors.blueAccent),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            if (onAddNew != null)
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.blueAccent, size: 30),
                    onPressed: onAddNew,
                    tooltip: 'Add New',
                  ),
                  const Text('Add New', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.vpn_key_sharp, color: Colors.white),
            tooltip: 'Change Password',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ChangePasswordScreen(),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDashboardCard(
              icon: Icons.people,
              title: 'Total Users',
              value: '1488888',
            ),
            _buildDashboardCard(
              icon: Icons.category,
              title: 'Total Category',
              value: '100',
              onAddNew: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddCategoryScreen(),
                ));
              },
            ),
            _buildDashboardCard(
              icon: Icons.format_quote,
              title: 'Total Quotes',
              value: '200',
              onAddNew: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddQuoteScreen(),
                ));
              },
            ),
            _buildDashboardCard(
              icon: Icons.health_and_safety,
              title: 'Total Health Tips',
              value: '50',
              onAddNew: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddHealthTipsScreen(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
