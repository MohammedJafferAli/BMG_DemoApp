import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../domain/entities/listing.dart';

class MapViewPage extends StatefulWidget {
  final List<Listing> listings;

  const MapViewPage({super.key, required this.listings});

  @override
  State<MapViewPage> createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  Listing? _selectedListing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildMapView(),
          if (_selectedListing != null) _buildListingCard(),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.surfaceVariant,
      child: Stack(
        children: [
          const Center(
            child: Text(
              'Map Integration Required\n(Google Maps/OpenStreetMap)',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          ...widget.listings.asMap().entries.map((entry) {
            final index = entry.key;
            final listing = entry.value;
            return Positioned(
              left: 50.0 + (index * 80.0) % 300,
              top: 100.0 + (index * 60.0) % 400,
              child: GestureDetector(
                onTap: () => setState(() => _selectedListing = listing),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _selectedListing?.id == listing.id 
                        ? AppColors.primary 
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '₹${listing.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: _selectedListing?.id == listing.id 
                          ? Colors.white 
                          : AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildListingCard() {
    return Positioned(
      bottom: ResponsiveUtils.spacing(context),
      left: ResponsiveUtils.spacing(context),
      right: ResponsiveUtils.spacing(context),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedListing!.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _selectedListing = null),
                  ),
                ],
              ),
              Text(_selectedListing!.location),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${_selectedListing!.price.toStringAsFixed(0)}/night',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to hotel details
                    },
                    child: const Text('View Details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}