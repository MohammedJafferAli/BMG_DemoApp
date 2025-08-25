import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/listing.dart';
import '../pages/hotel/hotel_details_page.dart';
import 'bookmark_button.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;

  const ListingCard({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;
    
    // Responsive sizing
    final borderRadius = isMobile ? 12.0 : 16.0;
    final imageHeight = isMobile ? 180.0 : 220.0;
    final padding = isMobile ? 16.0 : 20.0;
    final titleFontSize = isMobile ? 16.0 : 18.0;
    final bodyFontSize = isMobile ? 14.0 : 15.0;
    final priceFontSize = isMobile ? 16.0 : 18.0;
    final ratingSize = isMobile ? 14.0 : 16.0;
    final iconSize = isMobile ? 16.0 : 18.0;
    
    return Card(
      margin: EdgeInsets.zero,
      elevation: isMobile ? 2 : 4,
      shadowColor: AppColors.shadow.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => HotelDetailsPage(listing: listing),
            ),
          );
        },
        borderRadius: BorderRadius.circular(borderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(borderRadius),
              ),
              child: Stack(
                children: [
                  Container(
                    height: imageHeight,
                    width: double.infinity,
                    color: AppColors.surfaceVariant,
                    child: listing.images.isNotEmpty
                        ? Image.network(
                            listing.images.first,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: isMobile ? 48 : 64,
                                  color: AppColors.textSecondary,
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Icon(
                              Icons.hotel_outlined,
                              size: isMobile ? 48 : 64,
                              color: AppColors.textSecondary,
                            ),
                          ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
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
                ],
              ),
            ),
            
            // Content Section
            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Rating Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          listing.title,
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: isMobile ? 8 : 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RatingBarIndicator(
                                rating: listing.rating,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: AppColors.rating,
                                ),
                                itemCount: 5,
                                itemSize: ratingSize,
                              ),
                              SizedBox(width: isMobile ? 4 : 6),
                              Text(
                                '(${listing.reviewCount})',
                                style: TextStyle(
                                  fontSize: isMobile ? 11 : 12,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  SizedBox(height: isMobile ? 8 : 10),
                  
                  // Location Row
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: iconSize,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: isMobile ? 4 : 6),
                      Expanded(
                        child: Text(
                          listing.location,
                          style: TextStyle(
                            fontSize: bodyFontSize,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: isMobile ? 8 : 10),
                  
                  // Description
                  Text(
                    listing.description,
                    style: TextStyle(
                      fontSize: bodyFontSize,
                      color: AppColors.textSecondary,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SizedBox(height: isMobile ? 12 : 16),
                  
                  // Price and Availability Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '₹${listing.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: priceFontSize,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              TextSpan(
                                text: '/night',
                                style: TextStyle(
                                  fontSize: isMobile ? 13 : 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 10 : 12,
                          vertical: isMobile ? 4 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: listing.isAvailable
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                          border: Border.all(
                            color: listing.isAvailable
                                ? AppColors.success.withOpacity(0.2)
                                : AppColors.error.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          listing.isAvailable ? 'Available' : 'Booked',
                          style: TextStyle(
                            fontSize: isMobile ? 11 : 12,
                            fontWeight: FontWeight.w600,
                            color: listing.isAvailable
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}