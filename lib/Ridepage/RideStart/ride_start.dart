

// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';
import 'package:rideuser/chat/chat.dart';
import 'package:rideuser/core/colors.dart';
import 'package:rideuser/widgets/ride_widget.dart';

class RideStart extends StatefulWidget {
  const RideStart({super.key});

  @override
  _RideStartState createState() => _RideStartState();
}

class _RideStartState extends State<RideStart> {
  final MapController _mapController = MapController();
  Timer? _checkRideStatusTimer;
  Map<String, dynamic>? _rideData;

  @override
  void initState() {
    super.initState();

    // Start a timer to periodically dispatch CheckRideStatusEvent
    _checkRideStatusTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      context.read<RidestartBloc>().add(CheckRideStatusEvent());
    });
  }

  @override
  void dispose() {
    _checkRideStatusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Widget
          FlutterMap(
            mapController: _mapController,
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ",
              ),
            ],
          ),

          // BlocBuilder to react to state changes
          BlocBuilder<RidestartBloc, RidestartState>(
            builder: (context, state) {
              if (state is RidestartInitial) {
                return const Center(
                  child: LoadingScreenDialog(),
                );
              } else if (state is RideAcceptedState) {
                // Stop the timer when the ride is accepted
                _checkRideStatusTimer?.cancel();

                // Update _rideData when state changes
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _rideData = state.rideData;
                  });
                });
              } else if (state is RideAccepError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color:ThemeColors.red),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          
DraggableScrollableSheet(
  initialChildSize: _rideData != null ? 0.3 : 0.0,
  minChildSize: _rideData != null ? 0.1 : 0.0,
  maxChildSize: 0.5,
  builder: (BuildContext context, ScrollController scrollController) {
    if (_rideData == null) {
      return Container();
    }

    final driverName = _rideData!['driverDetails']['name'] ?? 'Unknown';
        final tripid = _rideData!['driverDetails']['_id'] ?? 'Unknown';
// print('this is the tripid:$tripid');
    final profileImg = _rideData!['driverDetails']['profileImg'] ?? '';
    final fare = _rideData!['fare'] ?? 0.0;
    final pickUpLocation = _rideData!['pickUpLocation'] ?? 'Unknown';
    const driverLocation ="Driver on the way";
    // final pickUpTime = _rideData!['pickUpTime'] ?? 'Unknown';
    final totalDistance = _rideData!['distance'] ?? 'Unknown';

    return Container(
      decoration: BoxDecoration(
        color:ThemeColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 10, offset: const Offset(0, -3)),
        ],
      ),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(16.0),
        children: [
          // Driver Details
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
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(thickness: 1.5, height: 20),
          // Pickup and Driver Location
          Row(
            children: [
              const Icon(Icons.location_pin, color:ThemeColors.orange),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pickup Point', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    Text('$pickUpLocation', style: const TextStyle(color:ThemeColors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Icon(Icons.directions_car_filled_rounded, color: Color.fromARGB(255, 54, 95, 244)),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(driverLocation, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    // Text('$driverLocation', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(thickness: 1.5, height: 20),
          // Fare and Distance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('₹${fare.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Text('Fare Estimate', style: TextStyle(color: ThemeColors.grey)),
                ],
              ),
              Column(
                children: [
                  Text('$totalDistance KM', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Text('Total Distance', style: TextStyle(color: ThemeColors.grey)),
                ],
              ),
            ],
          ),
          const Divider(thickness: 1.5, height: 20),
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Call action
                },
                icon: const Icon(Icons.cancel, color: ThemeColors.white),
                label: const Text('Cancel Ride', style: TextStyle(color: ThemeColors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 229, 171, 143)),
              ),
              ElevatedButton.icon(
                onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage()));
                },
                icon: const Icon(Icons.message, color: ThemeColors.white),
                label: const Text('Message', style: TextStyle(color: ThemeColors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  },
)


        ],
      ),
    );
  }
}
