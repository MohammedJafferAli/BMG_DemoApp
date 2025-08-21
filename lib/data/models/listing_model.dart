import '../../domain/entities/listing.dart';

class ListingModel {
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

  const ListingModel({
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

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      price: json['price'].toDouble(),
      images: List<String>.from(json['images']),
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      hostId: json['hostId'],
      hostName: json['hostName'],
      amenities: List<String>.from(json['amenities']),
      maxGuests: json['maxGuests'],
      isAvailable: json['isAvailable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'price': price,
      'images': images,
      'rating': rating,
      'reviewCount': reviewCount,
      'hostId': hostId,
      'hostName': hostName,
      'amenities': amenities,
      'maxGuests': maxGuests,
      'isAvailable': isAvailable,
    };
  }

  Listing toEntity() {
    return Listing(
      id: id,
      title: title,
      description: description,
      location: location,
      price: price,
      images: images,
      rating: rating,
      reviewCount: reviewCount,
      hostId: hostId,
      hostName: hostName,
      amenities: amenities,
      maxGuests: maxGuests,
      isAvailable: isAvailable,
    );
  }
}