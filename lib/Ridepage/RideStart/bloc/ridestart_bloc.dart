


// import 'package:bloc/bloc.dart';
// import 'package:flutter/foundation.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:meta/meta.dart';
// import 'package:rideuser/controller/payment_controller.dart';
// import 'package:rideuser/controller/ride_controller.dart';
// import 'package:rideuser/controller/user_socket.dart';
// import 'package:shared_preferences/shared_preferences.dart';


// part 'ridestart_event.dart';
// part 'ridestart_state.dart';

// class RidestartBloc extends Bloc<RidestartEvent, RidestartState> {
//   final UserSocketService socketService;
//       final PaymentController paymentController=PaymentController();
// RideService rideService=RideService();
//   bool isRideUpdated = false; // Add a flag to track ride updates

//   RidestartBloc(this.socketService) : super(RidestartInitial()) {
//     on<CheckRideStatusEvent>(_onCheckRideStatusEvent);
//             on<MakePaymentEvent>(_handleMakePaymentEvent);
//     on<CancelRideEvent>(_onCancelRide);


//        socketService.setRideAcceptedCallback((data) {
//       add(CheckRideStatusEvent());  // Dispatch event to check ride status
//     });

//   }


//     Future<String?> _getDriverId() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     return pref.getString('driverid');
//   }

//   Future<String?> _getUserId() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     return pref.getString('userid');
//   }

//   Future<String?> _getTripId() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     return pref.getString('tripid');
//   }

//   Future<void> _handleMakePaymentEvent(
//       MakePaymentEvent event, Emitter<RidestartState> emit) async {
//          String? driverId = await _getDriverId();
//     String? userId = await _getUserId();
//     String? tripid=await _getTripId();
//     print(driverId);
//     print(userId);
//     print(tripid);
//     emit(PaymentLoading());
//     try {
//       final response = await paymentController.makePayment(
//         userId:userId!,
//         tripId:tripid!,
//         driverId: driverId!,
//         paymentMethod: event.paymentMethod,
//         fare: event.fare,
//       );
//       emit(PaymentSuccess(response));
//     } catch (error) {
//       emit(PaymentFailure(error.toString()));
//     }
//   }



//   Future<void> _onCheckRideStatusEvent(
//       CheckRideStatusEvent event, Emitter<RidestartState> emit) async {
//     try {
//         if (isRideUpdated) {
//         return; // Prevent emitting the same data again
//       }
//       // Fetch the latest ride data from the socket service
//       final rideData = socketService.latestRideData;
//       if (rideData.isNotEmpty) {
//         final driverid = rideData['driverId'];
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//         final tripid=rideData['_id'];
//         print("this is the trip id:$tripid");
//         prefs.setString('driverid', driverid);
//           final startCoordinates = rideData['driverDetails']['currentLocation']['coordinates'];
//       final endCoordinates = rideData['startLocation']['coordinates'];

//       final LatLng startLatLng = LatLng(startCoordinates[1], startCoordinates[0]);
//       final LatLng endLatLng = LatLng(endCoordinates[0], endCoordinates[1]);

//       print('StartLatLng: $startCoordinates, EndLatLng: $endCoordinates');
// print('accepted');


//                      emit(RideAcceptedState(rideData));
//      // Wait for a small delay before emitting the next state (PicUpSimulationState)
//      await Future.delayed(Duration(milliseconds: 500)); // Adjust the delay if needed
//      emit(PicUpSimulationState(startLatLng: startLatLng, endLatLng: endLatLng));

//             print("Emitted RideAcceptedState and PicUpSimulationState");


//       }
//     } catch (e) {
//       emit(RideAccepError(message: 'Error checking ride status: $e'));
//     }
//   }



//   Future<void> _onCancelRide(CancelRideEvent event, Emitter<RidestartState> emit) async {
//   emit(CancelRideLoading());

//   String? userId = await _getUserId();
//   String? tripId = await _getTripId();

//   try {
//     final bool isCancelled = await rideService.cancelRide(
//       userId!,
//       tripId!,
//       event.cancelReason,
//     );

//     if (isCancelled) {
//       emit(CancelRideSuccess());
//     } else {
//       emit(CancelRideFailure('Failed to cancel the ride.'));
//     }
//   } catch (error) {
//     emit(CancelRideFailure('Error: $error'));
//   }
// }


// }









import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:meta/meta.dart';
import 'package:rideuser/controller/payment_controller.dart';
import 'package:rideuser/controller/ride_controller.dart';
import 'package:rideuser/controller/user_socket.dart';
import 'package:shared_preferences/shared_preferences.dart';


