// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';

// part 'ridestart_event.dart';
// part 'ridestart_state.dart';

// class RidestartBloc extends Bloc<RidestartEvent, RidestartState> {
//   RidestartBloc() : super(RidestartInitial()) {
//     on<RideAcceptedEvent>(_onRideAcceptedEvent);

// }

// // Future<void> _onRideAcceptedEvent(
// //     RideAcceptedEvent event, Emitter<RidestartState> emit) async {
// //   try {
// //     if(event.rideData.isNotEmpty){
// //     emit(RideAcceptedState(event.rideData));
// //     print('we got the data bruh');
// //     }else{
// // print('no data is here');
// //     }
// //   } catch (e) {
// //     print('Error: $e');
// //     emit(RideAccepError(message: 'Error accepting ride'));
// //   }
// // }
// Future<void> _onRideAcceptedEvent(
//     RideAcceptedEvent event, Emitter<RidestartState> emit) async {
//   print('Handling RideAcceptedEvent...');
//   try {
//     if (event.rideData.isNotEmpty) {
//       print('Emitting RideAcceptedState with data: ${event.rideData}');
//       emit(RideAcceptedState(event.rideData));
//     } else {
//       print('Received empty ride data');
//       emit(RideAccepError(message: 'Invalid ride data'));
//     }
//   } catch (e) {
//     print('Error handling RideAcceptedEvent: $e');
//     emit(RideAccepError(message: 'Error accepting ride'));
//   }
// }

// }

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rideuser/controller/user_socket.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'ridestart_event.dart';
part 'ridestart_state.dart';

class RidestartBloc extends Bloc<RidestartEvent, RidestartState> {
  final UserSocketService socketService;

  RidestartBloc(this.socketService) : super(RidestartInitial()) {
    on<CheckRideStatusEvent>(_onCheckRideStatusEvent);
  }

  Future<void> _onCheckRideStatusEvent(
      CheckRideStatusEvent event, Emitter<RidestartState> emit) async {
    try {
      // Fetch the latest ride data from the socket service
      final rideData = socketService.latestRideData;
      if (rideData.isNotEmpty) {
        final driverid = rideData['driverId'];
        final tripid=rideData['_id'];
        print("this is the trip id:$tripid");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('driverid', driverid);
        emit(RideAcceptedState(rideData));
      }
    } catch (e) {
      emit(RideAccepError(message: 'Error checking ride status: $e'));
    }
  }
}
