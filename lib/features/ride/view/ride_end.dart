import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/features/ride/bloc/RideStart/bloc/ridestart_bloc.dart';
import 'package:rideuser/features/map/view/map_pages.dart';
import 'package:rideuser/widgets/ride_completed_widget.dart';
import 'package:rideuser/widgets/ride_widget.dart';  // Import RideBottomBar

class RideEnd extends StatefulWidget {
  const RideEnd({super.key});

  @override
  _RideEndState createState() => _RideEndState();
}

class _RideEndState extends State<RideEnd> {
  Map<String, dynamic>? _rideData;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<RidestartBloc, RidestartState>(
            builder: (context, state) {
              if (state is DropSimulationState) {
                return MapboxDropSimulation(
                  startPoint: state.startLatLng,
                  endPoint: state.endLatLng,
                );
              }
              return const MapboxWidget();
            },
          ),
          
          BlocBuilder<RidestartBloc, RidestartState>(
            builder: (context, state) {
              if (state is RidestartInitial) {
                return const Center(
                  child: LoadingScreenDialog(),
                );
              } else if (state is DropSimulationState) {
                _rideData = state.requestData; 
                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: RidestartedBottomBar(rideData: _rideData!),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}



