import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../domain/entities/search_filters.dart';
import '../../blocs/listings/listings_bloc.dart';
import '../../widgets/listing_card.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/search_filters_widget.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/location_permission_dialog.dart';
import '../map/map_view_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Position? _userLocation;
  SearchFilters _filters = const SearchFilters();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  void _requestLocationPermission() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => LocationPermissionDialog(
          onLocationReceived: (position) {
            setState(() {
              _userLocation = position;
              if (position != null) {
                _filters = _filters.copyWith(
                  userLat: position.latitude,
                  userLon: position.longitude,
                );
              }
            });
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Search Hotels',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => _showMapView(context),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _showFilters(),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.primary,
            width: double.infinity,
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: ResponsiveUtils.contentMaxWidth(context)),
                padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
                child: CustomSearchBar(
                  onSearch: (query) {
                    if (query.trim().isNotEmpty) {
                      context.read<ListingsBloc>().add(SearchListings(query.trim()));
                    } else {
                      context.read<ListingsBloc>().add(LoadListings());
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: ResponsiveUtils.contentMaxWidth(context)),
                child: BlocBuilder<ListingsBloc, ListingsState>(
                  builder: (context, state) {
                    if (state is ListingsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ListingsLoaded) {
                      if (state.listings.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: ResponsiveUtils.iconSize(context, mobile: 64),
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(height: ResponsiveUtils.spacing(context)),
                              Text(
                                'No hotels found',
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.fontSize(context, mobile: 18),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8)),
                              Text(
                                'Try searching with different keywords',
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.fontSize(context, mobile: 14),
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: ResponsiveUtils.spacing(context)),
                              _buildSearchTips(context),
                            ],
                          ),
                        );
                      }
                      return Column(
                        children: [
                          // Results count and info
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
                            child: Text(
                              '${state.listings.length} hotel${state.listings.length != 1 ? 's' : ''} found',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.fontSize(context, mobile: 16),
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveUtils.spacing(context),
                              ),
                              itemCount: state.listings.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: ResponsiveUtils.spacing(context, mobile: 12),
                                  ),
                                  child: ListingCard(listing: state.listings[index]),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: ResponsiveUtils.iconSize(context, mobile: 64),
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: ResponsiveUtils.spacing(context)),
                          Text(
                            'Search for hotels',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.fontSize(context, mobile: 18),
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: ResponsiveUtils.spacing(context)),
                          _buildSearchTips(context),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => SearchFiltersWidget(
          currentFilters: _filters,
          userLocation: _userLocation,
          onFiltersChanged: (filters) {
            setState(() {
              _filters = filters;
            });
            context.read<ListingsBloc>().add(FilterListings(_filters));
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showMapView(BuildContext context) {
    final state = context.read<ListingsBloc>().state;
    if (state is ListingsLoaded) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MapViewPage(listings: state.listings),
        ),
      );
    }
  }

  Widget _buildSearchTips(BuildContext context) {
    final searchTips = [
      {'icon': Icons.location_on, 'text': 'Search by location (Mumbai, Delhi, Goa)'},
      {'icon': Icons.hotel, 'text': 'Search by hotel name or type'},
      {'icon': Icons.wifi, 'text': 'Search by amenities (WiFi, Pool, Parking)'},
      {'icon': Icons.star, 'text': 'Search by quality (luxury, budget, highly rated)'},
      {'icon': Icons.people, 'text': 'Search by group type (couple, family, friends)'},
    ];

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(context),
      ),
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search Tips:',
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(context, mobile: 16),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8)),
          ...searchTips.map((tip) => Padding(
            padding: EdgeInsets.only(
              bottom: ResponsiveUtils.spacing(context, mobile: 4),
            ),
            child: Row(
              children: [
                Icon(
                  tip['icon'] as IconData,
                  size: ResponsiveUtils.iconSize(context, mobile: 16),
                  color: AppColors.primary,
                ),
                SizedBox(width: ResponsiveUtils.spacing(context, mobile: 8)),
                Expanded(
                  child: Text(
                    tip['text'] as String,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.fontSize(context, mobile: 14),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}