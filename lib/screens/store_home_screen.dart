import 'package:flutter/material.dart';
import '../core/vindora_theme.dart';
import '../services/api_client.dart';

class StoreHomeScreen extends StatefulWidget {
  const StoreHomeScreen({super.key});
  @override
  State<StoreHomeScreen> createState() => _StoreHomeScreenState();
}

class _StoreHomeScreenState extends State<StoreHomeScreen> {
  final _api = ApiClient();
  bool _loading = true;
  String? _error;
  List<dynamic> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await _api.get('products');
      setState(() => _products = (data['products'] as List?) ?? []);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('Vindora')),
        body: RefreshIndicator(
          onRefresh: _loadProducts,
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? ListView(children: [const SizedBox(height: 120), Center(child: Text(_error!)), TextButton(onPressed: _loadProducts, child: const Text('إعادة المحاولة'))])
                  : _products.isEmpty
                      ? const Center(child: Text('مفيش منتجات متاحة حاليًا'))
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .68, crossAxisSpacing: 12, mainAxisSpacing: 12),
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            final p = _products[index] as Map<String, dynamic>;
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: VindoraColors.border)),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                Expanded(child: p['image_url'] == null || p['image_url'].toString().isEmpty
                                    ? const ColoredBox(color: Color(0xFFF0F1F6), child: Icon(Icons.image_outlined, size: 42, color: VindoraColors.muted))
                                    : Image.network(p['image_url'].toString(), fit: BoxFit.cover, errorBuilder: (_, __, ___) => const ColoredBox(color: Color(0xFFF0F1F6), child: Icon(Icons.image_not_supported_outlined)))),
                                Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text((p['name'] ?? '').toString(), maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, color: VindoraColors.navy)),
                                  const SizedBox(height: 6),
                                  Text('${p['sale_price'] ?? ''} ج.م', style: const TextStyle(color: VindoraColors.purple, fontWeight: FontWeight.w800)),
                                ])),
                              ]),
                            );
                          },
                        ),
        ),
      ),
    );
  }
}
