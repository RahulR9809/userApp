import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/Ridepage/bloc/ride_bloc.dart';
import 'package:rideuser/controller/user_socket.dart';
import 'package:rideuser/customBottomNav/bloc/bottom_nav_bloc.dart';
import 'package:rideuser/mainpage/mainpage.dart';
import 'package:rideuser/profilepage/bloc/profile_bloc.dart';
import 'controller/auth_controller.dart';
import 'package:rideuser/auth_intro/auth_intro.dart';
import 'package:rideuser/auth_intro/bloc/auth_bloc.dart';
import 'package:rideuser/auth_otp/bloc/otp_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  runApp(const MyApp());


    final userSocketService = UserSocketService();

  // Connect the user
  userSocketService.connect("USER_123");

  // Disconnect after 10 seconds for testing
  Future.delayed(Duration(seconds: 10), () {
    userSocketService.disconnect();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authService: authService)..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(),
          
        ),
        BlocProvider(
          create: (context) => BottomNavBloc(),
          
        ),
        BlocProvider(create: (context) => OtpBloc(authService: authService)),
          BlocProvider(create: (context) => RideBloc()),

      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is GoogleAuthenticatedState || state is EmailAuthenticatedState){
             context.read<BottomNavBloc>().add(UpdateTab(0));
            navigatorKey.currentState?.pushReplacement(
              MaterialPageRoute(builder: (context) =>   const MainPage()),
            );
          }else if(state is LoginLoading){
            const CircularProgressIndicator();
          }
          else if (state is ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: MaterialApp(
          navigatorKey: navigatorKey,
          theme: ThemeData(primaryColor: Colors.black),
          debugShowCheckedModeBanner: false,
          home: Builder(
            builder: (context) {
              return BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is UnauthenticatedState || state is AuthInitial) {
                    return const Intropage(); 
                  }
                  return const SizedBox(); 
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
