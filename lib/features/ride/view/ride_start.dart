
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/features/ride/bloc/RideStart/bloc/ridestart_bloc.dart';
import 'package:rideuser/features/ride/view/ride_end.dart';
import 'package:rideuser/features/map/view/map_pages.dart';
import 'package:rideuser/features/ride/view/ride.dart';
import 'package:rideuser/widgets/ride_completed_widget.dart';

class RideStart extends StatefulWidget {
  const RideStart({super.key});

  @override
  _RideStartState createState() => _RideStartState();
}

class _RideStartState extends State<RideStart> {
  Map<String, dynamic>? _rideData;


 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<RidestartBloc, RidestartState>(
            builder: (context, state) {

              if (state is PicUpSimulationState) {
                return MapboxPicupSimulation(
                  startPoint: state.startLatLng,
                  endPoint: state.endLatLng,
                );
              }
              return const MapboxLoading();
            },
          ),
          BlocBuilder<RidestartBloc, RidestartState>(
            builder: (context, state) {
      
                if (state is PicUpSimulationState) {
                _rideData = state.requestData;
                return Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: RideBottomBar(rideData: _rideData!));
              }
      return const SizedBox.shrink();
            },
          ),
          BlocListener<RidestartBloc, RidestartState>(
            listener: (context, state) {
                if (state is RidestartedState) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RideEnd()),
      );
    }else
              if (state is CancelRideSuccess) {
                showCustomSnackBar(context, 'Ride cancelled successfully!',
                    backgroundColor: Colors.green);

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const StartRide()));
              }

             
            },
            child: Container(),
          ),
        ],
      ),
    );
  }
}





