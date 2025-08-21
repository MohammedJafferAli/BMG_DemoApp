# BMG Flutter App - Complete Setup Guide

## 🚀 Quick Setup (Automated)

Run the automated setup script:
```bash
chmod +x setup_bmg.sh
./setup_bmg.sh
```

## 📋 Manual Setup Steps

### 1. Prerequisites
```bash
# Install Flutter SDK (>=3.10.0)
# Install Dart SDK (>=3.0.0)
# Install Android Studio / Xcode
```

### 2. Project Creation
```bash
flutter create bmg
cd bmg
```

### 3. Dependencies Installation
```bash
flutter pub get
```

### 4. Code Generation
```bash
flutter packages pub run build_runner build
```

### 5. Run Application
```bash
flutter run
```

## 🎯 AI Prompt for Recreation

Use this exact prompt to recreate the entire BMG app from scratch:

```
Create a cross-platform mobile application using the Flutter framework named 'BMG'. The app should support both Android and iOS platforms and resemble a hotel room booking system. Use a theme pack inspired by Airbnb but with a distinct color palette. Include all necessary files, dependencies, and folder structures. The app should support user registration via email for anonymous users and allow existing users to log in. During registration, users must choose between 'guest' or 'host' roles. Guests can browse listings and book rooms without immediate payment. Upon booking, generate a unique order ID, confirm the booking, and send the order ID to the user's registered email. Include functionality to track booking status. Plan for future integration with Indian payment systems. Ensure clean architecture and modular code structure.

Requirements:
- Clean Architecture (Domain, Data, Presentation layers)
- BLoC state management with flutter_bloc
- Dependency injection using GetIt
- Email service for booking confirmations
- Airbnb-inspired UI with custom purple/violet color scheme
- Role-based authentication (Guest/Host)
- Booking system with date selection and pricing
- Order ID generation and tracking
- Local storage for user sessions
- Mock data for listings
- Cross-platform compatibility
- Future payment integration structure
```

## 📁 Project Structure Created

```
BMG/
├── lib/
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── app_colors.dart
│   │   ├── di/
│   │   │   └── injection_container.dart
│   │   └── utils/
│   │       └── email_service.dart
│   ├── data/
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   ├── listing_model.dart
│   │   │   └── booking_model.dart
│   │   ├── repositories/
│   │   │   ├── auth_repository_impl.dart
│   │   │   ├── listings_repository_impl.dart
│   │   │   └── booking_repository_impl.dart
│   │   └── datasources/
│   │       ├── auth_local_datasource.dart
│   │       ├── auth_remote_datasource.dart
│   │       ├── listings_datasource.dart
│   │       └── booking_datasource.dart
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── user.dart
│   │   │   ├── listing.dart
│   │   │   └── booking.dart
│   │   ├── repositories/
│   │   │   ├── auth_repository.dart
│   │   │   ├── listings_repository.dart
│   │   │   └── booking_repository.dart
│   │   └── usecases/
│   │       ├── usecase.dart
│   │       ├── auth/
│   │       │   ├── login_usecase.dart
│   │       │   └── register_usecase.dart
│   │       ├── booking/
│   │       │   ├── create_booking_usecase.dart
│   │       │   └── get_bookings_usecase.dart
│   │       └── listings/
│   │           └── get_listings_usecase.dart
│   ├── presentation/
│   │   ├── pages/
│   │   │   ├── splash/
│   │   │   │   └── splash_page.dart
│   │   │   ├── auth/
│   │   │   │   ├── login_page.dart
│   │   │   │   └── register_page.dart
│   │   │   ├── home/
│   │   │   │   └── home_page.dart
│   │   │   ├── listings/
│   │   │   │   └── listings_page.dart
│   │   │   ├── booking/
│   │   │   │   ├── booking_page.dart
│   │   │   │   └── bookings_page.dart
│   │   │   └── profile/
│   │   │       └── profile_page.dart
│   │   ├── widgets/
│   │   │   ├── custom_text_field.dart
│   │   │   ├── custom_button.dart
│   │   │   ├── search_bar.dart
│   │   │   ├── listing_card.dart
│   │   │   └── booking_card.dart
│   │   └── blocs/
│   │       ├── auth/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── listings/
│   │       │   ├── listings_bloc.dart
│   │       │   ├── listings_event.dart
│   │       │   └── listings_state.dart
│   │       └── booking/
│   │           ├── booking_bloc.dart
│   │           ├── booking_event.dart
│   │           └── booking_state.dart
│   └── main.dart
├── android/
│   └── app/src/main/
│       └── AndroidManifest.xml
├── ios/
│   └── Runner/
│       └── Info.plist
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
├── pubspec.yaml
├── README.md
└── SETUP_README.md
```

## 🔧 Configuration Steps

### Email Service Setup
1. Open `lib/core/utils/email_service.dart`
2. Replace `your-email@gmail.com` with your Gmail
3. Replace `your-app-password` with Gmail app password
4. Enable 2FA and generate app password in Gmail

### API Integration (Future)
1. Update base URLs in datasources
2. Replace mock implementations with real API calls
3. Add proper error handling and retry logic

## 📱 App Features

- ✅ Email authentication with role selection
- ✅ Airbnb-inspired UI with custom colors
- ✅ Hotel listing browsing and search
- ✅ Complete booking flow with date/guest selection
- ✅ Order ID generation and email confirmation
- ✅ Booking status tracking
- ✅ User profile management
- ✅ Clean architecture with BLoC pattern
- ✅ Cross-platform compatibility
- 🔄 Payment integration (structure ready)

## 🚀 Next Steps

1. Integrate real backend APIs
2. Add Indian payment gateways (Razorpay, UPI)
3. Implement push notifications
4. Add image upload functionality
5. Create host dashboard for listing management
6. Add review and rating system