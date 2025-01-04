
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';


class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
      ),
      body: BlocConsumer<RidestartBloc, RidestartState>(
        listener: (context, state) {
          if (state is PaymentSuccess) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Payment Successful'),
                  content: Text('Response: ${state.response}'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else if (state is PaymentFailure) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Payment Failed'),
                  content: Text('Error: ${state.error}'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        builder: (context, state) {
          if (state is PaymentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: ElevatedButton(
              onPressed: () {
                final ridestartBloc = BlocProvider.of<RidestartBloc>(context);

                ridestartBloc.add(MakePaymentEvent(
                 
                  paymentMethod: 'Online-Payment',
                  fare: 100,
                ));
              },
              child: const Text('Make Payment'),
            ),
          );
        },
      ),
    );
  }
}
