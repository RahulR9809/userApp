// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:rideuser/Ridepage/request_ride.dart';


// class StartRide extends StatelessWidget {
//   const StartRide({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Always There\nto Take You Anywhere' ,
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),),
//         backgroundColor: Colors.transparent, // Make the AppBar transparent
//         elevation: 0, // Remove the shadow
//       ),
//       body: SingleChildScrollView( // Allow scrolling
//         padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Text
        
//             const SizedBox(height: 20), // Adjust spacing as needed

//             // Car Image Container
//             Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 image: const DecorationImage(
//                   image: NetworkImage('https://img-new.cgtrader.com/items/88236/9bd3f74530/city-car-3d-model-ige-igs-iges.jpg'), // Use a valid URL
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20), // Adjust spacing as needed

//             // Go Ride Button
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>  RidePage()));
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green, // Set button color
//                 padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
//                 textStyle: const TextStyle(fontSize: 18),
//               ),
//               child:  const Text('Go Ride',style: TextStyle(color: Colors.white),),
//             ),
//             const SizedBox(height: 20), // Adjust spacing as needed

//             // Travel Info Text
//             const Text(
//               'Travel in Comfort with Electric Vehicles',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 10), // Adjust spacing as needed

//             // Description about EVs
//             const Text(
//               'Experience the future of travel with our eco-friendly electric vehicles. Enjoy a smooth and quiet ride while contributing to a sustainable environment.',
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 20), // Adjust spacing as needed

//             // EV Image Container
//             Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 image: const DecorationImage(
//                   image: NetworkImage('https://img-new.cgtrader.com/items/88236/9bd3f74530/city-car-3d-model-ige-igs-iges.jpg'), // Use a valid URL
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20), // Adjust spacing as needed
  
//             const SizedBox(height: 20), // Adjust spacing as needed

//             const SizedBox(height: 20), // Adjust spacing as needed
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:rideuser/Ridepage/request_ride.dart';
import 'package:rideuser/core/colors.dart';

class StartRide extends StatelessWidget {
  const StartRide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Always There\n to Take You Anywhere',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: ThemeColors.brightWhite, // Use Bright White
          ),
        ),
        backgroundColor: ThemeColors.royalPurple, // Use Royal Purple
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Car Image with Gradient Overlay for Readability
            Container(
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://img-new.cgtrader.com/items/88236/9bd3f74530/city-car-3d-model-ige-igs-iges.jpg'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 20,
                    offset: Offset(0, 8),
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
              ),
            ),
            const SizedBox(height: 20),

            // Go Ride Button with Electric Blue
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RidePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.royalPurple, // Use Royal Purple
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 8,
              ),
              child: const Text(
                'Go Ride',
                style: TextStyle(color: ThemeColors.brightWhite, fontSize: 20), // Use Bright White
              ),
            ),
            const SizedBox(height: 20),

            // Travel Info Text with White Color
            const Text(
              'Travel in Comfort with Electric Vehicles',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: ThemeColors.brightWhite, // Use Bright White
              ),
            ),
            const SizedBox(height: 10),

            // Description Text with Soft Yellow for a warm vibe
            const Text(
              'Experience the future of travel with our eco-friendly electric vehicles. '
              'Enjoy a smooth and quiet ride while contributing to a sustainable environment.',
              style: TextStyle(
                fontSize: 16,
                color: ThemeColors.lightgrey, // Use Soft Yellow
              ),
            ),
            const SizedBox(height: 30),

            // EV Image with Gradient Overlay for consistency
            Container(
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://img-new.cgtrader.com/items/88236/9bd3f74530/city-car-3d-model-ige-igs-iges.jpg'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 20,
                    offset: Offset(0, 8),
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
              ),
            ),
            const SizedBox(height: 40),

            // Footer Text in Royal Purple for Accent
            const Center(
              child: Text(
                'Your ride awaits!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: ThemeColors.brightWhite, // Use Royal Purple
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: ThemeColors.charcoalGray, // Use Charcoal Gray for background
    );
  }
}
