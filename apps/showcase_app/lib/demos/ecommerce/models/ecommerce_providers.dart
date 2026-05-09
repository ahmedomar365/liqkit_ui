import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'product_model.dart';

// Products provider
final productsProvider = StateProvider<List<Product>>((ref) {
  return Product.sampleProducts;
});

// Cart provider
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

// Cart notifier
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(Product product, {String? color, String? size}) {
    final existingIndex = state.indexWhere(
      (item) => item.product.id == product.id && 
                item.selectedColor == color && 
                item.selectedSize == size,
    );

    if (existingIndex != -1) {
      // Increase quantity if item already exists
      state = [
        ...state.sublist(0, existingIndex),
        state[existingIndex].copyWith(
          quantity: state[existingIndex].quantity + 1,
        ),
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      // Add new item
      state = [
        ...state,
        CartItem(
          product: product,
          quantity: 1,
          selectedColor: color,
          selectedSize: size,
        ),
      ];
    }
  }

  void removeFromCart(CartItem item) {
    state = state.where((cartItem) => cartItem != item).toList();
  }

  void updateQuantity(CartItem item, int quantity) {
    if (quantity <= 0) {
      removeFromCart(item);
      return;
    }

    final index = state.indexOf(item);
    if (index != -1) {
      state = [
        ...state.sublist(0, index),
        item.copyWith(quantity: quantity),
        ...state.sublist(index + 1),
      ];
    }
  }

  void clearCart() {
    state = [];
  }

  double get totalPrice {
    return state.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItems {
    return state.fold(0, (sum, item) => sum + item.quantity);
  }
}

// Favorites provider
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
  return FavoritesNotifier();
});

// Favorites notifier
class FavoritesNotifier extends StateNotifier<List<String>> {
  FavoritesNotifier() : super([]);

  void toggleFavorite(String productId) {
    if (state.contains(productId)) {
      state = state.where((id) => id != productId).toList();
    } else {
      state = [...state, productId];
    }
  }

  bool isFavorite(String productId) {
    return state.contains(productId);
  }
}

// Selected category provider
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filtered products provider
final filteredProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  return products.where((product) {
    final matchesCategory = selectedCategory == null || 
                           product.category == selectedCategory;
    final matchesSearch = searchQuery.isEmpty ||
                         product.name.toLowerCase().contains(searchQuery) ||
                         product.description.toLowerCase().contains(searchQuery);
    
    return matchesCategory && matchesSearch;
  }).toList();
});