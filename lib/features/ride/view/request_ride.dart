
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/features/ride/bloc/RequestRide/bloc/ride_bloc.dart';
import 'package:rideuser/features/ride/bloc/RequestRide/bloc/ride_event.dart';
import 'package:rideuser/features/ride/bloc/RequestRide/bloc/ride_state.dart';
import 'package:rideuser/features/ride/view/ride_start.dart';
import 'package:rideuser/widgets/search_page.dart';
import 'package:rideuser/core/colors.dart';
import 'package:rideuser/widgets/auth_widgets.dart';
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
  // double? _currentLatitude;
  // double? _currentLongitude;
  final GlobalKey<MapContainerCardState> _mapContainerKey =
      GlobalKey<MapContainerCardState>();
  String? _selectedVehicleType;
  String? _selectedPaymentMethod;
  bool _isBottomBarVisible = false;

//clear this before hosting
  double? _currentLatitude = 9.938034; 
  double? _currentLongitude = 76.321803;
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
    // ignore: unused_local_variable
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
          } else if (state is LocationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
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

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _mapContainerKey.currentState?.updateMapLocation(
                            state.latitude,
                            state.longitude,
                          );
                        });

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: buildLocationInputField(
                                label: 'Current Location',
                                controller: _currentLocationController,
                                hint: 'Fetching location...',
                                context: context,
              onLocationSelected: oncurrentlocationselected

                              ),
                            ),
                             Padding(
                            padding: EdgeInsets.only(
                                left: screenSize.width * 0.012,
                                top: screenSize.height *
                                    0.038), 
                            child: IconButton(
                              iconSize: 36, 
                              onPressed: () {
                                context.read<RideBloc>().add(FetchLocation());
                              },
                              icon: const Icon(
                                Icons.near_me,
                              ), 
                            ),
                          ),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: buildLocationInputField(
                              label: 'Current Location',
                              controller: _currentLocationController,
                              hint: 'Fetching location...',
                              context: context,
                              onLocationSelected: oncurrentlocationselected
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: screenSize.width * 0.012,
                                top: screenSize.height *
                                    0.038), 
                            child: IconButton(
                              iconSize: 36, 
                              onPressed: () {
                                context.read<RideBloc>().add(FetchLocation());
                              },
                              icon: const Icon(
                                Icons.near_me,
                              ), 
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
                            const SnackBar(
                                content: Text('No Drivers Found in your area')),
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
    _destinationLatitude = latitude;
    _destinationLongitude = longitude;
    _destinationController.text = fullAddress;

    BlocProvider.of<RideBloc>(context).add(
      SelectDestination(
          latitude: latitude, longitude: longitude, address: fullAddress),
    );
  }


  void oncurrentlocationselected(
      double latitude, double longitude, String fullAddress) {
    _currentLatitude = latitude;
    _currentLongitude = longitude;
    _currentLocationController.text = fullAddress;
  

    BlocProvider.of<RideBloc>(context).add(
      SelectDestination(
          latitude: latitude, longitude: longitude, address: fullAddress),
    );
  }




  Widget buildBottomBar() {
    final screenSize = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          if (_isBottomBarVisible) {
            setState(() {
              _isBottomBarVisible = false;
            });
            return false; 
          }
          return true;
        },
        child: Positioned(
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
                  offset: const Offset(0, -4),
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
                          isSelected:
                              _selectedPaymentMethod == 'Online-Payment',
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
                        try {
                          // Step 1: Calculate distance and fare
                          double distance = _rideController.calculateDistance(
                            _currentLatitude!,
                            _currentLongitude!,
                            _destinationLatitude!,
                            _destinationLongitude!,
                          );
                          debugPrint('Calculated Distance: $distance km');

                          double fare = _rideController.calculateFare(distance);
                          debugPrint('Calculated Fare: $fare');

                          // Step 2: Get userId from SharedPreferences
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          final userId = prefs.getString('userid');
                          if (userId == null) {
                            debugPrint('UserId not found in SharedPreferences');
                            return;
                          }
                          debugPrint('UserId: $userId');

                          // Step 3: Emit Ride Request Event
                          BlocProvider.of<RideBloc>(context).add(RequestRide(
                            userId: userId,
                            fare: fare,
                            distance: distance,
                            duration: distance *
                                2, // Assuming duration is proportional to distance
                            pickUpCoords: [
                              _currentLatitude!,
                              _currentLongitude!
                            ],
                            dropCoords: [
                              _destinationLatitude!,
                              _destinationLongitude!
                            ],
                            vehicleType: _selectedVehicleType ?? 'Car',
                            pickupLocation: _currentLocationController.text,
                            dropLocation: _destinationController.text,
                            paymentMethod:
                                _selectedPaymentMethod ?? 'Online-Payment',
                          ));

                          debugPrint('Ride Request Event Emitted:');
                          debugPrint('  UserId: $userId');
                          debugPrint('  Fare: $fare');
                          debugPrint('  Distance: $distance km');
                          debugPrint('  Duration: ${distance * 2} min');
                          debugPrint(
                              '  Pickup Coords: ${_currentLatitude!}, ${_currentLongitude!}');
                          debugPrint(
                              '  Drop Coords: ${_destinationLatitude!}, ${_destinationLongitude!}');
                          debugPrint(
                              '  Vehicle Type: ${_selectedVehicleType ?? 'Car'}');
                          debugPrint(
                              '  Pickup Location: ${_currentLocationController.text}');
                          debugPrint(
                              '  Drop Location: ${_destinationController.text}');
                          debugPrint(
                              '  Payment Method: ${_selectedPaymentMethod ?? 'Online-Payment'}');

                          // Step 4: Clear destination field
                          _destinationController.clear();
                          debugPrint('Destination Controller Cleared');

                          // Step 5: Toggle Bottom Bar Visibility
                          BlocProvider.of<RideBloc>(context)
                              .add(ToggleBottomBar());
                          debugPrint('Bottom Bar Visibility Toggled');
                        } catch (e, stackTrace) {
                          // Handle exceptions
                          debugPrint('Error occurred in onPressed: $e');
                          debugPrint('Stack Trace: $stackTrace');
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ));
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
              offset: const Offset(0, 4),
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
            offset: const Offset(0, 4),
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
