class MenuItem {
  final String id;
  final String name;
  final String category;
  final double basePrice;
  final String imageUrl;
  final String description;
  final bool isIndomie;
  final bool isAvailable;

  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.basePrice,
    required this.imageUrl,
    required this.description,
    this.isIndomie = false,
    this.isAvailable = true,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String? ?? 'Umum',
      basePrice: (json['base_price'] as num).toDouble(),
      imageUrl: json['image_url'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isIndomie: json['is_indomie'] as bool? ?? false,
      isAvailable: json['is_available'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'base_price': basePrice,
      'image_url': imageUrl,
      'description': description,
      'is_indomie': isIndomie,
      'is_available': isAvailable,
    };
  }
}

class IndomieCustomization {
  final String kematangan; // 'Kering / Standar', 'Nyemek', 'Lembek'
  final String pilihanTelur; // 'Tanpa Telur', 'Ceplok Matang', 'Ceplok 1/2 Matang', 'Dadar'
  final int jumlahCabe; // 0 - 15
  final List<String> toppings; // 'Kornet', 'Keju', 'Sosis', 'Bakso'
  final String catatan;

  const IndomieCustomization({
    this.kematangan = 'Kering / Standar',
    this.pilihanTelur = 'Ceplok 1/2 Matang',
    this.jumlahCabe = 3,
    this.toppings = const [],
    this.catatan = '',
  });

  double get extraPrice {
    double total = 0.0;
    // Telur
    if (pilihanTelur != 'Tanpa Telur') {
      total += 4000.0;
    }
    // Topping
    for (final t in toppings) {
      if (t == 'Kornet') total += 4000.0;
      if (t == 'Keju') total += 3000.0;
      if (t == 'Sosis') total += 3000.0;
      if (t == 'Bakso') total += 3000.0;
    }
    // Cabe gratis tapi jika cabe > 10 ekstra 2000
    if (jumlahCabe > 10) {
      total += 2000.0;
    }
    return total;
  }

  Map<String, dynamic> toJson() {
    return {
      'kematangan': kematangan,
      'pilihan_telur': pilihanTelur,
      'jumlah_cabe': jumlahCabe,
      'toppings': toppings,
      'catatan': catatan,
      'extra_price': extraPrice,
    };
  }

  factory IndomieCustomization.fromJson(Map<String, dynamic> json) {
    return IndomieCustomization(
      kematangan: json['kematangan'] as String? ?? 'Kering / Standar',
      pilihanTelur: json['pilihan_telur'] as String? ?? 'Ceplok 1/2 Matang',
      jumlahCabe: json['jumlah_cabe'] as int? ?? 3,
      toppings: (json['toppings'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      catatan: json['catatan'] as String? ?? '',
    );
  }
}
