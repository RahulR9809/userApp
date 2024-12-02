

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:rideuser/core/colors.dart';

class RideController {
  // Method to calculate the distance between two coordinates in kilometers
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

  // Method to calculate fare based on the distance
  double calculateFare(double distanceInKm) {
    if (distanceInKm <= 2) {
      return 40; // Flat rate for 2 km or less
    } else {
      return 40 +
          ((distanceInKm - 2) * 20); // Additional Rs. 20 per km after 2 km
    }
  }
}




class VehicleCard extends StatelessWidget {
  final String vehicleName;
  final String imageUrl;
  final String vehicleType;
  final bool isSelected;  // Add isSelected to track selection
  final void Function(String vehicleType) onSelect;

  const VehicleCard({
    super.key,
    required this.vehicleName,
    required this.imageUrl,
    required this.vehicleType,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelect(vehicleType);  // Notify parent when selected
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        color: isSelected ? Colors.green.shade200 : Colors.white,  // Change color based on selection
        child: Container(
          width: 150, // Set custom width
          height: 130, // Set custom height
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      height: 100, // Adjust image height
                      width: 100, // Adjust image width
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.directions_car,
                      color: Colors.green, size: 60),
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


  
  buildLocationInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: ThemeColors.brightWhite),
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


  // lib/services/location_service.da

class LocationService {
  Future<Map<String, dynamic>> getCurrentLocation(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable them in settings.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied. Please allow access.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied. Please enable them in settings.');
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";

        return {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'address': address,
        };
      }
      throw Exception('No placemarks found for the current location.');
    } catch (e) {
      throw Exception('Error fetching location: $e');
    }
  }
}

class MapContainerCard extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final double? destinationLatitude;
  final double? destinationLongitude;

  const MapContainerCard({
    super.key,
    this.latitude,
    this.longitude,
    this.destinationLatitude,
    this.destinationLongitude,
  });

  @override
  MapContainerCardState createState() => MapContainerCardState();
}

class MapContainerCardState extends State<MapContainerCard> {
  MapboxMapController? _mapController;
  LatLng? _currentLocationMarker;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
    updateMapLocation(widget.latitude, widget.longitude);
  }

  /// Updates map location only if it differs from the current marker location
  void updateMapLocation(double? latitude, double? longitude) {
    if (_mapController != null && latitude != null && longitude != null) {
      LatLng newPosition = LatLng(latitude, longitude);
      if (isCurrentLocationMarker(newPosition.latitude, newPosition.longitude)) {
        return; // Skip if the new position matches the current marker
      }

      _currentLocationMarker = newPosition;
      _mapController!.animateCamera(CameraUpdate.newLatLngZoom(newPosition, 14.0));

      _mapController!.clearSymbols(); // Clear existing markers
      _mapController!.addSymbol(SymbolOptions(
        geometry: newPosition,
        iconImage: "assets/liveLocation.png",
        iconSize: 0.5,
      ));
    }
  }

  /// Checks if the given latitude and longitude match the current marker's location
  bool isCurrentLocationMarker(double latitude, double longitude) {
    if (_currentLocationMarker == null) return false;
    return _currentLocationMarker!.latitude == latitude &&
        _currentLocationMarker!.longitude == longitude;
  }

  /// Adds a driver marker with a specific vehicle type
  void addDriverMarker(double latitude, double longitude, String vehicleType) {
    String iconAsset;
    if (vehicleType == 'Auto') {
      iconAsset = "assets/AutoLoction.png"; // Replace with the actual path of your auto image
    } else if (vehicleType == 'Car') {
      iconAsset = "assets/vehicleLocation.png"; // Replace with the actual path of your car image
    } else {
      iconAsset = "assets/vehicleLocation.png"; // Default icon
    }

    _mapController?.addSymbol(SymbolOptions(
      geometry: LatLng(latitude, longitude),
      iconImage: iconAsset,
      iconSize: 0.3, // Adjust the size as needed
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: MapboxMap(
        accessToken:
            "pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ", // Use your Mapbox token
        initialCameraPosition: CameraPosition(
          target: widget.latitude != null && widget.longitude != null
              ? LatLng(widget.latitude!, widget.longitude!)
              : const LatLng(9.968677, 76.318354),
          zoom: 14.0,
        ),
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
          Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
          Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
          Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer()),
        },
        onMapCreated: _onMapCreated,
        zoomGesturesEnabled: true, // Enable zoom gestures
        scrollGesturesEnabled: true, // Enable scroll gestures
        rotateGesturesEnabled: true, // Enable rotation gestures
        tiltGesturesEnabled: true, // Enable tilt gestures
        styleString: MapboxStyles.MAPBOX_STREETS,
      ),
    );
  }
}


// lib/widgets/loading_dialog.dart


class LoadingDialog extends StatelessWidget {
  final String message;

  const LoadingDialog({Key? key, this.message = 'Fetching location...'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text(message, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}


//for fetching searched place address//
//  Future<void> _updateDestinationLocation() async {
//     if (_destinationController.text.isNotEmpty) {
//       try {
//         List<Location> locations =
//             await locationFromAddress(_destinationController.text);
//         if (locations.isNotEmpty) {
//           Location location = locations.first;
//           List<Placemark> placemarks = await placemarkFromCoordinates(
//             location.latitude,
//             location.longitude,
//           );

//           if (placemarks.isNotEmpty) {
//             Placemark place = placemarks[0];
//             String fullAddress =
//                 "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";

//             setState(() {
//               _destinationController.text = fullAddress;
//               _destinationLatitude = location.latitude;
//               _destinationLongitude = location.longitude;
//             });
//           }
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error updating destination location: $e')),
//         );
//       }
//     }
//   } 



