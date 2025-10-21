// lib/screens/home/widgets/selected_item_sheet.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'frosted_action_bar.dart';

const kActionBarHeight = 56.0;

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
  final Map<String, dynamic>? result;
  final bool lowConfidence;

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
    this.result,
    this.lowConfidence = false,
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
                  Expanded(
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        if (photos.isEmpty)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(12, 12, 12, result == null && !lowConfidence ? bottomBarPadding : 12),
                              child: const _DropZone(),
                            ),
                          ),
                        if (photos.isNotEmpty)
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                            sliver: SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                (c, i) => Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.memory(photos[i], fit: BoxFit.cover)),
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
                        if (result != null)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                              child: _ResultCard(data: result!),
                            ),
                          ),
                        if (lowConfidence)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(12, 0, 12, bottomBarPadding),
                              child: _LowConfidenceBanner(onAddMore: onGallery),
                            ),
                          )
                        else
                          SliverToBoxAdapter(child: SizedBox(height: bottomBarPadding)),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: FrostedActionBar(
                  sending: sending,
                  canEstimate: photos.isNotEmpty,
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

class _DropZone extends StatelessWidget {
  const _DropZone();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: cs.surfaceVariant.withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant, width: 1),
      ),
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: CustomPaint(
          painter: _DashPainter(color: cs.outlineVariant),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_upload_outlined, color: cs.onSurfaceVariant),
                const SizedBox(height: 8),
                Text('Add photos', style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  final Color color;
  const _DashPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 8.0;
    const dashSpace = 6.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final r = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(15));
    final path = Path()..addRRect(r);
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        final extract = metric.extractPath(distance, next);
        canvas.drawPath(extract, paint);
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashPainter oldDelegate) => oldDelegate.color != color;
}

class _ResultCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ResultCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final p = (data['primary'] ?? {}) as Map<String, dynamic>;
    final parts = [
      (p['brand'] ?? '').toString(),
      (p['model'] ?? '').toString(),
      (p['reference'] ?? '').toString()
    ].where((e) => e.isNotEmpty).toList();
    final title = parts.isEmpty ? 'Unknown' : parts.join(' ');
    final conf = ((p['confidence'] ?? 0.0) as num).toDouble().clamp(0.0, 1.0);
    final est = (data['estimate'] ?? {}) as Map<String, dynamic>;
    final low = est['price_low'];
    final high = est['price_high'];
    final priceText = (low != null && high != null)
        ? '\$${low.toString()}–\$${high.toString()}'
        : (est['price'] != null ? '\$${est['price']}' : '—');

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: cs.surfaceVariant.withOpacity(0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: LinearProgressIndicator(value: conf, minHeight: 8)),
              const SizedBox(width: 10),
              Text('${(conf * 100).round()}%', style: TextStyle(color: cs.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.attach_money, size: 18, color: cs.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(priceText, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _LowConfidenceBanner extends StatelessWidget {
  final VoidCallback onAddMore;
  const _LowConfidenceBanner({required this.onAddMore});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: cs.surfaceVariant.withOpacity(0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.help_outline, color: cs.onSurfaceVariant),
          const SizedBox(width: 10),
          const Expanded(child: Text('Unsure result — add another angle?')),
          const SizedBox(width: 10),
          OutlinedButton(onPressed: onAddMore, child: const Text('Add more photos')),
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
