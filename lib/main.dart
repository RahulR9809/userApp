
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/features/ride/bloc/RequestRide/bloc/ride_bloc.dart';
import 'package:rideuser/features/ride/bloc/RideStart/bloc/ridestart_bloc.dart';
import 'package:rideuser/features/chat/bloc/chat_bloc.dart';
import 'package:rideuser/features/chat/service/chat_usersoketcontroller.dart';
import 'package:rideuser/features/auth/service/user_socket.dart';
import 'package:rideuser/features/nav/bloc/bottom_nav_bloc.dart';
import 'package:rideuser/features/nav/view/main_page.dart';
import 'package:rideuser/features/map/bloc/animation_state_bloc.dart';
import 'package:rideuser/features/payment/bloc/profile_bloc.dart';
import 'features/auth/service/auth_controller.dart';
import 'package:rideuser/features/auth/views/auth_intro.dart';
import 'package:rideuser/features/auth/bloc/auth_intro/bloc/auth_bloc.dart';
import 'package:rideuser/features/auth/bloc/auth_otp/bloc/otp_bloc.dart';

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
              AuthBloc(authService: authService, context: context)
                ..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(create: (context) => ProfileBloc()),
        BlocProvider(create: (context) => BottomNavBloc()),
        BlocProvider(create: (context) => OtpBloc(authService: authService)),
        BlocProvider(create: (context) => RideBloc()),
        BlocProvider(create: (context) => RidestartBloc(socketService)),
        BlocProvider(create: (context) => ChatBloc()),
        BlocProvider(create: (context) => AnimationStateBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is GoogleAuthenticatedState ||
                state is EmailAuthenticatedState) {
              context.read<BottomNavBloc>().add(UpdateTab(0));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainPage()),
              );
            }
          },
          child: const Intropage(),
        ),
      ),
    );
  }
}
