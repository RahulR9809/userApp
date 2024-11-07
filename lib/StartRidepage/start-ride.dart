// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:rideuser/StartRidepage/ride.dart';
import 'package:rideuser/widgets/auth_widgets.dart';


class StartRide extends StatelessWidget {
  const StartRide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Always There\nto Take You Anywhere' ,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),),
        backgroundColor: Colors.transparent, // Make the AppBar transparent
        elevation: 0, // Remove the shadow
      ),
      body: SingleChildScrollView( // Allow scrolling
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Text
        
            const SizedBox(height: 20), // Adjust spacing as needed

            // Car Image Container
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: NetworkImage('https://img-new.cgtrader.com/items/88236/9bd3f74530/city-car-3d-model-ige-igs-iges.jpg'), // Use a valid URL
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20), // Adjust spacing as needed

            // Go Ride Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const RidePage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Set button color
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child:  const Text('Go Ride',style: TextStyle(color: Colors.white),),
            ),
            const SizedBox(height: 20), // Adjust spacing as needed

            // Travel Info Text
            const Text(
              'Travel in Comfort with Electric Vehicles',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10), // Adjust spacing as needed

            // Description about EVs
            const Text(
              'Experience the future of travel with our eco-friendly electric vehicles. Enjoy a smooth and quiet ride while contributing to a sustainable environment.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20), // Adjust spacing as needed

            // EV Image Container
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: NetworkImage('https://img-new.cgtrader.com/items/88236/9bd3f74530/city-car-3d-model-ige-igs-iges.jpg'), // Use a valid URL
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20), // Adjust spacing as needed
  
            const SizedBox(height: 20), // Adjust spacing as needed

            const SizedBox(height: 20), // Adjust spacing as needed
          ],
        ),
      ),
    );
  }
}
