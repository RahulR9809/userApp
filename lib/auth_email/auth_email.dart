import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/auth_controller.dart';
import 'package:rideuser/auth_email/bloc/email_bloc.dart';
import 'package:rideuser/auth_otp/auth_otp.dart';
import 'package:rideuser/widgets/auth_widgets.dart';

final TextEditingController emailController = TextEditingController();

class AuthEmail extends StatelessWidget {
  const AuthEmail({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      appBar: const ElectraAppBar(title: 'Email Verification'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: BlocProvider(
          create: (context) => EmailBloc(authService: authService),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Rounded image section with soft shadow and padding
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[50],
                      borderRadius: BorderRadius.circular(80),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/email.jpg',
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // Enhanced title with sleek, modern styling
                const Text(
                  'Verify Your Email',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF003366),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Clear, concise description with relaxed line spacing
                const Text(
                  'Enter your email to receive a verification code. This helps us keep your account secure.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 48),

                // Custom Email TextField with icon and rounded borders
                buildTextField(
                  hintText: 'Email Address',
                  controller: emailController,
                  prefixIcon: const Icon(Icons.email, color: Colors.deepPurple),
                
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    const pattern =
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                    final regex = RegExp(pattern);
                    if (!regex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 36),

                // Bloc Consumer for loading and button with modern style
                BlocConsumer<EmailBloc, EmailState>(
                  listener: (context, state) {
                    if (state is LoadedState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('OTP sent for email verification!'),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OtpPage(),
                        ),
                      );
                    } else if (state is ErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Error: ${state.message}',
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is LoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: authbutton(
                        context,
                        'Send Verification Code',
                        () {
                          final email = emailController.text.trim();
                          debugPrint('Email to be sent: $email');
                          BlocProvider.of<EmailBloc>(context).add(
                            SendOTpButtonClickedEvent(email: email),
                          );
                        },
                     
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
