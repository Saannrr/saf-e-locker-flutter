import 'package:flutter/material.dart';
import 'package:saf_e_locker/widgets/custom_draggable_sheet.dart';
import 'package:saf_e_locker/widgets/locker_controls_sheet.dart';
import 'package:saf_e_locker/widgets/locker_found_sheet.dart';
import 'package:saf_e_locker/widgets/no_locker_found_sheet.dart';
import 'package:saf_e_locker/widgets/qr_scan_sheet.dart';
import 'package:saf_e_locker/widgets/payment_success_sheet.dart';
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
  int _currentIndex = 0; // To track bottom nav bar selection

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

  void _showLockerControls() {
    _showDraggableSheet(const LockerControlsSheet());
  }

  void _showLockerFoundSheet() {
    _showDraggableSheet(LockerFoundSheet(onSelectPayment: () {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, User',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                _isLockerActive
                    ? 'Your locker is ready.'
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
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildFindLockerCard() {
    return Column(
      children: [
        Expanded(
          child: Center(
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
                  child: const Icon(Icons.location_on_outlined, size: 80, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                const Text("You will find a booking something like this."),
              ],
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),
            onPressed: _isSearching ? null : _findLocker,
            child: _isSearching
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                  )
                : const Text('Rent'),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveLockerCard() {
    return GestureDetector(
      onTap: _showLockerControls,
      child: Card(
        color: Colors.grey[100],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('PIN ****', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Locker number 07', style: TextStyle(fontSize: 16, color: Colors.grey)),
              const Spacer(),
              Row(
                children: [
                  const Text('2H 48M', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Active', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Account',
        ),
      ],
      currentIndex: _currentIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}