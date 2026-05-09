import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'travel_models.dart';

// Destinations provider
final destinationsProvider = StateNotifierProvider<DestinationsNotifier, List<Destination>>((ref) {
  return DestinationsNotifier();
});

class DestinationsNotifier extends StateNotifier<List<Destination>> {
  DestinationsNotifier() : super(TravelSampleData.generateDestinations());

  void toggleFavorite(String destinationId) {
    state = state.map((destination) {
      if (destination.id == destinationId) {
        return destination.copyWith(isFavorite: !destination.isFavorite);
      }
      return destination;
    }).toList();
  }

  void addDestination(Destination destination) {
    state = [...state, destination];
  }
}

// Favorites provider
final favoriteDestinationsProvider = Provider<List<Destination>>((ref) {
  final destinations = ref.watch(destinationsProvider);
  return destinations.where((d) => d.isFavorite).toList();
});

// Popular destinations provider
final popularDestinationsProvider = Provider<List<Destination>>((ref) {
  final destinations = ref.watch(destinationsProvider);
  return destinations.where((d) => d.isPopular).toList();
});

// Travel packages provider
final packagesProvider = StateProvider<List<TravelPackage>>((ref) {
  return TravelSampleData.generatePackages();
});

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Search filter provider
final searchFilterProvider = StateProvider<SearchFilter>((ref) => SearchFilter());

class SearchFilter {
  final double? minPrice;
  final double? maxPrice;
  final String? type;
  final double? minRating;
  final List<String> amenities;

  SearchFilter({
    this.minPrice,
    this.maxPrice,
    this.type,
    this.minRating,
    this.amenities = const [],
  });

  SearchFilter copyWith({
    double? minPrice,
    double? maxPrice,
    String? type,
    double? minRating,
    List<String>? amenities,
  }) {
    return SearchFilter(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      type: type ?? this.type,
      minRating: minRating ?? this.minRating,
      amenities: amenities ?? this.amenities,
    );
  }
}

// Filtered destinations provider
final filteredDestinationsProvider = Provider<List<Destination>>((ref) {
  final destinations = ref.watch(destinationsProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final filter = ref.watch(searchFilterProvider);

  return destinations.where((destination) {
    // Text search
    if (query.isNotEmpty) {
      final matchesQuery = destination.name.toLowerCase().contains(query) ||
          destination.country.toLowerCase().contains(query) ||
          destination.description.toLowerCase().contains(query);
      if (!matchesQuery) return false;
    }

    // Price filter
    if (filter.minPrice != null && destination.pricePerNight < filter.minPrice!) {
      return false;
    }
    if (filter.maxPrice != null && destination.pricePerNight > filter.maxPrice!) {
      return false;
    }

    // Type filter
    if (filter.type != null && destination.type != filter.type) {
      return false;
    }

    // Rating filter
    if (filter.minRating != null && destination.rating < filter.minRating!) {
      return false;
    }

    // Amenities filter
    if (filter.amenities.isNotEmpty) {
      final hasAllAmenities = filter.amenities.every(
        (amenity) => destination.amenities.contains(amenity),
      );
      if (!hasAllAmenities) return false;
    }

    return true;
  }).toList();
});

// Booking details provider
final bookingDetailsProvider = StateNotifierProvider<BookingDetailsNotifier, BookingDetails>((ref) {
  return BookingDetailsNotifier();
});

class BookingDetails {
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int adults;
  final int children;
  final Destination? selectedDestination;

  BookingDetails({
    this.checkIn,
    this.checkOut,
    this.adults = 2,
    this.children = 0,
    this.selectedDestination,
  });

  int get totalGuests => adults + children;
  
  int get nights {
    if (checkIn == null || checkOut == null) return 0;
    return checkOut!.difference(checkIn!).inDays;
  }

  double get totalPrice {
    if (selectedDestination == null || nights == 0) return 0;
    return selectedDestination!.pricePerNight * nights;
  }

  BookingDetails copyWith({
    DateTime? checkIn,
    DateTime? checkOut,
    int? adults,
    int? children,
    Destination? selectedDestination,
  }) {
    return BookingDetails(
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      adults: adults ?? this.adults,
      children: children ?? this.children,
      selectedDestination: selectedDestination ?? this.selectedDestination,
    );
  }
}

class BookingDetailsNotifier extends StateNotifier<BookingDetails> {
  BookingDetailsNotifier() : super(BookingDetails());

  void updateCheckIn(DateTime date) {
    state = state.copyWith(checkIn: date);
  }

  void updateCheckOut(DateTime date) {
    state = state.copyWith(checkOut: date);
  }

  void updateAdults(int count) {
    state = state.copyWith(adults: count);
  }

  void updateChildren(int count) {
    state = state.copyWith(children: count);
  }

  void selectDestination(Destination destination) {
    state = state.copyWith(selectedDestination: destination);
  }

  void reset() {
    state = BookingDetails();
  }
}

// Recent searches provider
final recentSearchesProvider = StateNotifierProvider<RecentSearchesNotifier, List<String>>((ref) {
  return RecentSearchesNotifier();
});

class RecentSearchesNotifier extends StateNotifier<List<String>> {
  RecentSearchesNotifier() : super([]);

  void addSearch(String query) {
    if (query.isEmpty) return;
    
    // Remove if already exists
    state = state.where((s) => s != query).toList();
    
    // Add to beginning
    state = [query, ...state];
    
    // Keep only last 5
    if (state.length > 5) {
      state = state.take(5).toList();
    }
  }

  void clearSearches() {
    state = [];
  }
}