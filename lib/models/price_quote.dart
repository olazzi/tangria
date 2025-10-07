class PriceQuote {
  final String category;
  final String brand;
  final String model;
  final String condition;
  final String priceRange;
  final String error;
  final String? company;
  final String?description;
  final String? referenceNumber;
  final String? movement;
  final String? material;
  final String? dialColor;
  final String? diameter;
  final String? thickness;
  final String? depthRating;

  PriceQuote({
    required this.category,
    required this.brand,
    required this.model,
    required this.condition,
    required this.priceRange,
    required this.error,
    required this.company,
    required this.description,
    required this.referenceNumber,
    required this.movement,
    required this.material,
    required this.dialColor,
    required this.diameter,
    required this.thickness,
    required this.depthRating
  });

  factory PriceQuote.fromJson(Map<String, dynamic> j) => PriceQuote(
        category: j['category'] ?? '',
        brand: j['brand'] ?? '',
        model: j['model'] ?? '',
        condition: j['condition'] ?? '',
        priceRange: j['price_estimate'] ?? '',
        error: j['error'] ?? '',
        company: j['company'] ?? '',
        description: j['description'] ?? '',
        referenceNumber: j['reference number'] ?? '',
        movement: j['movement'] ?? '',
        material: j['material'] ?? '',
        dialColor: j['dial color'] ?? '',
        diameter: j['diameter'] ?? '',
        thickness: j['thickness'] ?? '',
        depthRating: j['depth rating'] ?? '',

      );

  Map<String, dynamic> toJson() => {
        'category': category,
        'brand': brand,
        'model': model,
        'condition': condition,
        'price_estimate': priceRange,
        'error': error,
        'company': company,
        'description': description,
        'reference number': referenceNumber,
        'movement': movement,
        'material': material,
        'dial color': dialColor,
        'diameter': diameter,
        'thickness': thickness,
        'depth rating': depthRating,
      };

  bool get hasError => error.isNotEmpty;
}
