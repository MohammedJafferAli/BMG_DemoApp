import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/listing.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/bookmark/bookmark_bloc.dart';

class BookmarkButton extends StatelessWidget {
  final Listing listing;
  final Color? color;
  final double? size;

  const BookmarkButton({
    super.key,
    required this.listing,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, bookmarkState) {
        final isBookmarked = context.read<BookmarkBloc>().isBookmarked(listing.id);
        
        return IconButton(
          onPressed: () => _toggleBookmark(context),
          icon: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: isBookmarked ? AppColors.primary : (color ?? AppColors.textSecondary),
            size: size ?? 24,
          ),
        );
      },
    );
  }

  void _toggleBookmark(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to bookmark listings')),
      );
      return;
    }

    final bookmarkBloc = context.read<BookmarkBloc>();
    final isBookmarked = bookmarkBloc.isBookmarked(listing.id);

    if (isBookmarked) {
      bookmarkBloc.add(RemoveBookmark(listingId: listing.id));
    } else {
      bookmarkBloc.add(AddBookmark(userId: authState.user.id, listing: listing));
    }
  }
}