import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive_utils.dart';

class PriceBreakdown extends StatelessWidget {
  final double basePrice;
  final int nights;
  final double taxRate;
  final double serviceFee;
  final double discount;

  const PriceBreakdown({
    super.key,
    required this.basePrice,
    required this.nights,
    this.taxRate = 0.12,
    this.serviceFee = 200,
    this.discount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal = basePrice * nights;
    final taxes = subtotal * taxRate;
    final total = subtotal + taxes + serviceFee - discount;

    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Breakdown',
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(context, mobile: 18),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveUtils.spacing(context)),
          
          _buildPriceRow('₹${basePrice.toStringAsFixed(0)} x $nights nights', subtotal),
          _buildPriceRow('Service fee', serviceFee),
          _buildPriceRow('Taxes (${(taxRate * 100).toInt()}%)', taxes),
          
          if (discount > 0)
            _buildPriceRow('Discount', -discount, isDiscount: true),
          
          const Divider(),
          _buildPriceRow('Total', total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            '${isDiscount ? '-' : ''}₹${amount.abs().toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isDiscount ? AppColors.success : (isTotal ? AppColors.primary : null),
            ),
          ),
        ],
      ),
    );
  }
}