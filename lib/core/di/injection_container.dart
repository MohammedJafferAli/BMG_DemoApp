import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/booking_datasource.dart';
import '../../data/datasources/listings_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../data/repositories/listings_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/repositories/listings_repository.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/booking/create_booking_usecase.dart';
import '../../domain/usecases/booking/get_bookings_usecase.dart';
import '../../domain/usecases/listings/get_listings_usecase.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/booking/booking_bloc.dart';
import '../../presentation/blocs/listings/listings_bloc.dart';
import '../utils/email_service.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  
  final dio = Dio();
  getIt.registerLazySingleton(() => dio);
  
  // Services
  getIt.registerLazySingleton<EmailService>(() => EmailService());
  
  // Data sources
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<ListingsDataSource>(
    () => ListingsDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<BookingDataSource>(
    () => BookingDataSourceImpl(getIt()),
  );
  
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<ListingsRepository>(
    () => ListingsRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(getIt(), getIt()),
  );
  
  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => GetListingsUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateBookingUseCase(getIt()));
  getIt.registerLazySingleton(() => GetBookingsUseCase(getIt()));
  
  // Blocs
  getIt.registerFactory(() => AuthBloc(getIt(), getIt()));
  getIt.registerFactory(() => ListingsBloc(getIt()));
  getIt.registerFactory(() => BookingBloc(getIt(), getIt()));
}