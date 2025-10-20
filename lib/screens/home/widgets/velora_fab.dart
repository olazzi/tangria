import 'package:flutter/material.dart';

class VeloraFab extends StatelessWidget {
  final bool isSending;
  final int? pendingDetailId;
  final VoidCallback onOpenSheet;
  final Future<void> Function(int id) onOpenDetail;

  const VeloraFab({
    super.key,
    required this.isSending,
    required this.pendingDetailId,
    required this.onOpenSheet,
    required this.onOpenDetail,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'velora-main-fab',
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 6,
      tooltip: pendingDetailId != null ? 'View details' : (isSending ? 'Estimating…' : 'Open gallery sheet'),
      onPressed: () async {
        if (pendingDetailId != null) {
          await onOpenDetail(pendingDetailId!);
          return;
        }
        onOpenSheet();
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: pendingDetailId != null
            ? const Icon(key: ValueKey('fab-view'), Icons.visibility_outlined)
            : (isSending
                ? const SizedBox(
                    key: ValueKey('fab-loading'),
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(key: ValueKey('fab-icon'), Icons.collections)),
      ),
    );
  }
}
