// import 'dart:ui' as ui;
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:animated_floating_buttons/animated_floating_buttons.dart';
// import 'package:rideuser/Ridepage/RequestRide/bloc/ride_bloc.dart';
// import 'package:rideuser/Ridepage/RequestRide/bloc/ride_event.dart';

// class MapPage extends StatefulWidget {
//   const MapPage({Key? key}) : super(key: key);

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   late MapboxMapController _mapController;
//   LatLng? _selectedLocation;
//   String _selectedAddress = 'Selected Location';
//   LatLng? _currentLocation;
//   String _currentAddress = 'Fetching current location...';

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   // Method to get the current location and address
//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.bestForNavigation,
//       );
//       _currentLocation = LatLng(position.latitude, position.longitude);

//       _mapController.animateCamera(
//         CameraUpdate.newLatLngZoom(_currentLocation!, 14),
//       );

//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );

//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
//         _currentAddress =
//             "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
//       }

//       // Dispatch the location to the BLoC
//       context.read<RideBloc>().add(
//         FetchLocation(
//           latitude: position.latitude,
//           longitude: position.longitude,
//           address: _currentAddress,
//         ),
//       );

//       final Uint8List markerImage = await _createIconMarker(
//         icon: Icons.location_on,
//         color: Colors.red,
//         size: 100,
//       );

//       _mapController.clearSymbols();
//       _mapController.addImage('current_location_icon', markerImage);
//       _mapController.addSymbol(
//         SymbolOptions(
//           geometry: _currentLocation!,
//           iconImage: 'current_location_icon',
//           iconSize: 2.0,
//         ),
//       );

//       setState(() {});
//     } catch (e) {
//       print("Error getting location: $e");
//     }
//   }

//   // Method to create a custom marker icon
//   Future<Uint8List> _createIconMarker({
//     required IconData icon,
//     required Color color,
//     required double size,
//   }) async {
//     final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
//     final Canvas canvas = Canvas(pictureRecorder);
//     final Paint paint = Paint()..color = color;

//     TextPainter textPainter = TextPainter(
//       textDirection: TextDirection.ltr,
//       textAlign: TextAlign.center,
//     );

//     textPainter.text = TextSpan(
//       text: String.fromCharCode(icon.codePoint),
//       style: TextStyle(
//         fontSize: size,
//         fontFamily: icon.fontFamily,
//         color: color,
//       ),
//     );

//     textPainter.layout();
//     textPainter.paint(canvas, Offset(0, 0));

//     final ui.Image image = await pictureRecorder
//         .endRecording()
//         .toImage(size.toInt(), size.toInt());
//     final ByteData? byteData =
//         await image.toByteData(format: ui.ImageByteFormat.png);
//     return byteData!.buffer.asUint8List();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Select Location'),
//         backgroundColor: Colors.green,
//       ),
//       body: Stack(
//         children: [
//           MapboxMap(
//             accessToken: 'pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ',
//             initialCameraPosition: const CameraPosition(
//               target: LatLng(9.938034, 76.321803),
//               zoom: 14,
//             ),
//             onMapCreated: (controller) {
//               _mapController = controller;
//             },
//             onMapClick: (point, latLng) async {
//               _selectedLocation = latLng;

//               List<Placemark> placemarks = await placemarkFromCoordinates(
//                 latLng.latitude,
//                 latLng.longitude,
//               );

//               if (placemarks.isNotEmpty) {
//                 Placemark place = placemarks.first;
//                 _selectedAddress =
//                     "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
//               }

//               context.read<RideBloc>().add(
//                 FetchLocation(
//                   latitude: latLng.latitude,
//                   longitude: latLng.longitude,
//                   address: _selectedAddress,
//                 ),
//               );

//               final Uint8List markerImage = await _createIconMarker(
//                 icon: Icons.location_on,
//                 color: Colors.red,
//                 size: 100,
//               );

//               _mapController.clearSymbols();
//               _mapController.addImage('selected_location_icon', markerImage);
//               _mapController.addSymbol(
//                 SymbolOptions(
//                   geometry: latLng,
//                   iconImage: 'selected_location_icon',
//                   iconSize: 2.0,
//                 ),
//               );

