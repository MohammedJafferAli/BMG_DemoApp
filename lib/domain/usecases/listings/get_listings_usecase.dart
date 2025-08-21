import '../../entities/listing.dart';
import '../../repositories/listings_repository.dart';
import '../usecase.dart';

class GetListingsUseCase implements UseCase<List<Listing>, NoParams> {
  final ListingsRepository repository;

  GetListingsUseCase(this.repository);

  @override
  Future<List<Listing>> call(NoParams params) async {
    return await repository.getListings();
  }
}