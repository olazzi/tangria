import 'package:flutter/material.dart';
import '../../../widgets/primary_button.dart';

class ActionBar extends StatelessWidget {
  final bool sending;
  final VoidCallback onAddPhotos, onCamera, onEstimate, onClear;
  const ActionBar({super.key, required this.sending, required this.onAddPhotos, required this.onCamera, required this.onEstimate, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: PrimaryButton(label: 'Add Photos', onPressed: onAddPhotos)),
        const SizedBox(width: 12),
        Expanded(child: PrimaryButton(label: 'Camera', onPressed: onCamera)),
        const SizedBox(width: 12),
        Expanded(child: PrimaryButton(label: 'Get Estimate', onPressed: sending ? null : onEstimate)),
        const SizedBox(width: 12),
        Expanded(child: PrimaryButton(label: 'Clear Item', onPressed: sending ? null : onClear)),
      ],
    );
  }
}
