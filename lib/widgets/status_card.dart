import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final String title;
  final bool isDetected; // Mengganti nama 'state' agar lebih jelas
  final IconData icon;
  final IconData? activeIcon; // Icon opsional saat state aktif/terdeteksi
  final String statusDetectedText;
  final String statusNotDetectedText;
  final Color detectedColor;
  final Color notDetectedColor;

  const StatusCard({
    super.key,
    required this.title,
    required this.isDetected,
    required this.icon,
    this.activeIcon,
    this.statusDetectedText = 'Detected',
    this.statusNotDetectedText = 'Not Detected',
    this.detectedColor = Colors.red,
    this.notDetectedColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    final currentIcon = isDetected ? (activeIcon ?? icon) : icon;
    final currentStatusText = isDetected
        ? statusDetectedText
        : statusNotDetectedText;
    final currentStatusColor = isDetected ? detectedColor : notDetectedColor;

    return SizedBox(
      width: 280, // Lebar bisa disesuaikan
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Padding lebih besar
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(currentIcon, size: 48, color: currentStatusColor),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Text(
                currentStatusText,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: currentStatusColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
