import 'package:equatable/equatable.dart';
import 'listing.dart';

class Bookmark extends Equatable {
  final String id;
  final String userId;
  final Listing listing;
  final DateTime createdAt;

  const Bookmark({
    required this.id,
    required this.userId,
    required this.listing,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, userId, listing, createdAt];
}