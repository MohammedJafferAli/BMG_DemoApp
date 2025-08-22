#!/bin/bash

# Hotel Room Management Project Generator
# Based on BMG template structure

set -e

PROJECT_NAME="hotel_room_management"
PACKAGE_NAME="com.example.hotel_room_management"

echo "🏨 Creating Hotel Room Management Flutter Project..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

# Create Flutter project
echo "📱 Creating Flutter project: $PROJECT_NAME"
flutter create --project-name $PROJECT_NAME --org com.example $PROJECT_NAME
cd $PROJECT_NAME

# Create directory structure
echo "📁 Creating project structure..."
mkdir -p lib/core/{theme,di,utils,constants}
mkdir -p lib/data/{models,repositories,datasources}
mkdir -p lib/domain/{entities,repositories,usecases}
mkdir -p lib/presentation/{pages,widgets,blocs}

# Update pubspec.yaml
echo "📦 Adding dependencies..."
cat > pubspec.yaml << EOF
name: hotel_room_management
description: A Flutter app for hotel room management and bed occupancy tracking
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  
  # Dependency Injection
  get_it: ^7.6.4
  
  # Networking & Storage
  dio: ^5.3.2
  shared_preferences: ^2.2.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # UI Components
  flutter_rating_bar: ^4.0.1
  cached_network_image: ^3.3.0
  carousel_slider: ^4.2.1
  
  # Utilities
  uuid: ^4.1.0
  intl: ^0.18.1
  mailer: ^6.0.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
  build_runner: ^2.4.7
  json_annotation: ^4.8.1
  json_serializable: ^6.7.1
  hive_generator: ^2.0.1

flutter:
  uses-material-design: true
EOF

# Create main.dart
cat > lib/main.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'presentation/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await di.init();
  runApp(const HotelManagementApp());
}

class HotelManagementApp extends StatelessWidget {
  const HotelManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Room Management',
      theme: AppTheme.lightTheme,
      home: const SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
EOF

# Create app theme
cat > lib/core/theme/app_theme.dart << 'EOF'
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2E7D32);
  static const Color secondary = Color(0xFF4CAF50);
  static const Color accent = Color(0xFF81C784);
  static const Color background = Color(0xFFF1F8E9);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFD32F2F);
  static const Color textPrimary = Color(0xFF1B5E20);
  static const Color textSecondary = Color(0xFF388E3C);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.green,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
EOF

# Create dependency injection
cat > lib/core/di/injection_container.dart << 'EOF'
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../data/datasources/room_local_datasource.dart';
import '../../data/repositories/room_repository_impl.dart';
import '../../domain/repositories/room_repository.dart';
import '../../domain/usecases/get_rooms.dart';
import '../../presentation/blocs/room/room_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());

  // Data sources
  sl.registerLazySingleton<RoomLocalDataSource>(
    () => RoomLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<RoomRepository>(
    () => RoomRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetRooms(sl()));

  // BLoC
  sl.registerFactory(() => RoomBloc(getRooms: sl()));
}
EOF

# Create room entity
cat > lib/domain/entities/room.dart << 'EOF'
import 'package:equatable/equatable.dart';

class Room extends Equatable {
  final String id;
  final String number;
  final String type;
  final int capacity;
  final int occupied;
  final double price;
  final bool isAvailable;
  final String status;

  const Room({
    required this.id,
    required this.number,
    required this.type,
    required this.capacity,
    required this.occupied,
    required this.price,
    required this.isAvailable,
    required this.status,
  });

  @override
  List<Object> get props => [id, number, type, capacity, occupied, price, isAvailable, status];
}
EOF

# Create room repository interface
cat > lib/domain/repositories/room_repository.dart << 'EOF'
import '../entities/room.dart';

abstract class RoomRepository {
  Future<List<Room>> getRooms();
  Future<Room> getRoomById(String id);
  Future<void> updateRoomOccupancy(String id, int occupied);
}
EOF

# Create get rooms use case
cat > lib/domain/usecases/get_rooms.dart << 'EOF'
import '../entities/room.dart';
import '../repositories/room_repository.dart';

class GetRooms {
  final RoomRepository repository;

  GetRooms(this.repository);

  Future<List<Room>> call() async {
    return await repository.getRooms();
  }
}
EOF

# Create room model
cat > lib/data/models/room_model.dart << 'EOF'
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/room.dart';

part 'room_model.g.dart';

