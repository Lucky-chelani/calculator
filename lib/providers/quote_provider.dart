import 'package:flutter/material.dart';
import '../models/quote_item.dart';

class QuoteProvider extends ChangeNotifier {
  List<QuoteItem> items = [QuoteItem()];

  void addItem() {
    items.add(QuoteItem());
    notifyListeners();
  }

  void removeItem(int index) {
    if (items.length > 1) {
      items.removeAt(index);
      notifyListeners();
    }
  }

  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + (item.rate - item.discount) * item.qty);

  double get totalTax =>
      items.fold(0.0, (sum, item) => sum + ((item.rate - item.discount) * item.qty) * (item.tax / 100));

  double get grandTotal => subtotal + totalTax;
}
