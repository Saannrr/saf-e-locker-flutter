import 'package:flutter/material.dart';

// FIXED: Converted to a StatefulWidget to manage the hour count.
class LockerFoundSheet extends StatefulWidget {
  final VoidCallback onSelectPayment;
  const LockerFoundSheet({super.key, required this.onSelectPayment});

  @override
  State<LockerFoundSheet> createState() => _LockerFoundSheetState();
}

class _LockerFoundSheetState extends State<LockerFoundSheet> {
  int _hours = 1;
  final double _pricePerHour = 2500.0;

  void _addHour() {
    setState(() {
      _hours++;
    });
  }

  void _subtractHour() {
    if (_hours > 1) {
      setState(() {
        _hours--;
      });
    }
  }
  
  // Helper for currency formatting
  String _formatCurrency(double value) {
    // In a real app, use the intl package for robust formatting.
    // final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 2);
    // return format.format(value);
    return 'Rp ${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final double totalPrice = _hours * _pricePerHour;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'We found a\nlocker!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Next, choose how many hours\nfor your locker.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                // FIXED: Added interactive hour selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(Icons.remove, _subtractHour),
                    Text('$_hours', style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold)),
                    _buildControlButton(Icons.add, _addHour),
                  ],
                ),
                const SizedBox(height: 24),
                // FIXED: Aligned pricing to the right and made it dynamic
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                       Text('Price: ${_formatCurrency(_pricePerHour)}/Hour', style: const TextStyle(fontSize: 16)),
                       Text('Total: ${_formatCurrency(totalPrice)}', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: widget.onSelectPayment,
            child: const Text('Select payment method'),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black87),
        onPressed: onPressed,
      ),
    );
  }
}