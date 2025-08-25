part of 'bookmark_bloc.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object> get props => [];
}

class LoadBookmarks extends BookmarkEvent {}

class AddBookmark extends BookmarkEvent {
  final String userId;
  final Listing listing;

  const AddBookmark({required this.userId, required this.listing});

  @override
  List<Object> get props => [userId, listing];
}

class RemoveBookmark extends BookmarkEvent {
  final String listingId;

  const RemoveBookmark({required this.listingId});

  @override
  List<Object> get props => [listingId];
}