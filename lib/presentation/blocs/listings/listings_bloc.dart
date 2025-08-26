import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/services/location_service.dart';
import '../../../domain/entities/listing.dart';
import '../../../domain/entities/search_filters.dart';
import '../../../domain/usecases/listings/get_listings_usecase.dart';
import '../../../domain/usecases/usecase.dart';

part 'listings_event.dart';
part 'listings_state.dart';

class ListingsBloc extends Bloc<ListingsEvent, ListingsState> {
  final GetListingsUseCase _getListingsUseCase;

  ListingsBloc(this._getListingsUseCase) : super(ListingsInitial()) {
    on<LoadListings>(_onLoadListings);
    on<SearchListings>(_onSearchListings);
    on<FilterListings>(_onFilterListings);
  }

  Future<void> _onLoadListings(
    LoadListings event,
    Emitter<ListingsState> emit,
  ) async {
    emit(ListingsLoading());
    try {
      final listings = await _getListingsUseCase(NoParams());
      emit(ListingsLoaded(listings));
    } catch (e) {
      emit(ListingsError(e.toString()));
    }
  }

  Future<void> _onSearchListings(
    SearchListings event,
    Emitter<ListingsState> emit,
  ) async {
    emit(ListingsLoading());
    try {
      final listings = await _getListingsUseCase(NoParams());
      final filteredListings = _performComprehensiveSearch(listings, event.query);
      emit(ListingsLoaded(filteredListings));
    } catch (e) {
      emit(ListingsError(e.toString()));
    }
  }

  List<Listing> _performComprehensiveSearch(List<Listing> listings, String query) {
    if (query.isEmpty) return listings;
    
    final searchTerms = query.toLowerCase().split(' ').where((term) => term.isNotEmpty).toList();
    
    return listings.where((listing) {
      // Create searchable content from all relevant fields
      final searchableContent = [
        listing.title,
        listing.location,
        listing.description,
        listing.hostName,
        ...listing.amenities,
      ].join(' ').toLowerCase();
      
      // Check if all search terms are found in the searchable content
      return searchTerms.every((term) => 
        searchableContent.contains(term) ||
        _matchesSpecialCriteria(listing, term)
      );
    }).toList();
  }
  
  bool _matchesSpecialCriteria(Listing listing, String term) {
    // Price-related searches
    if (term.contains('cheap') || term.contains('budget')) {
      return listing.price < 2000;
    }
    if (term.contains('expensive') || term.contains('luxury') || term.contains('premium')) {
      return listing.price > 5000;
    }
    
    // Rating-related searches
    if (term.contains('highly rated') || term.contains('top rated') || term.contains('best')) {
      return listing.rating >= 4.5;
    }
    if (term.contains('good rating')) {
      return listing.rating >= 4.0;
    }
    
    // Capacity-related searches
    if (term.contains('large') || term.contains('big') || term.contains('spacious')) {
      return listing.maxGuests >= 4;
    }
    if (term.contains('small') || term.contains('cozy') || term.contains('intimate')) {
      return listing.maxGuests <= 2;
    }
    
    // Accommodation type searches
    if (term.contains('couple') || term.contains('romantic')) {
      return listing.maxGuests >= 2 && 
             (listing.title.toLowerCase().contains('couple') ||
              listing.description.toLowerCase().contains('romantic') ||
              listing.amenities.any((amenity) => 
                amenity.toLowerCase().contains('couple') ||
                amenity.toLowerCase().contains('romantic')));
    }
    
    if (term.contains('family')) {
      return listing.maxGuests >= 3;
    }
    
    if (term.contains('group') || term.contains('friends')) {
      return listing.maxGuests >= 4;
    }
    
    // Availability searches
    if (term.contains('available') || term.contains('free')) {
      return listing.isAvailable;
    }
    
    return false;
  }

  Future<void> _onFilterListings(
    FilterListings event,
    Emitter<ListingsState> emit,
  ) async {
    emit(ListingsLoading());
    try {
      final listings = await _getListingsUseCase(NoParams());
      final filteredListings = _applyFilters(listings, event.filters);
      emit(ListingsLoaded(filteredListings));
    } catch (e) {
      emit(ListingsError(e.toString()));
    }
  }

  List<Listing> _applyFilters(List<Listing> listings, SearchFilters filters) {
    return listings.where((listing) {
      // Price filter
      if (filters.minPrice != null && listing.price < filters.minPrice!) {
        return false;
      }
      if (filters.maxPrice != null && listing.price > filters.maxPrice!) {
        return false;
      }
      
      // Rating filter
      if (filters.minRating != null && listing.rating < filters.minRating!) {
        return false;
      }
      
      // Location radius filter
      if (filters.radiusKm != null && 
          filters.userLat != null && 
          filters.userLon != null) {
        final distance = LocationService.calculateDistance(
          filters.userLat!, 
          filters.userLon!, 
          _getListingLat(listing), 
          _getListingLon(listing)
        );
        if (distance > filters.radiusKm!) {
          return false;
        }
      }
      
      // Accommodation type filter
      if (filters.accommodationType != AccommodationType.all) {
        if (!_matchesAccommodationType(listing, filters.accommodationType)) {
          return false;
        }
      }
      
      return true;
    }).toList();
  }

  double _getListingLat(Listing listing) {
    // Mock coordinates for demo - in real app, get from listing data
    switch (listing.location) {
      case 'Mumbai': return 19.0760;
      case 'Delhi': return 28.7041;
      case 'Goa': return 15.2993;
      case 'Jaipur': return 26.9124;
      case 'Kerala': return 10.8505;
      case 'Agra': return 27.1767;
      default: return 20.5937;
    }
  }

  double _getListingLon(Listing listing) {
    // Mock coordinates for demo - in real app, get from listing data
    switch (listing.location) {
      case 'Mumbai': return 72.8777;
      case 'Delhi': return 77.1025;
      case 'Goa': return 74.1240;
      case 'Jaipur': return 75.7873;
      case 'Kerala': return 76.2711;
      case 'Agra': return 78.0081;
      default: return 78.9629;
    }
  }

  bool _matchesAccommodationType(Listing listing, AccommodationType type) {
    final searchableContent = [
      listing.title,
      listing.description,
      ...listing.amenities,
    ].join(' ').toLowerCase();
    
    switch (type) {
      case AccommodationType.boys:
        return searchableContent.contains('boys') || 
               searchableContent.contains('male') ||
               searchableContent.contains('men only');
      case AccommodationType.girls:
        return searchableContent.contains('girls') || 
               searchableContent.contains('female') || 
               searchableContent.contains('women') ||
               searchableContent.contains('ladies only');
      case AccommodationType.couple:
        return searchableContent.contains('couple') || 
               searchableContent.contains('romantic') || 
               (listing.maxGuests >= 2 && !searchableContent.contains('dorm'));
      case AccommodationType.dorms:
        return searchableContent.contains('dorm') || 
               searchableContent.contains('shared') || 
               searchableContent.contains('bunk') ||
               listing.maxGuests > 4;
      default:
        return true;
    }
  }
}