@JsonSerializable()
class RoomModel extends Room {
  const RoomModel({
    required super.id,
    required super.number,
    required super.type,
    required super.capacity,
    required super.occupied,
    required super.price,
    required super.isAvailable,
    required super.status,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => _$RoomModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoomModelToJson(this);
}
EOF

# Create room local datasource
cat > lib/data/datasources/room_local_datasource.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';
import '../models/room_model.dart';

abstract class RoomLocalDataSource {
  Future<List<RoomModel>> getRooms();
}

class RoomLocalDataSourceImpl implements RoomLocalDataSource {
  final SharedPreferences sharedPreferences;

  RoomLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<RoomModel>> getRooms() async {
    // Mock data for demonstration
    return [
      const RoomModel(
        id: '1',
        number: '101',
        type: 'Single',
        capacity: 1,
        occupied: 0,
        price: 1500.0,
        isAvailable: true,
        status: 'Available',
      ),
      const RoomModel(
        id: '2',
        number: '102',
        type: 'Double',
        capacity: 2,
        occupied: 1,
        price: 2500.0,
        isAvailable: true,
        status: 'Partially Occupied',
      ),
      const RoomModel(
        id: '3',
        number: '201',
        type: 'Suite',
        capacity: 4,
        occupied: 4,
        price: 5000.0,
        isAvailable: false,
        status: 'Fully Occupied',
      ),
    ];
  }
}
EOF

# Create room repository implementation
cat > lib/data/repositories/room_repository_impl.dart << 'EOF'
import '../../domain/entities/room.dart';
import '../../domain/repositories/room_repository.dart';
import '../datasources/room_local_datasource.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomLocalDataSource localDataSource;

  RoomRepositoryImpl(this.localDataSource);

  @override
  Future<List<Room>> getRooms() async {
    return await localDataSource.getRooms();
  }

  @override
  Future<Room> getRoomById(String id) async {
    final rooms = await localDataSource.getRooms();
    return rooms.firstWhere((room) => room.id == id);
  }

  @override
  Future<void> updateRoomOccupancy(String id, int occupied) async {
    // Implementation for updating room occupancy
  }
}
EOF

# Create room bloc
cat > lib/presentation/blocs/room/room_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/room.dart';
import '../../../domain/usecases/get_rooms.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final GetRooms getRooms;

  RoomBloc({required this.getRooms}) : super(RoomInitial()) {
    on<LoadRooms>(_onLoadRooms);
  }

  Future<void> _onLoadRooms(LoadRooms event, Emitter<RoomState> emit) async {
    emit(RoomLoading());
    try {
      final rooms = await getRooms();
      emit(RoomLoaded(rooms));
    } catch (e) {
      emit(RoomError(e.toString()));
    }
  }
}
EOF

# Create room event
cat > lib/presentation/blocs/room/room_event.dart << 'EOF'
part of 'room_bloc.dart';

abstract class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object> get props => [];
}

class LoadRooms extends RoomEvent {}
EOF

# Create room state
cat > lib/presentation/blocs/room/room_state.dart << 'EOF'
part of 'room_bloc.dart';

abstract class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object> get props => [];
}

class RoomInitial extends RoomState {}

class RoomLoading extends RoomState {}

class RoomLoaded extends RoomState {
  final List<Room> rooms;

  const RoomLoaded(this.rooms);

  @override
  List<Object> get props => [rooms];
}

class RoomError extends RoomState {
  final String message;

  const RoomError(this.message);

  @override
  List<Object> get props => [message];
}
EOF

# Create splash page
cat > lib/presentation/pages/splash_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hotel,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 20),
            Text(
              'Hotel Room Management',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
EOF

# Create home page
cat > lib/presentation/pages/home_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection_container.dart' as di;
import '../blocs/room/room_bloc.dart';
import '../widgets/room_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<RoomBloc>()..add(LoadRooms()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Room Management'),
        ),
        body: BlocBuilder<RoomBloc, RoomState>(
          builder: (context, state) {
            if (state is RoomLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RoomLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.rooms.length,
                itemBuilder: (context, index) {
                  return RoomCard(room: state.rooms[index]);
                },
              );
            } else if (state is RoomError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('No rooms available'));
          },
        ),
      ),
    );
  }
}
EOF

# Create room card widget
cat > lib/presentation/widgets/room_card.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../domain/entities/room.dart';

class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Room ${room.number}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: room.isAvailable ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    room.status,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Type: ${room.type}'),
            Text('Capacity: ${room.capacity} beds'),
            Text('Occupied: ${room.occupied} beds'),
            Text('Price: ₹${room.price}/night'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: room.occupied / room.capacity,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                room.occupied == room.capacity ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
EOF

# Create README
cat > README.md << 'EOF'
# Hotel Room Management

A Flutter application for managing hotel rooms and tracking bed occupancy.

## Features

- Room listing with occupancy status
- Real-time bed availability tracking
- Clean architecture with BLoC pattern
- Responsive UI design

## Getting Started

1. Install dependencies:
```bash
flutter pub get
```

2. Generate code:
```bash
flutter packages pub run build_runner build
```

3. Run the app:
```bash
flutter run
```

## Architecture

- Clean Architecture
- BLoC State Management
- Dependency Injection with GetIt
- Repository Pattern

## Project Structure

```
lib/
├── core/           # Core functionality
├── data/           # Data layer
├── domain/         # Business logic
└── presentation/   # UI layer
```
EOF

echo "✅ Installing dependencies..."
flutter pub get

echo "🔧 Generating code..."
flutter packages pub run build_runner build --delete-conflicting-outputs

echo "🎉 Hotel Room Management project created successfully!"
echo "📍 Project location: $(pwd)"
echo ""
echo "🚀 To run the project:"
echo "   cd $PROJECT_NAME"
echo "   flutter run"
echo ""
echo "📱 Features included:"
echo "   ✓ Room management system"
echo "   ✓ Bed occupancy tracking"
echo "   ✓ Clean architecture"
echo "   ✓ BLoC state management"
echo "   ✓ Responsive UI"