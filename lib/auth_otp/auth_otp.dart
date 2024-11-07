import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/auth_email/auth_email.dart';
import 'package:rideuser/auth_intro/bloc/auth_bloc.dart';
import 'package:rideuser/auth_otp/bloc/otp_bloc.dart';
import 'package:rideuser/widgets/auth_widgets.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  // Controllers for OTP input fields
  final TextEditingController firstDigitController = TextEditingController();
  final TextEditingController secondDigitController = TextEditingController();
  final TextEditingController thirdDigitController = TextEditingController();
  final TextEditingController fourthDigitController = TextEditingController();

  // Focus nodes to control focus between fields
  final FocusNode firstFocusNode = FocusNode();
  final FocusNode secondFocusNode = FocusNode();
  final FocusNode thirdFocusNode = FocusNode();
  final FocusNode fourthFocusNode = FocusNode();

  @override
  void dispose() {
    // Dispose controllers and focus nodes to free up resources
    firstDigitController.dispose();
    secondDigitController.dispose();
    thirdDigitController.dispose();
    fourthDigitController.dispose();
    firstFocusNode.dispose();
    secondFocusNode.dispose();
    thirdFocusNode.dispose();
    fourthFocusNode.dispose();
    super.dispose();
  }

  // Method to validate OTP fields
  void _validateAndSubmitOTP(BuildContext context) {
    final otp = firstDigitController.text +
        secondDigitController.text +
        thirdDigitController.text +
        fourthDigitController.text;

    if (otp.length == 4 && otp.runes.every((c) => c >= 48 && c <= 57)) {
      // If OTP has 4 digits and each is a number, proceed with submission
      BlocProvider.of<AuthBloc>(context).add(SubmitOTPEvent(otp: otp));
    } else {
      // Show error message if fields are incomplete or not numbers
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a complete 4-digit OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ElectraAppBar(title: 'OTP'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header image for OTP screen
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              height: 120,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/email.jpg'), // Add image asset here
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Verify OTP',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003366),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Enter the 4-digit code sent to your email',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF00509E),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Row for OTP input fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildOtpTextField(firstDigitController, firstFocusNode,
                    secondFocusNode, context),
                buildOtpTextField(secondDigitController, secondFocusNode,
                    thirdFocusNode, context),
                buildOtpTextField(thirdDigitController, thirdFocusNode,
                    fourthFocusNode, context),
                buildOtpTextField(
                    fourthDigitController, fourthFocusNode, null, context),
              ],
            ),
            const SizedBox(height: 30),

            // Resend and Confirm buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    final email = emailController.text;
                    BlocProvider.of<OtpBloc>(context).add(
                      ResendOtPEvent(email: email),
                    );
                  },
                  child: const Text(
                    'Resend',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if(state is EmailAuthenticatedState){
                      ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logged successfull')),
          );
                    }else if(state is ErrorState){
                          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('wrong otp')),
          );
                    }
                  },
                  builder: (context, state) {
                    return ReusableButton(
                      text: 'Confirm',
                      onPressed: () => _validateAndSubmitOTP(context),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for building OTP input fields with focus management and refined styling
  Widget buildOtpTextField(TextEditingController controller,
      FocusNode focusNode, FocusNode? nextFocusNode, BuildContext context) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1, // Limit to one digit
        decoration: InputDecoration(
          counterText: '', // Hide counter
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.6)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          filled: true,
          fillColor: Colors.purple.withOpacity(0.2),
          hintText: '•',
          hintStyle:
              TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 20),
        ),
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        focusNode: focusNode,
        onChanged: (value) {
          if (value.isNotEmpty && nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
      ),
    );
  }
}
