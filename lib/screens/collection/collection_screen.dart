// lib/screens/collection/collection_screen.dart
import 'package:flutter/material.dart';
import '../../services/collection_service.dart';
import '../../models/collection_item.dart';
import './widgets/collection_header.dart';
import 'widgets/collection_list.dart';
import '../../services/velora_client.dart';
import 'widgets/recommendation_sheet.dart';
import '../../services/recommendation_service.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});
  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  late Future<List<CollectionItem>> _f;
  bool _loadingRec = false;

  @override
  void initState() {
    super.initState();
    _f = CollectionService.load();
  }

  Future<void> _openIdeasMenu(List<CollectionItem> items) async {
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'When you get new recommendations old ones will be replaced',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.bookmark_outline),
                  title: const Text('Saved Recommendations'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _openSaved();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.auto_awesome),
                  title: const Text('Get ideas'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _openRecommendations(items);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.close),
                  title: const Text('Cancel'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openRecommendations(List<CollectionItem> items) async {
    if (_loadingRec) return;
    setState(() => _loadingRec = true);
    try {
      final rec = await VeloraClient.recommendCollection(items);
      await RecommendationService.saveFromApi(rec);
      if (!mounted) return;
      await _openSaved();
      if (mounted) setState(() {});
    } finally {
      if (mounted) setState(() => _loadingRec = false);
    }
  }

  Future<void> _openSaved() async {
    final items = await RecommendationService.loadPreview(limit: 10);
    final data = {
      'recommendations': items.map((e) => {'title': e.title, 'reason': e.reason}).toList(),
    };
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RecommendSheet(data: data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'My Collection',
              style: TextStyle(
                fontFamily: 'Tektur',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 88, 79, 79),
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _loadingRec
                    ? null
                    : () async {
                        final items = await _f;
                        await _openIdeasMenu(items);
                      },
                child: _loadingRec
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.auto_awesome, size: 22),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: FutureBuilder<List<CollectionItem>>(
        future: _f,
        builder: (c, s) {
          if (s.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.hasError) {
            return Center(child: Text('Failed to load', style: Theme.of(context).textTheme.titleMedium));
          }
          final items = s.data ?? [];
          final totalRangeText = CollectionService.formatTotalRange(items);
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              CollectionHeader(
                totalValueText: totalRangeText,
                countText: '${items.length} items',
              ),
              const SizedBox(height: 16),
              CollectionList(items: items),
            ],
          );
        },
      ),
    );
  }
}
