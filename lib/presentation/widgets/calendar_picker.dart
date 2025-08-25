import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive_utils.dart';

class CalendarPicker extends StatefulWidget {
  final DateTime? checkIn;
  final DateTime? checkOut;
  final Function(DateTime?, DateTime?) onDatesChanged;

  const CalendarPicker({
    super.key,
    this.checkIn,
    this.checkOut,
    required this.onDatesChanged,
  });

  @override
  State<CalendarPicker> createState() => _CalendarPickerState();
}

class _CalendarPickerState extends State<CalendarPicker> {
  DateTime? _checkIn;
  DateTime? _checkOut;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _checkIn = widget.checkIn;
    _checkOut = widget.checkOut;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDateButton('Check-in', _checkIn),
              _buildDateButton('Check-out', _checkOut),
            ],
          ),
          SizedBox(height: ResponsiveUtils.spacing(context)),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(context)),
            ),
            child: CalendarDatePicker(
              initialDate: _focusedDay,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              onDateChanged: _onDateSelected,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateButton(String label, DateTime? date) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.spacing(context, mobile: 12)),
        decoration: BoxDecoration(
          color: date != null ? AppColors.primary.withOpacity(0.1) : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(context)),
          border: Border.all(
            color: date != null ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(context, mobile: 12),
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              date != null ? '${date.day}/${date.month}' : 'Select',
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(context, mobile: 16),
                fontWeight: FontWeight.w600,
                color: date != null ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      if (_checkIn == null || (_checkIn != null && _checkOut != null)) {
        _checkIn = date;
        _checkOut = null;
      } else if (_checkIn != null && _checkOut == null) {
        if (date.isAfter(_checkIn!)) {
          _checkOut = date;
        } else {
          _checkIn = date;
          _checkOut = null;
        }
      }
    });
    widget.onDatesChanged(_checkIn, _checkOut);
  }
}