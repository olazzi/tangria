import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> showCandidatePicker(BuildContext context, Map<String,dynamic> id) {
  final primary = (id['primary'] ?? {}) as Map<String,dynamic>;
  final candidates = (id['candidates'] ?? []) as List<dynamic>;
  final items = [primary, ...candidates.cast<Map<String,dynamic>>()];

  return showModalBottomSheet<Map<String,dynamic>>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      int selected = 0;
      return StatefulBuilder(builder: (ctx, setSt) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16,16,16,24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Is this the right item?', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final it = items[i];
                  final title = [it['brand']??'', it['model']??'', it['reference']??''].where((e)=> (e as String).isNotEmpty).join(' ');
                  final conf = ((it['confidence'] ?? 0.0) as num).toDouble();
                  return ListTile(
                    title: Text(title.isEmpty ? 'Unknown' : title),
                    subtitle: Text('Confidence ${(conf*100).toStringAsFixed(0)}%'),
                    leading: Radio<int>(value: i, groupValue: selected, onChanged: (v)=> setSt(()=> selected=v!)),
                    onTap: ()=> setSt(()=> selected=i),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: ElevatedButton(onPressed: ()=> Navigator.pop(ctx, items[selected]), child: const Text('Use this'))),
              const SizedBox(width: 12),
              Expanded(child: OutlinedButton(onPressed: ()=> Navigator.pop(ctx, null), child: const Text('Add more photos'))),
            ]),
            const SizedBox(height: 8),
          ]),
        );
      });
    },
  );
}
