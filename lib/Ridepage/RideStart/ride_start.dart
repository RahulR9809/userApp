

// // ignore_for_file: library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';
// import 'package:rideuser/Ridepage/RideStart/map/map_pages.dart';
// import 'package:rideuser/Ridepage/ride.dart';
// import 'package:rideuser/chat/chat.dart';
// import 'package:rideuser/core/colors.dart';
// import 'package:rideuser/widgets/ride_completedwidget.dart';
// import 'package:rideuser/widgets/ride_widget.dart';

// class RideStart extends StatefulWidget {
//   const RideStart({super.key});

//   @override
//   _RideStartState createState() => _RideStartState();
// }

// class _RideStartState extends State<RideStart> {
//   // Timer? _checkRideStatusTimer;
//   Map<String, dynamic>? _rideData;

//   // @override
//   // void initState() {
//   //   super.initState();

//   //   // Start a timer to periodically dispatch CheckRideStatusEvent
//   //   _checkRideStatusTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
//   //     context.read<RidestartBloc>().add(CheckRideStatusEvent());
//   //   });
//   // }

//   // @override
//   // void dispose() {
//   //   _checkRideStatusTimer?.cancel();
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
         
//  BlocBuilder<RidestartBloc, RidestartState>(
//   builder: (context, state) {
//     if(state is PicUpSimulationState){
//       return      MapboxPicupSimulation(startPoint: state.startLatLng, endPoint: state.endLatLng);

//     }
//     return LinearProgressIndicator();
//   },
//  ),




// BlocBuilder<RidestartBloc, RidestartState>(
//   builder: (context, state) {
//     if (state is RidestartInitial) {
//       return const Center(
//         child: LoadingScreenDialog(),
//       );
//     } else if (state is RideAcceptedState) {
//       // Stop the timer when the ride is accepted
//       // _checkRideStatusTimer?.cancel();

