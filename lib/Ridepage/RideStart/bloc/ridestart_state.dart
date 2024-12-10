part of 'ridestart_bloc.dart';

@immutable
sealed class RidestartState {}

final class RidestartInitial extends RidestartState {}




class RideAcceptedState extends RidestartState {
  final Map<String, dynamic> rideData;

  RideAcceptedState(this.rideData);
}

class RideAccepError extends RidestartState {
  final String message;

  RideAccepError({required this.message});
}