// lib/widgets/terminate_dialog.dart

import 'package:flutter/material.dart';

class TerminateDialog extends StatelessWidget {
  const TerminateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Terminate?', style: TextStyle(fontWeight: FontWeight.bold)),
      content: const Text('By terminating, your locker will be opened and the rest of your duration will be gone forever.'),
      actions: [
        TextButton(
          onPressed: () {
            // Send 'false' back when Cancel is tapped
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () {
            // Send 'true' back when Confirm is tapped
            Navigator.of(context).pop(true);
          },
          child: const Text('Confirm', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}