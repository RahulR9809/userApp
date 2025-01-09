// part of 'ridestart_bloc.dart';

// @immutable
// sealed class RidestartState {}

// final class RidestartInitial extends RidestartState {}




// class RideAcceptedState extends RidestartState {
//   final Map<String, dynamic> rideData;

//   RideAcceptedState(this.rideData);
// }


// class RideAccepError extends RidestartState {
//   final String message;

//   RideAccepError({required this.message});
// }

// class PicUpSimulationState extends RidestartState {
//   final LatLng startLatLng; 
//   final LatLng endLatLng;  

//   PicUpSimulationState({
//     required this.startLatLng,
//     required this.endLatLng,
//   });
// }


// class CancelRideLoading extends RidestartState {}

// class CancelRideSuccess extends RidestartState {}

// class CancelRideFailure extends RidestartState {
//   final String error;

//   CancelRideFailure(this.error);
// }


// class PaymentLoading extends RidestartState {}

// class PaymentSuccess extends RidestartState {
//   final Map<String, dynamic> response;

//   PaymentSuccess(this.response);
// }

// class PaymentFailure extends RidestartState {
//   final String error;

//   PaymentFailure(this.error);
// }



// class RideRequestVisible extends RidestartState {
//   final Map<String, dynamic> requestData;

//   RideRequestVisible(this.requestData);
// }



part of 'ridestart_bloc.dart';

@immutable
sealed class RidestartState {}

final class RidestartInitial extends RidestartState {}




class RideAcceptedState extends RidestartState {}


class RideAccepError extends RidestartState {
  final String message;

  RideAccepError({required this.message});
}

class PicUpSimulationState extends RidestartState {
  final LatLng startLatLng; 
  final LatLng endLatLng;  
  final Map<String, dynamic> requestData;

  PicUpSimulationState(this.requestData, {
    required this.startLatLng,
    required this.endLatLng,
  });
}


class CancelRideLoading extends RidestartState {}

class CancelRideSuccess extends RidestartState {}

class CancelRideFailure extends RidestartState {
  final String error;

  CancelRideFailure(this.error);
}


class PaymentLoading extends RidestartState {}

class PaymentSuccess extends RidestartState {
  final Map<String, dynamic> response;

  PaymentSuccess(this.response);
}

class PaymentFailure extends RidestartState {
  final String error;

  PaymentFailure(this.error);
}



class RideRequestVisible extends RidestartState {
  final Map<String, dynamic> requestData;

  RideRequestVisible(this.requestData);
}


class RidestartRequestVisible extends RidestartState {
  final Map<String, dynamic> requestData;

  RidestartRequestVisible(this.requestData);
}



class DropSimulationState extends RidestartState {
  final LatLng startLatLng; 
  final LatLng endLatLng;  
  final Map<String, dynamic> requestData;

  DropSimulationState(this.requestData, {
    required this.startLatLng,
    required this.endLatLng,
  });
}


class ChatConnected extends RidestartState{}

class ChatLoading extends RidestartState{}


  class ChatSocketConnectedstate extends RidestartState{
final String driverId;

  ChatSocketConnectedstate({required this.driverId});
}
