
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/features/ride/bloc/RideStart/bloc/ridestart_bloc.dart';
import 'package:rideuser/features/ride/view/ride.dart';

class PaymentCompletedPage extends StatelessWidget {
  const PaymentCompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: const Text("Payment Completed"),
        backgroundColor: Colors.green,
      ),
      body: BlocListener<RidestartBloc, RidestartState>(
        listenWhen: (previous, current) => current is RideCompletedState,
        listener: (context, state) {
          if (state is RideCompletedState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const StartRide(),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green.shade700,
                size: 100,
              ),
              const SizedBox(height: 20),

              const Text(
                "Payment Successful!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              const Text(
                "Thank you for your payment. Your transaction has been successfully completed.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
