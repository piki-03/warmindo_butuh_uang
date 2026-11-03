import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_item.dart';
import '../models/order_model.dart';
import '../core/config/supabase_config.dart';

// Mock Menu Items untuk Warmindo Butuh Uang
final List<MenuItem> defaultWarmindoMenu = [
  const MenuItem(
    id: 'm1',
    name: 'Indomie Goreng Original + Telur',
    category: 'Indomie Goreng',
    basePrice: 10000.0,
    imageUrl: 'https://images.unsplash.com/photo-1612927601601-6638404737ce?w=500',
    description: 'Indomie goreng legendaris dengan bumbu gurih khas warkop.',
    isIndomie: true,
  ),
  const MenuItem(
    id: 'm2',
    name: 'Indomie Goreng Aceh Pedas',
    category: 'Indomie Goreng',
    basePrice: 11000.0,
    imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=500',
    description: 'Rasa rempah tebal dan pedas khas mie Aceh.',
    isIndomie: true,
  ),
  const MenuItem(
    id: 'm3',
    name: 'Indomie Kuah Soto Medan',
    category: 'Indomie Kuah',
    basePrice: 10000.0,
    imageUrl: 'https://images.unsplash.com/photo-1591814468924-caf88d1232e1?w=500',
    description: 'Kuah hangat gurih segar dengan aroma jeruk nipis.',
    isIndomie: true,
  ),
  const MenuItem(
    id: 'm4',
    name: 'Indomie Kuah Kari Ayam Nyemek',
    category: 'Indomie Kuah',
    basePrice: 10000.0,
    imageUrl: 'https://images.unsplash.com/photo-1552611052-33e04de081de?w=500',
    description: 'Kuah kental kari pekat mantap diseruput malam hari.',
    isIndomie: true,
  ),
  const MenuItem(
    id: 'm5',
    name: 'Nasi Magelangan (Nasi Goreng Mie)',
    category: 'Nasi & Lauk',
    basePrice: 15000.0,
    imageUrl: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=500',
    description: 'Nasi goreng dicampur mie kuning dengan bumbu kecap manis gurih.',
  ),
  const MenuItem(
    id: 'm6',
    name: 'Nasi Sarden Saus Tomat',
    category: 'Nasi & Lauk',
    basePrice: 14000.0,
    imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500',
    description: 'Ikan sarden kaleng dimasak dengan irisan cabai dan bawang.',
  ),
  const MenuItem(
    id: 'm7',
    name: 'Es Teh Manis Jumbo',
    category: 'Minuman Dingin',
    basePrice: 4000.0,
    imageUrl: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=500',
    description: 'Teh melati wangi diseduh segar dengan es batu melimpah.',
  ),
  const MenuItem(
    id: 'm8',
    name: 'Es Nutrisari Jeruk Peras',
    category: 'Minuman Dingin',
    basePrice: 5000.0,
    imageUrl: 'https://images.unsplash.com/photo-1613478223719-2ab802602423?w=500',
    description: 'Minuman kesayangan warkop rasa jeruk manis asam segar.',
  ),
  const MenuItem(
    id: 'm9',
    name: 'Extra Joss Susu (JOSSU)',
    category: 'Minuman Dingin',
    basePrice: 6000.0,
    imageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=500',
    description: 'Kombinasi energi bertenaga dan manisnya susu kental kental manis.',
  ),
  const MenuItem(
    id: 'm10',
    name: 'Kopi Hitam Tubruk Warkop',
    category: 'Minuman Hangat',
    basePrice: 4000.0,
    imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=500',
    description: 'Kopi robusta hitam pekat manis pahit pas untuk melek malam.',
  ),
  const MenuItem(
    id: 'm11',
    name: 'Roti Bakar Cokelat Keju Susu',
    category: 'Camilan/Roti',
    basePrice: 12000.0,
    imageUrl: 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=500',
    description: 'Roti bakar empuk isi meises cokelat melimpah dan taburan keju cheddar.',
  ),
];

final menuListProvider = Provider<List<MenuItem>>((ref) {
  return defaultWarmindoMenu;
});

// State untuk pesanan aktif (Kitchen Display System)
class KitchenOrdersNotifier extends StateNotifier<List<OrderModel>> {
  KitchenOrdersNotifier() : super(_initialOrders);

  static final List<OrderModel> _initialOrders = [
    OrderModel(
      id: 'ORD-101',
      tableNumber: 3,
      customerName: 'Mas Dimas',
      items: [
        CartItem(
          id: 'c1',
          menuItem: defaultWarmindoMenu[0],
          quantity: 1,
          customization: const IndomieCustomization(
            kematangan: 'Nyemek',
            pilihanTelur: 'Ceplok 1/2 Matang',
            jumlahCabe: 7,
            toppings: ['Kornet'],
            catatan: 'Kuahnya jangan terlalu banyak mas',
          ),
        ),
        CartItem(
          id: 'c2',
          menuItem: defaultWarmindoMenu[6], // Es Teh
          quantity: 2,
        ),
      ],
      tipAmount: 2000.0,
      totalPrice: 24000.0,
      status: OrderStatus.cooking,
      createdAt: DateTime.now().subtract(const Duration(minutes: 6)),
    ),
    OrderModel(
      id: 'ORD-102',
      tableNumber: 7,
      customerName: 'Mbak Sarah',
      items: [
        CartItem(
          id: 'c3',
          menuItem: defaultWarmindoMenu[3], // Kari Ayam
          quantity: 1,
          customization: const IndomieCustomization(
            kematangan: 'Kering / Standar',
            pilihanTelur: 'Dadar',
            jumlahCabe: 12,
            toppings: ['Keju'],
            catatan: 'Cabe rawit merah ulek pedas!',
          ),
        ),
        CartItem(
          id: 'c4',
          menuItem: defaultWarmindoMenu[7], // Nutrisari
          quantity: 1,
        ),
      ],
      tipAmount: 3000.0,
      totalPrice: 25000.0,
      status: OrderStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
  ];

  void addOrder(OrderModel newOrder) {
    state = [newOrder, ...state];

    // Jika Supabase aktif, kirim juga ke DB Supabase
    if (SupabaseConfig.isConfigured) {
      SupabaseConfig.client?.from('orders').insert({
        'table_number': newOrder.tableNumber,
        'customer_name': newOrder.customerName,
        'total_price': newOrder.totalPrice,
        'status': 'pending',
        'tip_amount': newOrder.tipAmount,
      });
    }
  }

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    state = state.map((order) {
      if (order.id == orderId) {
        return OrderModel(
          id: order.id,
          tableNumber: order.tableNumber,
          customerName: order.customerName,
          items: order.items,
          tipAmount: order.tipAmount,
          totalPrice: order.totalPrice,
          status: newStatus,
          createdAt: order.createdAt,
        );
      }
      return order;
    }).toList();
  }
}

final kitchenOrdersProvider =
    StateNotifierProvider<KitchenOrdersNotifier, List<OrderModel>>((ref) {
  return KitchenOrdersNotifier();
});