part 'ridestart_event.dart';
part 'ridestart_state.dart';

class RidestartBloc extends Bloc<RidestartEvent, RidestartState> {
  final UserSocketService socketService;
      final PaymentController paymentController=PaymentController();
RideService rideService=RideService();
  bool isRideUpdated = false; // Add a flag to track ride updates
  Map<String, dynamic>? _rideData;

  RidestartBloc(this.socketService) : super(RidestartInitial()) {
    on<CheckRideStatusEvent>(_onCheckRideStatusEvent);
            on<MakePaymentEvent>(_handleMakePaymentEvent);
    on<CancelRideEvent>(_onCancelRide);

    on<RideRequestReceived>(_onRideRequestReceived);


       socketService.setRideAcceptedCallback((data) {
      add(RideRequestReceived(data));
    });
  

  }



  Future<String?> _getDriverId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('driverid');
  }

  Future<String?> _getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('userid');
  }

  Future<String?> _getTripId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('tripid');
  }

  Future<void> _handleMakePaymentEvent(
      MakePaymentEvent event, Emitter<RidestartState> emit) async {
    String? driverId = await _getDriverId();
    String? userId = await _getUserId();
    String? tripId = await _getTripId();

    if (driverId == null || userId == null || tripId == null) {
      emit(PaymentFailure("Missing required data"));
      return;
    }

    emit(PaymentLoading());

    try {
      final response = await paymentController.makePayment(
        userId: userId,
        tripId: tripId,
        driverId: driverId,
        paymentMethod: event.paymentMethod,
        fare: event.fare,
      );
      emit(PaymentSuccess(response));
    } catch (error) {
      emit(PaymentFailure(error.toString()));
    }
  }

  void _onRideRequestReceived(RideRequestReceived event, Emitter<RidestartState> emit) {
        _rideData = event.requestData; // Save the data in the Bloc
    emit(RideRequestVisible(event.requestData));
      add(CheckRideStatusEvent());

  }
Future<void> _onCheckRideStatusEvent(
    CheckRideStatusEvent event, Emitter<RidestartState> emit) async {
  print("Entered _onCheckRideStatusEvent");

  try {
    // Check if the current state is RideRequestVisible
    if (state is RideRequestVisible) {
      final rideData = _rideData!;

      // Debug: Print the entire rideData
      print("Ride Data: $rideData");

      // Check if rideData is empty
      if (rideData.isEmpty) {
        return;
      }

      // Extract driverId and tripId from rideData
      final driverId = rideData['driverId'];
      final tripId = rideData['_id'];


      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Check if both IDs are not null
      if (driverId != null && tripId != null) {
        // Store the IDs in SharedPreferences
        prefs.setString('driverid', driverId);
        prefs.setString('tripid', tripId);


        // Extract coordinates from rideData
        final startCoordinates = rideData['driverDetails']['currentLocation']['coordinates'];
        final endCoordinates = rideData['startLocation']['coordinates'];


        // Convert coordinates to LatLng
        final LatLng startLatLng = LatLng(startCoordinates[1], startCoordinates[0]);
        final LatLng endLatLng = LatLng(endCoordinates[0], endCoordinates[1]);

 emit(PicUpSimulationState(rideData,startLatLng: startLatLng, endLatLng: endLatLng));


      
      } else {
        // Handle missing IDs
        emit(RideAccepError(message: 'Missing driver or trip ID'));
      }
    }
  } catch (e, stackTrace) {
    // Print the error and stack trace for detailed debugging
    print("Error occurred in _onCheckRideStatusEvent: $e");
    print("StackTrace: $stackTrace");

    // Emit error state
    emit(RideAccepError(message: 'Error checking ride status: $e'));
  }

}


  Future<void> _onCancelRide(CancelRideEvent event, Emitter<RidestartState> emit) async {
    emit(CancelRideLoading());

    String? userId = await _getUserId();
    String? tripId = await _getTripId();

    if (userId == null || tripId == null) {
      emit(CancelRideFailure('Missing user or trip data'));
      return;
    }

    try {
      final bool isCancelled = await rideService.cancelRide(
        userId,
        tripId,
        event.cancelReason,
      );

      if (isCancelled) {
        emit(CancelRideSuccess());
      } else {
        emit(CancelRideFailure('Failed to cancel the ride.'));
      }
    } catch (error) {
      emit(CancelRideFailure('Error: $error'));
    }
  }
}