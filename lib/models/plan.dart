class Plan {

  int pages;
  int overage;
  String price;
  String overagePrice;
  int rollover;

  Plan({this.pages, this.overage, this.price, this.overagePrice, this.rollover});

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      pages: json['pages'] as int,
      overage: json['overageBlockSize'] as int,
      price: json['price'] as String,
      overagePrice: json['overageBlockPrice'] as String,
      rollover: json['rollover'] as int,
    );
  }

  @override
  String toString() {
    return "Plan(pages:$pages, price:$price, overage:$overage, overPrice:$overagePrice, rollover:$rollover)";
  }
}