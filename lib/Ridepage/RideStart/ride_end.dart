
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';
import 'package:rideuser/map/map_pages.dart';
import 'package:rideuser/Ridepage/ride.dart';
import 'package:rideuser/widgets/ride_completedwidget.dart';
import 'package:rideuser/widgets/ride_widget.dart';

class RideStart extends StatefulWidget {
  const RideStart({super.key});

  @override
  _RideStartState createState() => _RideStartState();
}

class _RideStartState extends State<RideStart> {
  Map<String, dynamic>? _rideData;

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    print("Building RideStart Screen");

    return Scaffold(
      body: Stack(
        children: [
          // 📍 Map View
          BlocBuilder<RidestartBloc, RidestartState>(
            builder: (context, state) {

              if (state is DropSimulationState) {
                print('Emitting PicUpSimulationState');
                return MapboxPicupSimulation(
                  startPoint: state.startLatLng,
                  endPoint: state.endLatLng,
                );
              }
              return MapboxWidget();
            },
          ),
          // 📋 Bottom Bar
          BlocBuilder<RidestartBloc, RidestartState>(
            builder: (context, state) {
              if (state is RidestartInitial) {
                return const Center(
                  child: LoadingScreenDialog(),
                );
              } else if (state is DropSimulationState) {
                print('picup simulation state emitted');
                _rideData = state.requestData;
                print('this is the ridedata from picupsimulation state:$_rideData');
                return Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: RideBottomBar(rideData: _rideData!));
              }
      return const SizedBox.shrink();
            },
          ),
          // BlocListener<RidestartBloc, RidestartState>(
          //   listener: (context, state) {
          //     if (state is CancelRideSuccess) {
          //       showCustomSnackBar(context, 'Ride cancelled successfully!',
          //           backgroundColor: Colors.green);

          //       Navigator.pushReplacement(context,
          //           MaterialPageRoute(builder: (context) => StartRide()));
          //     }

             
          //   },
          //   child: Container(),
          // ),
        ],
      ),
    );
  }
}





