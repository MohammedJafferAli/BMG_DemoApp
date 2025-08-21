import '../entities/booking.dart';

abstract class BookingRepository {
  Future<Booking> createBooking(
    String listingId,
    String guestId,
    DateTime checkIn,
    DateTime checkOut,
    int guests,
    double totalPrice,
  );
  Future<List<Booking>> getBookings(String userId);
  Future<Booking> getBookingById(String bookingId);
}