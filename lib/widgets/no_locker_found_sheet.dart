
import 'package:flutter/material.dart';

class NoLockerFoundSheet extends StatelessWidget {
  final VoidCallback onTryAgain;
  const NoLockerFoundSheet({super.key, required this.onTryAgain});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Oops!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Icon(
            Icons.close_rounded,
            color: Colors.red[400],
            size: 100,
          ),
          const SizedBox(height: 24),
          const Text(
            "We couldn't find locker\nnearby",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onTryAgain,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}