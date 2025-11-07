class QuoteItem {
  String name;
  double qty;
  double rate;
  double discount;
  double tax;

  QuoteItem({
    this.name = "",
    this.qty = 1,
    this.rate = 0,
    this.discount = 0,
    this.tax = 0,
  });

  double get total {
    final discountedRate = rate - discount;
    final subtotal = discountedRate * qty;
    final taxAmount = subtotal * (tax / 100);
    return subtotal + taxAmount;
  }
}
