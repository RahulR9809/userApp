part of 'ridestart_bloc.dart';

@immutable
sealed class RidestartEvent {}

class RideAcceptedEvent extends RidestartEvent {
  final Map<String, dynamic> rideData;

  RideAcceptedEvent(this.rideData);
}

class CheckRideStatusEvent extends RidestartEvent {}


class MakePaymentEvent extends RidestartEvent {
  final String? userId;
  final String? tripId;
  final String? driverId;
  final String paymentMethod;
  final double fare;

  MakePaymentEvent({
     this.userId,
     this.tripId,
     this.driverId,
    required this.paymentMethod,
    required this.fare,
  });
}


class UpdateRideDataEvent extends RidestartEvent {
  final Map<String, dynamic> rideData;

  UpdateRideDataEvent(this.rideData);
}


class CancelRideEvent extends RidestartEvent {
  final String? userId;
  final String? tripId;
  final String cancelReason;

  CancelRideEvent({
     this.userId,
     this.tripId,
    required this.cancelReason,
  });
}



class StartPickupSimulationEvent extends RidestartEvent {
  final LatLng startLatLng;
  final LatLng endLatLng;

  StartPickupSimulationEvent({required this.startLatLng, required this.endLatLng});
}



class RideRequestReceived extends RidestartEvent {
  final Map<String, dynamic> requestData;

  RideRequestReceived(this.requestData);
}


class CheckRideStartStatusEvent extends RidestartEvent {}


class RideStartReceived  extends RidestartEvent {
  final String rideData;

  RideStartReceived(this.rideData);
}



class ChatSocketConnectedevent extends RidestartEvent{
final String tripid;

  ChatSocketConnectedevent({required this.tripid});
}