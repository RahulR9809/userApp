
import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';
import 'package:rideuser/chat/chat.dart';
import 'package:rideuser/core/colors.dart';


class ReachedDialog {
  static void showReachedDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      title: '🚖 Your Driver Has Arrived!',
      desc: 'Your driver has reached your pickup location.',
      headerAnimationLoop: false,
      customHeader: Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 50,
      ),
      autoHide: Duration(seconds: 5),
      btnOkOnPress: () {},
    ).show();
  }
}










void showCustomSnackBar(BuildContext context, String message, {Color backgroundColor = Colors.green}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ),
  );
}


class CancelRideDialog extends StatefulWidget {
  final Function(String) onConfirm;
  final BuildContext parentContext;

  const CancelRideDialog({
    required this.onConfirm,
    required this.parentContext,
    super.key,
  });

  @override
  _CancelRideDialogState createState() => _CancelRideDialogState();
}

class _CancelRideDialogState extends State<CancelRideDialog> {
  String? _selectedReason;

  // Method to show the confirmation dialog
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Cancellation"),
          content: const Text("Are you sure you want to cancel the ride?"),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog without canceling
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Confirm cancellation
                widget.onConfirm(_selectedReason!);
                // Navigator.of(context).pop(); // Close the confirmation dialog
                // Navigator.of(context).pop(); // Close the reason selection dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> reasons = [
      "Driver is taking too long",
      "Change in plans",
      "Booked by mistake",
      "Found an alternate ride",
      "High fare",
    ];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Cancel Ride",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              "Please select a reason for canceling the ride:",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            ...reasons.map(
              (reason) => RadioListTile<String>(
                title: Text(reason),
                value: reason,
                groupValue: _selectedReason,
                onChanged: (value) {
                  setState(() {
                    _selectedReason = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: _selectedReason != null
                  ? () {
                      _showConfirmationDialog();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text(
                "Confirm",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}







class RideBottomBar extends StatefulWidget {
  final Map<String, dynamic> rideData;

  const RideBottomBar({super.key, required this.rideData});

  @override
  _RideBottomBarState createState() => _RideBottomBarState();
}

class _RideBottomBarState extends State<RideBottomBar> {
  bool _isCancelButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    // Start a 30-second timer when the widget is created
    Timer(const Duration(seconds: 30), () {
      setState(() {
        _isCancelButtonDisabled = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final driverName = widget.rideData['driverDetails']['name'] ?? 'Unknown';
    final profileImg = widget.rideData['driverDetails']['profileImg'] ?? '';
    final fare = widget.rideData['fare'] ?? 0.0;
    final pickUpLocation = widget.rideData['pickUpLocation'] ?? 'Unknown';
    final totalDistance = widget.rideData['distance'] ?? 'Unknown';

    return SizedBox(
      height: screenHeight * 0.7,
      child: DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.2,
        maxChildSize: 0.6,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: ThemeColors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(26)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(16.0),
              children: [
                // 🚗 Driver Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(profileImg),
                      backgroundColor: Colors.grey.shade200,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              driverName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(thickness: 1.5, height: 20),
                // 📍 Pickup Point
                Row(
                  children: [
                    const Icon(Icons.location_pin, color: ThemeColors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pickup Point',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            pickUpLocation,
                            style: const TextStyle(color: ThemeColors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // 🚦 Ride Status
                const Row(
                  children: [
                    Icon(
                      Icons.directions_car_filled_rounded,
                      color: Color.fromARGB(255, 54, 95, 244),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Driver on the way',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const Divider(thickness: 1.5, height: 20),
                // 📊 Fare & Distance
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '₹${fare.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Fare Estimate',
                          style: TextStyle(color: ThemeColors.grey),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '$totalDistance KM',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Total Distance',
                          style: TextStyle(color: ThemeColors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(thickness: 1.5, height: 20),
                // 🛠 Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _isCancelButtonDisabled
                          ? null // Disable button if time has passed
                          : () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CancelRideDialog(
                                    onConfirm: (String selectedReason) {
                                      // Dispatch CancelRideEvent with the selected reason
                                      context.read<RidestartBloc>().add(
                                            CancelRideEvent(
                                                cancelReason: selectedReason),
                                          );
                                    },
                                    parentContext: context, // Pass the parent context
                                  );
                                },
                              );
                            },
                      icon: const Icon(Icons.cancel, color: ThemeColors.white),
                      label: const Text('Cancel Ride'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _openChat(context),
                      icon: const Icon(Icons.message, color: ThemeColors.white),
                      label: const Text('Message'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatPage()),
    );
  }
}
