import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_item.dart';
import '../models/order_model.dart';

class CartState {
  final List<CartItem> items;
  final int tableNumber;
  final String customerName;
  final double tipAmount;

  const CartState({
    this.items = const [],
    this.tableNumber = 0,
    this.customerName = '',
    this.tipAmount = 2000.0, // Default tip uang rokok untuk Warmindo Butuh Uang
  });

  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.subtotal);

  double get grandTotal => subtotal + tipAmount;

  int get totalItemCount =>
      items.fold(0, (count, item) => count + item.quantity);

  CartState copyWith({
    List<CartItem>? items,
    int? tableNumber,
    String? customerName,
    double? tipAmount,
  }) {
    return CartState(
      items: items ?? this.items,
      tableNumber: tableNumber ?? this.tableNumber,
      customerName: customerName ?? this.customerName,
      tipAmount: tipAmount ?? this.tipAmount,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void setTableNumber(int number) {
    state = state.copyWith(tableNumber: number);
  }

  void setCustomerName(String name) {
    state = state.copyWith(customerName: name);
  }

  void setTipAmount(double tip) {
    state = state.copyWith(tipAmount: tip);
  }

  void addItem(MenuItem menuItem, {IndomieCustomization? customization}) {
    final newItem = CartItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      menuItem: menuItem,
      quantity: 1,
      customization: customization,
    );

    state = state.copyWith(items: [...state.items, newItem]);
  }

  void updateQuantity(String cartItemId, int newQty) {
    if (newQty <= 0) {
      removeItem(cartItemId);
      return;
    }
    state = state.copyWith(
      items: state.items.map((item) {
        if (item.id == cartItemId) {
          return item.copyWith(quantity: newQty);
        }
        return item;
      }).toList(),
    );
  }

  void removeItem(String cartItemId) {
    state = state.copyWith(
      items: state.items.where((i) => i.id != cartItemId).toList(),
    );
  }

  // Fitur Cerdas Khas Warmindo: Tambah Gorengan Mandiri di Meja (+Rp 1.500)
  void addGorenganMandiri() {
    const gorenganMenu = MenuItem(
      id: 'gorengan_mandiri',
      name: 'Gorengan Meja (Bakwan / Mendoan)',
      category: 'Gorengan/Snack',
      basePrice: 1500.0,
      imageUrl: 'https://images.unsplash.com/photo-1541544741938-0af808871cc0?w=500',
      description: 'Gorengan comot sendiri di piring meja',
    );

    // Cek apakah sudah ada item gorengan di keranjang
    final existingIndex = state.items.indexWhere((item) => item.menuItem.id == 'gorengan_mandiri');
    if (existingIndex >= 0) {
      final current = state.items[existingIndex];
      updateQuantity(current.id, current.quantity + 1);
    } else {
      addItem(gorenganMenu);
    }
  }

  void clearCart() {
    state = state.copyWith(items: []);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
