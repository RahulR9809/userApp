
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:meta/meta.dart';
import 'package:rideuser/chat/bloc/chat_bloc.dart';
import 'package:rideuser/controller/chat_usersoketcontroller.dart';
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
  Map<String, dynamic>? _rideData;

  RidestartBloc(this.socketService) : super(RidestartInitial()) {
    on<CheckRideStatusEvent>(_onCheckRideStatusEvent);
            on<MakePaymentEvent>(_handleMakePaymentEvent);
    on<CancelRideEvent>(_onCancelRide);

    on<RideRequestReceived>(_onRideRequestReceived);




       socketService.setRideAcceptedCallback((data) {
      add(RideRequestReceived(data));
    });


     socketService.setRideStartedCallback((data) {
      add(RideStartReceived(data));
    });
    on<RideStartReceived>(_onRidestartRequestReceived);
    on<CheckRideStartStatusEvent>(_onCheckRideStartStatusEvent);

   


  }



// FutureOr<void> _onChatSocketConnected(
//     ChatSocketConnectedevent event, Emitter<ChatState> emit) async {
//   String? userId = await _getUserId();
//   if (userId != null) {
//     UserChatSocketService().connectChatSocket(userId);
//     emit(ChatConnected());
//   } else {
//     emit(ChatError(message: 'User ID not found'));
//   }
// }



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


 void _onRidestartRequestReceived(RideStartReceived event, Emitter<RidestartState> emit) {
    if(event.rideData.isEmpty){
      add(CheckRideStartStatusEvent());
    }
      add(CheckRideStartStatusEvent());

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
      print('this is tripid:$tripId');


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


         UserChatSocketService chatService = UserChatSocketService();
        // chatService.initializeChatSocket();  
        chatService.connectChatSocket(tripId);  // Connect with tripId
        print('Chat connected for tripId: $tripId');

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




Future<void> _onCheckRideStartStatusEvent(
    CheckRideStartStatusEvent event, Emitter<RidestartState> emit) async {
  print("Entered _onCheckRideStatusEvent");

  try {
    // Check if the current state is RideRequestVisible
    if (state is RidestartRequestVisible) {
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
  final userid=rideData['userId'];

      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Check if both IDs are not null
      if (driverId != null && tripId != null) {
        // Store the IDs in SharedPreferences
        prefs.setString('driverid', driverId);
        prefs.setString('tripid', tripId);

          print('driverid:$driverId');
      print('usesrid:$userid');
        print('tripid in chat:$tripId');
        // Extract coordinates from rideData
        final startCoordinates = rideData['driverDetails']['currentLocation']['coordinates'];
        final endCoordinates = rideData['startLocation']['coordinates'];


        // Convert coordinates to LatLng
        final LatLng startLatLng = LatLng(startCoordinates[1], startCoordinates[0]);
        final LatLng endLatLng = LatLng(endCoordinates[0], endCoordinates[1]);

 emit(DropSimulationState(rideData,startLatLng: startLatLng, endLatLng: endLatLng));

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