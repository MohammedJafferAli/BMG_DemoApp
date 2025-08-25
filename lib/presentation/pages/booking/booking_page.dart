import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../domain/entities/listing.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/booking/booking_bloc.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/price_breakdown.dart';
import '../auth/login_page.dart';
import '../payment/payment_page.dart';

class BookingPage extends StatefulWidget {
  final Listing listing;

  const BookingPage({
    super.key,
    required this.listing,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _guests = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Now'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<BookingBloc, BookingState>(
            listener: (context, state) {
              if (state is BookingCreated) {
                _showBookingConfirmation(context, state.booking.orderId);
              } else if (state is BookingError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated && _canBook()) {
                _handleBooking();
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildListingInfo(),
              const SizedBox(height: 24),
              _buildDateSelection(),
              const SizedBox(height: 24),
              _buildGuestSelection(),
              const SizedBox(height: 24),
              _buildPricingDetails(),
              const SizedBox(height: 32),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  final isAuthenticated = authState is AuthAuthenticated;
                  
                  if (!isAuthenticated) {
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
                          decoration: BoxDecoration(
                            color: AppColors.info.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              ResponsiveUtils.borderRadius(context),
                            ),
                            border: Border.all(
                              color: AppColors.info.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.info,
                                size: ResponsiveUtils.iconSize(context, mobile: 20),
                              ),
                              SizedBox(width: ResponsiveUtils.spacing(context, mobile: 8)),
                              Expanded(
                                child: Text(
                                  'Sign in to complete your booking',
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.fontSize(context, mobile: 14),
                                    color: AppColors.info,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.spacing(context)),
                        CustomButton(
                          text: 'Sign In to Book',
                          onPressed: _canBook() ? _navigateToLogin : null,
                        ),
                      ],
                    );
                  }
                  
                  return BlocBuilder<BookingBloc, BookingState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: 'Confirm Booking',
                        isLoading: state is BookingLoading,
                        onPressed: _canBook() ? _handleBooking : null,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListingInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.listing.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  widget.listing.location,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Hosted by ${widget.listing.hostName}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Dates',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    label: 'Check-in',
                    date: _checkInDate,
                    onTap: () => _selectDate(true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateField(
                    label: 'Check-out',
                    date: _checkOutDate,
                    onTap: () => _selectDate(false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date != null
                  ? DateFormat('MMM dd, yyyy').format(date)
                  : 'Select date',
              style: TextStyle(
                fontSize: 16,
                color: date != null ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Guests',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Number of guests',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _guests > 1 ? () => setState(() => _guests--) : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      _guests.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: _guests < widget.listing.maxGuests
                          ? () => setState(() => _guests++)
                          : null,
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingDetails() {
    if (_checkInDate == null || _checkOutDate == null) {
      return const SizedBox.shrink();
    }

    final nights = _checkOutDate!.difference(_checkInDate!).inDays;

    return PriceBreakdown(
      basePrice: widget.listing.price,
      nights: nights,
    );
  }

  bool _canBook() {
    return _checkInDate != null &&
        _checkOutDate != null &&
        _checkOutDate!.isAfter(_checkInDate!) &&
        widget.listing.isAvailable;
  }

  void _navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
    );
  }

  void _handleBooking() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final nights = _checkOutDate!.difference(_checkInDate!).inDays;
      final subtotal = widget.listing.price * nights;
      final taxes = subtotal * 0.12;
      final serviceFee = 200.0;
      final totalPrice = subtotal + taxes + serviceFee;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentPage(
            totalAmount: totalPrice,
            bookingId: 'BMG${DateTime.now().millisecondsSinceEpoch}',
          ),
        ),
      );
    }
  }

  Future<void> _selectDate(bool isCheckIn) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = date;
          if (_checkOutDate != null && _checkOutDate!.isBefore(date)) {
            _checkOutDate = null;
          }
        } else {
          if (_checkInDate != null && date.isAfter(_checkInDate!)) {
            _checkOutDate = date;
          }
        }
      });
    }
  }

  void _showBookingConfirmation(BuildContext context, String orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Booking Confirmed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Your booking has been confirmed.\nOrder ID: $orderId',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'A confirmation email has been sent to your registered email address.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}