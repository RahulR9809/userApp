
import 'package:flutter/material.dart';

sealed class RideEvent {}

class FetchCurrentLocation extends RideEvent {
  final BuildContext context;

  FetchCurrentLocation({required this.context});
}


class FetchSuggestions extends RideEvent {
  final String query;

  FetchSuggestions(this.query);
}

class SelectSuggestion extends RideEvent {
  final String address;

  SelectSuggestion(this.address);
}

class FetchNearbyDrivers extends RideEvent {
  final double latitude;
  final double longitude;
  final String? vehicleType;

  FetchNearbyDrivers({
    required this.latitude,
    required this.longitude,
    this.vehicleType,
  });
}



class CalculateRideDistance extends RideEvent {
  final double startLatitude;
  final double startLongitude;
  final double endLatitude;
  final double endLongitude;

  CalculateRideDistance({
    required this.startLatitude,
    required this.startLongitude,
    required this.endLatitude,
    required this.endLongitude,
  });
}

class CalculateFare extends RideEvent {
  final double distanceInKm;

  CalculateFare(this.distanceInKm);
}

class RequestRide extends RideEvent {
  final String userId;
  final double fare;
  final double distance;
  final double duration;
  final List<double> pickUpCoords;
  final List<double> dropCoords;
  final String vehicleType;
  final String pickupLocation;
  final String dropLocation;
  final String paymentMethod;

  RequestRide({
    required this.userId,
    required this.fare,
    required this.distance,
    required this.duration,
    required this.pickUpCoords,
    required this.dropCoords,
    required this.vehicleType,
    required this.pickupLocation,
    required this.dropLocation,
    required this.paymentMethod,
  });
}



class ValidateRideRequest extends RideEvent {
  final List<Map<String, dynamic>> nearbyDrivers;
  final List<double>? pickUpCoords;
  final List<double>? dropCoords;
  final String? vehicleType;
  final String pickupLocation;
  final String dropLocation;

  ValidateRideRequest({
    required this.nearbyDrivers,
    required this.pickUpCoords,
    required this.dropCoords,
    required this.vehicleType,
    required this.pickupLocation,
    required this.dropLocation,
  });
}



