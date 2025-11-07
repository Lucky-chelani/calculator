import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quote_provider.dart';

class QuotePreviewScreen extends StatelessWidget {
  const QuotePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<QuoteProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Quote Preview")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("QUOTATION",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  ...List.generate(p.items.length, (i) {
                    final item = p.items[i];
                    return ListTile(
                      title: Text(item.name.isEmpty ? "Unnamed Item" : item.name),
                      subtitle: Text(
                          "Qty: ${item.qty} | Rate: ₹${item.rate} | Disc: ₹${item.discount} | Tax: ${item.tax}%"),
                      trailing: Text(
                        "₹${item.total.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }),

                  const Divider(thickness: 1),

                  _row("Subtotal", p.subtotal),
                  _row("Tax", p.totalTax),
                  const Divider(),
                  _row("Grand Total", p.grandTotal, bold: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text("₹${value.toStringAsFixed(2)}",
              style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
