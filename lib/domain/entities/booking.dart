import 'package:equatable/equatable.dart';

enum BookingStatus { pending, confirmed, cancelled, completed }

class Booking extends Equatable {
  final String id;
  final String orderId;
  final String listingId;
  final String guestId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double totalPrice;
  final BookingStatus status;
  final DateTime createdAt;
  final String? paymentId;

  const Booking({
    required this.id,
    required this.orderId,
    required this.listingId,
    required this.guestId,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    this.paymentId,
  });

  @override
  List<Object?> get props => [
        id,
        orderId,
        listingId,
        guestId,
        checkIn,
        checkOut,
        guests,
        totalPrice,
        status,
        createdAt,
        paymentId,
      ];
}