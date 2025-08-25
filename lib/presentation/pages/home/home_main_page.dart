import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/constants/cities.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/city_card.dart';
import '../../blocs/listings/listings_bloc.dart';
import '../search/search_page.dart';

class HomeMainPage extends StatelessWidget {
  const HomeMainPage({super.key});

  void _navigateToSearch(BuildContext context, String city) {
    context.read<ListingsBloc>().add(SearchListings(city));
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SearchPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'BMG',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to BMG',
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(context, mobile: 24),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8)),
            Text(
              'Discover amazing stays across India',
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(context, mobile: 16),
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, mobile: 24)),
            Text(
              'Popular Destinations',
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(context, mobile: 18),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, mobile: 16)),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: popularCities.length,
                itemBuilder: (context, index) {
                  final city = popularCities[index];
                  return CityCard(
                    city: city,
                    onTap: () => _navigateToSearch(context, city.name),
                  );
                },
              ),
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, mobile: 32)),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.hotel,
                    size: ResponsiveUtils.iconSize(context, mobile: 48),
                    color: AppColors.primary,
                  ),
                  SizedBox(height: ResponsiveUtils.spacing(context, mobile: 16)),
                  Text(
                    'Your gateway to amazing stays',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.fontSize(context, mobile: 16),
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
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