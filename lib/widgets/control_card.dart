import 'package:flutter/material.dart';

class ControlCard extends StatelessWidget {
  final String title;
  final bool state;
  final VoidCallback onToggle;
  final IconData icon;
  final IconData? activeIcon; // Icon opsional saat state aktif
  final Color? activeColor;
  final Color? inactiveColor;
  final String stateOnText;
  final String stateOffText;

  const ControlCard({
    super.key,
    required this.title,
    required this.state,
    required this.onToggle,
    required this.icon,
    this.activeIcon,
    this.activeColor,
    this.inactiveColor,
    this.stateOnText = 'ON',
    this.stateOffText = 'OFF',
  });

  @override
  Widget build(BuildContext context) {
    final currentIcon = state ? (activeIcon ?? icon) : icon;
    final currentIconColor = state
        ? (activeColor ?? Colors.yellow)
        : (inactiveColor ?? Colors.grey);
    final currentButtonColor = state
        ? (inactiveColor ?? Colors.red)
        : (activeColor ?? Colors.green);
    final currentButtonText = state
        ? "Turn ${stateOffText.toUpperCase()}"
        : "Turn ${stateOnText.toUpperCase()}";

    return SizedBox(
      width: 280, // Lebar bisa disesuaikan
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(currentIcon, size: 48, color: currentIconColor),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Text(
                state ? stateOnText : stateOffText,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: currentIconColor,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: onToggle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentButtonColor,
                  foregroundColor: Colors.white, // Warna teks tombol
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Text(currentButtonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
