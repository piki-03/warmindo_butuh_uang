import 'menu_item.dart';

enum OrderStatus {
  pending, // Menunggu antrean
  cooking, // Sedang dimasak di wajan
  ready,   // Siap diantar ke meja
  paid,    // Selesai & Lunas
  cancelled
}

class CartItem {
  final String id;
  final MenuItem menuItem;
  final int quantity;
  final IndomieCustomization? customization;

  const CartItem({
    required this.id,
    required this.menuItem,
    this.quantity = 1,
    this.customization,
  });

  double get unitPrice {
    return menuItem.basePrice + (customization?.extraPrice ?? 0.0);
  }

  double get subtotal => unitPrice * quantity;

  CartItem copyWith({
    int? quantity,
    IndomieCustomization? customization,
  }) {
    return CartItem(
      id: id,
      menuItem: menuItem,
      quantity: quantity ?? this.quantity,
      customization: customization ?? this.customization,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menu_item_id': menuItem.id,
      'item_name': menuItem.name,
      'quantity': quantity,
      'subtotal': subtotal,
      'customization': customization?.toJson(),
    };
  }
}

class OrderModel {
  final String id;
  final int tableNumber;
  final String customerName;
  final List<CartItem> items;
  final double tipAmount; // Tip uang rokok/kopi untuk Warmindo Butuh Uang
  final double totalPrice;
  final OrderStatus status;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.tableNumber,
    required this.customerName,
    required this.items,
    this.tipAmount = 0.0,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      tableNumber: json['table_number'] as int? ?? 1,
      customerName: json['customer_name'] as String? ?? 'Anak Tongkrongan',
      items: [], // Will be parsed with order_items
      tipAmount: (json['tip_amount'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['total_price'] as num).toDouble(),
      status: _parseStatus(json['status'] as String?),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  static OrderStatus _parseStatus(String? statusStr) {
    switch (statusStr) {
      case 'cooking':
        return OrderStatus.cooking;
      case 'ready':
        return OrderStatus.ready;
      case 'paid':
        return OrderStatus.paid;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending:
        return 'Antrean Baru';
      case OrderStatus.cooking:
        return 'Sedang Dimasak';
      case OrderStatus.ready:
        return 'Siap Diantar';
      case OrderStatus.paid:
        return 'Selesai';
      case OrderStatus.cancelled:
        return 'Dibatalkan';
    }
  }
}
