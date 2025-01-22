
import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:rideuser/features/ride/bloc/RequestRide/bloc/ride_event.dart';
import 'package:rideuser/features/ride/bloc/RequestRide/bloc/ride_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:rideuser/features/ride/service/ride_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Map<String, dynamic>> driver = [];

class RideBloc extends Bloc<RideEvent, RideState> {
  final RideService _rideService = RideService();
  bool _isBottomBarVisible = false;

  RideBloc() : super(RideInitial()) {
    on<FetchLocation>(_onFetchCurrentLocation);
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

  Future<void> _onFetchCurrentLocation(
    FetchLocation event,
    Emitter<RideState> emit,
  ) async {
    emit(LocationLoading());

    try {
      double latitude;
      double longitude;
      String address;

      if (event.latitude != null && event.longitude != null) {
        latitude = event.latitude!;
        longitude = event.longitude!;
      } else {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          throw Exception('Location services are disabled.');
        }

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
        latitude = position.latitude;
        longitude = position.longitude;
      }

      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      address = placemarks.isNotEmpty
          ? "${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].country}"
          : "Unknown Location";

      emit(LocationLoaded(latitude, longitude, address));
    } catch (e) {
      emit(LocationError('Error fetching location: $e'));
    }
  }

  void _onUpdateCurrentLocation(
      UpdateCurrentLocation event, Emitter<RideState> emit) {
    if (kDebugMode) {
      print('Emitting loacation loa');
    }
    emit(LocationLoaded(event.latitude, event.longitude, event.address));
  }

  Future<void> _onFetchSuggestions(
      FetchSuggestions event, Emitter<RideState> emit) async {
    emit(SuggestionsLoading()); 
    try {
      final suggestions = await RideService().fetchPickupLocation(
          event.query); 
      emit(SuggestionsLoaded(
          suggestions));
    } catch (e) {
      emit(DestinationError(
          'Failed to fetch suggestions: $e')); 
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
        return; 
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
    final id = prefs.getString('userid');
    final googletoken = prefs.getString('googletoken');
    final emailtoken = prefs.getString('emailtoken');
    final token = googletoken ?? emailtoken;
    try {
      final drivers = await RideService().getNearByDrivers(
        userId: id!,
        pickupLatitude: event.latitude,
        pickupLongitude: event.longitude,
        dropLatitude: event.latitude, 
        dropLongitude: event.longitude, 
        vehicleType: event.vehicleType,
        accessToken: token!, 
      );
      driver.addAll(drivers);
      if (drivers.isEmpty) {
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

  void _onCalculateFare(CalculateFare event, Emitter<RideState> emit) {
    double fare = _calculateFare(event.distanceInKm);
    emit(RideFareCalculated(fare));
  }

  void _onRequestRide(RequestRide event, Emitter<RideState> emit) async {
    try {
      emit(RideLoading()); 

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

  double _calculateDistance(double startLatitude, double startLongitude,
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

    return radiusOfEarthKm * c; 
  }

  double _calculateFare(double distanceInKm) {
    if (distanceInKm <= 2) {
      return 40; 
    } else {
      return 40 +
          ((distanceInKm - 2) * 20); 
    }
  }

  void _onSelectVehicle(SelectVehicle event, Emitter<RideState> emit) {
    emit(VehicleSelected(event.vehicleType));
  }

  void _onSelectPayment(SelectPayment event, Emitter<RideState> emit) {
    emit(PaymentSelected(event.paymentMethod));
  }
}
