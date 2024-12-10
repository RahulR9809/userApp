part of 'ridestart_bloc.dart';

@immutable
sealed class RidestartEvent {}

class RideAcceptedEvent extends RidestartEvent {
  final Map<String, dynamic> rideData;

  RideAcceptedEvent(this.rideData);
}

class CheckRideStatusEvent extends RidestartEvent {}