part of 'listings_bloc.dart';

abstract class ListingsEvent extends Equatable {
  const ListingsEvent();

  @override
  List<Object> get props => [];
}

class LoadListings extends ListingsEvent {}

class SearchListings extends ListingsEvent {
  final String query;

  const SearchListings(this.query);

  @override
  List<Object> get props => [query];
}