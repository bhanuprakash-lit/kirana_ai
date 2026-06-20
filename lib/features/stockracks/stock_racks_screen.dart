import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/api_client.dart';
import '../../core/theme/brand_theme.dart';

/// Module M3 — multi-rack stock: find which rack a product sits in, and place
/// stock into racks.
class StockRacksScreen extends ConsumerStatefulWidget {
  const StockRacksScreen({super.key});
  @override
  ConsumerState<StockRacksScreen> createState() => _StockRacksScreenState();
}

class _StockRacksScreenState extends ConsumerState<StockRacksScreen> {
  final _q = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  bool _loading = false;

  Future<void> _search() async {
    setState(() => _loading = true);
    try {
      final d = await ref
          .read(apiClientProvider)
          .get('/kirana/racks?q=${Uri.encodeComponent(_q.text.trim())}');
      final l = (d is Map ? d['items'] : null) as List<dynamic>? ?? [];
      setState(() => _results =
          l.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(title: const Text('Stock Racks')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _place,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Place stock'),
      ),
      body: Column(children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _q,
            onSubmitted: (_) => _search(),
            decoration: InputDecoration(
              hintText: 'Search rack (e.g. A1, top-shelf)',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward_rounded),
                  onPressed: _search),
            ),
          ),
        ),
        if (_loading) const LinearProgressIndicator(),
        Expanded(
          child: _results.isEmpty
              ? const Center(
                  child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('Search a rack to see what is stored there.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: BrandColors.muted))))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _results.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final r = _results[i];
                    return ListTile(
                      title: Text(r['product_name']?.toString() ?? 'Product'),
                      subtitle: Text('Rack ${r['rack']}'),
                      trailing: Text('${r['quantity']}',
                          style: const TextStyle(fontWeight: FontWeight.w800)),
                    );
                  },
                ),
        ),
      ]),
    );
  }

  void _place() {
    final pid = TextEditingController();
    final rack = TextEditingController();
    final qty = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          left: 20,
          right: 20,
          top: 16,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Place stock in a rack',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            TextField(
                controller: pid,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: 'Product ID')),
            const SizedBox(height: 12),
            TextField(controller: rack, decoration: const InputDecoration(labelText: 'Rack / bin label')),
            const SizedBox(height: 12),
            TextField(
                controller: qty,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: 'Quantity')),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () async {
                  final p = int.tryParse(pid.text.trim());
                  if (p == null || rack.text.trim().isEmpty) return;
                  await ref.read(apiClientProvider).post(
                      '/kirana/products/$p/locations', {
                    'rack': rack.text.trim(),
                    'quantity': int.tryParse(qty.text.trim()) ?? 0,
                  });
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: const Text('Save'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
