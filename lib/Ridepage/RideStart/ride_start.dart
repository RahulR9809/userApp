// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';

// class RideStart extends StatelessWidget {
//   final MapController _mapController = MapController();

//    RideStart({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//       body: FlutterMap(
//         mapController: _mapController,
//         options: MapOptions(),
//         children: [
//           TileLayer(
//             urlTemplate:
//                 "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ",
//             additionalOptions: const {
//               'accessToken':
//                   'pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ',
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';
// import 'package:rideuser/widgets/ride_widget.dart';

// class RideStart extends StatefulWidget {
//   const RideStart({super.key});

//   @override
//   _RideStartState createState() => _RideStartState();
// }

// class _RideStartState extends State<RideStart> {
//   final MapController _mapController = MapController();
//   Timer? _checkRideStatusTimer;

//   @override
//   void initState() {
//     super.initState();

//     // Start a timer to periodically dispatch CheckRideStatusEvent
//     _checkRideStatusTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
//       context.read<RidestartBloc>().add(CheckRideStatusEvent());
//     });
//   }

//   @override
//   void dispose() {
//     _checkRideStatusTimer?.cancel();
//     super.dispose();
//   }

//   void _showRideAcceptedDialog(Map<String, dynamic> rideData) {
//     final driverName = rideData['driverDetails']['name'] ?? 'Unknown';
//     final vehicleDetails =
//         rideData['driverDetails']['vehicleDetails'] ?? 'Unknown';

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Ride Accepted'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Driver: $driverName'),
//             Text('Vehicle: $vehicleDetails'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Map Widget
//           FlutterMap(
//             mapController: _mapController,
//             options: MapOptions(),
//             children: [
//               TileLayer(
//                 urlTemplate:
//                     "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ",
//               ),
//             ],
//           ),

//           // BlocBuilder to react to state changes
//      // BlocBuilder to react to state changes
// BlocBuilder<RidestartBloc, RidestartState>(
//   builder: (context, state) {
//     if (state is RidestartInitial) {
//       return const Center(
//         child:LoadingScreenDialog()
//       );
//     } else if (state is RideAcceptedState) {
//       // Stop the timer when the ride is accepted
//       _checkRideStatusTimer?.cancel();

//       // Show ride accepted dialog
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _showRideAcceptedDialog(state.rideData);
//       });

//       return const SizedBox.shrink();
//     } else if (state is RideAccepError) {
//       return Center(
//         child: Text(
//           state.message,
//           style: const TextStyle(color: Colors.red),
//         ),
//       );
//     }
//     return const SizedBox.shrink();
//   },
// ),

//         ],
//       ),
//     );
//   }
// }



import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';
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
            options: MapOptions(),
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
                    style: const TextStyle(color: Colors.red),
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
    final profileImg = _rideData!['driverDetails']['profileImg'] ?? '';
    final fare = _rideData!['fare'] ?? 0.0;
    final pickUpLocation = _rideData!['pickUpLocation'] ?? 'Unknown';
    const driverLocation ="Driver on the way";
    // final pickUpTime = _rideData!['pickUpTime'] ?? 'Unknown';
    final totalDistance = _rideData!['distance'] ?? 'Unknown';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
              const Icon(Icons.location_pin, color: Colors.orange),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pickup Point', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    Text('$pickUpLocation', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Icon(Icons.directions_car_filled_rounded, color: Color.fromARGB(255, 54, 95, 244)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$driverLocation', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
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
                  Text('\₹${fare.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Fare Estimate', style: TextStyle(color: Colors.grey)),
                ],
              ),
              Column(
                children: [
                  Text('$totalDistance KM', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Total Distance', style: TextStyle(color: Colors.grey)),
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
                icon: const Icon(Icons.cancel, color: Colors.white),
                label: const Text('Cancel Ride', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 229, 171, 143)),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Message action
                },
                icon: const Icon(Icons.message, color: Colors.white),
                label: const Text('Message', style: TextStyle(color: Colors.white)),
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
