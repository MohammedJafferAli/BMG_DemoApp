#!/bin/bash

# BMG Flutter App Automated Setup Script
# This script creates the complete BMG hotel booking app structure

set -e

PROJECT_NAME="bmg"
echo "🚀 Starting BMG Flutter App Setup..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

# Create Flutter project
echo "📱 Creating Flutter project..."
flutter create $PROJECT_NAME
cd $PROJECT_NAME

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p lib/core/{theme,di,utils,constants,errors}
mkdir -p lib/data/{models,repositories,datasources}
mkdir -p lib/domain/{entities,repositories,usecases/{auth,booking,listings}}
mkdir -p lib/presentation/{pages/{splash,auth,home,listings,booking,profile},widgets,blocs/{auth,booking,listings}}
mkdir -p assets/{images,icons,fonts}
mkdir -p android/app/src/main
mkdir -p ios/Runner

# Create pubspec.yaml
echo "📦 Setting up dependencies..."
cat > pubspec.yaml << 'EOF'
name: bmg
description: A cross-platform hotel room booking application
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"

dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  
  # Dependency Injection
  get_it: ^7.6.4
  
  # Networking
  dio: ^5.3.2
  retrofit: ^4.0.3
  json_annotation: ^4.8.1
  
  # Local Storage
  shared_preferences: ^2.2.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # UI Components
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  flutter_rating_bar: ^4.0.1
  carousel_slider: ^4.2.1
  
  # Email Service
  mailer: ^6.0.1
  
  # Utils
  uuid: ^4.1.0
  intl: ^0.18.1
  
  # Icons
  cupertino_icons: ^1.0.6

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  
  # Code Generation
  build_runner: ^2.4.7
  retrofit_generator: ^8.0.4
  json_serializable: ^6.7.1
  hive_generator: ^2.0.1

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
  
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Medium.ttf
          weight: 500
        - asset: assets/fonts/Poppins-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
EOF

# Install dependencies
echo "⬇️ Installing dependencies..."
flutter pub get

# Create main.dart
echo "🎯 Creating main application file..."
cat > lib/main.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/di/injection_container.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/booking/booking_bloc.dart';
import 'presentation/blocs/listings/listings_bloc.dart';
import 'presentation/pages/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  await initializeDependencies();
  
  runApp(const BMGApp());
}

class BMGApp extends StatelessWidget {
  const BMGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<ListingsBloc>()),
        BlocProvider(create: (_) => getIt<BookingBloc>()),
      ],
      child: MaterialApp(
        title: 'BMG',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const SplashPage(),
      ),
    );
  }
}
EOF

# Create theme files
echo "🎨 Creating theme configuration..."
cat > lib/core/theme/app_colors.dart << 'EOF'
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (Airbnb-inspired but distinct)
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFF8B7ED8);
  static const Color primaryDark = Color(0xFF5A4FCF);
  
  // Secondary Colors
  static const Color secondary = Color(0xFFFF6B6B);
  static const Color secondaryLight = Color(0xFFFF8E8E);
  static const Color secondaryDark = Color(0xFFE55555);
  
  // Neutral Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textLight = Color(0xFF95A5A6);
  
  // Accent Colors
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFE17055);
  static const Color error = Color(0xFFD63031);
  static const Color info = Color(0xFF74B9FF);
  
  // UI Colors
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFECF0F1);
  static const Color shadow = Color(0x1A000000);
  
  // Rating Colors
  static const Color rating = Color(0xFFFFD700);
}
EOF

cat > lib/core/theme/app_theme.dart << 'EOF'
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
      ),
    );
  }
}
EOF

# Create Android manifest
echo "🤖 Creating Android configuration..."
cat > android/app/src/main/AndroidManifest.xml << 'EOF'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    
    <application
        android:label="BMG"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>
EOF

