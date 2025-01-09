// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rideuser/Ridepage/RequestRide/bloc/ride_bloc.dart';
// import 'package:rideuser/Ridepage/RequestRide/bloc/ride_event.dart';
// import 'package:rideuser/Ridepage/RequestRide/bloc/ride_state.dart';
// import 'package:rideuser/Ridepage/RideStart/ride_start.dart';
// import 'package:rideuser/Ridepage/searchpage.dart';
// import 'package:rideuser/controller/ride_controller.dart';
// import 'package:rideuser/core/colors.dart';
// import 'package:rideuser/widgets/auth_widgets.dart';
// import 'package:rideuser/widgets/ride_widget.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class RidePage extends StatefulWidget {
//   const RidePage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _RidePageState createState() => _RidePageState();
// }

// class _RidePageState extends State<RidePage> {
//   final TextEditingController _currentLocationController =
//       TextEditingController();
//   final TextEditingController _destinationController = TextEditingController();
//   final RideController _rideController = RideController();

//   // double? _currentLatitude;
//   // double? _currentLongitude;
//   double? _destinationLatitude;
//   double? _destinationLongitude;

//   final GlobalKey<MapContainerCardState> _mapContainerKey =
//       GlobalKey<MapContainerCardState>();
//   final RideService _rideService = RideService();

//   List<Map<String, dynamic>> _nearbyDrivers = [];
//   String? _selectedVehicleType;

//   //  // have to clear these after use

//    double? _currentLatitude = 9.931233; // Default latitude
//   double? _currentLongitude = 76.267304; // Default longitude
//   final String _defaultAddress =
//       'Edathuruthikaran Holdings, 10/450-2, Kundannoor, Maradu, Ernakulam, Kerala 682304';
//   @override
//   void initState() {
//     super.initState();
//     _currentLocationController.text = _defaultAddress;
//   }
//   //  // have to clear these after use

//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;

//     return Scaffold(
//         backgroundColor: ThemeColors.lightWhite,
//         appBar: AppBar(
//           title: const Text('Ride Booking',style: TextStyle(color:ThemeColors.lightGrey),),
//           backgroundColor: ThemeColors.green,
//         ),
//         body: BlocListener<RideBloc, RideState>(
//           listener: (context, state) {
//             if (state is RideRequested) {
//               // Navigate to the Ride Start Page
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => const RideStart()));
//             } else if (state is RideRequestError) {
//               // Show an error message if the request fails
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('failed requesting ride')),
//               );
//             }
//           },
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.all(screenSize.width * 0.04),
//               child: Column(
//                 children: [
//                   BlocBuilder<RideBloc, RideState>(
//                     builder: (context, state) {
//                       if (state is LocationLoading) {
//                         return const Center(child: CircularProgressIndicator());
//                       } else if (state is LocationLoaded) {
//                         _currentLatitude = state.latitude;
//                         _currentLongitude = state.longitude;
//                         _currentLocationController.text = state.address;

//                         // Update map only if the current location changes
//                         if (!_mapContainerKey.currentState!
//                             .isCurrentLocationMarker(
//                           state.latitude,
//                           state.longitude,
//                         )) {
//                           WidgetsBinding.instance.addPostFrameCallback((_) {
//                             _mapContainerKey.currentState?.updateMapLocation(
//                               state.latitude,
//                               state.longitude,
//                             );
//                           });
//                         }

//                         return buildLocationInputField(
//                           label: 'Current Location',
//                           controller: _currentLocationController,
//                           hint: state.address,
//                           icon: Icons.my_location,
//                           onPressed: () {
//                             BlocProvider.of<RideBloc>(context)
//                                 .add(FetchCurrentLocation(context: context));
//                           },
//                           context: context,
//                         );
//                       }

//                       // else if (state is LocationError) {
//                       //   return buildLocationInputField(
//                       //     label: 'Current Location',
//                       //     controller: _currentLocationController,
//                       //     hint: 'Error: ${state.message}',
//                       //     icon: Icons.error,
//                       //     onPressed: () {
//                       //       BlocProvider.of<RideBloc>(context)
//                       //           .add(FetchCurrentLocation(context: context));
//                       //     },
//                       //     context: context,
//                       //   );
//                       // }

