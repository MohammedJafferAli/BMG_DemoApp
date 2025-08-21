import 'package:equatable/equatable.dart';
import '../../entities/booking.dart';
import '../../repositories/booking_repository.dart';
import '../usecase.dart';

class GetBookingsUseCase implements UseCase<List<Booking>, GetBookingsParams> {
  final BookingRepository repository;

  GetBookingsUseCase(this.repository);

  @override
  Future<List<Booking>> call(GetBookingsParams params) async {
    return await repository.getBookings(params.userId);
  }
}

class GetBookingsParams extends Equatable {
  final String userId;

  const GetBookingsParams(this.userId);

  @override
  List<Object> get props => [userId];
}