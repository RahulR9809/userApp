
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:rideuser/features/auth/views/auth_email.dart';
import 'package:rideuser/features/auth/bloc/auth_intro/bloc/auth_bloc.dart';
import 'package:rideuser/core/colors.dart';
import 'package:rideuser/features/nav/view/main_page.dart';
import 'package:rideuser/widgets/auth_widgets.dart';
import 'package:rideuser/widgets/ride_completed_widget.dart';

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
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is GoogleAuthenticatedState ||
              state is EmailAuthenticatedState) {
            ReachedDialog.showLocationReachedDialog(
              context,
              text: 'Welcome back! You have successfully logged in.',
              title: 'Login Successful!',
              type: QuickAlertType.success,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
            );
          } else if (state is UnauthenticatedState) {
            ReachedDialog.showLocationReachedDialog(context,
                text: 'Wrong email or password.',
                title: 'Error',
                type: QuickAlertType.warning);
          } else if (state is AuthBlocked) {
            ReachedDialog.showLocationReachedDialog(context,
                text: 'Your account has been blocked. Please contact support',
                title: 'Access Denied!',
                type: QuickAlertType.error);
          } else if (state is GoogleAuthError) {
            ReachedDialog.showLocationReachedDialog(context,
                text: 'The request could not be processed. Please try again.',
                title: 'Bad Request!!',
                type: QuickAlertType.error);
          }
        },
        builder: (context, state) {
          return Padding(
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
                        MaterialPageRoute(
                            builder: (context) => const AuthEmail()),
                      );
                    },
                    buttonColor: ThemeColors.green,
                    textColor: ThemeColors.white,
                    borderColor: null,
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
          );
        },
      ),
    );
  }
}
