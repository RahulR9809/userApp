part of 'ride_bloc.dart';

@immutable
sealed class RideState {}

final class RideInitial extends RideState {}

class RideLoadingState extends RideState{}

class RideLoadedState extends RideState{}

class ErrorLoadingRide extends RideState{}
