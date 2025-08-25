import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class FavoritesButton extends StatefulWidget {
  final String listingId;
  final bool initialIsFavorite;

  const FavoritesButton({
    super.key,
    required this.listingId,
    this.initialIsFavorite = false,
  });

  @override
  State<FavoritesButton> createState() => _FavoritesButtonState();
}

class _FavoritesButtonState extends State<FavoritesButton> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initialIsFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _toggleFavorite,
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite ? Colors.red : AppColors.textSecondary,
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    // TODO: Implement favorites logic with backend
  }
}