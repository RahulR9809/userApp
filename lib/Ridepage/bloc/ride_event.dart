part of 'ride_bloc.dart';

@immutable
sealed class RideEvent {}

class RequestedRideEvent extends RideEvent{}