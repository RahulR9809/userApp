// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';

// class MapPage extends StatefulWidget {
//   @override
//   _MapPageState createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   late MapboxMapController mapController;
//   Position? currentLocation;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Location services are disabled. Please enable them.'),
//       ));
//       return;
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission != LocationPermission.whileInUse &&
//           permission != LocationPermission.always) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Location permission denied. Please enable it.'),
//         ));
//         return;
//       }
//     }

//     currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     if (currentLocation != null) {
//       mapController.animateCamera(CameraUpdate.newLatLng(
//         LatLng(currentLocation!.latitude, currentLocation!.longitude),
//       ));
//     }
//   }

//   void _onMapCreated(MapboxMapController controller) {
//     mapController = controller;
//     if (currentLocation != null) {
//       mapController.animateCamera(CameraUpdate.newLatLng(
//         LatLng(currentLocation!.latitude, currentLocation!.longitude),
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mapbox Map'),
//       ),
//       body: MapboxMap(
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(
//           target: LatLng(9.9312, 76.2673), // Default to Kochi, adjust as needed
//           zoom: 12.0,
//         ),
//         styleString: "mapbox://styles/rahul9809/cm31gvpde00wq01o0euf4ew5o", // You can change the style here
//       ),
//     );
//   }
// }
