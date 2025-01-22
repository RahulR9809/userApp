
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/features/ride/bloc/RideStart/bloc/ridestart_bloc.dart';
import 'package:rideuser/features/payment/payment_completed.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Paymentdetails extends StatefulWidget {
  final Map<String, dynamic>? rideData;

  const Paymentdetails({super.key, this.rideData});

  @override
  State<Paymentdetails> createState() => _PaymentdetailsState();
}

class _PaymentdetailsState extends State<Paymentdetails> {
  @override
  Widget build(BuildContext context) {
    final rideData = widget.rideData ?? {};
    final fare = rideData['fare'] ?? 0.0;
    final distance = rideData['distance'] ?? 0;
    final pickUpLocation = rideData['pickUpLocation'] ?? 'Not available';
    final dropOffLocation = rideData['dropOffLocation'] ?? 'Not available';
    final paymentStatus = rideData['isPaymentComplete'] ?? false;

    const gstPercentage = 18.0;
    final gstAmount = (fare * gstPercentage) / 100;
    final totalAmount = fare + gstAmount;
    final String maxAmount = totalAmount.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay here'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ride Invoice',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Trip Details'),
            const SizedBox(height: 10),
            _buildDetailsRowAligned('Pick-Up Location:', pickUpLocation),
            _buildDetailsRowAligned('Drop-Off Location:', dropOffLocation),
            const SizedBox(height: 20),
            const Divider(),

            _buildSectionTitle('Fare Breakdown'),
            const SizedBox(height: 10),
            _buildDetailsRow('Fare:', '\$${fare.toStringAsFixed(2)}'),
            _buildDetailsRow('Distance:', '$distance km'),
            const SizedBox(height: 20),
            const Divider(),

            _buildSectionTitle('GST Breakdown'),
            const SizedBox(height: 10),
            _buildDetailsRow(
                'GST (${gstPercentage.toStringAsFixed(0)}%):', '\$${gstAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 20),
            const Divider(),

            _buildSectionTitle('Total Amount'),
            const SizedBox(height: 10),
            _buildDetailsRow(
              'Total Amount:',
              '\$${totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final ridestartBloc = BlocProvider.of<RidestartBloc>(context);
                ridestartBloc.add(CreateCheckoutSessionEvent(
                  fare: '100',
                ));
                SharedPreferences pref = await SharedPreferences.getInstance();
                final checkouturl = pref.getString('paymentUrl');
                if (kDebugMode) {
                  print("Checkout URL: $checkouturl");
                } 

                if (checkouturl != null) {
                  Future.delayed(const Duration(seconds: 5));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WebViewScreen(checkoutUrl: checkouturl, fare: maxAmount),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: paymentStatus ? Colors.green : Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                paymentStatus ? 'Payment Completed' : 'Proceed to Pay',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
      ),
    );
  }

  Widget _buildDetailsRow(String label, String value, {TextStyle? style}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: style ??
                const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsRowAligned(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}









class WebViewScreen extends StatefulWidget {
  final String checkoutUrl;
  final String fare;

  const WebViewScreen({super.key, required this.checkoutUrl, required this.fare});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url != widget.checkoutUrl) {
              _showPaymentDialog(success: request.url.contains('payment-success'));
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate; 
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  void _showPaymentDialog({required bool success}) {
    Navigator.pop(context); // Close the WebView
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text( 'Payment Successful'),
        content: const Text(
            'Your payment was successful!'
           ),
        actions: [
          TextButton(
            onPressed: () {
                 Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const PaymentCompletedPage(), 
      ),
    );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Checkout'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}



