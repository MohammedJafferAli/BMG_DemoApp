import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static const String _smtpHost = 'smtp.gmail.com';
  static const int _smtpPort = 587;
  static const String _username = 'your-email@gmail.com'; // Configure with actual email
  static const String _password = 'your-app-password'; // Configure with app password

  Future<void> sendBookingConfirmation({
    required String toEmail,
    required String userName,
    required String orderId,
    required String listingTitle,
    required DateTime checkIn,
    required DateTime checkOut,
    required double totalPrice,
  }) async {
    try {
      final smtpServer = gmail(_username, _password);
      
      final message = Message()
        ..from = const Address(_username, 'BMG Booking')
        ..recipients.add(toEmail)
        ..subject = 'Booking Confirmation - Order #$orderId'
        ..html = _buildBookingEmailTemplate(
          userName: userName,
          orderId: orderId,
          listingTitle: listingTitle,
          checkIn: checkIn,
          checkOut: checkOut,
          totalPrice: totalPrice,
        );

      await send(message, smtpServer);
    } catch (e) {
      // Log error in production
      print('Failed to send email: $e');
    }
  }

  String _buildBookingEmailTemplate({
    required String userName,
    required String orderId,
    required String listingTitle,
    required DateTime checkIn,
    required DateTime checkOut,
    required double totalPrice,
  }) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <style>
            body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f8f9fa; }
            .container { max-width: 600px; margin: 0 auto; background-color: white; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
            .header { background-color: #6C5CE7; color: white; padding: 30px; text-align: center; }
            .content { padding: 30px; }
            .order-id { background-color: #f8f9fa; padding: 15px; border-radius: 8px; margin: 20px 0; text-align: center; }
            .details { margin: 20px 0; }
            .detail-row { display: flex; justify-content: space-between; margin: 10px 0; padding: 10px 0; border-bottom: 1px solid #eee; }
            .footer { background-color: #f8f9fa; padding: 20px; text-align: center; color: #666; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>🏨 BMG</h1>
                <h2>Booking Confirmed!</h2>
            </div>
            <div class="content">
                <p>Dear $userName,</p>
                <p>Your booking has been confirmed! Here are your booking details:</p>
                
                <div class="order-id">
                    <h3>Order ID: $orderId</h3>
                </div>
                
                <div class="details">
                    <div class="detail-row">
                        <strong>Property:</strong>
                        <span>$listingTitle</span>
                    </div>
                    <div class="detail-row">
                        <strong>Check-in:</strong>
                        <span>${checkIn.day}/${checkIn.month}/${checkIn.year}</span>
                    </div>
                    <div class="detail-row">
                        <strong>Check-out:</strong>
                        <span>${checkOut.day}/${checkOut.month}/${checkOut.year}</span>
                    </div>
                    <div class="detail-row">
                        <strong>Total Amount:</strong>
                        <span>₹${totalPrice.toStringAsFixed(2)}</span>
                    </div>
                </div>
                
                <p>Please save this email for your records. You can track your booking status in the BMG app.</p>
                <p>Thank you for choosing BMG!</p>
            </div>
            <div class="footer">
                <p>© 2024 BMG - Book My Guest</p>
            </div>
        </div>
    </body>
    </html>
    ''';
  }
}