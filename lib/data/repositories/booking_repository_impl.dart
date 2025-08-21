import 'package:uuid/uuid.dart';
import '../../core/utils/email_service.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_datasource.dart';
import '../models/booking_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingDataSource dataSource;
  final EmailService emailService;

  BookingRepositoryImpl(this.dataSource, this.emailService);

  @override
  Future<Booking> createBooking(
    String listingId,
    String guestId,
    DateTime checkIn,
    DateTime checkOut,
    int guests,
    double totalPrice,
  ) async {
    final orderId = 'BMG${DateTime.now().millisecondsSinceEpoch}';
    
    final bookingModel = BookingModel(
      id: const Uuid().v4(),
      orderId: orderId,
      listingId: listingId,
      guestId: guestId,
      checkIn: checkIn,
      checkOut: checkOut,
      guests: guests,
      totalPrice: totalPrice,
      status: BookingStatus.confirmed,
      createdAt: DateTime.now(),
    );

    final createdBooking = await dataSource.createBooking(bookingModel);
    
    // Send confirmation email (mock implementation)
    try {
      await emailService.sendBookingConfirmation(
        toEmail: 'user@example.com', // Get from user data
        userName: 'User Name', // Get from user data
        orderId: orderId,
        listingTitle: 'Listing Title', // Get from listing data
        checkIn: checkIn,
        checkOut: checkOut,
        totalPrice: totalPrice,
      );
    } catch (e) {
      // Log email error but don't fail the booking
      print('Email sending failed: $e');
    }

    return createdBooking.toEntity();
  }

  @override
  Future<List<Booking>> getBookings(String userId) async {
    final bookingModels = await dataSource.getBookings(userId);
    return bookingModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Booking> getBookingById(String bookingId) async {
    final bookingModel = await dataSource.getBookingById(bookingId);
    return bookingModel.toEntity();
  }
}