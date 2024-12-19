// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rideuser/auth_email/auth_email.dart';
// import 'package:rideuser/auth_intro/bloc/auth_bloc.dart';
// import 'package:rideuser/widgets/auth_widgets.dart';

// class Intropage extends StatelessWidget {
//   const Intropage({super.key});
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F4F6), // Soft gray background for a classic look
//       appBar: const ElectraAppBar(title: 'Electra',),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//               // Add space for the image
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.15),
//                       blurRadius: 5,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 clipBehavior: Clip.antiAlias,
//                 child: Image.asset(
//                   'assets/Man track taxi driver cab on tablet map.jpg',
//                   height: 250,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               const Text(
//                 'Welcome to Electra!',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF003366), // Same navy as AppBar for coherence
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Let\'s get started',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF00509E), // Soft blue for accent
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Everything starts from here.',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.black54,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 30),
//               // Auth buttons
//               authbutton(context, 'Email', () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const AuthEmail()));
//               }),
//               const SizedBox(height: 20),
//               authbutton(
//                 context,
//                 'Sign Up with Google',
//                 () {
//                   BlocProvider.of<AuthBloc>(context)
//                       .add(SigninClickedEvent());
//                 },
//                 imagePath: 'assets/google.png', // Optional Google image path
//               ),
//               const SizedBox(height: 50),
//               const Text(
//                 'Join us for a seamless journey!',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.black54,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/auth_email/auth_email.dart';
import 'package:rideuser/auth_intro/bloc/auth_bloc.dart';
import 'package:rideuser/core/colors.dart';
import 'package:rideuser/widgets/auth_widgets.dart';

class Intropage extends StatelessWidget {
  const Intropage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.lightWhite,
      appBar: AppBar(
        title: const Text(
          'Electra',
          style: TextStyle(
            color: ThemeColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: ThemeColors.green,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Image Section
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeColors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/Man track taxi driver cab on tablet map.jpg',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 30),
              // Welcome Text
              const Text(
                'Welcome to Electra!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Let\'s get started',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: ThemeColors.darkGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Everything starts from here.',
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // Buttons
              authbutton(
                context,
                'Login with Email',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthEmail()),
                  );
                },
                buttonColor: ThemeColors.green,
                textColor: ThemeColors.white, borderColor: null,
              ),
              const SizedBox(height: 20),
              authbutton(
                context,
                'Sign Up with Google',
                () {
                  BlocProvider.of<AuthBloc>(context)
                      .add(SigninClickedEvent());
                },
                imagePath: 'assets/google.png',
                buttonColor: ThemeColors.white,
                textColor: ThemeColors.black,
                borderColor: ThemeColors.lightGrey,
              ),
              const SizedBox(height: 50),
              const Text(
                'Join us for a seamless journey!',
                style: TextStyle(
                  fontSize: 14,
                  color: ThemeColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
