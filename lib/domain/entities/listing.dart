import 'package:equatable/equatable.dart';

class Listing extends Equatable {
  final String id;
  final String title;
  final String description;
  final String location;
  final double price;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final String hostId;
  final String hostName;
  final List<String> amenities;
  final int maxGuests;
  final bool isAvailable;

  const Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.price,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.hostId,
    required this.hostName,
    required this.amenities,
    required this.maxGuests,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        location,
        price,
        images,
        rating,
        reviewCount,
        hostId,
        hostName,
        amenities,
        maxGuests,
        isAvailable,
      ];
}