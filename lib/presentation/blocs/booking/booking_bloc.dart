import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/booking.dart';
import '../../../domain/usecases/booking/create_booking_usecase.dart';
import '../../../domain/usecases/booking/get_bookings_usecase.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final CreateBookingUseCase _createBookingUseCase;
  final GetBookingsUseCase _getBookingsUseCase;

  BookingBloc(this._createBookingUseCase, this._getBookingsUseCase) 
      : super(BookingInitial()) {
    on<CreateBooking>(_onCreateBooking);
    on<LoadBookings>(_onLoadBookings);
  }

  Future<void> _onCreateBooking(
    CreateBooking event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final booking = await _createBookingUseCase(CreateBookingParams(
        listingId: event.listingId,
        guestId: event.guestId,
        checkIn: event.checkIn,
        checkOut: event.checkOut,
        guests: event.guests,
        totalPrice: event.totalPrice,
      ));
      emit(BookingCreated(booking));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onLoadBookings(
    LoadBookings event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final bookings = await _getBookingsUseCase(GetBookingsParams(event.userId));
      emit(BookingsLoaded(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}