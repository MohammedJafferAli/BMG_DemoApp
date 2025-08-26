import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/search_filters.dart';

class SearchFiltersWidget extends StatefulWidget {
  final SearchFilters currentFilters;
  final Position? userLocation;
  final Function(SearchFilters) onFiltersChanged;

  const SearchFiltersWidget({
    super.key,
    required this.currentFilters,
    required this.onFiltersChanged,
    this.userLocation,
  });

  @override
  State<SearchFiltersWidget> createState() => _SearchFiltersWidgetState();
}

class _SearchFiltersWidgetState extends State<SearchFiltersWidget> {
  late SearchFilters _filters;
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filters = widget.currentFilters;
    _minPriceController.text = _filters.minPrice?.toString() ?? '';
    _maxPriceController.text = _filters.maxPrice?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filters',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Price Range
          const Text('Price Range (₹)', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Min Price',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _filters = _filters.copyWith(
                      minPrice: double.tryParse(value),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _maxPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Max Price',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _filters = _filters.copyWith(
                      maxPrice: double.tryParse(value),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Rating
          const Text('Minimum Rating', style: TextStyle(fontWeight: FontWeight.w600)),
          Slider(
            value: _filters.minRating ?? 0,
            min: 0,
            max: 5,
            divisions: 10,
            label: (_filters.minRating ?? 0).toStringAsFixed(1),
            onChanged: (value) {
              setState(() {
                _filters = _filters.copyWith(minRating: value);
              });
            },
          ),

          // Location Radius
          if (widget.userLocation != null) ...[
            const Text('Distance from your location', style: TextStyle(fontWeight: FontWeight.w600)),
            Slider(
              value: (_filters.radiusKm ?? 50).toDouble(),
              min: 1,
              max: 100,
              divisions: 99,
              label: '${_filters.radiusKm ?? 50} km',
              onChanged: (value) {
                setState(() {
                  _filters = _filters.copyWith(radiusKm: value.round());
                });
              },
            ),
          ],

          // Accommodation Type
          const Text('Accommodation Type', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: AccommodationType.values.map((type) {
              return FilterChip(
                label: Text(_getAccommodationLabel(type)),
                selected: _filters.accommodationType == type,
                onSelected: (selected) {
                  setState(() {
                    _filters = _filters.copyWith(accommodationType: type);
                  });
                },
                selectedColor: AppColors.primary.withOpacity(0.2),
              );
            }).toList(),
          ),

          const Spacer(),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _filters = const SearchFilters();
                      _minPriceController.clear();
                      _maxPriceController.clear();
                    });
                  },
                  child: const Text('Clear All'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => widget.onFiltersChanged(_filters),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getAccommodationLabel(AccommodationType type) {
    switch (type) {
      case AccommodationType.all:
        return 'All';
      case AccommodationType.boys:
        return 'Boys Only';
      case AccommodationType.girls:
        return 'Girls Only';
      case AccommodationType.couple:
        return 'Couple Friendly';
      case AccommodationType.dorms:
        return 'Dorms';
    }
  }
}