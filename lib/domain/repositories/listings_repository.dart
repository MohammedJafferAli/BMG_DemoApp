import '../entities/listing.dart';

abstract class ListingsRepository {
  Future<List<Listing>> getListings();
  Future<Listing> getListingById(String id);
  Future<List<Listing>> getListingsByCity(String city);
}