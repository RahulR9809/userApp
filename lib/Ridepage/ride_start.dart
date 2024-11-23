import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';


class LocationHelper {
  final BuildContext context;

  LocationHelper(this.context);

  Future<void> updateDestinationLocation({
    required TextEditingController destinationController,
    required Function(double, double) onLocationUpdated,
  }) async {
    if (destinationController.text.isNotEmpty) {
      try {
        // Get coordinates from the destination address
        Location? location = await _getCoordinatesFromAddress(destinationController.text);

        if (location != null) {
          // Get the full address details using the coordinates
          String? fullAddress = await _getAddressFromCoordinates(location.latitude, location.longitude);

          if (fullAddress != null) {
            destinationController.text = fullAddress;
            onLocationUpdated(location.latitude, location.longitude);
          }
        }
      } catch (e) {
        _showSnackBar('Error updating destination location: $e');
      }
    }
  }

  // Helper method to get coordinates from an address
  Future<Location?> _getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return locations.first;
      }
    } catch (e) {
      _showSnackBar('Error fetching coordinates from address: $e');
    }
    return null;
  }

  // Helper method to get a full address from coordinates
  Future<String?> _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";
      }
    } catch (e) {
      _showSnackBar('Error fetching address from coordinates: $e');
    }
    return null;
  }

  // Helper method to show a snackbar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class LocationService {



  
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
  }

  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      return "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";
    }
    return '';
  }

  Future<Location?> getLocationFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return locations.first;
      }
    } catch (e) {
      print('Error fetching location: $e');
    }
    return null;
  }
}



class RideController {
  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    const double radiusOfEarthKm = 6371;
    double latDistance = (endLatitude - startLatitude) * pi / 180;
    double lonDistance = (endLongitude - startLongitude) * pi / 180;

    double a = sin(latDistance / 2) * sin(latDistance / 2) +
        cos(startLatitude * pi / 180) *
            cos(endLatitude * pi / 180) *
            sin(lonDistance / 2) *
            sin(lonDistance / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radiusOfEarthKm * c; // Distance in km
  }

  double calculateFare(double distanceInKm) {
    if (distanceInKm <= 2) {
      return 40; // Flat rate for 2 km or less
    } else {
      return 40 + ((distanceInKm - 2) * 20); // Additional Rs. 20 per km after 2 km
    }
  }
}



class LocationInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final VoidCallback onPressed;

  const LocationInputField({
    Key? key,
    required this.label,
    required this.controller,
    required this.hint,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: IconButton(
              icon: Icon(icon),
              onPressed: onPressed,
            ),
          ),
        ),
      ],
    );
  }
}



class VehicleCard extends StatelessWidget {
  final String vehicleName;
  final String imageUrl;
  final String vehicleType;
  final bool isSelected;
  final void Function(String vehicleType) onSelect;

  const VehicleCard({
    Key? key,
    required this.vehicleName,
    required this.imageUrl,
    required this.vehicleType,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelect(vehicleType);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        color: isSelected ? Colors.green.shade200 : Colors.white,
        child: Container(
          width: 150,
          height: 130,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.directions_car, color: Colors.green, size: 60),
              const SizedBox(height: 8.0),
              Text(
                vehicleName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                vehicleType,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


