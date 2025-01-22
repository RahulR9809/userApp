
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/features/auth/views/auth_email.dart';
import 'package:rideuser/features/auth/bloc/auth_intro/bloc/auth_bloc.dart';
import 'package:rideuser/features/auth/bloc/auth_otp/bloc/otp_bloc.dart';
import 'package:rideuser/core/colors.dart';
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

  final FocusNode firstFocusNode = FocusNode();
  final FocusNode secondFocusNode = FocusNode();
  final FocusNode thirdFocusNode = FocusNode();
  final FocusNode fourthFocusNode = FocusNode();

  @override
  void dispose() {
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

  void _validateAndSubmitOTP(BuildContext context) {
    final otp = firstDigitController.text +
        secondDigitController.text +
        thirdDigitController.text +
        fourthDigitController.text;

    if (otp.length == 4 && otp.runes.every((c) => c >= 48 && c <= 57)) {
      BlocProvider.of<AuthBloc>(context).add(SubmitOTPEvent(otp: otp));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a complete 4-digit OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OTP',
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
      backgroundColor: ThemeColors.lightWhite,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              height: 120,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/email.jpg'), 
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
                color: ThemeColors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Enter the 4-digit code sent to your email',
              style: TextStyle(
                fontSize: 16,
                color: ThemeColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

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
                      color: ThemeColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is EmailAuthenticatedState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logged in successfully')),
                      );
                    } else if (state is ErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Wrong OTP')),
                      );
                    }
                  },
                  builder: (context, state) {
                    return ReusableButton(
                      color: ThemeColors.green,
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

  Widget buildOtpTextField(TextEditingController controller,
      FocusNode focusNode, FocusNode? nextFocusNode, BuildContext context) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '', 
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: ThemeColors.black.withOpacity(0.8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: ThemeColors.black.withOpacity(0.6)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: ThemeColors.black, width: 2),
          ),
          filled: true,
          fillColor: ThemeColors.black.withOpacity(0.2),
          hintText: '',
          hintStyle:
              TextStyle(color: ThemeColors.black.withOpacity(0.6), fontSize: 20),
        ),
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: ThemeColors.black),
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
