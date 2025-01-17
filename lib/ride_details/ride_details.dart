// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:rideuser/core/colors.dart'; // Import intl package

// class TripDetailPage extends StatefulWidget {
//   const TripDetailPage({super.key});

//   @override
//   State<TripDetailPage> createState() => _TripDetailPageState();
// }

// class _TripDetailPageState extends State<TripDetailPage> {
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   context.read<RidestartBloc>().add(GetTripDetailByIdEvent());
//   // }

//   // Function to convert UTC to IST and format it
//   String formatDateToIST(String utcDate) {
//     DateTime utcDateTime = DateTime.parse(utcDate);
//     DateTime istDateTime = utcDateTime.add(const Duration(hours: 5, minutes: 30));
//     return DateFormat('dd MMM yyyy - hh:mm a').format(istDateTime);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final isWideScreen = screenWidth > 600;

//     return Scaffold(
//             backgroundColor: ThemeColors.black,

//       appBar: AppBar(
//               backgroundColor: ThemeColors.green,
// leading: Container(),
//         title: const Text('Trip Details',style: TextStyle(color: Colors.white),),
//         elevation: 4,
//         centerTitle: true,
//       ),
//       body: BlocBuilder<RidestartBloc, RidestartState>(
//         builder: (context, state) {
//           if (state is TripLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is TripLoaded) {
//             final tripDetails = state.tripDetails['getTripDetail'];
//             final driverName = tripDetails['driverId']?['name'] ?? 'Unknown';
//             final vehicleType =
//                 tripDetails['driverId']?['vehicleDetails']?['vehicle_type'] ?? 'Unknown';
//             final pickUpLocation = tripDetails['pickUpLocation'] ?? 'Unknown';
//             final dropOffLocation = tripDetails['dropOffLocation'] ?? 'Unknown';
//             final paymentMethod = tripDetails['paymentMethod'] ?? 'Unknown';
//             final fare = tripDetails['fare']?.toStringAsFixed(2) ?? 'Unknown';
//             final tripStatus = tripDetails['tripStatus'] ?? 'Unknown';
//             final createdAt = tripDetails['createdAt'] ?? 'Unknown';
//             final distance = tripDetails['distance']?.toString() ?? 'Unknown';
//             final duration = tripDetails['duration']?.toString() ?? 'Unknown';

//             return Container(
             
//               child: Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(isWideScreen ? 25.0 : 16.0),
//                   child: Card(
//                     elevation: 8,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         vertical: isWideScreen ? 30.0 : 20.0,
//                         horizontal: isWideScreen ? 20.0 : 15.0,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 10,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _buildDetailRow('Driver Name', driverName),
//                             _buildDetailRow('Vehicle Type', vehicleType),
//                             _buildDetailRow('Pickup Location', pickUpLocation),
//                             _buildDetailRow('Drop-off Location', dropOffLocation),
//                             _buildDetailRow('Payment Method', paymentMethod),
//                             _buildDetailRow('Fare', '\$$fare'),
//                             _buildDetailRow('Trip Status', tripStatus),
//                             _buildDetailRow('Distance', '$distance km'),
//                             _buildDetailRow('Duration', '$duration mins'),
//                             _buildDetailRow('Time/Date', formatDateToIST(createdAt)),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           } else if (state is TripError) {
//             return Center(
//               child: Text(state.message, style: const TextStyle(color: Colors.red)),
//             );
//           }
//           return const Center(child: Text('No data available'));
//         },
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.black54,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w600,
//               ),
//               softWrap: true,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rideuser/core/colors.dart'; // Import intl package

class TripDetailPage extends StatefulWidget {
  const TripDetailPage({super.key});

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  // Function to convert UTC to IST and format it
  String formatDateToIST(String utcDate) {
    DateTime utcDateTime = DateTime.parse(utcDate);
    DateTime istDateTime = utcDateTime.add(const Duration(hours: 5, minutes: 30));
    return DateFormat('dd MMM yyyy - hh:mm a').format(istDateTime);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    return Scaffold(
      backgroundColor: ThemeColors.black,
      appBar: AppBar(
        backgroundColor: ThemeColors.green,
        title: const Text(
          'Trip Details',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 4,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              context.read<RidestartBloc>().add(GetTripDetailByIdEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<RidestartBloc, RidestartState>(
        builder: (context, state) {
          if (state is TripLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TripLoaded) {
            final tripDetails = state.tripDetails['getTripDetail'];
            if (tripDetails == null || tripDetails.isEmpty) {
              return _buildNoDataView();
            }

            final driverName = tripDetails['driverId']?['name'] ?? 'Unknown';
            final vehicleType =
                tripDetails['driverId']?['vehicleDetails']?['vehicle_type'] ?? 'Unknown';
            final pickUpLocation = tripDetails['pickUpLocation'] ?? 'Unknown';
            final dropOffLocation = tripDetails['dropOffLocation'] ?? 'Unknown';
            final paymentMethod = tripDetails['paymentMethod'] ?? 'Unknown';
            final fare = tripDetails['fare']?.toStringAsFixed(2) ?? 'Unknown';
            final tripStatus = tripDetails['tripStatus'] ?? 'Unknown';
            final createdAt = tripDetails['createdAt'] ?? 'Unknown';
            final distance = tripDetails['distance']?.toString() ?? 'Unknown';
            final duration = tripDetails['duration']?.toString() ?? 'Unknown';

            return Center(
              child: Padding(
                padding: EdgeInsets.all(isWideScreen ? 25.0 : 16.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: isWideScreen ? 30.0 : 20.0,
                      horizontal: isWideScreen ? 20.0 : 15.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('Driver Name', driverName),
                          _buildDetailRow('Vehicle Type', vehicleType),
                          _buildDetailRow('Pickup Location', pickUpLocation),
                          _buildDetailRow('Drop-off Location', dropOffLocation),
                          _buildDetailRow('Payment Method', paymentMethod),
                          _buildDetailRow('Fare', '\$$fare'),
                          _buildDetailRow('Trip Status', tripStatus),
                          _buildDetailRow('Distance', '$distance km'),
                          _buildDetailRow('Duration', '$duration mins'),
                          _buildDetailRow('Time/Date', formatDateToIST(createdAt)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else if (state is TripError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: Colors.red)),
            );
          }
          return _buildNoDataView();
        },
      ),
    );
  }

  Widget _buildNoDataView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No data available.',
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              context.read<RidestartBloc>().add(GetTripDetailByIdEvent());
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
