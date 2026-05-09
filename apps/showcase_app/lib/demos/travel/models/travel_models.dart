import 'package:flutter/widgets.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

// Destination model
class Destination {
  final String id;
  final String name;
  final String country;
  final String description;
  final List<String> images;
  final double rating;
  final int reviews;
  final double pricePerNight;
  final List<String> amenities;
  final String type; // hotel, resort, apartment, villa
  final bool isFavorite;
  final bool isPopular;
  final Map<String, dynamic> location;
  final List<Activity> activities;
  final WeatherCondition weather;

  const Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.description,
    required this.images,
    required this.rating,
    required this.reviews,
    required this.pricePerNight,
    required this.amenities,
    required this.type,
    this.isFavorite = false,
    this.isPopular = false,
    required this.location,
    this.activities = const [],
    required this.weather,
  });

  Destination copyWith({
    String? id,
    String? name,
    String? country,
    String? description,
    List<String>? images,
    double? rating,
    int? reviews,
    double? pricePerNight,
    List<String>? amenities,
    String? type,
    bool? isFavorite,
    bool? isPopular,
    Map<String, dynamic>? location,
    List<Activity>? activities,
    WeatherCondition? weather,
  }) {
    return Destination(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      description: description ?? this.description,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      amenities: amenities ?? this.amenities,
      type: type ?? this.type,
      isFavorite: isFavorite ?? this.isFavorite,
      isPopular: isPopular ?? this.isPopular,
      location: location ?? this.location,
      activities: activities ?? this.activities,
      weather: weather ?? this.weather,
    );
  }
}

// Activity model
class Activity {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final Duration duration;
  final double rating;
  final String category;

  const Activity({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.duration,
    required this.rating,
    required this.category,
  });
}

// Weather condition model
class WeatherCondition {
  final String condition;
  final double temperature;
  final IconData icon;

  const WeatherCondition({
    required this.condition,
    required this.temperature,
    required this.icon,
  });
}

// Booking model
class Booking {
  final String id;
  final Destination destination;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double totalPrice;
  final String status; // confirmed, pending, cancelled
  final String bookingReference;

  const Booking({
    required this.id,
    required this.destination,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalPrice,
    required this.status,
    required this.bookingReference,
  });
}

// Flight model
class Flight {
  final String id;
  final String airline;
  final String flightNumber;
  final String departure;
  final String arrival;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final String cabin; // economy, business, first
  final Duration duration;

  const Flight({
    required this.id,
    required this.airline,
    required this.flightNumber,
    required this.departure,
    required this.arrival,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.cabin,
    required this.duration,
  });
}

// Travel package model
class TravelPackage {
  final String id;
  final String name;
  final String description;
  final Destination destination;
  final List<String> inclusions;
  final double price;
  final int days;
  final int nights;
  final String imageUrl;
  final bool isAllInclusive;

  const TravelPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.destination,
    required this.inclusions,
    required this.price,
    required this.days,
    required this.nights,
    required this.imageUrl,
    this.isAllInclusive = false,
  });
}

