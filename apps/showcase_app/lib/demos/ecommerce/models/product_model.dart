class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviews;
  final List<String> colors;
  final List<String> sizes;
  final bool isFavorite;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.rating = 0.0,
    this.reviews = 0,
    this.colors = const [],
    this.sizes = const [],
    this.isFavorite = false,
    this.stock = 0,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    double? rating,
    int? reviews,
    List<String>? colors,
    List<String>? sizes,
    bool? isFavorite,
    int? stock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      colors: colors ?? this.colors,
      sizes: sizes ?? this.sizes,
      isFavorite: isFavorite ?? this.isFavorite,
      stock: stock ?? this.stock,
    );
  }

  // Sample products
  static List<Product> get sampleProducts => [
    const Product(
      id: '1',
      name: 'Liquid Glass Headphones',
      description: 'Premium wireless headphones with liquid glass design and superior sound quality.',
      price: 299.99,
      imageUrl: 'https://via.placeholder.com/300x300/007AFF/FFFFFF?text=Headphones',
      category: 'Electronics',
      rating: 4.8,
      reviews: 245,
      colors: ['Black', 'Silver', 'Blue'],
      stock: 15,
    ),
    const Product(
      id: '2',
      name: 'Smart Watch Pro',
      description: 'Advanced smartwatch with health monitoring and liquid glass display.',
      price: 399.99,
      imageUrl: 'https://via.placeholder.com/300x300/34C759/FFFFFF?text=Watch',
      category: 'Electronics',
      rating: 4.9,
      reviews: 189,
      colors: ['Space Gray', 'Silver', 'Gold'],
      sizes: ['40mm', '44mm'],
      stock: 23,
    ),
    const Product(
      id: '3',
      name: 'Designer Backpack',
      description: 'Stylish backpack with liquid glass accents and premium materials.',
      price: 159.99,
      imageUrl: 'https://via.placeholder.com/300x300/5856D6/FFFFFF?text=Backpack',
      category: 'Fashion',
      rating: 4.6,
      reviews: 92,
      colors: ['Navy', 'Black', 'Gray'],
      stock: 45,
    ),
    const Product(
      id: '4',
      name: 'Wireless Earbuds',
      description: 'True wireless earbuds with liquid glass charging case.',
      price: 199.99,
      imageUrl: 'https://via.placeholder.com/300x300/FF9500/FFFFFF?text=Earbuds',
      category: 'Electronics',
      rating: 4.7,
      reviews: 456,
      colors: ['White', 'Black'],
      stock: 67,
    ),
    const Product(
      id: '5',
      name: 'Smart Home Hub',
      description: 'Control your home with this liquid glass smart hub.',
      price: 249.99,
      imageUrl: 'https://via.placeholder.com/300x300/AF52DE/FFFFFF?text=Hub',
      category: 'Smart Home',
      rating: 4.5,
      reviews: 78,
      colors: ['White', 'Gray'],
      stock: 12,
    ),
    const Product(
      id: '6',
      name: 'Fitness Tracker',
      description: 'Track your fitness goals with style and precision.',
      price: 129.99,
      imageUrl: 'https://via.placeholder.com/300x300/FF3B30/FFFFFF?text=Tracker',
      category: 'Fitness',
      rating: 4.4,
      reviews: 234,
      colors: ['Black', 'Pink', 'Blue'],
      sizes: ['S', 'M', 'L'],
      stock: 89,
    ),
  ];
}

class CartItem {
  final Product product;
  final int quantity;
  final String? selectedColor;
  final String? selectedSize;

  const CartItem({
    required this.product,
    required this.quantity,
    this.selectedColor,
    this.selectedSize,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
    String? selectedColor,
    String? selectedSize,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
    );
  }
}