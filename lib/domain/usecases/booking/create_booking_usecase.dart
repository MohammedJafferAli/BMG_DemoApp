import 'package:equatable/equatable.dart';
import '../../entities/booking.dart';
import '../../repositories/booking_repository.dart';
import '../usecase.dart';

class CreateBookingUseCase implements UseCase<Booking, CreateBookingParams> {
  final BookingRepository repository;

  CreateBookingUseCase(this.repository);

  @override
  Future<Booking> call(CreateBookingParams params) async {
    return await repository.createBooking(
      params.listingId,
      params.guestId,
      params.checkIn,
      params.checkOut,
      params.guests,
      params.totalPrice,
    );
  }
}

class CreateBookingParams extends Equatable {
  final String listingId;
  final String guestId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double totalPrice;

  const CreateBookingParams({
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