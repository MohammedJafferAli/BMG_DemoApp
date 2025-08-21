# BMG - Book My Guest

A cross-platform mobile application built with Flutter for hotel room booking, inspired by Airbnb's design with a distinct color palette.

## Features

### Authentication
- Email-based user registration and login
- Role-based system (Guest/Host)
- Secure local storage for user sessions

### Booking System
- Browse hotel listings with search functionality
- Book rooms without immediate payment
- Generate unique order IDs for each booking
- Email confirmation with booking details
- Track booking status (Pending, Confirmed, Cancelled, Completed)

### User Interface
- Airbnb-inspired design with custom color palette
- Clean and intuitive user experience
- Cross-platform compatibility (Android & iOS)
- Responsive design with proper theming

### Architecture
- Clean Architecture pattern
- BLoC state management
- Dependency injection with GetIt
- Modular code structure

## Project Structure

```
lib/
├── core/
│   ├── theme/           # App theming and colors
│   ├── di/              # Dependency injection
│   ├── utils/           # Utility classes (email service)
│   └── constants/       # App constants
├── data/
│   ├── models/          # Data models with JSON serialization
│   ├── repositories/    # Repository implementations
│   └── datasources/     # Local and remote data sources
├── domain/
│   ├── entities/        # Business entities
│   ├── repositories/    # Repository interfaces
│   └── usecases/        # Business logic use cases
└── presentation/
    ├── pages/           # UI screens
    ├── widgets/         # Reusable UI components
    └── blocs/           # State management
```

## Getting Started

### Prerequisites
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode for platform-specific development

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd BMG
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (for JSON serialization):
```bash
flutter packages pub run build_runner build
```

4. Run the app:
```bash
flutter run
```

## Configuration

### Email Service
To enable email notifications, update the email configuration in `lib/core/utils/email_service.dart`:
- Replace `your-email@gmail.com` with your Gmail address
- Replace `your-app-password` with your Gmail app password
- Enable 2-factor authentication and generate an app password

### API Integration
Currently using mock data. To integrate with real APIs:
1. Update the base URL in data sources
2. Implement proper authentication endpoints
3. Add error handling and retry mechanisms

## Future Enhancements

### Payment Integration
- Integration with Indian payment systems (Razorpay, Paytm, UPI)
- Secure payment processing
- Payment history and receipts

### Additional Features
- Push notifications
- Real-time chat between guests and hosts
- Review and rating system
- Advanced search filters
- Map integration
- Multi-language support

## Dependencies

### Core
- `flutter_bloc`: State management
- `get_it`: Dependency injection
- `equatable`: Value equality

### Networking & Storage
- `dio`: HTTP client
- `shared_preferences`: Local storage
- `hive`: Local database

### UI Components
- `flutter_rating_bar`: Rating display
- `cached_network_image`: Image caching
- `carousel_slider`: Image carousels

### Utilities
- `uuid`: Unique ID generation
- `intl`: Internationalization
- `mailer`: Email service

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please contact the development team or create an issue in the repository.