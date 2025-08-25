import '../../../domain/entities/listing.dart';

class AIRecommendationsService {
  static final AIRecommendationsService _instance = AIRecommendationsService._internal();
  factory AIRecommendationsService() => _instance;
  AIRecommendationsService._internal();

  List<Listing> getPersonalizedRecommendations(
    List<Listing> allListings,
    Map<String, dynamic> userPreferences,
  ) {
    final recommendations = <Listing>[];
    
    // Mock AI logic - in real app, use ML models
    for (final listing in allListings) {
      double score = _calculateRecommendationScore(listing, userPreferences);
      if (score > 0.7) {
        recommendations.add(listing);
      }
    }
    
    recommendations.sort((a, b) => 
      _calculateRecommendationScore(b, userPreferences)
          .compareTo(_calculateRecommendationScore(a, userPreferences)));
    
    return recommendations.take(10).toList();
  }

  double _calculateRecommendationScore(Listing listing, Map<String, dynamic> preferences) {
    double score = 0.0;
    
    // Price preference
    final preferredPrice = preferences['maxPrice'] ?? 10000.0;
    if (listing.price <= preferredPrice) {
      score += 0.3;
    }
    
    // Rating preference
    if (listing.rating >= 4.0) {
      score += 0.2;
    }
    
    // Amenities match
    final preferredAmenities = preferences['amenities'] as List<String>? ?? [];
    final matchingAmenities = listing.amenities
        .where((amenity) => preferredAmenities.contains(amenity))
        .length;
    score += (matchingAmenities / preferredAmenities.length) * 0.3;
    
    // Location preference
    final preferredLocation = preferences['location'] as String?;
    if (preferredLocation != null && 
        listing.location.toLowerCase().contains(preferredLocation.toLowerCase())) {
      score += 0.2;
    }
    
    return score;
  }

  List<Listing> getTrendingStays(List<Listing> allListings) {
    // Mock trending logic
    return allListings
        .where((listing) => listing.rating >= 4.5 && listing.reviewCount > 50)
        .take(5)
        .toList();
  }

  List<String> getPopularDestinations() {
    return [
      'Mumbai',
      'Delhi',
      'Bangalore',
      'Goa',
      'Jaipur',
      'Kerala',
      'Agra',
      'Udaipur',
    ];
  }

  List<Listing> getSimilarHotels(Listing selectedListing, List<Listing> allListings) {
    return allListings
        .where((listing) => 
            listing.id != selectedListing.id &&
            (listing.price - selectedListing.price).abs() <= 1000 &&
            listing.location == selectedListing.location)
        .take(3)
        .toList();
  }
}