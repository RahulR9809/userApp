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
  final PaymentController paymentController = PaymentController();
  RideService rideService = RideService();
  Map<String, dynamic>? _rideData;
  Map<String, dynamic>? rideData;

  RidestartBloc(this.socketService) : super(RidestartInitial()) {
    on<CheckRideStatusEvent>(_onCheckRideStatusEvent);
    on<MakePaymentEvent>(_Confirmpayment);
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

    on<CreateCheckoutSessionEvent>(_onCreateCheckoutSession);

        on<GetTripDetailByIdEvent>(_onGetTripDetailByIdEvent);

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

  Future<String?> _getFare() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('tripid');
  }

 Future<String?> _getpaymentId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('paymentid');
  }

  FutureOr<void> _onCreateCheckoutSession(
      CreateCheckoutSessionEvent event, Emitter<RidestartState> emit)async{
        emit(CheckoutLoading());
            String? driverId = await _getDriverId();
    String? userId = await _getUserId();
    String? tripId = await _getTripId();
    try {
      final url = await paymentController.createCheckoutSession(
        userId: userId!,
        driverId:driverId!,
        tripId:tripId!,
        fare: event.fare!,
      );
      if (kDebugMode) {
        print('the url$url');
      }
      emit(CheckoutSuccess());
    } catch (e) {
      emit(CheckoutFailure(e.toString()));
    }
      }

  Future<void> _Confirmpayment(
      MakePaymentEvent event, Emitter<RidestartState> emit) async {
    String? driverId = await _getDriverId();
    String? userId = await _getUserId();
    String? tripId = await _getTripId();
    String? paymentid = await _getpaymentId();

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
         sessionId: paymentid!,
      );
      print('the response is $response');
      emit(PaymentSuccess(response));
    } catch (error) {
      emit(PaymentFailure(error.toString()));
    }
  }

  void _onRideRequestReceived(
      RideRequestReceived event, Emitter<RidestartState> emit) {
    _rideData = event.requestData; // Save the data in the Bloc
    emit(RideRequestVisible(event.requestData));
    add(CheckRideStatusEvent());
  }

  void _onRidestartRequestReceived(
      RideStartReceived event, Emitter<RidestartState> emit) {
    rideData = event.rideData;
    emit(RidestartRequestVisible(event.rideData));
    add(CheckRideStartStatusEvent());
  }

  Future<void> _onCheckRideStatusEvent(
      CheckRideStatusEvent event, Emitter<RidestartState> emit) async {
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
        final tripFare = print('this is tripid:$tripId');

        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Check if both IDs are not null
        if (driverId != null && tripId != null) {
          // Store the IDs in SharedPreferences
          prefs.setString('driverid', driverId);
          prefs.setString('tripid', tripId);

          // Extract coordinates from rideData
          final startCoordinates =
              rideData['driverDetails']['currentLocation']['coordinates'];
          final endCoordinates = rideData['startLocation']['coordinates'];

          // Convert coordinates to LatLng
          final LatLng startLatLng =
              LatLng(startCoordinates[1], startCoordinates[0]);
          final LatLng endLatLng = LatLng(endCoordinates[0], endCoordinates[1]);

          UserChatSocketService chatService = UserChatSocketService();
          // chatService.initializeChatSocket();
          chatService.connectChatSocket(tripId); // Connect with tripId
          print('Chat connected for tripId: $tripId');

          emit(PicUpSimulationState(rideData,
              startLatLng: startLatLng, endLatLng: endLatLng));
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
    print("Entered _onCheckRidestartStatusEvent");

    try {
      // Check if the current state is RideRequestVisible
      print('Current state: ${state.runtimeType}');

      if (state is RidestartRequestVisible) {
        final rideDatas = rideData;

        // Debug: Print the entire rideData
        print("Ride Data: $rideData");

        // Check if rideData is null or empty
        if (rideDatas == null || rideDatas.isEmpty) {
          print('No data found in rideData');
          emit(RideAccepError(message: 'No ride data available.'));
          return;
        }

        // Extract coordinates from rideData safely
        final startCoordinates =
            rideDatas['tripDetails']?['startLocation']?['coordinates'];
        final endCoordinates =
            rideDatas['tripDetails']?['endLocation']?['coordinates'];

        print('startCoordinates: $startCoordinates');
        print('endCoordinates: $endCoordinates');

        // Validate the coordinates before use
        if (startCoordinates == null || endCoordinates == null) {
          print('Missing coordinates data.');
          emit(RideAccepError(message: 'Missing coordinates data.'));
          return;
        }

        // Convert coordinates to LatLng
        try {
          final LatLng startLatLng = LatLng(
              startCoordinates[0], startCoordinates[1]); // lat, long order
          final LatLng endLatLng =
              LatLng(endCoordinates[0], endCoordinates[1]); // lat, long order
          print('Converted startLatLng: $startLatLng');
          print('Converted endLatLng: $endLatLng');

          emit(RidestartedState());
          emit(DropSimulationState(rideDatas,
              startLatLng: startLatLng, endLatLng: endLatLng));
          print('Emitting DropSimulationState with updated coordinates');
        } catch (e) {
          print('Error converting coordinates: $e');
          emit(RideAccepError(message: 'Error converting coordinates.'));
        }
      } else {
        print('State is not RidestartRequestVisible, skipping processing.');
      }
    } catch (e, stackTrace) {
      // Print the error and stack trace for detailed debugging
      print("Error occurred in _onCheckRideStartStatusEvent: $e");
      print("StackTrace: $stackTrace");

      // Emit error state
      emit(RideAccepError(message: 'Error checking ride status: $e'));
    }
  }

  Future<void> _onCancelRide(
      CancelRideEvent event, Emitter<RidestartState> emit) async {
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



 Future<void> _onGetTripDetailByIdEvent(
      GetTripDetailByIdEvent event, Emitter<RidestartState> emit) async {
    emit(TripLoading());
    try {
          String? tripId = await _getTripId();

     final response=  await paymentController.getTripDetailById(tripId!);

      if (response!=null) {
        emit(TripLoaded(response)); // Emit TripLoaded state with the fetched data
      } else {
        emit(TripError('Failed to load trip details'));
      }
    } catch (e) {
      emit(TripError('Failed to load trip details'));
    }
  }


}
