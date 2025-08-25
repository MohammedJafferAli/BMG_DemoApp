import 'dart:async';
import 'package:flutter/material.dart';

class AvailabilityService {
  static final AvailabilityService _instance = AvailabilityService._internal();
  factory AvailabilityService() => _instance;
  AvailabilityService._internal();

  final Map<String, bool> _availabilityCache = {};
  final StreamController<Map<String, bool>> _availabilityController = 
      StreamController<Map<String, bool>>.broadcast();

  Stream<Map<String, bool>> get availabilityStream => _availabilityController.stream;

  Future<bool> checkRealTimeAvailability(
    String listingId,
    DateTime checkIn,
    DateTime checkOut,
  ) async {
    // Mock real-time check - in real app, call hotel API
    await Future.delayed(const Duration(milliseconds: 500));
    
    final isAvailable = DateTime.now().millisecond % 2 == 0;
    _availabilityCache[listingId] = isAvailable;
    _availabilityController.add(Map.from(_availabilityCache));
    
    return isAvailable;
  }

  Future<Map<String, dynamic>> getDynamicPricing(
    String listingId,
    DateTime checkIn,
    DateTime checkOut,
  ) async {
    // Mock dynamic pricing based on demand
    await Future.delayed(const Duration(milliseconds: 300));
    
    final basePrice = 2000.0;
    final demandMultiplier = _calculateDemandMultiplier(checkIn);
    final seasonalMultiplier = _calculateSeasonalMultiplier(checkIn);
    
    final finalPrice = basePrice * demandMultiplier * seasonalMultiplier;
    
    return {
      'basePrice': basePrice,
      'finalPrice': finalPrice,
      'demandMultiplier': demandMultiplier,
      'seasonalMultiplier': seasonalMultiplier,
      'savings': basePrice > finalPrice ? basePrice - finalPrice : 0,
    };
  }

  double _calculateDemandMultiplier(DateTime checkIn) {
    final dayOfWeek = checkIn.weekday;
    // Weekend pricing
    if (dayOfWeek == 6 || dayOfWeek == 7) {
      return 1.3;
    }
    return 1.0;
  }

  double _calculateSeasonalMultiplier(DateTime checkIn) {
    final month = checkIn.month;
    // Peak season (Dec-Jan, Mar-May)
    if ([12, 1, 3, 4, 5].contains(month)) {
      return 1.2;
    }
    // Off season (Jun-Sep)
    if ([6, 7, 8, 9].contains(month)) {
      return 0.8;
    }
    return 1.0;
  }

  Future<int> getRemainingRooms(String listingId) async {
    // Mock remaining rooms count
    await Future.delayed(const Duration(milliseconds: 200));
    return 3 + DateTime.now().millisecond % 8;
  }

  void startAvailabilityPolling(List<String> listingIds) {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      for (final id in listingIds) {
        checkRealTimeAvailability(id, DateTime.now(), DateTime.now().add(const Duration(days: 1)));
      }
    });
  }

  void dispose() {
    _availabilityController.close();
  }
}