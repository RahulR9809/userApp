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
import 'package:rideuser/controller/user_socket.dart';
import 'package:rideuser/core/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class StartRide extends StatelessWidget {
//   const StartRide({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Always There\n to Take You Anywhere',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.w700,
//             color: ThemeColors.brightWhite, // Use Bright White
//           ),
//         ),
//         backgroundColor: ThemeColors.royalPurple, // Use Royal Purple
//         elevation: 4,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),

//             // Car Image with Gradient Overlay for Readability
//             Container(
//               height: 240,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 image: const DecorationImage(
//                   image: NetworkImage(
//                       'https://img-new.cgtrader.com/items/88236/9bd3f74530/city-car-3d-model-ige-igs-iges.jpg'),
//                   fit: BoxFit.cover,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.6),
//                     blurRadius: 20,
//                     offset: Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.black.withOpacity(0.6), Colors.transparent],
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Go Ride Button with Electric Blue
//             ElevatedButton(
//               onPressed: () async {
//                 // Get the userId from SharedPreferences
//                 SharedPreferences prefs = await SharedPreferences.getInstance();
//                 String? userId = prefs.getString('userid');

//                 if (userId != null) {
//                   // Initialize UserSocketService and connect to the server
//                   UserSocketService userSocketService = UserSocketService();
//                   userSocketService.initializeSocket(); // Initialize socket
//                   userSocketService.connectSocket(userId); // Connect with userId

//                   // Navigate to the RidePage
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => RidePage()),
//                   );
//                 } else {
//                   // Handle case where no userId is found
//                   print('No user ID found');
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ThemeColors.royalPurple, // Use Royal Purple
//                 padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 elevation: 8,
//               ),
//               child: const Text(
//                 'Go Ride',
//                 style: TextStyle(color: ThemeColors.brightWhite, fontSize: 20), // Use Bright White
//               ),
//             ),
//             const SizedBox(height: 20),

//             const Text(
//               'Travel in Comfort with Electric Vehicles',
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w700,
//                 color: ThemeColors.brightWhite, 
//               ),
//             ),
//             const SizedBox(height: 10),

//             const Text(
//               'Experience the future of travel with our eco-friendly electric vehicles. '
//               'Enjoy a smooth and quiet ride while contributing to a sustainable environment.',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: ThemeColors.lightgrey,
//               ),
//             ),
//             const SizedBox(height: 30),
//             Container(
//               height: 240,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 image: const DecorationImage(
//                   image: NetworkImage(
//                       'https://img-new.cgtrader.com/items/88236/9bd3f74530/city-car-3d-model-ige-igs-iges.jpg'),
//                   fit: BoxFit.cover,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.6),
//                     blurRadius: 20,
//                     offset: Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.black.withOpacity(0.6), Colors.transparent],
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 40),

//             const Center(
//               child: Text(
//                 'Your ride awaits!',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w800,
//                   color: ThemeColors.brightWhite, // Use Royal Purple
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: ThemeColors.charcoalGray, // Use Charcoal Gray for background
//     );
//   }
// }







// class StartRide extends StatelessWidget {
//   const StartRide({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Always There\n to Take You Anywhere',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.w700,
//             color: ThemeColors.brightWhite,
//           ),
//         ),
//         backgroundColor: ThemeColors.royalPurple,
//         elevation: 4,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             // Car Image with Gradient Overlay for Readability
//             Container(
//               height: 240,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 image: const DecorationImage(
//                   image: NetworkImage(
//                       'https://img-new.cgtrader.com/items/88236/9bd3f74530/city-car-3d-model-ige-igs-iges.jpg'),
//                   fit: BoxFit.cover,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.6),
//                     blurRadius: 20,
//                     offset: Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.black.withOpacity(0.6), Colors.transparent],
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Go Ride Button with Electric Blue
//             ElevatedButton(
//               onPressed: () async {
//                 // Get the userId from SharedPreferences
//                 SharedPreferences prefs = await SharedPreferences.getInstance();
//                 String? userId = prefs.getString('userid');

//                 if (userId != null) {
//                   // Initialize UserSocketService and connect to the server
//                   UserSocketService userSocketService = UserSocketService();
//                   userSocketService.initializeSocket(); // Initialize socket
//                   userSocketService.connectSocket(userId); // Connect with userId

//                   // Wait for the socket to connect before navigating
//                   await Future.delayed(Duration(seconds: 2));

//                   // Check if the socket is connected
//                   if (userSocketService.isConnected()) {
//                     // Navigate to the RidePage
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => RidePage()),
//                     );
//                   } else {
//                     // Handle the case where the socket connection failed
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Failed to connect to socket. Try again later.')),
//                     );
//                   }
//                 } else {
//                   // Handle case where no userId is found
//                   print('No user ID found');
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ThemeColors.royalPurple,
//                 padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 elevation: 8,
//               ),
//               child: const Text(
//                 'Go Ride',
//                 style: TextStyle(color: ThemeColors.brightWhite, fontSize: 20),
//               ),
//             ),
//             const SizedBox(height: 20),

//             const Text(
//               'Travel in Comfort with Electric Vehicles',
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w700,
//                 color: ThemeColors.brightWhite,
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               'Experience the future of travel with our eco-friendly electric vehicles. '
//               'Enjoy a smooth and quiet ride while contributing to a sustainable environment.',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: ThemeColors.lightgrey,
//               ),
//             ),
//             const SizedBox(height: 30),
//             Container(
//               height: 240,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 image: const DecorationImage(
//                   image: NetworkImage(
//                       'https://img-new.cgtrader.com/items/88236/9bd3f74530/city-car-3d-model-ige-igs-iges.jpg'),
//                   fit: BoxFit.cover,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.6),
//                     blurRadius: 20,
//                     offset: Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.black.withOpacity(0.6), Colors.transparent],
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 40),

//             const Center(
//               child: Text(
//                 'Your ride awaits!',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w800,
//                   color: ThemeColors.brightWhite,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: ThemeColors.charcoalGray,
//     );
//   }
// }





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
            color: ThemeColors.brightWhite,
          ),
        ),
        backgroundColor: ThemeColors.royalPurple,
        elevation: 4,
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
                  userSocketService.initializeSocket();
                  userSocketService.connectSocket(userId);

                  await Future.delayed(Duration(seconds: 2));

                  if (userSocketService.isConnected()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RidePage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to connect to socket. Try again later.')),
                    );
                  }
                } else {
                  print('No user ID found');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.royalPurple,
                padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 29),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 8,
              ),
              child: const Text(
                'Go Ride',
                style: TextStyle(color: ThemeColors.brightWhite, fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Travel in Comfort with Electric Vehicles',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: ThemeColors.brightWhite,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Experience the future of travel with our eco-friendly electric vehicles. '
              'Enjoy a smooth and quiet ride while contributing to a sustainable environment.',
              style: TextStyle(
                fontSize: 16,
                color: ThemeColors.lightgrey,
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
                color: ThemeColors.brightWhite,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Electric vehicles (EVs) are the future of transportation. They provide a quiet, smooth ride and are environmentally friendly. '
              'With zero emissions, EVs contribute to a cleaner, healthier planet while reducing your carbon footprint. '
              'Experience the thrill of driving without the guilt of harming the environment.',
              style: TextStyle(
                fontSize: 16,
                color: ThemeColors.lightgrey,
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
                  color: ThemeColors.brightWhite,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: ThemeColors.charcoalGray,
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
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: ThemeColors.brightWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