//       // Update _rideData when state changes
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         setState(() {
//           _rideData = state.rideData;
//         });
//       });
//     } else if (state is RideAccepError) {
//       return Center(
//         child: Text(
//           state.message,
//           style: const TextStyle(color: ThemeColors.red),
//         ),
//       );
//     } else if (state is CancelRideSuccess) {
//       // Show success dialog and navigate to StartRidePage
      
//         RefactoredDialoge.showCustomDialog(context: context,
//          title: 'Ride Canceled',
//           content: 'Your ride has been successfully canceled.',
//            primaryButtonText: 'OK',
//             onPrimaryButtonPressed: () {
//            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const StartRide()));
//           },
//            );
       
      
//     }

//     return const SizedBox.shrink();
//   },
// ),

          
// DraggableScrollableSheet(
//   initialChildSize: _rideData != null ? 0.3 : 0.0,
//   minChildSize: _rideData != null ? 0.1 : 0.0,
//   maxChildSize: 0.5,
//   builder: (BuildContext context, ScrollController scrollController) {
//     if (_rideData == null) {
//       return Container();
//     }

//     final driverName = _rideData!['driverDetails']['name'] ?? 'Unknown';
//         final tripid = _rideData!['driverDetails']['_id'] ?? 'Unknown';
// // print('this is the tripid:$tripid');
//     final profileImg = _rideData!['driverDetails']['profileImg'] ?? '';
//     final fare = _rideData!['fare'] ?? 0.0;
//     final pickUpLocation = _rideData!['pickUpLocation'] ?? 'Unknown';
//     const driverLocation ="Driver on the way";
//     // final pickUpTime = _rideData!['pickUpTime'] ?? 'Unknown';
//     final totalDistance = _rideData!['distance'] ?? 'Unknown';

//     return Container(
//       decoration: BoxDecoration(
//         color:ThemeColors.white,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
//         boxShadow: [
//           BoxShadow(color: Colors.grey.shade300, blurRadius: 10, offset: const Offset(0, -3)),
//         ],
//       ),
//       child: ListView(
//         controller: scrollController,
//         padding: const EdgeInsets.all(16.0),
//         children: [
//           // Driver Details
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               CircleAvatar(
//                 radius: 30,
//                 backgroundImage: NetworkImage(profileImg),
//                 backgroundColor: Colors.grey.shade200,
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         driverName,
//                         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const Divider(thickness: 1.5, height: 20),
//           // Pickup and Driver Location
//           Row(
//             children: [
//               const Icon(Icons.location_pin, color:ThemeColors.orange),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text('Pickup Point', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
//                     Text('$pickUpLocation', style: const TextStyle(color:ThemeColors.grey)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 18),
//           const Row(
//             children: [
//               Icon(Icons.directions_car_filled_rounded, color: Color.fromARGB(255, 54, 95, 244)),
//               SizedBox(width: 8),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(driverLocation, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
//                     // Text('$driverLocation', style: TextStyle(color: Colors.grey)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const Divider(thickness: 1.5, height: 20),
//           // Fare and Distance
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Column(
//                 children: [
//                   Text('₹${fare.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
//                   const Text('Fare Estimate', style: TextStyle(color: ThemeColors.grey)),
//                 ],
//               ),
//               Column(
//                 children: [
//                   Text('$totalDistance KM', style: const TextStyle(fontWeight: FontWeight.bold)),
//                   const Text('Total Distance', style: TextStyle(color: ThemeColors.grey)),
//                 ],
//               ),
//             ],
//           ),
//           const Divider(thickness: 1.5, height: 20),
//           // Action Buttons
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
       

//       ElevatedButton.icon(
//   onPressed: () {
//     // Show Cancel Dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return CancelRideDialog(
//           onConfirm: (String selectedReason) {
//             // Dispatch CancelRideEvent with the selected reason
//             context.read<RidestartBloc>().add(
//                   CancelRideEvent(
//                     cancelReason: selectedReason,
//                   ),
//                 );
//           },
//         );
//       },
//     );
//   },
//   icon: const Icon(Icons.cancel, color: ThemeColors.white),
//   label: const Text('Cancel Ride', style: TextStyle(color: ThemeColors.white)),
//   style: ElevatedButton.styleFrom(
//     backgroundColor: const Color.fromARGB(255, 229, 171, 143),
//   ),
// ),


//               ElevatedButton.icon(
//                 onPressed: () {
//              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage()));
//                 },
//                 icon: const Icon(Icons.message, color: ThemeColors.white),
//                 label: const Text('Message', style: TextStyle(color: ThemeColors.white)),
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   },
// )


//         ],
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';
import 'package:rideuser/Ridepage/RideStart/map/map_pages.dart';
import 'package:rideuser/Ridepage/ride.dart';
import 'package:rideuser/chat/chat.dart';
import 'package:rideuser/core/colors.dart';
import 'package:rideuser/widgets/ride_widget.dart';

class RideStart extends StatefulWidget {
  const RideStart({super.key});

  @override
  _RideStartState createState() => _RideStartState();
}

class _RideStartState extends State<RideStart> {
  Map<String, dynamic>? _rideData;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    print("Building RideStart Screen");

    return Scaffold(
      body: Stack(
        children: [
          // 📍 Map View
          BlocBuilder<RidestartBloc, RidestartState>(
            builder: (context, state) {
              print("Map View: Checking state $state");

              if (state is PicUpSimulationState) {
                print('Emitting PicUpSimulationState');
                return MapboxPicupSimulation(
                  startPoint: state.startLatLng,
                  endPoint: state.endLatLng,
                );
              }
              return MapboxWidget();
            },
          ),
          // 📋 Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BlocBuilder<RidestartBloc, RidestartState>(
              builder: (context, state) {
                if (state is RidestartInitial) {
                  return const Center(
                    child: LoadingScreenDialog(),
                  );
                } else if (state is PicUpSimulationState) {
                  _rideData = state.requestData;
                  return _buildBottomBar(context, _rideData!);
                } else if (state is RideRequestVisible) {
                  _rideData = state.requestData;
                  return _buildBottomBar(context, _rideData!);
                }
                return const SizedBox.shrink();
              },
            ),
            
          ),
           BlocListener<RidestartBloc, RidestartState>(
          listener: (context, state) {
            if (state is CancelRideSuccess) {
                    showCustomSnackBar(context, 'Ride cancelled successfully!', backgroundColor: Colors.green);

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>StartRide()));
            }
          },
          child: Container(),
        ),
        ],
      ),
    );
  }

  /// 🧩 Bottom Bar with ride data
  Widget _buildBottomBar(BuildContext context, Map<String, dynamic> rideData) {
    final screenHeight = MediaQuery.of(context).size.height;

    print("Building Bottom Bar with ride data: $rideData");

    final driverName = rideData['driverDetails']['name'] ?? 'Unknown';
    final profileImg = rideData['driverDetails']['profileImg'] ?? '';
    final fare = rideData['fare'] ?? 0.0;
    final pickUpLocation = rideData['pickUpLocation'] ?? 'Unknown';
    final totalDistance = rideData['distance'] ?? 'Unknown';

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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
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
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
  onPressed: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CancelRideDialog(
          onConfirm: (String selectedReason) {
            // Dispatch CancelRideEvent with the selected reason
            context.read<RidestartBloc>().add(
              CancelRideEvent(cancelReason: selectedReason),
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



  /// 💬 Open Chat
  void _openChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatPage()),
    );
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





// class CancelRideDialog extends StatelessWidget {
//   final Function(String) onConfirm;
//   final BuildContext parentContext;

//   const CancelRideDialog({
//     required this.onConfirm,
//     required this.parentContext,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16.0),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: BlocConsumer<RidestartBloc, RidestartState>(
//           listener: (context, state) {
//             if (state is Showconfirmationstate) {
//               // Show the confirmation dialog
//               _showConfirmationDialog(context);
//             } 
//             else if (state is CancelRideSuccessState) {
//               // Trigger the callback with the cancellation message
//               Navigator.of(context).pop(); // Close the dialog
//             } 
          
//           },
//           builder: (context, state) {
//             final List<String> reasons = [
//               "Driver is taking too long",
//               "Change in plans",
//               "Booked by mistake",
//               "Found an alternate ride",
//               "High fare",
//             ];
    
//             String? selectedReason;
//             if (state is CancelRideReasonSelectedState) {
//               selectedReason = state.reason;
//             }
    
//             return Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   "Cancel Ride",
//                   style: TextStyle(
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10.0),
//                 const Text(
//                   "Please select a reason for canceling the ride:",
//                   style: TextStyle(
//                     fontSize: 14.0,
//                     color: Colors.grey,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 20.0),
//                 ...reasons.map(
//                   (reason) => RadioListTile<String>(
//                     title: Text(reason),
//                     value: reason,
//                     groupValue: selectedReason,
//                     onChanged: (value) {
//                       context.read<RidestartBloc>().add(SelectReasonEvent(value!));
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 15.0),
//                 ElevatedButton(
//                   onPressed: selectedReason != null
//                       ? () {
//                           context.read<RidestartBloc>().add(ShowConfirmationDialogEvent());
//                         }
//                       : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent,
//                   ),
//                   child: const Text(
//                     "Confirm",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: const Text(
//                     "Cancel",
//                     style: TextStyle(
//                       color: Colors.redAccent,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

// void _showConfirmationDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text("Confirm Cancellation"),
//         content: const Text("Are you sure you want to cancel the ride?"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               // Close the confirmation dialog without canceling
//               Navigator.of(context).pop();
//             },
//             child: const Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () {
//               // Proceed with the cancellation
//               final selectedReasonState = context.read<RidestartBloc>().state;
//               if (selectedReasonState is CancelRideReasonSelectedState) {
//                 // Extract the reason from the state
//                 final selectedReason = selectedReasonState.reason;
//                 context.read<RidestartBloc>().add(
//                   ConfirmCancellationEvent(selectedReason),
//                 );
//               }
//               Navigator.of(context).pop(); // Close the confirmation dialog
//             },
//             child: const Text("OK"),
//           ),
//         ],
//       );
//     },
//   );
// }

// }