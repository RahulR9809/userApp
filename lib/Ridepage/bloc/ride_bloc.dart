import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rideuser/controller/ride_controller.dart';

part 'ride_event.dart';
part 'ride_state.dart';

class RideBloc extends Bloc<RideEvent, RideState> {
  RideBloc() : super(RideInitial()) {

  //  on<RequestedRideEvent>((event, emit) async{
  //    emit(RideLoadingState());
  //    final data=await RideService.createRideRequest(userId: '', fare: null)
  //  },);
  }
}
