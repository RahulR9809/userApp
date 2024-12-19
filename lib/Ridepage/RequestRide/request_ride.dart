import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_bloc.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_event.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_state.dart';
import 'package:rideuser/Ridepage/RideStart/ride_start.dart';
import 'package:rideuser/Ridepage/searchpage.dart';
import 'package:rideuser/controller/ride_controller.dart';
import 'package:rideuser/core/colors.dart';
import 'package:rideuser/widgets/auth_widgets.dart';
import 'package:rideuser/widgets/ride_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RidePage extends StatefulWidget {
  const RidePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RidePageState createState() => _RidePageState();
}

class _RidePageState extends State<RidePage> {
  final TextEditingController _currentLocationController =
      TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final RideController _rideController = RideController();

  double? _currentLatitude;
  double? _currentLongitude;
  double? _destinationLatitude;
  double? _destinationLongitude;

  final GlobalKey<MapContainerCardState> _mapContainerKey =
      GlobalKey<MapContainerCardState>();
  final RideService _rideService = RideService();

  List<Map<String, dynamic>> _nearbyDrivers = [];
  String? _selectedVehicleType;



  //  // have to clear these after use

  //  double? _currentLatitude = 9.931233; // Default latitude
  // double? _currentLongitude = 76.267304; // Default longitude
  // final String _defaultAddress =
  //     'Edathuruthikaran Holdings, 10/450-2, Kundannoor, Maradu, Ernakulam, Kerala 682304';
  // @override
  // void initState() {
  //   super.initState();
  //   _currentLocationController.text = _defaultAddress;
  // }
  //  // have to clear these after use



  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: ThemeColors.lightWhite,
        appBar: AppBar(
          title: const Text('Ride Booking',style: TextStyle(color:ThemeColors.lightGrey),),
          backgroundColor: ThemeColors.green,
        ),
        body: BlocListener<RideBloc, RideState>(
          listener: (context, state) {
            if (state is RideRequested) {
              // Navigate to the Ride Start Page
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const RideStart()));
            } else if (state is RideRequestError) {
              // Show an error message if the request fails
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('failed requesting ride')),
              );
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenSize.width * 0.04),
              child: Column(
                children: [
                  BlocBuilder<RideBloc, RideState>(
                    builder: (context, state) {
                      if (state is LocationLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is LocationLoaded) {
                        _currentLatitude = state.latitude;
                        _currentLongitude = state.longitude;
                        _currentLocationController.text = state.address;

                        // Update map only if the current location changes
                        if (!_mapContainerKey.currentState!
                            .isCurrentLocationMarker(
                          state.latitude,
                          state.longitude,
                        )) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _mapContainerKey.currentState?.updateMapLocation(
                              state.latitude,
                              state.longitude,
                            );
                          });
                        }

                        return buildLocationInputField(
                          label: 'Current Location',
                          controller: _currentLocationController,
                          hint: state.address,
                          icon: Icons.my_location,
                          onPressed: () {
                            BlocProvider.of<RideBloc>(context)
                                .add(FetchCurrentLocation(context: context));
                          },
                          context: context,
                        );
                      } else if (state is LocationError) {
                        return buildLocationInputField(
                          label: 'Current Location',
                          controller: _currentLocationController,
                          hint: 'Error: ${state.message}',
                          icon: Icons.error,
                          onPressed: () {
                            BlocProvider.of<RideBloc>(context)
                                .add(FetchCurrentLocation(context: context));
                          },
                          context: context,
                        );
                      }

                      return buildLocationInputField(
                        label: 'Current Location',
                        controller: _currentLocationController,
                        hint: 'Fetching location...',
                        icon: Icons.my_location,
                        onPressed: () {
                          BlocProvider.of<RideBloc>(context)
                              .add(FetchCurrentLocation(context: context));
                        },
                        context: context,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocProvider(
                    create: (_) => RideBloc(),
                    child: DestinationSearchField(
                      onLocationSelected: _onLocationSelected,
                    ),
                  ),
                  const SizedBox(height: 30),
                  BlocListener<RideBloc, RideState>(
                    listener: (context, state) {
                      if (state is NearbyDriversLoaded) {
                        // Update map with the fetched drivers
                        for (var driver in state.drivers) {
                          final latitude = driver['coordinates'][1];
                          final longitude = driver['coordinates'][0];
                          final vehicleType = driver['vehicle_type'];
                          _mapContainerKey.currentState?.addDriverMarker(
                            latitude,
                            longitude,
                            vehicleType,
                          );
                        }
                      } else if (state is NearbyDriversError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    child: BlocBuilder<RideBloc, RideState>(
                      builder: (context, state) {
                        if (state is NearbyDriversLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return ReusableButton(
                          text: 'Search Nearby Drivers',
                          color: ThemeColors.green,
                          onPressed: () {
                            if (kDebugMode) {
                              print('nearbydrivers$_nearbyDrivers');
                            }
                            if (_currentLatitude != null &&
                                _currentLongitude != null) {
                              BlocProvider.of<RideBloc>(context).add(
                                FetchNearbyDrivers(
                                  latitude: _currentLatitude!,
                                  longitude: _currentLongitude!,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Please wait for the current location to be fetched.'),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  MapContainerCard(
                    key: _mapContainerKey,
                    latitude: _currentLatitude,
                    longitude: _currentLongitude,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Available Electric Vehicles',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.darkGrey),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      VehicleCard(
                        vehicleName: 'Electric Car',
                        imageUrl: 'assets/rideCar.png',
                        vehicleType: 'Car',
                        onSelect: _selectVehicle,
                        isSelected: _selectedVehicleType == 'Car',
                      ),
                      VehicleCard(
                        vehicleName: 'Electric Auto',
                        imageUrl: 'assets/rideAuto.png',
                        vehicleType: 'Auto',
                        onSelect: _selectVehicle,
                        isSelected: _selectedVehicleType == 'Auto',
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ReusableButton(
                    color: ThemeColors.green,
                    text: 'Request Ride',
                    onPressed: () async {
                      // Calculate distance
                      double distance = _rideController.calculateDistance(
                        _currentLatitude!,
                        _currentLongitude!,
                        _destinationLatitude!,
                        _destinationLongitude!,
                      );
                      driver.clear();
                      // Calculate fare
                      double fare = _rideController.calculateFare(distance);

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final userId = prefs.getString('userid');
                      const paymentMethod = 'Online-Payment';
                      BlocProvider.of<RideBloc>(context).add(RequestRide(
                        userId: userId!,
                        fare: fare,
                        distance: distance,
                        duration:
                            distance * 2, // Assuming duration is 2x distance
                        pickUpCoords: [_currentLatitude!, _currentLongitude!],
                        dropCoords: [
                          _destinationLatitude!,
                          _destinationLongitude!
                        ],
                        vehicleType: _selectedVehicleType ?? 'Car',
                        pickupLocation: _currentLocationController.text,
                        dropLocation: _destinationController.text,
                        paymentMethod: paymentMethod,
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Ride requested successfully!')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _onLocationSelected(
      double latitude, double longitude, String fullAddress) {
    setState(() {
      _destinationLatitude = latitude;
      _destinationLongitude = longitude;
      _destinationController.text = fullAddress;
    });
  }

  Future<void> _fetchNearbyDrivers(double latitude, double longitude) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('userid');
      final token = prefs.getString('googletoken');
      final drivers = await _rideService.getNearByDrivers(
        userId: id!,
        pickupLatitude: latitude,
        pickupLongitude: longitude,
        dropLatitude: _destinationLatitude ?? latitude,
        dropLongitude: _destinationLongitude ?? longitude,
        vehicleType: _selectedVehicleType,
        accessToken: token!,
      );

      setState(() {
        _nearbyDrivers = drivers;
      });

      _updateMapWithDrivers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching nearby drivers: $e')),
      );
    }
  }

  Map<String, dynamic> _getNearestDriver(List<Map<String, dynamic>> drivers) {
    double nearestDistance = double.infinity;
    Map<String, dynamic> nearestDriver = {};

    for (var driver in drivers) {
      double driverLatitude = driver['coordinates'][1];
      double driverLongitude = driver['coordinates'][0];

      // Calculate the distance to the driver
      double distance = _rideController.calculateDistance(
        _currentLatitude!,
        _currentLongitude!,
        driverLatitude,
        driverLongitude,
      );

      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestDriver = driver;
      }
    }

    return nearestDriver;
  }

  void _updateMapWithDrivers() {
    for (var driver in _nearbyDrivers) {
      double latitude = driver['coordinates'][1];
      double longitude = driver['coordinates'][0];
      String vehicleType = driver['vehicle_type'];

      _mapContainerKey.currentState
          ?.addDriverMarker(latitude, longitude, vehicleType);
    }
  }

  void _selectVehicle(String vehicleType) {
    setState(() {
      _selectedVehicleType = vehicleType.trim();
    });
  }
}