//                       return buildLocationInputField(
//                         label: 'Current Location',
//                         controller: _currentLocationController,
//                         hint: 'Fetching location...',
//                         icon: Icons.my_location,
//                         onPressed: () {
//                           BlocProvider.of<RideBloc>(context)
//                               .add(FetchCurrentLocation(context: context));
//                         },
//                         context: context,
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   BlocProvider(
//                     create: (_) => RideBloc(),
//                     child: DestinationSearchField(
//                       onLocationSelected: _onLocationSelected,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   BlocListener<RideBloc, RideState>(
//                     listener: (context, state) {
//                       if (state is NearbyDriversLoaded) {
//                         // Update map with the fetched drivers
//                         for (var driver in state.drivers) {
//                           final latitude = driver['coordinates'][1];
//                           final longitude = driver['coordinates'][0];
//                           final vehicleType = driver['vehicle_type'];
//                           _mapContainerKey.currentState?.addDriverMarker(
//                             latitude,
//                             longitude,
//                             vehicleType,
//                           );
//                         }
//                       } else if (state is NearbyDriversError) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text(state.message)),
//                         );
//                       }
//                     },
//                     child: BlocBuilder<RideBloc, RideState>(
//                       builder: (context, state) {
//                         if (state is NearbyDriversLoading) {
//                           return const Center(
//                               child: CircularProgressIndicator());
//                         }
//                         return ReusableButton(
//                           text: 'Search Nearby Drivers',
//                           color: ThemeColors.green,
//                           onPressed: () {
//                             if (kDebugMode) {
//                               print('nearbydrivers$_nearbyDrivers');
//                             }
//                             if (_currentLatitude != null &&
//                                 _currentLongitude != null) {
//                               BlocProvider.of<RideBloc>(context).add(
//                                 FetchNearbyDrivers(
//                                   latitude: _currentLatitude!,
//                                   longitude: _currentLongitude!,
//                                 ),
//                               );
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text(
//                                       'Please wait for the current location to be fetched.'),
//                                 ),
//                               );
//                             }
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   MapContainerCard(
//                     key: _mapContainerKey,
//                     latitude: _currentLatitude,
//                     longitude: _currentLongitude,
//                   ),
//                   const SizedBox(height: 15),
//                   const Text(
//                     'Available Electric Vehicles',
//                     style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: ThemeColors.darkGrey),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       VehicleCard(
//                         vehicleName: 'Electric Car',
//                         imageUrl: 'assets/rideCar.png',
//                         vehicleType: 'Car',
//                         onSelect: _selectVehicle,
//                         isSelected: _selectedVehicleType == 'Car',
//                       ),
//                       VehicleCard(
//                         vehicleName: 'Electric Auto',
//                         imageUrl: 'assets/rideAuto.png',
//                         vehicleType: 'Auto',
//                         onSelect: _selectVehicle,
//                         isSelected: _selectedVehicleType == 'Auto',
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15),
//                   ReusableButton(
//                     color: ThemeColors.green,
//                     text: 'Request Ride',
//                     onPressed: () async {
//                       // Calculate distance
//                       double distance = _rideController.calculateDistance(
//                         _currentLatitude!,
//                         _currentLongitude!,
//                         _destinationLatitude!,
//                         _destinationLongitude!,
//                       );
//                       driver.clear();
//                       // Calculate fare
//                       double fare = _rideController.calculateFare(distance);

//                       SharedPreferences prefs =
//                           await SharedPreferences.getInstance();
//                       final userId = prefs.getString('userid');
//                       const paymentMethod = 'Online-Payment';
//                       BlocProvider.of<RideBloc>(context).add(RequestRide(
//                         userId: userId!,
//                         fare: fare,
//                         distance: distance,
//                         duration:
//                             distance * 2, // Assuming duration is 2x distance
//                         pickUpCoords: [_currentLatitude!, _currentLongitude!],
//                         dropCoords: [
//                           _destinationLatitude!,
//                           _destinationLongitude!
//                         ],
//                         vehicleType: _selectedVehicleType ?? 'Car',
//                         pickupLocation: _currentLocationController.text,
//                         dropLocation: _destinationController.text,
//                         paymentMethod: paymentMethod,
//                       ));
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content: Text('Ride requested successfully!')),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }

