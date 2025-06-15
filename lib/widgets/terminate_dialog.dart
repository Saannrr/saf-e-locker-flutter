import 'package:flutter/material.dart';

class TerminateDialog extends StatelessWidget {
  const TerminateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Terminate?', style: TextStyle(fontWeight: FontWeight.bold)),
      content: const Text('By terminating, your locker will be opened and the rest of your duration will be gone forever.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () {
            // In a real app, handle termination logic here.
            Navigator.of(context).pop();
          },
          child: const Text('Confirm', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
