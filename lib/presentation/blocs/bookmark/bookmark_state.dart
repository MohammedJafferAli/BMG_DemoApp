part of 'bookmark_bloc.dart';

abstract class BookmarkState extends Equatable {
  const BookmarkState();

  @override
  List<Object> get props => [];
}

class BookmarkInitial extends BookmarkState {}

class BookmarksLoaded extends BookmarkState {
  final List<Bookmark> bookmarks;

  const BookmarksLoaded(this.bookmarks);

  @override
  List<Object> get props => [bookmarks];
}