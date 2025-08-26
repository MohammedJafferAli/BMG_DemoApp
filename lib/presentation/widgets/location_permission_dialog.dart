import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/location_service.dart';

class LocationPermissionDialog extends StatelessWidget {
  final Function(Position?) onLocationReceived;

  const LocationPermissionDialog({
    super.key,
    required this.onLocationReceived,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enable Location'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, size: 48, color: AppColors.primary),
          SizedBox(height: 16),
          Text(
            'Allow BMG to access your location to find nearby stays and provide better recommendations.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onLocationReceived(null);
          },
          child: const Text('Skip'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();
            final position = await LocationService.getCurrentLocation();
            onLocationReceived(position);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Allow'),
        ),
      ],
    );
  }
}