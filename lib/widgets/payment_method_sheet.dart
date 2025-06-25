// lib/widgets/payment_method_sheet.dart (NEW FILE)

import 'package:flutter/material.dart';

class PaymentMethodSheet extends StatelessWidget {
  final VoidCallback onPaymentSelected;
  const PaymentMethodSheet({super.key, required this.onPaymentSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          _buildPaymentOption('Gopay', () => onPaymentSelected()),
          _buildPaymentOption('Shopeepay', () => onPaymentSelected()),
          _buildPaymentOption('Dana', () => onPaymentSelected()),
          _buildPaymentOption('Bank', () => onPaymentSelected()),
          _buildPaymentOption('QRIS', () => onPaymentSelected()),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right),
    );
  }
}