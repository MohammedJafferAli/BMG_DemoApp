import 'package:equatable/equatable.dart';

enum AccommodationType { all, boys, girls, couple, dorms }

class SearchFilters extends Equatable {
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final int? radiusKm;
  final double? userLat;
  final double? userLon;
  final AccommodationType accommodationType;

  const SearchFilters({
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.radiusKm,
    this.userLat,
    this.userLon,
    this.accommodationType = AccommodationType.all,
  });

  SearchFilters copyWith({
    double? minPrice,
    double? maxPrice,
    double? minRating,
    int? radiusKm,
    double? userLat,
    double? userLon,
    AccommodationType? accommodationType,
  }) {
    return SearchFilters(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      radiusKm: radiusKm ?? this.radiusKm,
      userLat: userLat ?? this.userLat,
      userLon: userLon ?? this.userLon,
      accommodationType: accommodationType ?? this.accommodationType,
    );
  }

  @override
  List<Object?> get props => [
    minPrice, maxPrice, minRating, radiusKm, 
    userLat, userLon, accommodationType
  ];
}