import 'package:flutter/material.dart';
import '../widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        shape: const Border(
          bottom: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _buildFilterTab('All'),
                  const SizedBox(width: 8),
                  _buildFilterTab('Today'),
                  const SizedBox(width: 8),
                  _buildFilterTab('This Week'),
                  const SizedBox(width: 8),
                  _buildFilterTab('Harassment'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: const [
                  NotificationCard(
                    title: 'Harassment Detected',
                    description:
                        'Employee #23 involved in harassment at Counter Zone',
                    time: '10:45 AM',
                    zone: 'Zone: Kitchen',
                    icon: Icons.warning,
                    borderColor: Color(0xFFEF4444),
                    iconBackgroundColor: Color(0xFFFEE2E2),
                    iconColor: Color(0xFFEF4444),
                  ),
                  NotificationCard(
                    title: 'Extended Phone Usage',
                    description:
                        'Employee #45 using phone for over 15 minutes',
                    time: '9:30 AM',
                    zone: 'Zone: Front Desk',
                    iconPath: 'assets/phone.svg',
                    borderColor: Color(0xFFF59E0B),
                    iconBackgroundColor: Color(0xFFFEF3C7),
                    iconColor: Color(0xFFF59E0B),
                  ),
                  NotificationCard(
                    title: 'Zone Absence',
                    description:
                        'Employee #12 absent from assigned zone for 10 minutes',
                    time: 'Yesterday',
                    zone: 'Zone: Service Area',
                    iconPath: 'assets/away.svg',
                    borderColor: Color(0xFF23989f),
                    iconBackgroundColor: Color(0xFFDBEAFE),
                    iconColor: Color(0xFF23989f),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String text) {
    final isSelected = _selectedFilter == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDBEAFE) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? const Color(0xFF007B83) : const Color(0xFF4B5563),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
} 