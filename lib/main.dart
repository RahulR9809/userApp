// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rideuser/Ridepage/RequestRide/bloc/ride_bloc.dart';
// import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';
// import 'package:rideuser/chat/bloc/chat_bloc.dart';
// import 'package:rideuser/controller/bloc/socket_state.dart';
// import 'package:rideuser/controller/chat_usercontroller.dart';
// import 'package:rideuser/controller/user_socket.dart';
// import 'package:rideuser/customBottomNav/bloc/bottom_nav_bloc.dart';
// import 'package:rideuser/mainpage/mainpage.dart';
// import 'package:rideuser/profilepage/bloc/profile_bloc.dart';
// import 'controller/auth_controller.dart';
// import 'package:rideuser/auth_intro/auth_intro.dart';
// import 'package:rideuser/auth_intro/bloc/auth_bloc.dart';
// import 'package:rideuser/auth_otp/bloc/otp_bloc.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// void main() async {
//   WidgetsFlutterBinding
//       .ensureInitialized(); 
// UserChatSocketService userChatSocketService=UserChatSocketService();
//   UserSocketService userSocketService = UserSocketService();
//   userSocketService.initializeSocket();
//   userChatSocketService.initializeChatSocket();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     AuthService authService = AuthService();
//    UserSocketService socketService=UserSocketService();

//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) =>
//               AuthBloc(authService: authService)..add(CheckAuthStatusEvent()),
//         ),
//         BlocProvider(
//           create: (context) => ProfileBloc(),
//         ),
//         BlocProvider(
//           create: (context) => BottomNavBloc(),
//         ),
//         BlocProvider(create: (context) => OtpBloc(authService: authService)),
//         BlocProvider(create: (context) => RideBloc()),
//         BlocProvider(create: (context) => RidestartBloc(socketService),),
//                 BlocProvider(create: (context) => ChatBloc()),

//       ],
//       child: 
//       BlocListener<AuthBloc, AuthState>(
//         listener: (context, state) async {
//           if (state is GoogleAuthenticatedState ||
//               state is EmailAuthenticatedState) {
//             context.read<BottomNavBloc>().add(UpdateTab(0));
//             navigatorKey.currentState?.pushReplacement(
//               MaterialPageRoute(builder: (context) => const MainPage()),
//             );
//           } else if (state is LoginLoading) {
//             const CircularProgressIndicator();
//           } else if (state is ErrorState) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Error: ${state.message}')),
//             );
//           } else if (state is AuthBlocked) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                   content: Text('Blocked by admin')), // Show the snackbar here
//             );
//           }
//         },
//         child: MaterialApp(
//           navigatorKey: navigatorKey,
//           debugShowCheckedModeBanner: false,
//           home: Builder(
//             builder: (context) {
//               return BlocBuilder<AuthBloc, AuthState>(
//                 builder: (context, state) {
//                   if (state is UnauthenticatedState || state is AuthInitial) {
//                     return const Intropage();
//                   }
//                   return const SizedBox();
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rideuser/Ridepage/RequestRide/bloc/ride_bloc.dart';
// import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';
// import 'package:rideuser/chat/bloc/chat_bloc.dart';
// import 'package:rideuser/controller/chat_usersoketcontroller.dart';
// import 'package:rideuser/controller/user_socket.dart';
// import 'package:rideuser/customBottomNav/bloc/bottom_nav_bloc.dart';
// import 'package:rideuser/mainpage/mainpage.dart';
// import 'package:rideuser/profilepage/bloc/profile_bloc.dart';
// import 'controller/auth_controller.dart';
// import 'package:rideuser/auth_intro/auth_intro.dart';
// import 'package:rideuser/auth_intro/bloc/auth_bloc.dart';
// import 'package:rideuser/auth_otp/bloc/otp_bloc.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized(); 
//   UserChatSocketService userChatSocketService = UserChatSocketService();
//   UserSocketService userSocketService = UserSocketService();
//   ChatBloc _chatBloc=ChatBloc();

//   // Initialize sockets
//   userSocketService.initializeSocket();
//   userChatSocketService.initializeChatSocket();
  
//   runApp(const MyApp());
// }
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     AuthService authService = AuthService();
//     UserSocketService socketService = UserSocketService();

