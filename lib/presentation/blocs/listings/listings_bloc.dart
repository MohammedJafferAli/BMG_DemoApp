import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/listing.dart';
import '../../../domain/usecases/listings/get_listings_usecase.dart';
import '../../../domain/usecases/usecase.dart';

part 'listings_event.dart';
part 'listings_state.dart';

class ListingsBloc extends Bloc<ListingsEvent, ListingsState> {
  final GetListingsUseCase _getListingsUseCase;

  ListingsBloc(this._getListingsUseCase) : super(ListingsInitial()) {
    on<LoadListings>(_onLoadListings);
    on<SearchListings>(_onSearchListings);
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
      final filteredListings = listings
          .where((listing) =>
              listing.title.toLowerCase().contains(event.query.toLowerCase()) ||
              listing.location.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(ListingsLoaded(filteredListings));
    } catch (e) {
      emit(ListingsError(e.toString()));
    }
  }
}