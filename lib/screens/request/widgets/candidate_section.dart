import 'package:flutter/material.dart';
import '../../request/widgets/candidate_picker.dart';

class CandidateSection extends StatelessWidget {
  final List<Map<String, dynamic>> candidates;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final VoidCallback onConfirm;
  const CandidateSection({
    super.key,
    required this.candidates,
    required this.selectedIndex,
    required this.onChanged,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: CandidatePicker(
        candidates: candidates,
        selectedIndex: selectedIndex,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onAddPhotos: () {},
      ),
    );
  }
}
