import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../domain/entities/listing.dart';
import '../../widgets/reviews_section.dart';
import '../../widgets/top_back_button.dart';
import '../../widgets/bookmark_button.dart';
import '../booking/booking_page.dart';

class HotelDetailsPage extends StatelessWidget {
  final Listing listing;

  const HotelDetailsPage({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildImageSliver(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      SizedBox(height: ResponsiveUtils.spacing(context)),
                      _buildDescription(),
                      SizedBox(height: ResponsiveUtils.spacing(context)),
                      _buildAmenities(),
                      SizedBox(height: ResponsiveUtils.spacing(context)),
                      _buildLocation(),
                      SizedBox(height: ResponsiveUtils.spacing(context)),
                      ReviewsSection(
                        averageRating: listing.rating,
                        totalReviews: listing.reviewCount,
                        reviews: _getMockReviews(),
                      ),
                      SizedBox(height: ResponsiveUtils.spacing(context, mobile: 100)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const TopBackButton(),
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: BookmarkButton(
                    listing: listing,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBookingBar(context),
    );
  }

  Widget _buildImageSliver() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: PageView.builder(
          itemCount: listing.images.length,
          itemBuilder: (context, index) => Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(listing.images[index]),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          listing.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(listing.location),
            const Spacer(),
            Text(
              '₹${listing.price.toStringAsFixed(0)}/night',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About this place',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(listing.description),
        const SizedBox(height: 8),
        Text('Hosted by ${listing.hostName}'),
        Text('Max guests: ${listing.maxGuests}'),
      ],
    );
  }

  Widget _buildAmenities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amenities',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: listing.amenities.map((amenity) => Chip(
            label: Text(amenity),
            backgroundColor: AppColors.primary.withOpacity(0.1),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text('Map View (Integration needed)'),
          ),
        ),
      ],
    );
  }

  Widget _buildBookingBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₹${listing.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const Text('per night'),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingPage(listing: listing),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Book Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Review> _getMockReviews() {
    return [
      Review(
        userName: 'John Doe',
        rating: 5.0,
        comment: 'Amazing stay! Great location and excellent service.',
        date: '2 days ago',
      ),
      Review(
        userName: 'Jane Smith',
        rating: 4.0,
        comment: 'Good value for money. Clean rooms and friendly staff.',
        date: '1 week ago',
      ),
    ];
  }
}