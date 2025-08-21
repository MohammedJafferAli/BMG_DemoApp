part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class CreateBooking extends BookingEvent {
  final String listingId;
  final String guestId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double totalPrice;

  const CreateBooking({
    required this.listingId,
    required this.guestId,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalPrice,
  });

  @override
  List<Object> get props => [listingId, guestId, checkIn, checkOut, guests, totalPrice];
}

class LoadBookings extends BookingEvent {
  final String userId;

  const LoadBookings(this.userId);

  @override
  List<Object> get props => [userId];
}