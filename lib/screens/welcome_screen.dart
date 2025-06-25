// lib/screens/welcome_screen.dart

import 'package:flutter/material.dart';
import 'package:saf_e_locker/widgets/custom_draggable_sheet.dart';
import 'package:saf_e_locker/widgets/locker_controls_sheet.dart';
import 'package:saf_e_locker/widgets/locker_found_sheet.dart';
import 'package:saf_e_locker/widgets/no_locker_found_sheet.dart';
import 'package:saf_e_locker/widgets/qr_scan_sheet.dart';
import 'package:saf_e_locker/widgets/payment_success_sheet.dart';
import 'package:saf_e_locker/widgets/payment_method_sheet.dart';
import 'package:saf_e_locker/widgets/extend_time_sheet.dart';
import 'package:saf_e_locker/widgets/terminate_dialog.dart';
import 'dart:async';
import 'dart:math';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLockerActive = false;
  bool _isSearching = false;
  int _currentIndex = 0;
  // FIX: Add a Key to force a hard refresh of the UI state.
  Key _bodyKey = UniqueKey();

  // --- LOGIC METHODS ---
  void _findLocker() {
    setState(() => _isSearching = true);
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isSearching = false);
        final bool isLockerFound = Random().nextBool();
        if (isLockerFound) {
          _showLockerFoundSheet();
        } else {
          _showNoLockerFoundSheet();
        }
      }
    });
  }

  void _showDraggableSheet(Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomDraggableSheet(child: child),
    );
  }

  void _showLockerFoundSheet() {
    _showDraggableSheet(LockerFoundSheet(onSelectPayment: () {
      Navigator.pop(context);
      _showPaymentMethodSheet();
    }));
  }

  void _showPaymentMethodSheet() {
    _showDraggableSheet(PaymentMethodSheet(onPaymentSelected: () {
      Navigator.pop(context);
      _showQrScanSheet();
    }));
  }

  void _showNoLockerFoundSheet() {
    _showDraggableSheet(NoLockerFoundSheet(onTryAgain: () {
      Navigator.pop(context);
      _findLocker();
    }));
  }

  void _showQrScanSheet() {
    _showDraggableSheet(QrScanSheet(onSuccess: () {
      Navigator.pop(context);
      _showPaymentSuccessSheet();
    }));
  }

  void _showPaymentSuccessSheet() {
    _showDraggableSheet(PaymentSuccessSheet(onDone: () {
      Navigator.pop(context);
      setState(() => _isLockerActive = true);
    }));
  }

  void _showExtendTimeSheet() {
    _showDraggableSheet(const ExtendTimeSheet());
  }

  void _showTerminateDialog() async {
    final bool? didConfirm = await showDialog<bool>(
      context: context,
      builder: (_) => const TerminateDialog(),
    );
    if (didConfirm == true && mounted) {
      // FIX: Change the key to force the UI to rebuild from scratch.
      setState(() {
        _isLockerActive = false;
        _bodyKey = UniqueKey(); 
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Locker session terminated.')),
      );
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      setState(() { _currentIndex = index; });
    } else if (index == 1) {
      setState(() { _currentIndex = index; });
      Navigator.pushNamed(context, '/account').then((_) {
        setState(() { _currentIndex = 0; });
      });
    }
  }


  // --- UI BUILD METHODS ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            key: _bodyKey, // FIX: Apply the key here.
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24.0),
              Text(
                'Welcome, User',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                _isLockerActive
                  ? 'Remember your PIN if you can\'t use your\nphone to open the locker'
                  : 'You currently don\'t have any ongoing billing.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              
              Expanded(
                child: _isLockerActive
                    ? _buildActiveLockerCard()
                    : _buildFindLockerCard(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _isLockerActive ? null : FloatingActionButton(
        onPressed: _isSearching ? null : _findLocker,
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black,
        elevation: 2,
        shape: const CircleBorder(),
        child: _isSearching
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 3, color: Colors.black))
            : const Icon(Icons.add),
      ),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Widget _buildFindLockerCard() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.location_on_outlined, size: 80, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          const Text(
            "Press 'Rent' to find an available locker.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveLockerCard() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: const Text('2H 48M', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('PIN ****', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        Icon(Icons.visibility_off_outlined, size: 20),
                      ],
                    ),
                    const SizedBox(height: 8),
                    PopupMenuButton<String>(
                      onSelected: (String value) {
                        switch (value) {
                          case 'OPEN':
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Locker Opened!')));
                            break;
                          case 'EXTEND':
                            _showExtendTimeSheet();
                            break;
                          case 'TERMINATE':
                            _showTerminateDialog();
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(value: 'OPEN', child: Text('OPEN')),
                        const PopupMenuItem<String>(value: 'EXTEND', child: Text('EXTEND')),
                        const PopupMenuItem<String>(value: 'TERMINATE', child: Text('TERMINATE', style: TextStyle(color: Colors.red))),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Active', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            Icon(Icons.keyboard_arrow_down, size: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: const Color(0xFFF8F3FB),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildNavItem(
              icon: _currentIndex == 0 ? Icons.star : Icons.star_border,
              label: 'Home',
              isSelected: _currentIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: Text(
                _isLockerActive ? '' : 'Rent',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ),
            _buildNavItem(
              icon: _currentIndex == 1 ? Icons.person : Icons.person_outline,
              label: 'Account',
              isSelected: _currentIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final Color activeColor = Colors.deepPurple[800]!;
    final Color inactiveColor = Colors.grey[600]!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 80,
        height: 56,
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? activeColor : inactiveColor),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? activeColor : inactiveColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