//   void _onLocationSelected(
//       double latitude, double longitude, String fullAddress) {
//     setState(() {
//       _destinationLatitude = latitude;
//       _destinationLongitude = longitude;
//       _destinationController.text = fullAddress;
//     });
//   }

//   Future<void> _fetchNearbyDrivers(double latitude, double longitude) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       final id = prefs.getString('userid');
//       final token = prefs.getString('googletoken');
//       final drivers = await _rideService.getNearByDrivers(
//         userId: id!,
//         pickupLatitude: latitude,
//         pickupLongitude: longitude,
//         dropLatitude: _destinationLatitude ?? latitude,
//         dropLongitude: _destinationLongitude ?? longitude,
//         vehicleType: _selectedVehicleType,
//         accessToken: token!,
//       );

//       setState(() {
//         _nearbyDrivers = drivers;
//       });

//       _updateMapWithDrivers();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching nearby drivers: $e')),
//       );
//     }
//   }

//   Map<String, dynamic> _getNearestDriver(List<Map<String, dynamic>> drivers) {
//     double nearestDistance = double.infinity;
//     Map<String, dynamic> nearestDriver = {};

//     for (var driver in drivers) {
//       double driverLatitude = driver['coordinates'][1];
//       double driverLongitude = driver['coordinates'][0];

//       // Calculate the distance to the driver
//       double distance = _rideController.calculateDistance(
//         _currentLatitude!,
//         _currentLongitude!,
//         driverLatitude,
//         driverLongitude,
//       );

//       if (distance < nearestDistance) {
//         nearestDistance = distance;
//         nearestDriver = driver;
//       }
//     }

//     return nearestDriver;
//   }

//   void _updateMapWithDrivers() {
//     for (var driver in _nearbyDrivers) {
//       double latitude = driver['coordinates'][1];
//       double longitude = driver['coordinates'][0];
//       String vehicleType = driver['vehicle_type'];

//       _mapContainerKey.currentState
//           ?.addDriverMarker(latitude, longitude, vehicleType);
//     }
//   }

//   void _selectVehicle(String vehicleType) {
//     setState(() {
//       _selectedVehicleType = vehicleType.trim();
//     });
//   }
// }

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
import 'package:rideuser/widgets/currentlocation_map.dart';
import 'package:rideuser/widgets/ride_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RidePage extends StatefulWidget {
  const RidePage({super.key});

  @override
  _RidePageState createState() => _RidePageState();
}

class _RidePageState extends State<RidePage> {
  final TextEditingController _currentLocationController =
      TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final RideController _rideController = RideController();
  double? _destinationLatitude;
  double? _destinationLongitude;

  final GlobalKey<MapContainerCardState> _mapContainerKey =
      GlobalKey<MapContainerCardState>();
  final RideService _rideService = RideService();
  // double? _currentLatitude;
  // double? _currentLongitude;
  String? _selectedVehicleType;
  String? _selectedPaymentMethod;
  bool _isBottomBarVisible = false;


