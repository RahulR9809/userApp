
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/features/ride/bloc/RideStart/bloc/ridestart_bloc.dart';
import 'package:rideuser/features/payment/service/payment_controller.dart';

class PaymentPage extends StatelessWidget {
  final PaymentController paymentController = PaymentController();

  PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
        leading: Container(),
      ),
      body: BlocConsumer<RidestartBloc, RidestartState>(
        listener: (context, state) {
          if (state is PaymentSuccess) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Payment Successful'),
                content: Text('Response: ${state.response}'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else if (state is PaymentFailure) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Payment Failed'),
                content: Text('Error: ${state.error}'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CheckoutLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return const Column(
            children: [
            
            ],
          );
        },
      ),
    );
  }
}
