import 'package:flutter/material.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_bloc.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_event.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_state.dart';
import 'package:rideuser/chat/chat.dart';
import 'package:rideuser/core/colors.dart';
import 'package:rideuser/widgets/ride_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Replace with your actual BLoC file

class BottomBarWidget extends StatelessWidget {
  final RideController rideController;
  final TextEditingController currentLocationController;
  final TextEditingController destinationController;
  final double currentLatitude;
  final double currentLongitude;
  final double destinationLatitude;
  final double destinationLongitude;

  const BottomBarWidget({super.key, 
    required this.rideController,
    required this.currentLocationController,
    required this.destinationController,
    required this.currentLatitude,
    required this.currentLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Positioned(
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
            String? _selectedVehicleType;
            String? _selectedPaymentMethod;

            if (state is VehicleSelected) {
              _selectedVehicleType = state.vehicleType;
            }
            if (state is PaymentSelected) {
              _selectedPaymentMethod = state.paymentMethod;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Vehicle',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.045,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 10),
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
                      width: screenSize.width * 0.25,
                    ),
                    _buildCard(
                      icon: Icons.electric_rickshaw,
                      label: 'Auto(3 Seater)',
                      isSelected: _selectedVehicleType == 'Auto',
                      onTap: () {
                        BlocProvider.of<RideBloc>(context)
                            .add(SelectVehicle(vehicleType: 'Auto'));
                      },
                      width: screenSize.width * 0.25,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Select Payment Method',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.045,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDisabledCard(
                      icon: Icons.money,
                      label: 'Cash',
                      width: screenSize.width * 0.25,
                    ),
                    _buildDisabledCard(
                      icon: Icons.account_balance_wallet,
                      label: 'Wallet',
                      width: screenSize.width * 0.25,
                    ),
                    _buildCard(
                      icon: Icons.credit_card,
                      label: 'Online Payment',
                      isSelected: _selectedPaymentMethod == 'Online-Payment',
                      onTap: () {
                        BlocProvider.of<RideBloc>(context).add(
                            SelectPayment(paymentMethod: 'Online-Payment'));
                      },
                      width: screenSize.width * 0.25,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: screenSize.width * 0.9,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      double distance = rideController.calculateDistance(
                        currentLatitude,
                        currentLongitude,
                        destinationLatitude,
                        destinationLongitude,
                      );
                      double fare = rideController.calculateFare(distance);

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final userId = prefs.getString('userid');
                      BlocProvider.of<RideBloc>(context).add(RequestRide(
                        userId: userId!,
                        fare: fare,
                        distance: distance,
                        duration: distance * 2,
                        pickUpCoords: [currentLatitude, currentLongitude],
                        dropCoords: [
                          destinationLatitude,
                          destinationLongitude
                        ],
                        vehicleType: _selectedVehicleType ?? 'Car',
                        pickupLocation: currentLocationController.text,
                        dropLocation: destinationController.text,
                        paymentMethod:
                            _selectedPaymentMethod ?? 'Online-Payment',
                      ));
                    },
                    child: const Text(
                      'Request Ride',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required double width,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(12),
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
                size: 30, color: isSelected ? Colors.white : Colors.black),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
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
    required double width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
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
          Icon(icon, size: 30, color: Colors.black.withOpacity(0.5)),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black.withOpacity(0.5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}