//               setState(() {});
//             },
//           ),
//           Positioned(
//             bottom: 30,
//             right: 20,
//             child: AnimatedFloatingActionButton(
//               animatedIconData: AnimatedIcons.menu_close,
//               fabButtons: <Widget>[
//                 FloatingActionButton(
//                   heroTag: 'current_location',
//                   backgroundColor: Colors.blue,
//                   onPressed: () {
//                     _getCurrentLocation();
//                   },
//                   child: const Icon(Icons.my_location, color: Colors.white),
//                 ),
//                 FloatingActionButton(
//                   heroTag: 'confirm_location',
//                   backgroundColor: Colors.green,
//                   onPressed: () {
//                     if (_selectedLocation != null) {
//                       Navigator.pop(context, {
//                         'latitude': _selectedLocation!.latitude,
//                         'longitude': _selectedLocation!.longitude,
//                         'address': _selectedAddress,
//                       });
//                     } else {
//                       print("No location selected.");
//                     }
//                   },
//                   child: const Icon(Icons.check, color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_bloc.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_event.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapboxMapController _mapController;
  LatLng? _selectedLocation;
  String _selectedAddress = 'Selected Location';
  LatLng? _currentLocation;
  String _currentAddress = 'Fetching current location...';

  @override
  void initState() {
    super.initState();
  }

  // Method to request location permission
  Future<bool> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  // Method to get the current location and address
  Future<void> _getCurrentLocation() async {
    bool hasPermission = await _requestLocationPermission();
    if (!hasPermission) {
      print("Location permission denied");
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      _currentLocation = LatLng(position.latitude, position.longitude);

      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 14),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        _currentAddress =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }

      // Dispatch the location to the BLoC
      context.read<RideBloc>().add(
            FetchLocation(
              latitude: position.latitude,
              longitude: position.longitude,
              address: _currentAddress,
            ),
          );

      final Uint8List markerImage = await _createIconMarker(
        icon: Icons.location_on,
        color: Colors.red,
        size: 100,
      );

      _mapController.clearSymbols();
      _mapController.addImage('current_location_icon', markerImage);
      _mapController.addSymbol(
        SymbolOptions(
          geometry: _currentLocation!,
          iconImage: 'current_location_icon',
          iconSize: 2.0,
        ),
      );

      setState(() {});
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  // Method to create a custom marker icon
  Future<Uint8List> _createIconMarker({
    required IconData icon,
    required Color color,
    required double size,
  }) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = color;

    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: size,
        fontFamily: icon.fontFamily,
        color: color,
      ),
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset(0, 0));

    final ui.Image image = await pictureRecorder
        .endRecording()
        .toImage(size.toInt(), size.toInt());
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          MapboxMap(
            accessToken:
                'pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ',
            initialCameraPosition: const CameraPosition(
              target: LatLng(9.938034, 76.321803),
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
         onMapClick: (point, latLng) async {
  _selectedLocation = latLng;

  List<Placemark> placemarks = await placemarkFromCoordinates(
    latLng.latitude,
    latLng.longitude,
  );

  if (placemarks.isNotEmpty) {
    Placemark place = placemarks.first;
    _selectedAddress =
        "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
  }

  // Dispatch the location to the BLoC
  context.read<RideBloc>().add(
    FetchLocation(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      address: _selectedAddress,
    ),
  );

  final Uint8List markerImage = await _createIconMarker(
    icon: Icons.location_on,
    color: Colors.red,
    size: 100,
  );

  _mapController.clearSymbols();
  _mapController.addImage('selected_location_icon', markerImage);
  _mapController.addSymbol(
    SymbolOptions(
      geometry: latLng,
      iconImage: 'selected_location_icon',
      iconSize: 2.0,
    ),
  );

  setState(() {}); // Trigger rebuild to update UI
},

          ),
          Positioned(
            bottom: 30,
            right: 20,
            child: AnimatedFloatingActionButton(
              animatedIconData: AnimatedIcons.menu_close,
              fabButtons: <Widget>[
                FloatingActionButton(
                  heroTag: 'current_location',
                  backgroundColor: Colors.blue,
                  onPressed: () async {
                    await _getCurrentLocation();

                    if (_currentLocation != null) {
                      // Animate the camera to the current location with smooth transition
                      _mapController.animateCamera(
                        CameraUpdate.newLatLngZoom(_currentLocation!,
                            14), // You can adjust the zoom level if needed
                      );
                    }
                  },
                  child: const Icon(Icons.my_location, color: Colors.white),
                ),
              FloatingActionButton(
  heroTag: 'confirm_location',
  backgroundColor: Colors.green,
  onPressed: () {
    if (_currentLocation != null) {
      // Dispatch UpdateCurrentLocation event for current location
      context.read<RideBloc>().add(
        UpdateCurrentLocation(
          latitude: _currentLocation!.latitude,
          longitude: _currentLocation!.longitude,
          address: _currentAddress,
        ),
      );
    } else if (_selectedLocation != null) {
      // Dispatch UpdateCurrentLocation event for selected location
      context.read<RideBloc>().add(
        UpdateCurrentLocation(
          latitude: _selectedLocation!.latitude,
          longitude: _selectedLocation!.longitude,
          address: _selectedAddress,
        ),
      );
    } else {
      print("No location selected.");
    }

    Navigator.pop(context); // Return to the RidePage
  },
  child: const Icon(Icons.check, color: Colors.white),
),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
