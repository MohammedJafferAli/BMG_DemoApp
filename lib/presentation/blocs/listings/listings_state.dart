part of 'listings_bloc.dart';

abstract class ListingsState extends Equatable {
  const ListingsState();

  @override
  List<Object> get props => [];
}

class ListingsInitial extends ListingsState {}

class ListingsLoading extends ListingsState {}

class ListingsLoaded extends ListingsState {
  final List<Listing> listings;

  const ListingsLoaded(this.listings);

  @override
  List<Object> get props => [listings];
}

class ListingsError extends ListingsState {
  final String message;

  const ListingsError(this.message);

  @override
  List<Object> get props => [message];
}