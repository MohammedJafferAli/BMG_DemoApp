# 🤖 AI Prompt for BMG Recreation

## Complete Prompt for AI Assistant

```
Create a cross-platform mobile application using the Flutter framework named 'BMG'. The app should support both Android and iOS platforms and resemble a hotel room booking system. Use a theme pack inspired by Airbnb but with a distinct color palette. Include all necessary files, dependencies, and folder structures. The app should support user registration via email for anonymous users and allow existing users to log in. During registration, users must choose between 'guest' or 'host' roles. Guests can browse listings and book rooms without immediate payment. Upon booking, generate a unique order ID, confirm the booking, and send the order ID to the user's registered email. Include functionality to track booking status. Plan for future integration with Indian payment systems. Ensure clean architecture and modular code structure.

Technical Requirements:
- Clean Architecture (Domain, Data, Presentation layers)
- BLoC state management with flutter_bloc
- Dependency injection using GetIt
- Email service for booking confirmations with HTML templates
- Airbnb-inspired UI with custom purple/violet color scheme (#6C5CE7 primary)
- Role-based authentication (Guest/Host) with local storage
- Complete booking system with date selection, guest count, and pricing
- Unique order ID generation (BMG + timestamp format)
- Booking status tracking (Pending, Confirmed, Cancelled, Completed)
- Mock data for hotel listings with Indian locations
- Cross-platform compatibility with proper Android/iOS configs
- Future payment integration structure for Razorpay, UPI, Paytm
- Email confirmation system using mailer package
- Search functionality for listings
- User profile management with logout
- Responsive UI with cards, proper spacing, and modern design
- Error handling and loading states
- Form validation for authentication
- Local caching with SharedPreferences and Hive

UI Components Needed:
- Splash screen with BMG branding
- Login/Register pages with role selection
- Home page with bottom navigation
- Listings page with search and cards
- Booking page with date picker and pricing
- Bookings history page
- Profile page with user info and settings
- Custom widgets: buttons, text fields, cards
- Status indicators and confirmation dialogs

Data Models:
- User (id, email, name, role, createdAt)
- Listing (id, title, description, location, price, images, rating, host info, amenities)
- Booking (id, orderId, listingId, guestId, dates, guests, totalPrice, status, createdAt)

Mock Data:
- 3-5 sample hotel listings in Indian cities (Goa, Mumbai, Jaipur)
- Realistic pricing in INR
- Sample amenities and host information
- Proper image placeholders

File Structure:
Complete clean architecture with proper separation of concerns, all necessary imports, proper error handling, and production-ready code quality.
```

## Usage Instructions

1. **Copy the above prompt exactly**
2. **Paste into any AI assistant (Claude, ChatGPT, etc.)**
3. **The AI will generate the complete BMG app**
4. **Follow the setup instructions in SETUP_README.md**

## Alternative: Use the Shell Script

```bash
# Run the automated setup
chmod +x setup_bmg.sh
./setup_bmg.sh

# Then use the AI prompt to fill in the complete implementation
```

## Expected Output

The AI should generate:
- ✅ Complete Flutter project structure
- ✅ All 50+ files with proper implementation
- ✅ Working authentication system
- ✅ Hotel booking functionality
- ✅ Email service integration
- ✅ Clean architecture pattern
- ✅ BLoC state management
- ✅ Cross-platform compatibility
- ✅ Production-ready code quality

## Verification Checklist

After AI generation, verify:
- [ ] `flutter pub get` runs successfully
- [ ] `flutter run` launches the app
- [ ] Authentication flow works
- [ ] Listings display properly
- [ ] Booking flow completes
- [ ] Email service is configured
- [ ] All imports resolve correctly
- [ ] No compilation errors