// Sample data
class TravelSampleData {
  static List<Destination> generateDestinations() {
    return [
      Destination(
        id: '1',
        name: 'Santorini Paradise',
        country: 'Greece',
        description: 'Experience the magic of Santorini with breathtaking sunsets, white-washed buildings, and crystal-clear waters.',
        images: [
          'https://picsum.photos/800/600?random=300',
          'https://picsum.photos/800/600?random=301',
          'https://picsum.photos/800/600?random=302',
        ],
        rating: 4.8,
        reviews: 1234,
        pricePerNight: 250,
        amenities: ['WiFi', 'Pool', 'Spa', 'Restaurant', 'Beach Access'],
        type: 'resort',
        isPopular: true,
        location: {'lat': 36.3932, 'lng': 25.4615},
        activities: [
          const Activity(
            id: 'a1',
            name: 'Sunset Cruise',
            description: 'Sail around the caldera during golden hour',
            imageUrl: 'https://picsum.photos/400/300?random=310',
            price: 120,
            duration: Duration(hours: 3),
            rating: 4.9,
            category: 'cruise',
          ),
        ],
        weather: const WeatherCondition(
          condition: 'Sunny',
          temperature: 28,
          icon: LiqMaterialIcons.wbSunnyOutlined,
        ),
      ),
      Destination(
        id: '2',
        name: 'Bali Retreat',
        country: 'Indonesia',
        description: 'Discover the tropical paradise of Bali with lush landscapes, ancient temples, and pristine beaches.',
        images: [
          'https://picsum.photos/800/600?random=303',
          'https://picsum.photos/800/600?random=304',
          'https://picsum.photos/800/600?random=305',
        ],
        rating: 4.7,
        reviews: 2345,
        pricePerNight: 180,
        amenities: ['WiFi', 'Pool', 'Yoga', 'Restaurant', 'Spa'],
        type: 'villa',
        isFavorite: true,
        location: {'lat': -8.4095, 'lng': 115.1889},
        weather: const WeatherCondition(
          condition: 'Partly Cloudy',
          temperature: 30,
          icon: LiqMaterialIcons.cloudOutlined,
        ),
      ),
      Destination(
        id: '3',
        name: 'Swiss Alpine Lodge',
        country: 'Switzerland',
        description: 'Nestled in the Swiss Alps, enjoy skiing, hiking, and breathtaking mountain views.',
        images: [
          'https://picsum.photos/800/600?random=306',
          'https://picsum.photos/800/600?random=307',
          'https://picsum.photos/800/600?random=308',
        ],
        rating: 4.9,
        reviews: 890,
        pricePerNight: 350,
        amenities: ['WiFi', 'Ski Access', 'Fireplace', 'Restaurant', 'Spa'],
        type: 'hotel',
        isPopular: true,
        location: {'lat': 46.8182, 'lng': 8.2275},
        weather: const WeatherCondition(
          condition: 'Snowy',
          temperature: -2,
          icon: LiqMaterialIcons.acUnitOutlined,
        ),
      ),
      Destination(
        id: '4',
        name: 'Maldives Overwater Villa',
        country: 'Maldives',
        description: 'Stay in luxury overwater villas with direct ocean access and world-class diving.',
        images: [
          'https://picsum.photos/800/600?random=309',
          'https://picsum.photos/800/600?random=310',
          'https://picsum.photos/800/600?random=311',
        ],
        rating: 4.9,
        reviews: 567,
        pricePerNight: 800,
        amenities: ['WiFi', 'Private Pool', 'Diving', 'Restaurant', 'Spa', 'Butler Service'],
        type: 'resort',
        location: {'lat': 3.2028, 'lng': 73.2207},
        weather: const WeatherCondition(
          condition: 'Sunny',
          temperature: 31,
          icon: LiqMaterialIcons.beachAccessOutlined,
        ),
      ),
      Destination(
        id: '5',
        name: 'Tokyo City Hotel',
        country: 'Japan',
        description: 'Experience the perfect blend of tradition and modernity in the heart of Tokyo.',
        images: [
          'https://picsum.photos/800/600?random=312',
          'https://picsum.photos/800/600?random=313',
          'https://picsum.photos/800/600?random=314',
        ],
        rating: 4.6,
        reviews: 1567,
        pricePerNight: 220,
        amenities: ['WiFi', 'Gym', 'Restaurant', 'Business Center', 'Concierge'],
        type: 'hotel',
        isFavorite: true,
        location: {'lat': 35.6762, 'lng': 139.6503},
        weather: const WeatherCondition(
          condition: 'Clear',
          temperature: 22,
          icon: LiqMaterialIcons.localFloristOutlined,
        ),
      ),
    ];
  }

  static List<TravelPackage> generatePackages() {
    return [
      TravelPackage(
        id: 'p1',
        name: 'Greek Island Hopping',
        description: '7 days exploring the most beautiful Greek islands',
        destination: generateDestinations()[0],
        inclusions: [
          'Round-trip flights',
          'Hotel accommodation',
          'Daily breakfast',
          'Island transfers',
          'Guided tours',
        ],
        price: 2499,
        days: 7,
        nights: 6,
        imageUrl: 'https://picsum.photos/400/300?random=320',
        isAllInclusive: true,
      ),
      TravelPackage(
        id: 'p2',
        name: 'Bali Adventure Package',
        description: '5 days of adventure and relaxation in Bali',
        destination: generateDestinations()[1],
        inclusions: [
          'Airport transfers',
          'Villa accommodation',
          'Temple tours',
          'Surfing lessons',
          'Spa treatment',
        ],
        price: 1799,
        days: 5,
        nights: 4,
        imageUrl: 'https://picsum.photos/400/300?random=321',
      ),
    ];
  }

  static List<String> popularSearches = [
    'Beach Resorts',
    'Mountain Retreats',
    'City Breaks',
    'All Inclusive',
    'Honeymoon',
    'Family Friendly',
    'Adventure',
    'Luxury',
  ];
}