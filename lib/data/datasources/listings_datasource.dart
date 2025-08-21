import 'package:dio/dio.dart';
import '../models/listing_model.dart';

abstract class ListingsDataSource {
  Future<List<ListingModel>> getListings();
  Future<ListingModel> getListingById(String id);
}

class ListingsDataSourceImpl implements ListingsDataSource {
  final Dio dio;

  ListingsDataSourceImpl(this.dio);

  @override
  Future<List<ListingModel>> getListings() async {
    // Mock implementation - replace with actual API calls
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      const ListingModel(
        id: '1',
        title: 'Luxury Villa in Goa',
        description: 'Beautiful beachfront villa with stunning ocean views',
        location: 'Goa, India',
        price: 5000,
        images: ['https://example.com/image1.jpg'],
        rating: 4.8,
        reviewCount: 124,
        hostId: 'host1',
        hostName: 'Rajesh Kumar',
        amenities: ['WiFi', 'Pool', 'Beach Access', 'Kitchen'],
        maxGuests: 6,
        isAvailable: true,
      ),
      const ListingModel(
        id: '2',
        title: 'Cozy Apartment in Mumbai',
        description: 'Modern apartment in the heart of the city',
        location: 'Mumbai, India',
        price: 3000,
        images: ['https://example.com/image2.jpg'],
        rating: 4.5,
        reviewCount: 89,
        hostId: 'host2',
        hostName: 'Priya Sharma',
        amenities: ['WiFi', 'AC', 'Kitchen', 'Parking'],
        maxGuests: 4,
        isAvailable: true,
      ),
      const ListingModel(
        id: '3',
        title: 'Heritage Hotel in Rajasthan',
        description: 'Experience royal living in this heritage property',
        location: 'Jaipur, Rajasthan',
        price: 8000,
        images: ['https://example.com/image3.jpg'],
        rating: 4.9,
        reviewCount: 156,
        hostId: 'host3',
        hostName: 'Maharaja Hotels',
        amenities: ['WiFi', 'Restaurant', 'Spa', 'Pool'],
        maxGuests: 8,
        isAvailable: true,
      ),
    ];
  }

  @override
  Future<ListingModel> getListingById(String id) async {
    // Mock implementation - replace with actual API calls
    await Future.delayed(const Duration(seconds: 1));
    final listings = await getListings();
    return listings.firstWhere((listing) => listing.id == id);
  }
}