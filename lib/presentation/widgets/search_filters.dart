import 'package:flutter/material.dart';
import '../../core/utils/responsive_utils.dart';

class SearchFilters extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersChanged;

  const SearchFilters({super.key, required this.onFiltersChanged});

  @override
  State<SearchFilters> createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<SearchFilters> {
  RangeValues _priceRange = const RangeValues(0, 10000);
  double _rating = 0;
  String _propertyType = 'All';
  List<String> _amenities = [];

  final List<String> _propertyTypes = ['All', 'Hotel', 'Resort', 'Apartment', 'Villa'];
  final List<String> _availableAmenities = ['WiFi', 'Pool', 'Gym', 'Spa', 'Restaurant', 'Parking'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters',
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(context, mobile: 18),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveUtils.spacing(context)),
          
          // Price Range
          Text('Price Range (₹${_priceRange.start.round()} - ₹${_priceRange.end.round()})'),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 20000,
            divisions: 20,
            onChanged: (values) {
              setState(() => _priceRange = values);
              _updateFilters();
            },
          ),
          
          // Rating
          Text('Minimum Rating: ${_rating.round()} stars'),
          Slider(
            value: _rating,
            min: 0,
            max: 5,
            divisions: 5,
            onChanged: (value) {
              setState(() => _rating = value);
              _updateFilters();
            },
          ),
          
          // Property Type
          Text('Property Type'),
          DropdownButton<String>(
            value: _propertyType,
            isExpanded: true,
            items: _propertyTypes.map((type) => DropdownMenuItem(
              value: type,
              child: Text(type),
            )).toList(),
            onChanged: (value) {
              setState(() => _propertyType = value!);
              _updateFilters();
            },
          ),
          
          // Amenities
          Text('Amenities'),
          Wrap(
            children: _availableAmenities.map((amenity) => FilterChip(
              label: Text(amenity),
              selected: _amenities.contains(amenity),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _amenities.add(amenity);
                  } else {
                    _amenities.remove(amenity);
                  }
                });
                _updateFilters();
              },
            )).toList(),
          ),
        ],
      ),
    );
  }

  void _updateFilters() {
    widget.onFiltersChanged({
      'priceMin': _priceRange.start,
      'priceMax': _priceRange.end,
      'rating': _rating,
      'propertyType': _propertyType,
      'amenities': _amenities,
    });
  }
}