// lib/screens/account_screen.dart (NEW FILE)

import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildListTile(
            context,
            title: 'Account Information',
            onTap: () => Navigator.pushNamed(context, '/account-info'),
          ),
          _buildListTile(
            context,
            title: 'Transaction History',
            onTap: () => Navigator.pushNamed(context, '/transaction-history'),
          ),
          const Divider(),
          _buildListTile(
            context,
            title: 'Logout',
            textColor: Colors.red,
            onTap: () {
              // Handle logout logic and navigate back to login screen
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, {required String title, required VoidCallback onTap, Color? textColor}) {
    return ListTile(
      title: Text(title, style: TextStyle(color: textColor ?? Colors.black)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}