import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quote_provider.dart';
import '../screens/quote_preview_screen.dart';

class QuoteFormScreen extends StatelessWidget {
  const QuoteFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuoteProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Product Quote Builder")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => provider.addItem(),
        child: const Icon(Icons.add),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.items.length,
                  itemBuilder: (context, index) {
                    final item = provider.items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(labelText: "Product/Service"),
                                    onChanged: (v) {
                                      item.name = v;
                                      provider.notifyListeners();
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => provider.removeItem(index),
                                )
                              ],
                            ),
                            
                            isWide
                                ? Row(
                                    children: _buildFields(item, provider)
                                        .map((w) => Expanded(child: Padding(
                                              padding: const EdgeInsets.only(right: 8),
                                              child: w,
                                            )))
                                        .toList(),
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: _buildFields(item, provider)
                                        .map((w) => Padding(
                                              padding: const EdgeInsets.only(bottom: 8),
                                              child: w,
                                            ))
                                        .toList(),
                                  ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Item Total: ₹${item.total.toStringAsFixed(2)}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              _buildTotalsCard(provider),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  child: const Text("Preview Quote"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuotePreviewScreen()),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildFields(item, provider) {
    return [
      _numberField("Qty", item.qty, (v) {
        item.qty = v;
        provider.notifyListeners();
      }),
      _numberField("Rate", item.rate, (v) {
        item.rate = v;
        provider.notifyListeners();
      }),
      _numberField("Discount Per Item", item.discount, (v) {
        item.discount = v;
        provider.notifyListeners();
      }),
      _numberField("Tax %", item.tax, (v) {
        item.tax = v;
        provider.notifyListeners();
      }),
    ];
  }

  Widget _numberField(String label, double initial, Function(double) onChanged) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      onChanged: (v) => onChanged(double.tryParse(v) ?? 0),
    );
  }

  Widget _buildTotalsCard(QuoteProvider provider) {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _row("Subtotal", provider.subtotal),
          _row("Tax", provider.totalTax),
          const Divider(),
          _row("Grand Total", provider.grandTotal, bold: true),
        ],
      ),
    );
  }

  Widget _row(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null),
          Text("₹${value.toStringAsFixed(2)}",
              style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null),
        ],
      ),
    );
  }
}
