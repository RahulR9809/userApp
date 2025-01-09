
// Ride BLoC Implementation
import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_event.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:rideuser/controller/ride_controller.dart';
import 'package:rideuser/widgets/ride_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
  List<Map<String, dynamic>> driver = [];

class RideBloc extends Bloc<RideEvent, RideState> {

    final RideService _rideService = RideService();
  bool _isBottomBarVisible = false;

  RideBloc() : super(RideInitial()) {
    on<FetchCurrentLocation>(_onFetchCurrentLocation);
     on<FetchSuggestions>(_onFetchSuggestions);
    on<SelectSuggestion>(_onSelectSuggestion);

        on<FetchNearbyDrivers>(_onFetchNearbyDrivers);

          on<CalculateRideDistance>(_onCalculateRideDistance);
    on<CalculateFare>(_onCalculateFare);
    on<RequestRide>(_onRequestRide);

      on<SelectVehicle>(_onSelectVehicle);
    on<SelectPayment>(_onSelectPayment);
    on<ToggleBottomBar>(_onToggleBottomBar);

    on<UpdateCurrentLocation>(_onUpdateCurrentLocation);


  }



  

  void _onToggleBottomBar(ToggleBottomBar event, Emitter<RideState> emit) {
    _isBottomBarVisible = !_isBottomBarVisible;
    emit(BottomBarVisibilityChanged(isVisible: _isBottomBarVisible));
  }


  // Future<void> _onFetchCurrentLocation(
  //     FetchCurrentLocation event, Emitter<RideState> emit) async {
  //   emit(LocationLoading());

  //   try {
  //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       throw Exception('Location services are disabled.');
  //     }

  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         throw Exception('Location permission denied.');
  //       }
  //     }

  //     if (permission == LocationPermission.deniedForever) {
  //       throw Exception(
  //           'Location permissions are permanently denied. Please enable them in settings.');
  //     }

  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.bestForNavigation,
  //     );

  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       position.latitude,
  //       position.longitude,
  //     );

  //     if (placemarks.isNotEmpty) {
  //       Placemark place = placemarks[0];
  //       String address =
  //           "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";

  //       emit(LocationLoaded(
  //        position.latitude,
  //          position.longitude,
  //         address,
  //       ));
  //     } else {
  //       const SnackBar(content: Text('Turn on Location'));
  //     }
  //   } catch (e) {
  //     DialogHelper.showCustomDialog(content:'please enable location service', title: 'warning', primaryButtonText: 'OK', context: event.context);
  //     emit(LocationError('Error fetching location: $e'));
  //   }
  // }







 Future<void> _onFetchCurrentLocation(
      FetchCurrentLocation event, Emitter<RideState> emit) async {
    emit(LocationLoading());
    try {
      // Check location permission
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location services are disabled.');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied.');
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Reverse geocoding to get address
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      String address = placemarks.isNotEmpty
          ? "${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].country}"
          : "Unknown Location";

      emit(LocationLoaded(position.latitude, position.longitude, address));
    } catch (e) {
      emit(LocationError('Error fetching location: $e'));
    }
  }

  // Handle updating location from MapPage
  void _onUpdateCurrentLocation(
      UpdateCurrentLocation event, Emitter<RideState> emit) {
    emit(LocationLoaded(event.latitude, event.longitude, event.address));
  }







Future<void> _onFetchSuggestions(
    FetchSuggestions event, Emitter<RideState> emit) async {
  emit(SuggestionsLoading());  // Emit loading state first
  try {
    final suggestions = await RideService().fetchPickupLocation(event.query); // Ensure this is fetching the suggestions
    emit(SuggestionsLoaded(suggestions));  // Emit suggestions loaded state with data
  } catch (e) {
    emit(DestinationError('Failed to fetch suggestions: $e'));  // Handle errors gracefully
  }
}





