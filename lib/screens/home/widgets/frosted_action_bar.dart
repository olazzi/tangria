import 'package:flutter/material.dart';

class FrostedActionBar extends StatelessWidget {
  final bool sending;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onEstimate;
  final VoidCallback onClear;

  const FrostedActionBar({
    super.key,
    required this.sending,
    required this.onCamera,
    required this.onGallery,
    required this.onEstimate,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Daha erken 2 satıra geç → yazılar görünür kalsın
        final twoRows = constraints.maxWidth < 520;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(12, twoRows ? 8 : 10, 12, 12),
          decoration: BoxDecoration(
            color: cs.surface,
            border: Border(top: BorderSide(color: cs.outlineVariant)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: twoRows
              ? _TwoRowLayout(
                  sending: sending,
                  onCamera: onCamera,
                  onGallery: onGallery,
                  onEstimate: onEstimate,
                  onClear: onClear,
                )
              : _OneRowLayout(
                  sending: sending,
                  onCamera: onCamera,
                  onGallery: onGallery,
                  onEstimate: onEstimate,
                  onClear: onClear,
                ),
        );
      },
    );
  }
}

class _OneRowLayout extends StatelessWidget {
  final bool sending;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onEstimate;
  final VoidCallback onClear;

  const _OneRowLayout({
    required this.sending,
    required this.onCamera,
    required this.onGallery,
    required this.onEstimate,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _SolidButton(icon: Icons.photo_camera_outlined, label: 'Camera', onTap: sending ? null : onCamera, busy: false)),
        const SizedBox(width: 8),
        Expanded(child: _OutlineButton(icon: Icons.photo_library_outlined, label: 'Gallery', onTap: sending ? null : onGallery)),
        const SizedBox(width: 8),
        Expanded(child: _SolidButton(icon: Icons.price_change, label: sending ? 'Estimating' : 'Estimate', onTap: sending ? null : onEstimate, busy: sending)),
        const SizedBox(width: 8),
        Expanded(child: _OutlineButton(icon: Icons.delete_sweep_outlined, label: 'Clear', onTap: sending ? null : onClear)),
      ],
    );
  }
}

class _TwoRowLayout extends StatelessWidget {
  final bool sending;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onEstimate;
  final VoidCallback onClear;

  const _TwoRowLayout({
    required this.sending,
    required this.onCamera,
    required this.onGallery,
    required this.onEstimate,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _SolidButton(icon: Icons.photo_camera_outlined, label: 'Camera', onTap: sending ? null : onCamera, busy: false)),
            const SizedBox(width: 8),
            Expanded(child: _OutlineButton(icon: Icons.photo_library_outlined, label: 'Gallery', onTap: sending ? null : onGallery)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _SolidButton(icon: Icons.price_change, label: sending ? 'Estimating' : 'Estimate', onTap: sending ? null : onEstimate, busy: sending)),
            const SizedBox(width: 8),
            Expanded(child: _OutlineButton(icon: Icons.delete_sweep_outlined, label: 'Clear', onTap: sending ? null : onClear)),
          ],
        ),
      ],
    );
  }
}

const _kButtonHeight = 52.0; // biraz daha yüksek → 2 satıra yer

class _SolidButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool busy;

  const _SolidButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.busy,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        minimumSize: const Size.fromHeight(_kButtonHeight),
        maximumSize: const Size(double.infinity, _kButtonHeight),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (busy)
            const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
          else
            Icon(icon, size: 20),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _OutlineButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: cs.onSurface,
        side: BorderSide(color: cs.outlineVariant),
        minimumSize: const Size.fromHeight(_kButtonHeight),
        maximumSize: const Size(double.infinity, _kButtonHeight),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
