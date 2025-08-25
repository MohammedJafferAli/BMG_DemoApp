import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../blocs/listings/listings_bloc.dart';
import '../../widgets/listing_card.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/search_filters.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Hotels'),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _showFilters(context),
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
                    if (query.isNotEmpty) {
                      context.read<ListingsBloc>().add(SearchListings(query));
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
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
                        itemCount: state.listings.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: ResponsiveUtils.spacing(context, mobile: 12)),
                            child: ListingCard(listing: state.listings[index]),
                          );
                        },
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

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => SearchFilters(
          onFiltersChanged: (filters) {
            // TODO: Apply filters to search
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}