# Create iOS Info.plist
echo "🍎 Creating iOS configuration..."
cat > ios/Runner/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>$(DEVELOPMENT_LANGUAGE)</string>
	<key>CFBundleDisplayName</key>
	<string>BMG</string>
	<key>CFBundleExecutable</key>
	<string>$(EXECUTABLE_NAME)</string>
	<key>CFBundleIdentifier</key>
	<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>bmg</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>$(FLUTTER_BUILD_NAME)</string>
	<key>CFBundleSignature</key>
	<string>????</string>
	<key>CFBundleVersion</key>
	<string>$(FLUTTER_BUILD_NUMBER)</string>
	<key>LSRequiresIPhoneOS</key>
	<true/>
	<key>UILaunchStoryboardName</key>
	<string>LaunchScreen</string>
	<key>UIMainStoryboardFile</key>
	<string>Main</string>
	<key>UISupportedInterfaceOrientations</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	<key>UISupportedInterfaceOrientations~ipad</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationPortraitUpsideDown</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	<key>CADisableMinimumFrameDurationOnPhone</key>
	<true/>
	<key>UIApplicationSupportsIndirectInputEvents</key>
	<true/>
</dict>
</plist>
EOF

# Create basic splash page to avoid errors
echo "📱 Creating basic splash page..."
cat > lib/presentation/pages/splash/splash_page.dart << 'EOF'
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hotel, size: 80, color: Color(0xFF6C5CE7)),
            SizedBox(height: 16),
            Text('BMG', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            Text('Book My Guest', style: TextStyle(fontSize: 16)),
            SizedBox(height: 40),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
EOF

# Create basic DI container
echo "🔧 Creating dependency injection..."
cat > lib/core/di/injection_container.dart << 'EOF'
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // TODO: Add dependency registrations
}
EOF

# Create basic BLoCs
echo "🧠 Creating basic BLoC structure..."
cat > lib/presentation/blocs/auth/auth_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());
}
EOF

cat > lib/presentation/blocs/auth/auth_event.dart << 'EOF'
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}
EOF

cat > lib/presentation/blocs/auth/auth_state.dart << 'EOF'
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}
EOF

cat > lib/presentation/blocs/listings/listings_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'listings_event.dart';
part 'listings_state.dart';

class ListingsBloc extends Bloc<ListingsEvent, ListingsState> {
  ListingsBloc() : super(ListingsInitial());
}
EOF

cat > lib/presentation/blocs/listings/listings_event.dart << 'EOF'
part of 'listings_bloc.dart';

abstract class ListingsEvent extends Equatable {
  const ListingsEvent();
  @override
  List<Object> get props => [];
}
EOF

cat > lib/presentation/blocs/listings/listings_state.dart << 'EOF'
part of 'listings_bloc.dart';

abstract class ListingsState extends Equatable {
  const ListingsState();
  @override
  List<Object> get props => [];
}

class ListingsInitial extends ListingsState {}
EOF

cat > lib/presentation/blocs/booking/booking_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingInitial());
}
EOF

cat > lib/presentation/blocs/booking/booking_event.dart << 'EOF'
part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();
  @override
  List<Object> get props => [];
}
EOF

cat > lib/presentation/blocs/booking/booking_state.dart << 'EOF'
part of 'booking_bloc.dart';

abstract class BookingState extends Equatable {
  const BookingState();
  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}
EOF

# Run flutter pub get again
echo "📦 Final dependency installation..."
flutter pub get

# Create README
echo "📝 Creating documentation..."
cat > README.md << 'EOF'
# BMG - Book My Guest

A cross-platform hotel room booking application built with Flutter.

## Quick Start

1. Install dependencies: `flutter pub get`
2. Run the app: `flutter run`

## Features

- Cross-platform (Android & iOS)
- Clean Architecture
- BLoC State Management
- Email Authentication
- Hotel Booking System
- Order ID Generation
- Email Confirmations

## Setup Complete!

The basic structure is ready. Use the AI prompt in SETUP_README.md to generate the complete implementation.
EOF

echo "✅ BMG Flutter App setup completed successfully!"
echo "📁 Project created in: $(pwd)"
echo ""
echo "🚀 Next steps:"
echo "1. cd $PROJECT_NAME"
echo "2. Use the AI prompt from SETUP_README.md to generate complete code"
echo "3. flutter run"
echo ""
echo "🎯 The basic structure is ready for AI code generation!"