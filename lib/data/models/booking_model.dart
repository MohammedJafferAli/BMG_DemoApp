import '../../domain/entities/booking.dart';

class BookingModel {
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

  const BookingModel({
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

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      orderId: json['orderId'],
      listingId: json['listingId'],
      guestId: json['guestId'],
      checkIn: DateTime.parse(json['checkIn']),
      checkOut: DateTime.parse(json['checkOut']),
      guests: json['guests'],
      totalPrice: json['totalPrice'].toDouble(),
      status: BookingStatus.values.byName(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      paymentId: json['paymentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'listingId': listingId,
      'guestId': guestId,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'guests': guests,
      'totalPrice': totalPrice,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'paymentId': paymentId,
    };
  }

  Booking toEntity() {
    return Booking(
      id: id,
      orderId: orderId,
      listingId: listingId,
      guestId: guestId,
      checkIn: checkIn,
      checkOut: checkOut,
      guests: guests,
      totalPrice: totalPrice,
      status: status,
      createdAt: createdAt,
      paymentId: paymentId,
    );
  }
}