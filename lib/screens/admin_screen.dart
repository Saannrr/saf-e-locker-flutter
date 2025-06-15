import 'package:flutter/material.dart';
import 'package:saf_e_locker/widgets/stat_card.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Using a TabController for a simple, effective admin layout
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
              Tab(icon: Icon(Icons.people), text: 'Users'),
              Tab(icon: Icon(Icons.lock), text: 'Lockers'),
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
          ),
        ),
        body: const TabBarView(
          children: [
            // Dashboard Tab
            DashboardTab(),
            // Users Tab
            UsersTab(),
            // Lockers Tab
            LockersTab(),
          ],
        ),
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Overview', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            children: [
              StatCard(title: 'Total Users', value: '1,234', icon: Icons.people_alt, color: Colors.blue),
              StatCard(title: 'Active Lockers', value: '56', icon: Icons.lock_open, color: Colors.green),
              StatCard(title: 'Total Revenue', value: 'Rp 15.7M', icon: Icons.monetization_on, color: Colors.orange),
              StatCard(title: 'Issues Reported', value: '3', icon: Icons.report_problem, color: Colors.red),
            ],
          )
        ],
      ),
    );
  }
}

class UsersTab extends StatelessWidget {
  const UsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder list of users
    final users = List.generate(20, (index) => 'user${index + 1}@example.com');

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(users[index]),
          subtitle: const Text('Joined: 14 June 2025'),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        );
      },
    );
  }
}

class LockersTab extends StatelessWidget {
  const LockersTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder list of lockers
    return ListView.builder(
      itemCount: 50,
      itemBuilder: (context, index) {
        final bool isActive = index % 5 != 0;
        return ListTile(
          leading: Icon(
            Icons.lock_outline,
            color: isActive ? Colors.green : Colors.grey,
          ),
          title: Text('Locker #${index + 1}'),
          subtitle: Text(isActive ? 'Status: Active' : 'Status: Available'),
          trailing: Text(
            isActive ? 'In Use' : 'Free',
            style: TextStyle(color: isActive ? Colors.green : Colors.black54),
          ),
        );
      },
    );
  }
}