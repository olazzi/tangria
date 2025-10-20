// lib/screens/home/widgets/selected_item_sheet.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';

const kActionBarHeight = 56.0;
const _kButtonHeight = 48.0;

class SelectedItemSheet extends StatelessWidget {
  final List<Uint8List> photos;
  final bool sending;
  final bool collapsed;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onEstimate;
  final VoidCallback onClear;
  final VoidCallback onClose;
  final VoidCallback onToggleCollapse;
  final void Function(int index)? onRemovePhoto;
  final ScrollController? scrollController;

  const SelectedItemSheet({
    super.key,
    required this.photos,
    required this.sending,
    required this.collapsed,
    required this.onCamera,
    required this.onGallery,
    required this.onEstimate,
    required this.onClear,
    required this.onClose,
    required this.onToggleCollapse,
    this.onRemovePhoto,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fg = cs.onSurface;
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    final bottomBarPadding = kActionBarHeight + bottomSafe + 12;

    return SafeArea(
      top: false,
      bottom: true,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Material(
          color: cs.surface,
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 8, 8),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 5,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: fg.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const Text('Selected', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: fg.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: fg.withOpacity(0.12)),
                          ),
                          child: Text('${photos.length}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                        const Spacer(),
                        IconButton(onPressed: onToggleCollapse, icon: Icon(collapsed ? Icons.unfold_more : Icons.unfold_less)),
                        IconButton(onPressed: onClose, icon: const Icon(Icons.close_rounded)),
                      ],
                    ),
                  ),
                  if (collapsed)
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(12, 6, 12, bottomBarPadding),
                        child: _CollapsedBarContent(photos: photos, sending: sending),
                      ),
                    )
                  else
                    Expanded(
                      child: _GridArea(
                        photos: photos,
                        sending: sending,
                        scrollController: scrollController,
                        onRemovePhoto: onRemovePhoto,
                        bottomPad: bottomBarPadding,
                      ),
                    ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _FrostedActionBar(
                  sending: sending,
                  onCamera: onCamera,
                  onGallery: onGallery,
                  onEstimate: onEstimate,
                  onClear: onClear,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollapsedBarContent extends StatelessWidget {
  final List<Uint8List> photos;
  final bool sending;
  const _CollapsedBarContent({required this.photos, required this.sending});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (photos.isNotEmpty)
          SizedBox(
            height: 76,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.memory(photos[i], fit: BoxFit.cover),
                ),
              ),
            ),
          )
        else
          Container(
            height: 76,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: cs.surfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.outlineVariant),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('No photos yet', style: TextStyle(color: cs.onSurfaceVariant)),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(sending ? Icons.sync : Icons.price_change, size: 18, color: cs.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              sending ? 'Estimating…' : 'Ready to estimate',
              style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}

class _GridArea extends StatelessWidget {
  final List<Uint8List> photos;
  final bool sending;
  final ScrollController? scrollController;
  final void Function(int index)? onRemovePhoto;
  final double bottomPad;

  const _GridArea({
    required this.photos,
    required this.sending,
    required this.scrollController,
    required this.onRemovePhoto,
    required this.bottomPad,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        if (photos.isEmpty)
          SliverToBoxAdapter(
            child: Container(
              height: 220,
              alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              decoration: BoxDecoration(
                color: cs.surfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Text('Add some photos', style: TextStyle(color: cs.onSurfaceVariant, fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        if (photos.isNotEmpty)
          SliverPadding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, bottomPad),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (c, i) => Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.memory(photos[i], fit: BoxFit.cover),
                    ),
                    if (onRemovePhoto != null && photos.length > 1)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Material(
                          color: Colors.black54,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () => onRemovePhoto!(i),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.close_rounded, size: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                childCount: photos.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
            ),
          ),
        if (sending)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: _EstimatingStripe(),
            ),
          ),
      ],
    );
  }
}

class _FrostedActionBar extends StatelessWidget {
  final bool sending;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onEstimate;
  final VoidCallback onClear;

  const _FrostedActionBar({
    required this.sending,
    required this.onCamera,
    required this.onGallery,
    required this.onEstimate,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surface,
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 420;
              if (!narrow) {
                return Row(
                  children: [
                    Expanded(child: _SolidButton(icon: Icons.photo_camera_outlined, label: 'Camera', onTap: sending ? null : onCamera, busy: false)),
                    const SizedBox(width: 8),
                    Expanded(child: _OutlineButton(icon: Icons.photo_library_outlined, label: 'Gallery', onTap: sending ? null : onGallery)),
                    const SizedBox(width: 8),
                    Expanded(child: _SolidButton(icon: Icons.price_change, label: sending ? 'Estimating' : 'Estimate', onTap: sending ? null : onEstimate, busy: sending)),
                    const SizedBox(width: 8),
                    SizedBox(width: 120, child: _OutlineButton(icon: Icons.delete_sweep_outlined, label: 'Clear', onTap: sending ? null : onClear)),
                  ],
                );
              }
              final w = (constraints.maxWidth - 8) / 2;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SizedBox(width: w, child: _SolidButton(icon: Icons.photo_camera_outlined, label: 'Camera', onTap: sending ? null : onCamera, busy: false)),
                  SizedBox(width: w, child: _OutlineButton(icon: Icons.photo_library_outlined, label: 'Gallery', onTap: sending ? null : onGallery)),
                  SizedBox(width: w, child: _SolidButton(icon: Icons.price_change, label: sending ? 'Estimating' : 'Estimate', onTap: sending ? null : onEstimate, busy: sending)),
                  SizedBox(width: w, child: _OutlineButton(icon: Icons.delete_sweep_outlined, label: 'Clear', onTap: sending ? null : onClear)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

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
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (busy)
            const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
          else
            Icon(icon, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false, style: const TextStyle(fontWeight: FontWeight.w600)),
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
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _EstimatingStripe extends StatelessWidget {
  const _EstimatingStripe();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: cs.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Estimating…', style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(height: 10),
          LinearProgressIndicator(minHeight: 6),
        ],
      ),
    );
  }
}
