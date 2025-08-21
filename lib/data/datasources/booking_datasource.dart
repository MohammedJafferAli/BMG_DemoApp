import 'package:dio/dio.dart';
import '../models/booking_model.dart';

abstract class BookingDataSource {
  Future<BookingModel> createBooking(BookingModel booking);
  Future<List<BookingModel>> getBookings(String userId);
  Future<BookingModel> getBookingById(String bookingId);
}

class BookingDataSourceImpl implements BookingDataSource {
  final Dio dio;

  BookingDataSourceImpl(this.dio);

  @override
  Future<BookingModel> createBooking(BookingModel booking) async {
    // Mock implementation - replace with actual API calls
    await Future.delayed(const Duration(seconds: 1));
    return booking;
  }

  @override
  Future<List<BookingModel>> getBookings(String userId) async {
    // Mock implementation - replace with actual API calls
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  @override
  Future<BookingModel> getBookingById(String bookingId) async {
    // Mock implementation - replace with actual API calls
    await Future.delayed(const Duration(seconds: 1));
    throw Exception('Booking not found');
  }
}