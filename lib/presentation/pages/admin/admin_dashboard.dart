import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsCards(),
            SizedBox(height: ResponsiveUtils.spacing(context)),
            _buildQuickActions(context),
            SizedBox(height: ResponsiveUtils.spacing(context)),
            _buildRecentBookings(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Total Bookings', '1,234', Icons.book, AppColors.primary)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('Revenue', '₹2.5L', Icons.currency_rupee, AppColors.success)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('Hotels', '45', Icons.hotel, AppColors.secondary)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showAddHotelDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Hotel'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.analytics),
                label: const Text('View Reports'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentBookings() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Bookings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text('Booking #BMG${1000 + index}'),
                  subtitle: Text('Hotel Paradise - ₹${2000 + (index * 500)}'),
                  trailing: Chip(
                    label: Text(index % 2 == 0 ? 'Confirmed' : 'Pending'),
                    backgroundColor: index % 2 == 0 
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.warning.withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddHotelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Hotel'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(labelText: 'Hotel Name')),
            SizedBox(height: 16),
            TextField(decoration: InputDecoration(labelText: 'Location')),
            SizedBox(height: 16),
            TextField(decoration: InputDecoration(labelText: 'Price per night')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add Hotel'),
          ),
        ],
      ),
    );
  }
}