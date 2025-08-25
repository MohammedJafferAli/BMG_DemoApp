import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../domain/entities/user.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/listings/listings_bloc.dart';
import '../booking/bookings_page.dart';
import '../profile/profile_page.dart';
import '../help/help_page.dart';
import '../search/search_page.dart';
import 'home_main_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ListingsBloc>().add(LoadListings());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final isAuthenticated = authState is AuthAuthenticated;
        final user = isAuthenticated ? authState.user : null;
        final pages = [
          const HomeMainPage(),
          const SearchPage(),
          const BookingsPage(),
          const HelpPage(),
          const ProfilePage(),
        ];

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
          bottomNavigationBar: LayoutBuilder(
            builder: (context, constraints) {
              
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: BottomNavigationBar(
                    currentIndex: _currentIndex,
                    onTap: (index) => setState(() => _currentIndex = index),
                    type: BottomNavigationBarType.fixed,
                    showUnselectedLabels: true,
                    selectedItemColor: AppColors.primary,
                    unselectedItemColor: AppColors.textSecondary,
                    selectedFontSize: ResponsiveUtils.fontSize(context, mobile: 12),
                    unselectedFontSize: ResponsiveUtils.fontSize(context, mobile: 11),
                    iconSize: ResponsiveUtils.iconSize(context, mobile: 22),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    selectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                    items: [
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined),
                        activeIcon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.search_outlined),
                        activeIcon: Icon(Icons.search),
                        label: 'Search',
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.bookmark_outline),
                        activeIcon: const Icon(Icons.bookmark),
                        label: user?.role == UserRole.guest ? 'Bookmarks' : 'Bookmarks',
                      ),
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.help_outline),
                        activeIcon: Icon(Icons.help),
                        label: 'Help',
                      ),
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.person_outline),
                        activeIcon: Icon(Icons.person),
                        label: 'Profile',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}