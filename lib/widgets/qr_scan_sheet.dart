// lib/widgets/qr_scan_sheet.dart

import 'dart:async';
import 'package:flutter/material.dart';

class QrScanSheet extends StatefulWidget {
  final VoidCallback onSuccess;
  const QrScanSheet({super.key, required this.onSuccess});

  @override
  State<QrScanSheet> createState() => _QrScanSheetState();
}

class _QrScanSheetState extends State<QrScanSheet> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        widget.onSuccess();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Scan the QR\ncode to pay',
            textAlign: TextAlign.center,
            // FIX: Applying a style from the theme that we know is black.
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: Icon(Icons.qr_code_scanner, size: 150, color: Colors.black54),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            '00:00',
            // FIX: Applying another style from the theme.
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}