  //   @override
  // void initState() {
  //   super.initState();
  //   // Trigger the FetchCurrentLocation event when the page opens
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     BlocProvider.of<RideBloc>(context).add(
  //       FetchCurrentLocation(context: context),
  //     );
  //   });
  // }

//clear this before hosting
  double? _currentLatitude = 9.938034; // Default latitude
  double? _currentLongitude = 76.321803; // Default longitude
  final String _defaultAddress =
      'Edathuruthikaran Holdings, 10/450-2, Kundannoor, Maradu, Ernakulam, Kerala 682304';
  @override
  void initState() {
    super.initState();
    _currentLocationController.text = _defaultAddress;
  }
//clear this before hosting

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      backgroundColor: ThemeColors.lightWhite,
      appBar: AppBar(
        title: const Text(
          'Ride Booking',
          style: TextStyle(color: ThemeColors.lightWhite),
        ),
        backgroundColor: ThemeColors.green,
      ),
      body: BlocListener<RideBloc, RideState>(
        listener: (context, state) {
          if (state is RideRequested) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ride requested successfully!')),
            );
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const RideStart()));
          } else if (state is RideRequestError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed requesting ride')),
            );
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(screenSize.width * 0.04),
                child: Column(
                  children: [
                    BlocBuilder<RideBloc, RideState>(builder: (context, state) {
                      if (state is LocationLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is LocationLoaded) {
                        _currentLatitude = state.latitude;
                        _currentLongitude = state.longitude;
                        _currentLocationController.text = state.address;

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

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: isSmallScreen
                                    ? screenSize.width * 0.75
                                    : screenSize.width * 0.8,
                                child: buildLocationInputField(
                                  label: 'Current Location',
                                  controller: _currentLocationController,
                                  hint: 'Fetching location...',
                                 
                                  context: context,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: screenSize.width * 0.012,
                                  top: screenSize.height *
                                      0.038), // Adjust spacing
                              child: IconButton(
                                iconSize: 36, // Make the icon larger
                                onPressed: () {
                                  // BlocProvider.of<RideBloc>(context).add(
                                  //     FetchCurrentLocation(context: context));
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MapPage()));
                                },
                                icon: const Icon(
                                  Icons.near_me,
                                ), // Customize color
                              ),
                            ),
                          ],
                        );

                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: isSmallScreen
                                  ? screenSize.width * 0.75
                                  : screenSize.width * 0.8,
                              child: buildLocationInputField(
                                label: 'Current Location',
                                controller: _currentLocationController,
                                hint: 'Fetching location...',
                                context: context,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: screenSize.width * 0.012,
                                top: screenSize.height *
                                    0.038), // Adjust spacing
                            child: IconButton(
                              iconSize: 36, // Make the icon larger
                              onPressed: () {
                                BlocProvider.of<RideBloc>(context).add(
                                    FetchCurrentLocation(context: context));
                              },
                              icon: const Icon(
                                Icons.near_me,
                              ), // Customize color
                            ),
                          ),
                        ],
                      );
                    }),
                    SizedBox(height: screenSize.height * 0.02),
                    BlocProvider(
                      create: (_) => RideBloc(),
                      child: DestinationSearchField(
                        onLocationSelected: _onLocationSelected,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.03),
                    BlocListener<RideBloc, RideState>(
                      listener: (context, state) {
                        if (state is NearbyDriversLoaded) {
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
              const SnackBar(content: Text('No Drivers Found in your area')),
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
                    SizedBox(height: screenSize.height * 0.04),
                    MapContainerCard(
                      key: _mapContainerKey,
                      latitude: _currentLatitude,
                      longitude: _currentLongitude,
                    ),
                    SizedBox(height: screenSize.height * 0.03),
                    ReusableButton(
                      color: ThemeColors.green,
                      text: 'Click Here',
                      onPressed: () {
                        setState(() {
                          _isBottomBarVisible = !_isBottomBarVisible;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (_isBottomBarVisible) buildBottomBar(),
          ],
        ),
      ),
    );
  }

  void _onLocationSelected(
      double latitude, double longitude, String fullAddress) {
    setState(() {
      _destinationLatitude = latitude;
      _destinationLongitude = longitude;
      _destinationController.text = fullAddress;
    });
  }





Widget buildBottomBar() {
  final screenSize = MediaQuery.of(context).size;
  return WillPopScope(
    onWillPop: () async {
      if (_isBottomBarVisible) {
        setState(() {
          _isBottomBarVisible = false;
        });
        return false; // Prevents exiting the screen
      }
      return true; // Allows exiting the screen
    },
  child:  Positioned(
    left: 0,
    right: 0,
    bottom: 0,
    child: Container(
      padding: EdgeInsets.all(screenSize.width * 0.04),
      decoration: BoxDecoration(
        color: ThemeColors.lightWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: BlocBuilder<RideBloc, RideState>(
        builder: (context, state) {
          if (state is VehicleSelected) {
            _selectedVehicleType = state.vehicleType;
          }
          if (state is PaymentSelected) {
            _selectedPaymentMethod = state.paymentMethod;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Select Vehicle',
                style: TextStyle(
                  fontSize: screenSize.width * 0.045,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.darkGrey,
                ),
              ),
              SizedBox(height: screenSize.height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCard(
                    icon: Icons.directions_car,
                    label: 'Car(4 Seater)',
                    isSelected: _selectedVehicleType == 'Car',
                    onTap: () {
                      BlocProvider.of<RideBloc>(context)
                          .add(SelectVehicle(vehicleType: 'Car'));
                    },
                  ),
                  _buildCard(
                    icon: Icons.electric_rickshaw,
                    label: 'Auto(3 Seater)',
                    isSelected: _selectedVehicleType == 'Auto',
                    onTap: () {
                      BlocProvider.of<RideBloc>(context)
                          .add(SelectVehicle(vehicleType: 'Auto'));
                    },
                  ),
                ],
              ),
              SizedBox(height: screenSize.height * 0.02),
              Text(
                'Select Payment Method',
                style: TextStyle(
                  fontSize: screenSize.width * 0.045,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.darkGrey,
                ),
              ),
              SizedBox(height: screenSize.height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDisabledCard(
                    icon: Icons.money,
                    label: 'Cash',
                  ),
                  _buildDisabledCard(
                    icon: Icons.account_balance_wallet,
                    label: 'Wallet',
                  ),
                  _buildCard(
                    icon: Icons.credit_card,
                    label: 'Online Payment',
                    isSelected: _selectedPaymentMethod == 'Online-Payment',
                    onTap: () {
                      BlocProvider.of<RideBloc>(context).add(
                          SelectPayment(paymentMethod: 'Online-Payment'));
                    },
                  ),
                ],
              ),
              SizedBox(height: screenSize.height * 0.02),
              ReusableButton(
                text: 'Request Ride',
                color: ThemeColors.green,
                onPressed: () async {
                  double distance = _rideController.calculateDistance(
                    _currentLatitude!,
                    _currentLongitude!,
                    _destinationLatitude!,
                    _destinationLongitude!,
                  );
                  double fare = _rideController.calculateFare(distance);

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  final userId = prefs.getString('userid');
                  BlocProvider.of<RideBloc>(context).add(RequestRide(
                    userId: userId!,
                    fare: fare,
                    distance: distance,
                    duration: distance * 2,
                    pickUpCoords: [_currentLatitude!, _currentLongitude!],
                    dropCoords: [
                      _destinationLatitude!,
                      _destinationLongitude!
                    ],
                    vehicleType: _selectedVehicleType ?? 'Car',
                    pickupLocation: _currentLocationController.text,
                    dropLocation: _destinationController.text,
                    paymentMethod: _selectedPaymentMethod ?? 'Online-Payment',
                  ));
                  // _currentLocationController.clear();
_destinationController.clear();


                  setState(() {
                    _isBottomBarVisible = false;
                  });
                },
          
              ),
            ],
          );
        },
      ),
    ),
  )
  );
}

