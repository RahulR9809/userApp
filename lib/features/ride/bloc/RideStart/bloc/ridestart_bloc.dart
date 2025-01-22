// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:rideuser/features/chat/service/chat_usersoketcontroller.dart';
import 'package:rideuser/features/payment/service/payment_controller.dart';
import 'package:rideuser/features/ride/service/ride_controller.dart';
import 'package:rideuser/features/auth/service/user_socket.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'ridestart_event.dart';
part 'ridestart_state.dart';

class RidestartBloc extends Bloc<RidestartEvent, RidestartState> {
  final UserSocketService socketService;
  final PaymentController paymentController = PaymentController();
  RideService rideService = RideService();
  Map<String, dynamic>? _rideData;
  Map<String, dynamic>? rideData;
  Map<String, dynamic>? rideDatas;

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

    socketService.ridecompletedCallback((data) {
      add(RideCompletedReceived(data));
    });

    on<RideCompletedStatusEvent>(_ridecompletedSuccess);

    on<RideStartReceived>(_onRidestartRequestReceived);
    on<RideCompletedReceived>(_onRideCompletedRequestReceived);

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
      CreateCheckoutSessionEvent event, Emitter<RidestartState> emit) async {
    emit(CheckoutLoading());
    String? driverId = await _getDriverId();
    String? userId = await _getUserId();
    String? tripId = await _getTripId();
    try {
      final url = await paymentController.createCheckoutSession(
        userId: userId!,
        driverId: driverId!,
        tripId: tripId!,
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
      if (kDebugMode) {
        print('the response is $response');
      }
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


  FutureOr<void> _onRideCompletedRequestReceived(
      RideCompletedReceived event, Emitter<RidestartState> emit) {
        rideDatas=event.rideData;
        add(RideCompletedStatusEvent());
  }


  Future<void> _onCheckRideStatusEvent(
      CheckRideStatusEvent event, Emitter<RidestartState> emit) async {
    try {
      if (state is RideRequestVisible) {
        final rideData = _rideData!;

        if (kDebugMode) {
          print("Ride Data: $rideData");
        }

        if (rideData.isEmpty) {
          return;
        }

        final driverId = rideData['driverId'];
        final tripId = rideData['_id'];
        // final tripFare = print('this is tripid:$tripId');

        SharedPreferences prefs = await SharedPreferences.getInstance();

        if (driverId != null && tripId != null) {
          prefs.setString('driverid', driverId);
          prefs.setString('tripid', tripId);

          final startCoordinates =
              rideData['driverDetails']['currentLocation']['coordinates'];
          final endCoordinates = rideData['startLocation']['coordinates'];

          final LatLng startLatLng =
              LatLng(startCoordinates[1], startCoordinates[0]);
          final LatLng endLatLng = LatLng(endCoordinates[0], endCoordinates[1]);

          UserChatSocketService chatService = UserChatSocketService();
          chatService.connectChatSocket(tripId);
          if (kDebugMode) {
            print('Chat connected for tripId: $tripId');
          }

          emit(PicUpSimulationState(rideData,
              startLatLng: startLatLng, endLatLng: endLatLng));
        } else {
          emit(RideAccepError(message: 'Missing driver or trip ID'));
        }
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error occurred in _onCheckRideStatusEvent: $e");
      }
      if (kDebugMode) {
        print("StackTrace: $stackTrace");
      }

      emit(RideAccepError(message: 'Error checking ride status: $e'));
    }
  }

  Future<void> _onCheckRideStartStatusEvent(
      CheckRideStartStatusEvent event, Emitter<RidestartState> emit) async {

    try {

      if (state is RidestartRequestVisible) {
        final rideDatas = rideData;

        if (kDebugMode) {
          print("Ride Data: $rideData");
        }

      
        if (rideDatas == null || rideDatas.isEmpty) {
          if (kDebugMode) {
            print('No data found in rideData');
          }
          emit(RideAccepError(message: 'No ride data available.'));
          return;
        }

        final startCoordinates =
            rideDatas['tripDetails']?['startLocation']?['coordinates'];
        final endCoordinates =
            rideDatas['tripDetails']?['endLocation']?['coordinates'];

        if (kDebugMode) {
          print('startCoordinates: $startCoordinates');
        }
        if (kDebugMode) {
          print('endCoordinates: $endCoordinates');
        }

        if (startCoordinates == null || endCoordinates == null) {
          emit(RideAccepError(message: 'Missing coordinates data.'));
          return;
        }

        try {
          final LatLng startLatLng = LatLng(
              startCoordinates[0], startCoordinates[1]);
          final LatLng endLatLng =
              LatLng(endCoordinates[0], endCoordinates[1]); 
          if (kDebugMode) {
            print('Converted startLatLng: $startLatLng');
          }
          if (kDebugMode) {
            print('Converted endLatLng: $endLatLng');
          }

          emit(RidestartedState());
          emit(DropSimulationState(rideDatas,
              startLatLng: startLatLng, endLatLng: endLatLng));
        } catch (e) {
          emit(RideAccepError(message: 'Error converting coordinates.'));
        }
      } else {
        if (kDebugMode) {
          print('State is not RidestartRequestVisible, skipping processing.');
        }
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("StackTrace: $stackTrace");
      }

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

      final response = await paymentController.getTripDetailById(tripId!);

      // ignore: unnecessary_null_comparison
      if (response != null) {
        emit(TripLoaded(
            response));
      } else {
        emit(TripError('Failed to load trip details'));
      }
    } catch (e) {
      emit(TripError('Failed to load trip details'));
    }
  }



  FutureOr<void> _ridecompletedSuccess(RideCompletedStatusEvent event, Emitter<RidestartState> emit) {
    emit(RideCompletedState());
  }
}