Future<void> _onSelectSuggestion(
    SelectSuggestion event, Emitter<RideState> emit) async {

    try {
      final locations = await locationFromAddress(event.address).timeout(
        const Duration(seconds: 4),
      );
      if (locations.isNotEmpty) {
        final location = locations.first;
        emit(AddressSelected(
          location.latitude,
          location.longitude,
          event.address,
        ));
        return;  // Success, exit the loop
      } else {
        throw Exception('No location found');
      }
    } catch (e) {
   
        return;
      }
    }
  


  void _onFetchNearbyDrivers(
    FetchNearbyDrivers event, Emitter<RideState> emit) async {
  emit(NearbyDriversLoading());
        SharedPreferences prefs = await SharedPreferences.getInstance();
      final id=  prefs.getString('userid');
      final googletoken=prefs.getString('googletoken');
      final emailtoken=prefs.getString('emailtoken');
      final token=googletoken ?? emailtoken;
  try {
    final drivers = await RideService().getNearByDrivers(
      userId: id!, 
      pickupLatitude: event.latitude,
      pickupLongitude: event.longitude,
      dropLatitude: event.latitude, // Example, replace as needed
      dropLongitude: event.longitude, // Example, replace as needed
      vehicleType: event.vehicleType,
      accessToken: token!, // Replace with your logic
    );
driver.addAll(drivers);
if(drivers.isEmpty){
  emit(NearbyDriversError('No Drivers found in you area'));
}
if (kDebugMode) {
  print('dirvers data is here $driver');
}
    emit(NearbyDriversLoaded(drivers));
  } catch (e) {
    emit(NearbyDriversError('Error fetching nearby drivers: $e'));
  }
}




// Handle distance calculation
  void _onCalculateRideDistance(
    CalculateRideDistance event,
    Emitter<RideState> emit,
  ) {
    double distance = _calculateDistance(
      event.startLatitude,
      event.startLongitude,
      event.endLatitude,
      event.endLongitude,
    );
    emit(RideDistanceCalculated(distance));
  }

  // Handle fare calculation
  void _onCalculateFare(CalculateFare event, Emitter<RideState> emit) {
    double fare = _calculateFare(event.distanceInKm);
    emit(RideFareCalculated(fare));
  }

  // Handle requesting a ride
  void _onRequestRide(RequestRide event, Emitter<RideState> emit) async {
    try {
      emit(RideLoading()); // Indicate loading state

      // Call the service to create the ride request
      final response = await _rideService.createRideRequest(
        userId: event.userId,
        fare: event.fare,
        distance: event.distance,
        duration: event.duration,
        pickUpCoords: event.pickUpCoords,
        dropCoords: event.dropCoords,
        vehicleType: event.vehicleType,
        pickupLocation: event.pickupLocation,
        dropLocation: event.dropLocation,
        paymentMethod: event.paymentMethod,
      );

      if (response.isNotEmpty) {
      
        emit(RideRequested('Ride requested successfully!'));
       
      } else {
        emit(RideRequestError('Failed to request ride. Please try again.'));
      }
    } catch (e) {
      emit(RideRequestError('Error requesting ride: $e'));
    }
  }

  // Calculate distance using Haversine formula
  double _calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    const double radiusOfEarthKm = 6371; // Radius of Earth in kilometers
    double latDistance = (endLatitude - startLatitude) * pi / 180;
    double lonDistance = (endLongitude - startLongitude) * pi / 180;

    double a = sin(latDistance / 2) * sin(latDistance / 2) +
        cos(startLatitude * pi / 180) *
            cos(endLatitude * pi / 180) *
            sin(lonDistance / 2) *
            sin(lonDistance / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radiusOfEarthKm * c; // Distance in kilometers
  }

  // Calculate fare based on distance
  double _calculateFare(double distanceInKm) {
    if (distanceInKm <= 2) {
      return 40; // Flat rate for 2 km or less
    } else {
      return 40 + ((distanceInKm - 2) * 20); // Additional Rs. 20 per km after 2 km
    }
  }




  void _onSelectVehicle(SelectVehicle event, Emitter<RideState> emit) {
    emit(VehicleSelected(event.vehicleType));
  }

  void _onSelectPayment(SelectPayment event, Emitter<RideState> emit) {
    emit(PaymentSelected(event.paymentMethod));
  }


}