Widget _buildCard({
  required IconData icon,
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  final screenSize = MediaQuery.of(context).size;
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: screenSize.width * 0.3,
      padding: EdgeInsets.all(screenSize.width * 0.03),
      decoration: BoxDecoration(
        color: isSelected ? ThemeColors.green : ThemeColors.lightGrey,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon,
              size: screenSize.width * 0.07,
              color: isSelected ? Colors.white : Colors.black),
          SizedBox(height: screenSize.height * 0.01),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenSize.width * 0.035,
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
    
  );
}

Widget _buildDisabledCard({
  required IconData icon,
  required String label,
}) {
  final screenSize = MediaQuery.of(context).size;
  return Container(
    width: screenSize.width * 0.28,
    padding: EdgeInsets.all(screenSize.width * 0.03),
    decoration: BoxDecoration(
      color: ThemeColors.lightGrey.withOpacity(0.5),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 6,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        Icon(icon,
            size: screenSize.width * 0.07,
            color: Colors.black.withOpacity(0.5)),
        SizedBox(height: screenSize.height * 0.01),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: screenSize.width * 0.035,
            color: Colors.black.withOpacity(0.5),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

}



  

//   Widget buildBottomBar() {
//     final screenSize = MediaQuery.of(context).size;

//     return Positioned(
//       left: 0,
//       right: 0,
//       bottom: 0,
//       child: Container(
//         padding: EdgeInsets.all(screenSize.width * 0.04),
//         decoration: BoxDecoration(
//           color: ThemeColors.lightWhite,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 10,
//               offset: Offset(0, -4),
//             ),
//           ],
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(16),
//             topRight: Radius.circular(16),
//           ),
//         ),
//         child: BlocBuilder<RideBloc, RideState>(
//           builder: (context, state) {
//             if (state is VehicleSelected) {
//               _selectedVehicleType = state.vehicleType;
//             }
//             if (state is PaymentSelected) {
//               _selectedPaymentMethod = state.paymentMethod;
//             }
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   'Select Vehicle',
//                   style: TextStyle(
//                     fontSize: screenSize.width * 0.045,
//                     fontWeight: FontWeight.bold,
//                     color: ThemeColors.darkGrey,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _buildCard(
//                       icon: Icons.directions_car,
//                       label: 'Car(4 Seater)',
//                       isSelected: _selectedVehicleType == 'Car',
//                       onTap: () {
//                         BlocProvider.of<RideBloc>(context)
//                             .add(SelectVehicle(vehicleType: 'Car'));
//                       },
//                     ),
//                     _buildCard(
//                       icon: Icons.electric_rickshaw,
//                       label: 'Auto(3 Seater)',
//                       isSelected: _selectedVehicleType == 'Auto',
//                       onTap: () {
//                         BlocProvider.of<RideBloc>(context)
//                             .add(SelectVehicle(vehicleType: 'Auto'));
//                       },
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Select Payment Method',
//                   style: TextStyle(
//                     fontSize: screenSize.width * 0.045,
//                     fontWeight: FontWeight.bold,
//                     color: ThemeColors.darkGrey,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _buildDisabledCard(
//                       icon: Icons.money,
//                       label: 'Cash',
//                     ),
//                     _buildDisabledCard(
//                       icon: Icons.account_balance_wallet,
//                       label: 'Wallet',
//                     ),
//                     _buildCard(
//                       icon: Icons.credit_card,
//                       label: 'Online Payment',
//                       isSelected: _selectedPaymentMethod == 'Online-Payment',
//                       onTap: () {
//                         BlocProvider.of<RideBloc>(context).add(
//                             SelectPayment(paymentMethod: 'Online-Payment'));
//                       },
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 ReusableButton(
//                   text: 'Request Ride',
//                   color: ThemeColors.green,
//                   onPressed: () async {
//                     double distance = _rideController.calculateDistance(
//                       _currentLatitude!,
//                       _currentLongitude!,
//                       _destinationLatitude!,
//                       _destinationLongitude!,
//                     );
//                     double fare = _rideController.calculateFare(distance);

//                     SharedPreferences prefs =
//                         await SharedPreferences.getInstance();
//                     final userId = prefs.getString('userid');
//                     BlocProvider.of<RideBloc>(context).add(RequestRide(
//                       userId: userId!,
//                       fare: fare,
//                       distance: distance,
//                       duration: distance * 2,
//                       pickUpCoords: [_currentLatitude!, _currentLongitude!],
//                       dropCoords: [
//                         _destinationLatitude!,
//                         _destinationLongitude!
//                       ],
//                       vehicleType: _selectedVehicleType ?? 'Car',
//                       pickupLocation: _currentLocationController.text,
//                       dropLocation: _destinationController.text,
//                       paymentMethod: _selectedPaymentMethod ?? 'Online-Payment',
//                     ));

//                     setState(() {
//                       _isBottomBarVisible = false;
//                     });
//                   },
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildCard({
//     required IconData icon,
//     required String label,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 120,
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isSelected ? ThemeColors.green : ThemeColors.lightGrey,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 6,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Icon(icon,
//                 size: 30, color: isSelected ? Colors.white : Colors.black),
//             const SizedBox(height: 8),
//             Text(
//               label,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: isSelected ? Colors.white : Colors.black,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDisabledCard({
//     required IconData icon,
//     required String label,
//   }) {
//     return Container(
//       width: 110,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: ThemeColors.lightGrey.withOpacity(0.5),
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 6,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(icon, size: 30, color: Colors.black.withOpacity(0.5)),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.black.withOpacity(0.5),
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
