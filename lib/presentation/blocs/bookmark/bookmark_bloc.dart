import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/bookmark.dart';
import '../../../domain/entities/listing.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final List<Bookmark> _bookmarks = [];

  BookmarkBloc() : super(BookmarkInitial()) {
    on<LoadBookmarks>(_onLoadBookmarks);
    on<AddBookmark>(_onAddBookmark);
    on<RemoveBookmark>(_onRemoveBookmark);
  }

  void _onLoadBookmarks(LoadBookmarks event, Emitter<BookmarkState> emit) {
    emit(BookmarksLoaded(_bookmarks));
  }

  void _onAddBookmark(AddBookmark event, Emitter<BookmarkState> emit) {
    final bookmark = Bookmark(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: event.userId,
      listing: event.listing,
      createdAt: DateTime.now(),
    );
    _bookmarks.add(bookmark);
    emit(BookmarksLoaded(_bookmarks));
  }

  void _onRemoveBookmark(RemoveBookmark event, Emitter<BookmarkState> emit) {
    _bookmarks.removeWhere((b) => b.listing.id == event.listingId);
    emit(BookmarksLoaded(_bookmarks));
  }

  bool isBookmarked(String listingId) {
    return _bookmarks.any((b) => b.listing.id == listingId);
  }
}