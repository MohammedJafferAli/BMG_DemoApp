import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive_utils.dart';

class ReviewsSection extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  final List<Review> reviews;

  const ReviewsSection({
    super.key,
    required this.averageRating,
    required this.totalReviews,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Reviews',
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(context, mobile: 18),
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            RatingBarIndicator(
              rating: averageRating,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: AppColors.rating,
              ),
              itemCount: 5,
              itemSize: ResponsiveUtils.iconSize(context, mobile: 16),
            ),
            SizedBox(width: ResponsiveUtils.spacing(context, mobile: 8)),
            Text('$averageRating ($totalReviews)'),
          ],
        ),
        SizedBox(height: ResponsiveUtils.spacing(context)),
        
        // Rating breakdown
        _buildRatingBreakdown(),
        
        SizedBox(height: ResponsiveUtils.spacing(context)),
        
        // Individual reviews
        ...reviews.take(3).map((review) => _buildReviewCard(context, review)),
        
        if (reviews.length > 3)
          TextButton(
            onPressed: () => _showAllReviews(context),
            child: Text('View all $totalReviews reviews'),
          ),
      ],
    );
  }

  Widget _buildRatingBreakdown() {
    return Column(
      children: [
        _buildRatingBar('Cleanliness', 4.5),
        _buildRatingBar('Location', 4.2),
        _buildRatingBar('Service', 4.7),
        _buildRatingBar('Value', 4.0),
      ],
    );
  }

  Widget _buildRatingBar(String category, double rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(category, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: rating / 5,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.rating),
            ),
          ),
          SizedBox(width: 8),
          Text(rating.toString(), style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, Review review) {
    return Card(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.spacing(context, mobile: 8)),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.spacing(context, mobile: 12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  child: Text(review.userName[0]),
                ),
                SizedBox(width: ResponsiveUtils.spacing(context, mobile: 8)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      RatingBarIndicator(
                        rating: review.rating,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: AppColors.rating,
                        ),
                        itemCount: 5,
                        itemSize: 12,
                      ),
                    ],
                  ),
                ),
                Text(
                  review.date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8)),
            Text(review.comment),
          ],
        ),
      ),
    );
  }

  void _showAllReviews(BuildContext context) {
    // Navigate to full reviews page
  }
}

class Review {
  final String userName;
  final double rating;
  final String comment;
  final String date;

  Review({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}