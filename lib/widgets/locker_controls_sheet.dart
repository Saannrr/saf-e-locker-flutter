
import 'package:flutter/material.dart';
import 'package:saf_e_locker/widgets/extend_time_sheet.dart';
import 'package:saf_e_locker/widgets/terminate_dialog.dart';
import 'package:saf_e_locker/widgets/custom_draggable_sheet.dart';

class LockerControlsSheet extends StatelessWidget {
  const LockerControlsSheet({Key? key}) : super(key: key);

  void _showExtendTimeSheet(BuildContext context) {
    Navigator.pop(context); 
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CustomDraggableSheet(child: ExtendTimeSheet()),
    );
  }

  void _showTerminateDialog(BuildContext context) {
    Navigator.pop(context); 
    showDialog(
      context: context,
      builder: (_) => const TerminateDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('PIN ****', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          _buildOption(context, 'OPEN', () { Navigator.pop(context); }),
          const Divider(),
          _buildOption(context, 'EXTEND', () => _showExtendTimeSheet(context)),
          const Divider(),
          _buildOption(context, 'TERMINATE', () => _showTerminateDialog(context), isDestructive: true),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDestructive ? Colors.red : Colors.black,
          ),
        ),
      ),
    );
  }
}