import 'package:dio/dio.dart';
import '../models/listing_model.dart';

final List<ListingModel> _mockListings = [
  // Mumbai
  const ListingModel(id: '1', title: 'Luxury Apartment in Bandra', description: 'Modern apartment with sea view', location: 'Mumbai', price: 4500, images: ['https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=400'], rating: 4.8, reviewCount: 124, hostId: 'host1', hostName: 'Rajesh Kumar', amenities: ['WiFi', 'AC', 'Kitchen'], maxGuests: 4, isAvailable: true),
  const ListingModel(id: '2', title: 'Cozy Studio in Andheri', description: 'Perfect for business travelers', location: 'Mumbai', price: 2800, images: ['https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=400'], rating: 4.5, reviewCount: 89, hostId: 'host2', hostName: 'Priya Sharma', amenities: ['WiFi', 'AC', 'Kitchen'], maxGuests: 2, isAvailable: true),
  const ListingModel(id: '3', title: 'Premium Hotel in Colaba', description: 'Heritage hotel near Gateway of India', location: 'Mumbai', price: 6500, images: ['https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=400'], rating: 4.9, reviewCount: 156, hostId: 'host3', hostName: 'Heritage Hotels', amenities: ['WiFi', 'Restaurant', 'Spa'], maxGuests: 6, isAvailable: true),
  const ListingModel(id: '4', title: 'Boutique Stay in Juhu', description: 'Beach-side boutique hotel', location: 'Mumbai', price: 5200, images: ['https://images.unsplash.com/photo-1578683010236-d716f9a3f461?w=400'], rating: 4.7, reviewCount: 98, hostId: 'host4', hostName: 'Coastal Stays', amenities: ['WiFi', 'Pool', 'Beach Access'], maxGuests: 4, isAvailable: true),
  const ListingModel(id: '5', title: 'Business Hotel in BKC', description: 'Modern hotel in business district', location: 'Mumbai', price: 3800, images: ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400'], rating: 4.6, reviewCount: 67, hostId: 'host5', hostName: 'Business Hotels', amenities: ['WiFi', 'Gym', 'Conference Room'], maxGuests: 3, isAvailable: true),
  // Delhi
  const ListingModel(id: '6', title: 'Luxury Suite in CP', description: 'Premium suite in Connaught Place', location: 'Delhi', price: 5500, images: ['https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400'], rating: 4.8, reviewCount: 142, hostId: 'host6', hostName: 'Capital Stays', amenities: ['WiFi', 'AC', 'Room Service'], maxGuests: 4, isAvailable: true),
  const ListingModel(id: '7', title: 'Heritage Haveli in Old Delhi', description: 'Traditional haveli experience', location: 'Delhi', price: 4200, images: ['https://images.unsplash.com/photo-1590490360182-c33d57733427?w=400'], rating: 4.7, reviewCount: 89, hostId: 'host7', hostName: 'Heritage Homes', amenities: ['WiFi', 'Traditional Decor', 'Courtyard'], maxGuests: 6, isAvailable: true),
  const ListingModel(id: '8', title: 'Modern Apartment in Gurgaon', description: 'Contemporary living space', location: 'Delhi', price: 3200, images: ['https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=400'], rating: 4.5, reviewCount: 76, hostId: 'host8', hostName: 'Metro Stays', amenities: ['WiFi', 'AC', 'Kitchen'], maxGuests: 3, isAvailable: true),
  const ListingModel(id: '9', title: 'Boutique Hotel in Khan Market', description: 'Stylish hotel in upscale area', location: 'Delhi', price: 4800, images: ['https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=400'], rating: 4.6, reviewCount: 103, hostId: 'host9', hostName: 'Boutique Collection', amenities: ['WiFi', 'Restaurant', 'Spa'], maxGuests: 4, isAvailable: true),
  const ListingModel(id: '10', title: 'Airport Hotel in Aerocity', description: 'Convenient for travelers', location: 'Delhi', price: 3600, images: ['https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=400'], rating: 4.4, reviewCount: 54, hostId: 'host10', hostName: 'Airport Hotels', amenities: ['WiFi', 'Airport Shuttle', 'Gym'], maxGuests: 2, isAvailable: true),
  // Goa
  const ListingModel(id: '11', title: 'Beach Villa in Calangute', description: 'Luxury villa steps from beach', location: 'Goa', price: 7500, images: ['https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=400'], rating: 4.9, reviewCount: 187, hostId: 'host11', hostName: 'Beach Villas', amenities: ['WiFi', 'Pool', 'Beach Access'], maxGuests: 8, isAvailable: true),
  const ListingModel(id: '12', title: 'Portuguese House in Fontainhas', description: 'Heritage Portuguese architecture', location: 'Goa', price: 4500, images: ['https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?w=400'], rating: 4.7, reviewCount: 92, hostId: 'host12', hostName: 'Heritage Goa', amenities: ['WiFi', 'Traditional Decor', 'Balcony'], maxGuests: 4, isAvailable: true),
  const ListingModel(id: '13', title: 'Beach Shack in Arambol', description: 'Rustic beach experience', location: 'Goa', price: 2200, images: ['https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=400'], rating: 4.3, reviewCount: 45, hostId: 'host13', hostName: 'Beach Shacks', amenities: ['WiFi', 'Beach Access', 'Hammock'], maxGuests: 2, isAvailable: true),
  const ListingModel(id: '14', title: 'Luxury Resort in Candolim', description: 'Premium resort experience', location: 'Goa', price: 9200, images: ['https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400'], rating: 4.8, reviewCount: 234, hostId: 'host14', hostName: 'Luxury Resorts', amenities: ['WiFi', 'Pool', 'Spa', 'Restaurant'], maxGuests: 6, isAvailable: true),
  const ListingModel(id: '15', title: 'Cozy Cottage in Anjuna', description: 'Peaceful retreat near beach', location: 'Goa', price: 3800, images: ['https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=400'], rating: 4.6, reviewCount: 78, hostId: 'host15', hostName: 'Cottage Stays', amenities: ['WiFi', 'Garden', 'Kitchen'], maxGuests: 4, isAvailable: true),
  // Jaipur
  const ListingModel(id: '16', title: 'Palace Hotel in City Palace', description: 'Royal palace experience', location: 'Jaipur', price: 12000, images: ['https://images.unsplash.com/photo-1599661046827-dacde6976549?w=400'], rating: 4.9, reviewCount: 298, hostId: 'host16', hostName: 'Royal Palaces', amenities: ['WiFi', 'Restaurant', 'Spa', 'Heritage'], maxGuests: 8, isAvailable: true),
  const ListingModel(id: '17', title: 'Haveli in Pink City', description: 'Traditional Rajasthani haveli', location: 'Jaipur', price: 5500, images: ['https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400'], rating: 4.7, reviewCount: 134, hostId: 'host17', hostName: 'Pink City Stays', amenities: ['WiFi', 'Courtyard', 'Traditional Decor'], maxGuests: 6, isAvailable: true),
  const ListingModel(id: '18', title: 'Modern Hotel in Malviya Nagar', description: 'Contemporary comfort', location: 'Jaipur', price: 3200, images: ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400'], rating: 4.4, reviewCount: 67, hostId: 'host18', hostName: 'Modern Stays', amenities: ['WiFi', 'AC', 'Restaurant'], maxGuests: 4, isAvailable: true),
  const ListingModel(id: '19', title: 'Desert Camp near Jaipur', description: 'Unique desert experience', location: 'Jaipur', price: 4800, images: ['https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=400'], rating: 4.5, reviewCount: 89, hostId: 'host19', hostName: 'Desert Camps', amenities: ['WiFi', 'Camel Safari', 'Bonfire'], maxGuests: 4, isAvailable: true),
  const ListingModel(id: '20', title: 'Boutique Stay in Bani Park', description: 'Charming boutique hotel', location: 'Jaipur', price: 4200, images: ['https://images.unsplash.com/photo-1578683010236-d716f9a3f461?w=400'], rating: 4.6, reviewCount: 92, hostId: 'host20', hostName: 'Boutique Jaipur', amenities: ['WiFi', 'Pool', 'Garden'], maxGuests: 3, isAvailable: true),
  // Kerala
  const ListingModel(id: '21', title: 'Houseboat in Alleppey', description: 'Traditional Kerala houseboat', location: 'Kerala', price: 6500, images: ['https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=400'], rating: 4.8, reviewCount: 156, hostId: 'host21', hostName: 'Backwater Cruises', amenities: ['WiFi', 'Traditional Meals', 'Scenic Views'], maxGuests: 4, isAvailable: true),
  const ListingModel(id: '22', title: 'Tree House in Wayanad', description: 'Unique tree house experience', location: 'Kerala', price: 4800, images: ['https://images.unsplash.com/photo-1520637836862-4d197d17c90a?w=400'], rating: 4.7, reviewCount: 89, hostId: 'host22', hostName: 'Tree Houses', amenities: ['WiFi', 'Nature Views', 'Adventure'], maxGuests: 2, isAvailable: true),
  const ListingModel(id: '23', title: 'Beach Resort in Kovalam', description: 'Luxury beach resort', location: 'Kerala', price: 8200, images: ['https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?w=400'], rating: 4.9, reviewCount: 203, hostId: 'host23', hostName: 'Beach Resorts', amenities: ['WiFi', 'Pool', 'Spa', 'Beach Access'], maxGuests: 6, isAvailable: true),
  const ListingModel(id: '24', title: 'Plantation Stay in Munnar', description: 'Tea plantation experience', location: 'Kerala', price: 3800, images: ['https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400'], rating: 4.6, reviewCount: 112, hostId: 'host24', hostName: 'Plantation Stays', amenities: ['WiFi', 'Tea Tours', 'Mountain Views'], maxGuests: 4, isAvailable: true),
  const ListingModel(id: '25', title: 'Heritage Home in Kochi', description: 'Colonial heritage home', location: 'Kerala', price: 4500, images: ['https://images.unsplash.com/photo-1590490360182-c33d57733427?w=400'], rating: 4.5, reviewCount: 78, hostId: 'host25', hostName: 'Heritage Kerala', amenities: ['WiFi', 'Heritage Architecture', 'Garden'], maxGuests: 5, isAvailable: true),
  // Agra
  const ListingModel(id: '26', title: 'Hotel with Taj View', description: 'Stunning views of Taj Mahal', location: 'Agra', price: 7500, images: ['https://images.unsplash.com/photo-1564507592333-c60657eea523?w=400'], rating: 4.8, reviewCount: 187, hostId: 'host26', hostName: 'Taj View Hotels', amenities: ['WiFi', 'Taj View', 'Restaurant'], maxGuests: 4, isAvailable: true),
  const ListingModel(id: '27', title: 'Heritage Hotel near Red Fort', description: 'Mughal era inspired hotel', location: 'Agra', price: 5200, images: ['https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=400'], rating: 4.6, reviewCount: 134, hostId: 'host27', hostName: 'Mughal Heritage', amenities: ['WiFi', 'Heritage Decor', 'Garden'], maxGuests: 6, isAvailable: true),
  const ListingModel(id: '28', title: 'Budget Stay in Sadar Bazaar', description: 'Affordable comfort', location: 'Agra', price: 1800, images: ['https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=400'], rating: 4.2, reviewCount: 45, hostId: 'host28', hostName: 'Budget Stays', amenities: ['WiFi', 'AC', 'Market Access'], maxGuests: 2, isAvailable: true),
  const ListingModel(id: '29', title: 'Luxury Resort in Agra', description: 'Premium resort experience', location: 'Agra', price: 9500, images: ['https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400'], rating: 4.7, reviewCount: 156, hostId: 'host29', hostName: 'Luxury Agra', amenities: ['WiFi', 'Pool', 'Spa', 'Fine Dining'], maxGuests: 8, isAvailable: true),
  const ListingModel(id: '30', title: 'Boutique Stay near Mehtab Bagh', description: 'Peaceful garden views', location: 'Agra', price: 4200, images: ['https://images.unsplash.com/photo-1578683010236-d716f9a3f461?w=400'], rating: 4.5, reviewCount: 89, hostId: 'host30', hostName: 'Garden Views', amenities: ['WiFi', 'Garden', 'Peaceful'], maxGuests: 3, isAvailable: true),
];

abstract class ListingsDataSource {
  Future<List<ListingModel>> getListings();
  Future<ListingModel> getListingById(String id);
  Future<List<ListingModel>> getListingsByCity(String city);
}

class ListingsDataSourceImpl implements ListingsDataSource {
  final Dio dio;

  ListingsDataSourceImpl(this.dio);

  @override
  Future<List<ListingModel>> getListings() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockListings;
  }

  @override
  Future<ListingModel> getListingById(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    final listings = await getListings();
    return listings.firstWhere((listing) => listing.id == id);
  }

  @override
  Future<List<ListingModel>> getListingsByCity(String city) async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockListings.where((listing) => listing.location.toLowerCase().contains(city.toLowerCase())).toList();
  }
}