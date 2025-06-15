import 'package:flutter/material.dart';

// FIXED: Converted to a StatefulWidget to manage the hour count.
class ExtendTimeSheet extends StatefulWidget {
  const ExtendTimeSheet({super.key});

  @override
  State<ExtendTimeSheet> createState() => _ExtendTimeSheetState();
}

class _ExtendTimeSheetState extends State<ExtendTimeSheet> {
  int _hours = 1;
  final double _pricePerHour = 2500.0;
  final double _penaltyMultiplier = 1.7;

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

  String _formatCurrency(double value) {
    return 'Rp ${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final double totalPenaltyPrice = _hours * _pricePerHour * _penaltyMultiplier;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Extend your time',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Set the new extra hours for your locker.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(Icons.remove, _subtractHour),
                    Text('$_hours', style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold)),
                    _buildControlButton(Icons.add, _addHour),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // FIXED: Pricing is now dynamic
          Text(
            'Penalty Since: ${_penaltyMultiplier}x\nPrice ${_formatCurrency(_pricePerHour)}/Hour\nTotal: ${_formatCurrency(totalPenaltyPrice)}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
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