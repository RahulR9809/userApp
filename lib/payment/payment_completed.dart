// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';
// import 'package:rideuser/Ridepage/ride.dart';

// class PaymentCompletedPage extends StatelessWidget {
//   const PaymentCompletedPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Container(),
//         title: const Text("Payment Completed"),
//         backgroundColor: Colors.green,
//       ),
//       body: BlocBuilder<RidestartBloc, RidestartState>(
//         builder: (context, state) {
//           if(State is RideCompletedState){
//                Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => StartRide(), 
//       ),
//     );
//           }
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // ✅ Payment Success Icon
//                 Icon(
//                   Icons.check_circle_outline,
//                   color: Colors.green.shade700,
//                   size: 100,
//                 ),
//                 const SizedBox(height: 20),

//                 // ✅ Payment Success Title
//                 const Text(
//                   "Payment Successful!",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 10),

//                 // ✅ Payment Description
//                 const Text(
//                   "Thank you for your payment. Your transaction has been successfully completed.",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 30),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';
import 'package:rideuser/Ridepage/ride.dart';

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
            // Navigate to StartRide page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => StartRide(),
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
              // ✅ Payment Success Icon
              Icon(
                Icons.check_circle_outline,
                color: Colors.green.shade700,
                size: 100,
              ),
              const SizedBox(height: 20),

              // ✅ Payment Success Title
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

              // ✅ Payment Description
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
