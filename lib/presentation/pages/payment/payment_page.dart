import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';

class PaymentPage extends StatefulWidget {
  final double totalAmount;
  final String bookingId;

  const PaymentPage({
    super.key,
    required this.totalAmount,
    required this.bookingId,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedMethod = 'UPI';
  final _upiController = TextEditingController();
  final _cardController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAmountCard(),
            SizedBox(height: ResponsiveUtils.spacing(context)),
            _buildPaymentMethods(),
            const Spacer(),
            _buildPayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Amount', style: TextStyle(fontSize: 18)),
            Text(
              '₹${widget.totalAmount.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        SizedBox(height: ResponsiveUtils.spacing(context, mobile: 12)),
        
        _buildPaymentOption('UPI', Icons.account_balance_wallet, 'Pay with UPI ID'),
        _buildPaymentOption('Card', Icons.credit_card, 'Credit/Debit Card'),
        _buildPaymentOption('Wallet', Icons.wallet, 'Digital Wallet'),
        
        if (_selectedMethod == 'UPI') _buildUPIInput(),
        if (_selectedMethod == 'Card') _buildCardInput(),
      ],
    );
  }

  Widget _buildPaymentOption(String method, IconData icon, String subtitle) {
    return Card(
      child: RadioListTile<String>(
        value: method,
        groupValue: _selectedMethod,
        onChanged: (value) => setState(() => _selectedMethod = value!),
        title: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            SizedBox(width: ResponsiveUtils.spacing(context, mobile: 8)),
            Text(method),
          ],
        ),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget _buildUPIInput() {
    return Padding(
      padding: EdgeInsets.only(top: ResponsiveUtils.spacing(context, mobile: 8)),
      child: TextField(
        controller: _upiController,
        decoration: const InputDecoration(
          labelText: 'UPI ID',
          hintText: 'example@upi',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildCardInput() {
    return Padding(
      padding: EdgeInsets.only(top: ResponsiveUtils.spacing(context, mobile: 8)),
      child: TextField(
        controller: _cardController,
        decoration: const InputDecoration(
          labelText: 'Card Number',
          hintText: '1234 5678 9012 3456',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      height: ResponsiveUtils.minTouchTarget(context),
      child: ElevatedButton(
        onPressed: _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        child: Text('Pay ₹${widget.totalAmount.toStringAsFixed(0)}'),
      ),
    );
  }

  void _processPayment() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Payment Successful'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 64),
            SizedBox(height: ResponsiveUtils.spacing(context)),
            Text('Payment of ₹${widget.totalAmount.toStringAsFixed(0)} completed'),
            Text('Booking ID: ${widget.bookingId}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}