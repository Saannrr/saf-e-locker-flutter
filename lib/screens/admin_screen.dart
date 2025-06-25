// lib/screens/admin_screen.dart

import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const LockerManagementTab(),
    const UserManagementTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome, Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
          ),
        ],
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: 'Locker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'User',
          ),
        ],
      ),
    );
  }
}

// --- Locker Management Tab and Widgets ---

// Enum to represent locker status
enum LockerStatus { used, available, maintenance }

class LockerManagementTab extends StatelessWidget {
  const LockerManagementTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 10, // Placeholder
      itemBuilder: (context, index) {
        // Cycle through all three statuses for the demo
        LockerStatus status;
        if (index % 3 == 0) {
          status = LockerStatus.used;
        } else if (index % 3 == 1) {
          status = LockerStatus.available;
        } else {
          status = LockerStatus.maintenance;
        }
        
        return _LockerAdminCard(
          id: 'LKR${(index + 1).toString().padLeft(2, '0')}',
          tariff: 'Rp 5.000,00/hr',
          lidStatus: status == LockerStatus.used ? 'Closed' : 'Open',
          status: status,
        );
      },
    );
  }
}

class _LockerAdminCard extends StatelessWidget {
  final String id;
  final String tariff;
  final String lidStatus;
  final LockerStatus status;

  const _LockerAdminCard({
    required this.id,
    required this.tariff,
    required this.lidStatus,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    bool isMaintenance = status == LockerStatus.maintenance;

    return Card(
      color: const Color(0xFFF3E5F5).withOpacity(0.5),
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildInfoColumn('ID', id)),
                Expanded(child: _buildInfoColumn('Tariff', tariff)),
                Expanded(child: _buildInfoColumn('Lid', lidStatus)),
              ],
            ),
            const Divider(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column
                Expanded(
                flex: 2,
                child: Column(
                  children: [
                    // 1. ADDED: Top margin of 10
                    const SizedBox(height: 10),
                    SizedBox(
                      // 2. MODIFIED: Height changed to 68 as requested
                      height: 68,
                      child: _buildStatusChip(status),
                    ),
                    const SizedBox(height: 8),
                    _buildActionButton(
                      'Reset PIN',
                      isMaintenance ? null : () => _showResetPinDialog(context)
                    ),
                    // 3. ADDED: Bottom margin of 10
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(width: 16),
                // Right Column
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildActionButton('Set Price', isMaintenance ? null : () => _showSetPriceDialog(context)),
                      const SizedBox(height: 8),
                      _buildActionButton('Disable/Enable', () => _showDisableLockerDialog(context)),
                      const SizedBox(height: 8),
                      _buildActionButton('Open', isMaintenance ? null : () {}),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      ],
    );
  }

  Widget _buildStatusChip(LockerStatus status) {
    String text;
    Color bgColor;
    Color textColor;

    switch (status) {
      case LockerStatus.used:
        text = 'USED';
        bgColor = const Color(0xFFFDE4A4);
        textColor = const Color(0xFF795548);
        break;
      case LockerStatus.available:
        text = 'AVAILABLE';
        bgColor = const Color(0xFFC8E6C9);
        textColor = Colors.green.shade900;
        break;
      case LockerStatus.maintenance:
        text = 'MAINTENANCE';
        bgColor = const Color(0xFFFFCDD2);
        textColor = Colors.red.shade900;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback? onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          disabledBackgroundColor: Colors.grey[300],
          elevation: 2,
          shadowColor: Colors.grey.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 4) // Add padding to prevent overflow
        ),
        child: FittedBox( // Wrap with FittedBox to scale text
          fit: BoxFit.scaleDown,
          child: Text(text, style: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}


// --- User Management Tab and Widgets ---

class UserManagementTab extends StatelessWidget {
  const UserManagementTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20, // Placeholder
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text('User ${index + 1}'),
          subtitle: Text('user${index+1}@example.com'),
          onTap: () => _showUserDetailDialog(context, 'uid${index+1}', 'User ${index + 1}', 'user${index+1}@example.com'),
        );
      },
    );
  }
}

// --- Admin Dialog Helper Functions ---

void _showResetPinDialog(BuildContext context) {
  const textStyle = TextStyle(color: Colors.black);
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('PIN has been reset', style: textStyle),
      content: const Text('We will now inform the User about this change.', style: textStyle),
      actions: [
        TextButton(
          child: const Text('Confirm'),
          onPressed: () => Navigator.of(ctx).pop(),
        ),
      ],
    ),
  );
}

void _showSetPriceDialog(BuildContext context) {
  const textStyle = TextStyle(color: Colors.black);
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Set Price for the locker', style: textStyle),
      content: const TextField(
        decoration: InputDecoration(
          prefixText: 'Rp ',
          suffixText: '/hr',
          labelText: 'Price',
        ),
        keyboardType: TextInputType.number,
      ),
      actions: [
        TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(ctx).pop()),
        ElevatedButton(child: const Text('Confirm'), onPressed: () => Navigator.of(ctx).pop()),
      ],
    ),
  );
}

void _showDisableLockerDialog(BuildContext context) {
  const textStyle = TextStyle(color: Colors.black);
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Locker has been disabled', style: textStyle),
      content: const Text('Locker status will be under maintenance.', style: textStyle),
      actions: [
        TextButton(
          child: const Text('Confirm'),
          onPressed: () => Navigator.of(ctx).pop(),
        ),
      ],
    ),
  );
}

void _showUserDetailDialog(BuildContext context, String uid, String username, String email) {
   const textStyle = TextStyle(color: Colors.black);
   showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(username, style: textStyle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('UID: $uid', style: textStyle),
          const SizedBox(height: 8),
          Text('Email: $email', style: textStyle),
        ],
      ),
      actions: [
        TextButton(child: const Text('Close'), onPressed: () => Navigator.of(ctx).pop()),
        ElevatedButton(
          child: const Text('Reset Password'), 
          onPressed: () {
             Navigator.of(ctx).pop(); // Close detail dialog
             _showResetPinDialog(context); // Show confirmation
          }
        ),
      ],
    ),
  );
}