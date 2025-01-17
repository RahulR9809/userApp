// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';
// import 'package:rideuser/controller/user_socket.dart';
//    UserSocketService socketService=UserSocketService();

// class PaymentPage extends StatelessWidget {
//   const PaymentPage({super.key, });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => RidestartBloc(socketService),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Payment Page'),
//         ),
//         body: BlocConsumer<RidestartBloc, RidestartState>(
//           listener: (context, state) {
//             if (state is PaymentSuccess) {
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                     title: const Text('Payment Successful'),
//                     content: Text('Response: ${state.response}'),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: const Text('OK'),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             } else if (state is PaymentFailure) {
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                     title: const Text('Payment Failed'),
//                     content: Text('Error: ${state.error}'),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: const Text('OK'),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             }
//           },
//           builder: (context, state) {
//             if (state is PaymentLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             return Column(
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     final ridestartBloc = BlocProvider.of<RidestartBloc>(context);
//                     ridestartBloc.add(MakePaymentEvent(
//                       paymentMethod: 'Online-Payment',
//                       fare: 90,
//                     ));
//                   },
//                   child: const Text('confirm payment'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     final ridestartBloc = BlocProvider.of<RidestartBloc>(context);
//                     ridestartBloc.add(CreateCheckoutSessionEvent(
//                       fare: 100,
//                     ));
//                   },
//                   child: const Text('Checkout'),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }





// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:rideuser/controller/payment_controller.dart';

// class PaymentPage extends StatelessWidget {
//   final PaymentController paymentController = PaymentController();

//   PaymentPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Payment Page'),
//       ),
//       body: BlocConsumer<RidestartBloc, RidestartState>(
//         listener: (context, state) {
//           if (state is PaymentSuccess) {
//             showDialog(
//               context: context,
//               builder: (context) => AlertDialog(
//                 title: const Text('Payment Successful'),
//                 content: Text('Response: ${state.response}'),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('OK'),
//                   ),
//                 ],
//               ),
//             );
//           } else if (state is PaymentFailure) {
//             showDialog(
//               context: context,
//               builder: (context) => AlertDialog(
//                 title: const Text('Payment Failed'),
//                 content: Text('Error: ${state.error}'),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('OK'),
//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is CheckoutLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
    
//           return Column(
//             children: [
//               ElevatedButton(
//                 onPressed: () async {
//                final ridestartBloc = BlocProvider.of<RidestartBloc>(context);
//                     ridestartBloc.add(CreateCheckoutSessionEvent(
//                       fare: 100,
//                     ));
//                         SharedPreferences pref = await SharedPreferences.getInstance();
                         
//     final checkouturl=pref.getString('paymentUrl');
//                   if (checkouturl != null) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => WebViewScreen(checkoutUrl: checkouturl),
//                       ),
//                     );
//                   }
//                 },
//                 child: const Text('Checkout'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   final ridestartBloc = BlocProvider.of<RidestartBloc>(context);
//                   ridestartBloc.add(MakePaymentEvent(
//                     paymentMethod: 'Online-Payment',
//                     fare: 100,
//                   ));
//                 },
//                 child: const Text('Confirm Payment'),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }



// class WebViewScreen extends StatefulWidget {
//   final String checkoutUrl;

//   const WebViewScreen({Key? key, required this.checkoutUrl}) : super(key: key);

//   @override
//   State<WebViewScreen> createState() => _WebViewScreenState();
// }

// class _WebViewScreenState extends State<WebViewScreen> {
//   late final WebViewController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(NavigationDelegate(
//         onPageStarted: (String url) {
//           // Detect success URL
//           if (url.contains('payment-success')) {
//             String sessionId = Uri.parse(url).queryParameters['session_id'] ?? '';
//             _handlePaymentSuccess(sessionId);
//           }
//           // Detect cancel URL
//           if (url.contains('payment-failure')) {
//             _handlePaymentFailure();
//           }
//         },
//       ))
//       ..loadRequest(Uri.parse(widget.checkoutUrl));
//   }

//   void _handlePaymentSuccess(String sessionId) {
//     // Dispatch the MakePaymentEvent after successful payment
//     BlocProvider.of<RidestartBloc>(context).add(MakePaymentEvent(
//       paymentMethod: 'Online-Payment',
//       fare: 100,
//     ));

//     // Close the WebView and show success dialog
//     Navigator.pop(context);
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Payment Successful'),
//         content: Text('Session ID: $sessionId'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _handlePaymentFailure() {
//     // Close the WebView and show failure dialog
//     Navigator.pop(context);
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Payment Failed'),
//         content: const Text('Your payment was not completed.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.clearCache(); // Clear cache before disposing
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Stripe Checkout'),
//       ),
//       body: WebViewWidget(controller: _controller),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/Ridepage/RideStart/bloc/ridestart_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:rideuser/controller/payment_controller.dart';

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

          return Column(
            children: [
              // ElevatedButton(
              //   onPressed: () async {
              //     final ridestartBloc = BlocProvider.of<RidestartBloc>(context);
              //     ridestartBloc.add(CreateCheckoutSessionEvent(
              //       fare: 100,
              //     ));
              //     SharedPreferences pref = await SharedPreferences.getInstance();
              //     final checkouturl = pref.getString('paymentUrl');
              //     print("Checkout URL: $checkouturl"); // Debugging line

              //     if (checkouturl != null) {
              //       Future.delayed(Duration(seconds: 5));
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => WebViewScreen(checkoutUrl: checkouturl),
              //         ),
              //       );
              //     }
              //   },
              //   child: const Text('Checkout'),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     final ridestartBloc = BlocProvider.of<RidestartBloc>(context);
              //     ridestartBloc.add(MakePaymentEvent(
              //       paymentMethod: 'Online-Payment',
              //       fare: 100,
              //     ));
              //   },
              //   child: const Text('Confirm Payment'),
              // ),
            ],
          );
        },
      ),
    );
  }
}
