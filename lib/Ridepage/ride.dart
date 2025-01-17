
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_bloc.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_event.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_state.dart';
import 'package:rideuser/Ridepage/RequestRide/request_ride.dart';
import 'package:rideuser/chat/chat.dart';
import 'package:rideuser/controller/chat_usersoketcontroller.dart';
import 'package:rideuser/controller/user_socket.dart';
import 'package:rideuser/core/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
class StartRide extends StatelessWidget {
  const StartRide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          // ' Always There\n to Take You Anywhere',
          'Electra',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: ThemeColors.white,
          ),
        ),
        // centerTitle: true,
        backgroundColor: ThemeColors.green,
        leading: Container(),
          centerTitle: false,

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // First Car Image with Gradient Overlay for Readability
            _buildImageContainer(
              'assets/view-3d-car-with-city.jpg',
              'Experience Smooth Rides',
            ),
            const SizedBox(height: 20),

            // Ride Button with Action
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? userId = prefs.getString('userid');

                if (userId != null) {
                  UserSocketService userSocketService = UserSocketService();
                  userSocketService.connectSocket(userId);
                 
                  //  Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => const RidePage()),
                  //   );
                  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => BlocProvider(
      create: (_) => RideBloc(),
      child: RidePage(),
    ),
  ),
);

                } else {
                  if (kDebugMode) {
                    print('No user ID found');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.green,
                padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 29),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 8,
              ),
              child: const Text(
                'Go Ride',
                style: TextStyle(color: ThemeColors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Travel in Comfort with Electric Vehicles',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: ThemeColors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Experience the future of travel with our eco-friendly electric vehicles. '
              'Enjoy a smooth and quiet ride while contributing to a sustainable environment.',
              style: TextStyle(
                fontSize: 16,
                color: ThemeColors.grey,
              ),
            ),
            const SizedBox(height: 30),

            // Second Car Image with Gradient Overlay for a different view
            _buildImageContainer(
              'assets/Eco.jpg',
              'Eco-friendly Electric Ride',
            ),
            const SizedBox(height: 40),

            // Additional Information Section
            const Text(
              'Why Choose Electric Vehicles?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: ThemeColors.darkGrey,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Electric vehicles (EVs) are the future of transportation. They provide a quiet, smooth ride and are environmentally friendly. '
              'With zero emissions, EVs contribute to a cleaner, healthier planet while reducing your carbon footprint. '
              'Experience the thrill of driving without the guilt of harming the environment.',
              style: TextStyle(
                fontSize: 16,
                color: ThemeColors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Third Image Section
            _buildImageContainer(
              'assets/ride.jpg',
              'Drive Smart, Live Smart',
            ),
            const SizedBox(height: 40),

            // Footer Section
            const Center(
              child: Text(
                'Your ride awaits!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: ThemeColors.darkGrey,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: ThemeColors.lightWhite,
    );
  }

  Widget _buildImageContainer(String imageUrl, String text) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 146, 148, 146).withOpacity(0.6),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 237, 237, 237),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