//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) =>
//               AuthBloc(authService: authService, context: context)..add(CheckAuthStatusEvent()),
//         ),
//         BlocProvider(create: (context) => ProfileBloc()),
//         BlocProvider(create: (context) => BottomNavBloc()),
//         BlocProvider(create: (context) => OtpBloc(authService: authService)),
//         BlocProvider(create: (context) => RideBloc()),
//         BlocProvider(create: (context) => RidestartBloc(socketService)),
//         BlocProvider(create: (context) => ChatBloc()),
//       ],
//       child: BlocListener<AuthBloc, AuthState>(
//         listener: (context, state) async {
//           print('Current Auth State: $state');
          
//           if (state is GoogleAuthenticatedState || state is EmailAuthenticatedState) {
//             context.read<BottomNavBloc>().add(UpdateTab(0));
//             print('Navigating to MainPage...');
//             navigatorKey.currentState?.pushReplacement(
//               MaterialPageRoute(builder: (context) => const MainPage()),
//             );
//           } else if (state is LoginLoading) {
//             print('Login is in progress...');
//             // Optionally, show a loading spinner here if needed
//           } 
//         },
//         child: MaterialApp(
//           navigatorKey: navigatorKey,
//           debugShowCheckedModeBanner: false,
//           home: Builder(
//             builder: (context) {
//               return BlocBuilder<AuthBloc, AuthState>(
//                 builder: (context, state) {
//                   print('AuthBloc State: $state');
                  
//                   if (state is LoginLoading) {
//                     // Show a loading spinner when login is in progress
//                     return const Scaffold(
//                       body: Center(child: CircularProgressIndicator()),
//                     );
//                   } else if (state is GoogleUnAuthenticatedState || state is UnauthenticatedState) {
//                     // If not authenticated, show the intro page or login page
//                     return const Intropage();
//                   } else if (state is AuthInitial) {
//                     return const Intropage();
//                   }
//                   return const SizedBox();
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_bloc.dart';
import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';
import 'package:rideuser/chat/bloc/chat_bloc.dart';
import 'package:rideuser/controller/chat_usersoketcontroller.dart';
import 'package:rideuser/controller/user_socket.dart';
import 'package:rideuser/customBottomNav/bloc/bottom_nav_bloc.dart';
import 'package:rideuser/mainpage/mainpage.dart';
import 'package:rideuser/profilepage/bloc/profile_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'controller/auth_controller.dart';
import 'package:rideuser/auth_intro/auth_intro.dart';
import 'package:rideuser/auth_intro/bloc/auth_bloc.dart';
import 'package:rideuser/auth_otp/bloc/otp_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserChatSocketService userChatSocketService = UserChatSocketService();
  UserSocketService userSocketService = UserSocketService();
  
  userSocketService.initializeSocket();
  userChatSocketService.initializeChatSocket();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    UserSocketService socketService = UserSocketService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthBloc(authService: authService, context: context)..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(create: (context) => ProfileBloc()),
        BlocProvider(create: (context) => BottomNavBloc()),
        BlocProvider(create: (context) => OtpBloc(authService: authService)),
        BlocProvider(create: (context) => RideBloc()),
        BlocProvider(create: (context) => RidestartBloc(socketService)),
        BlocProvider(create: (context) => ChatBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: Builder(
        //   builder: (context) {
        //     return BlocBuilder<AuthBloc, AuthState>(
        //       builder: (context, state) {
        //         // Navigate to MainPage if authenticated
        //         if (state is GoogleAuthenticatedState || state is EmailAuthenticatedState) {
        //           WidgetsBinding.instance.addPostFrameCallback((_) {
        //             context.read<BottomNavBloc>().add(UpdateTab(0));
        //             Navigator.pushReplacement(
        //               context,
        //               MaterialPageRoute(builder: (context) => MainPage()),
        //             );
        //           });
        //           return const SizedBox();
        //         }

        //         // Return IntroPage by default
        //         return const Intropage();
        //       },
        //     );
        //   },
        // ),


        home: BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is GoogleAuthenticatedState || state is EmailAuthenticatedState) {
      context.read<BottomNavBloc>().add(UpdateTab(0));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    }
  },
  child: const Intropage(),
),

      ),
    );
  }
}
