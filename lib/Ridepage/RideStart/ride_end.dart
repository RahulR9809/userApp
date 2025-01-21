import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';
import 'package:rideuser/map/map_pages.dart';
import 'package:rideuser/widgets/ride_completedwidget.dart';
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
    print("Building RideStart Screen");

    return Scaffold(
      body: Stack(
        children: [
          // 📍 Map View
          BlocBuilder<RidestartBloc, RidestartState>(
            builder: (context, state) {
              // Handle different ride simulation states
              if (state is DropSimulationState) {
print("Emitting DropSimulationState with updated coordinates: ${state.startLatLng}, ${state.endLatLng}");
                return MapboxDropSimulation(
                  startPoint: state.startLatLng,
                  endPoint: state.endLatLng,
                );
              }
              // Default map view if no simulation state
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
                print('DropSimulationState emitted');
                _rideData = state.requestData;  // Get ride data from state
                print('This is the ride data: $_rideData');
                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: RidestartedBottomBar(rideData: _rideData!),
                );
              }
              // Default state when no relevant simulation state
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}



