import '../../domain/entities/listing.dart';
import '../../domain/repositories/listings_repository.dart';
import '../datasources/listings_datasource.dart';

class ListingsRepositoryImpl implements ListingsRepository {
  final ListingsDataSource dataSource;

  ListingsRepositoryImpl(this.dataSource);

  @override
  Future<List<Listing>> getListings() async {
    final listingModels = await dataSource.getListings();
    return listingModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Listing> getListingById(String id) async {
    final listingModel = await dataSource.getListingById(id);
    return listingModel.toEntity();
  }
}