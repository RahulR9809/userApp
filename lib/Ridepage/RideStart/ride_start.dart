
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';
import 'package:rideuser/Ridepage/RideStart/ride_end.dart';
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
//   late ChatBloc _chatBloc;

//   @override
//   void initState() {
//     super.initState();
//     _chatBloc = BlocProvider.of<ChatBloc>(context);
//     _initializeChat();
//   }



//  Future<void> _initializeChat() async {
//      SharedPreferences pref = await SharedPreferences.getInstance();
//     final tripid= pref.getString('tripid')??'no trip id';

//     _chatBloc.add(ChatSocketConnectedevent(userid: tripid));
//   }
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

              if (state is PicUpSimulationState) {
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
              } else if (state is PicUpSimulationState) {
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
          BlocListener<RidestartBloc, RidestartState>(
            listener: (context, state) {
                if (state is RidestartedState) {
      // Navigate to RideEnd when DropSimulationState is emitted
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RideEnd()),
      );
    }else
              if (state is CancelRideSuccess) {
                showCustomSnackBar(context, 'Ride cancelled successfully!',
                    backgroundColor: Colors.green);

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => StartRide()));
              }

             
            },
            child: Container(),
          ),
        ],
      ),
    );
  }
}





