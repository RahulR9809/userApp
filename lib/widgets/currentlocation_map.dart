import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:animated_floating_buttons/animated_floating_buttons.dart';

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
    _getCurrentLocation();
  }

  // Method to get the current location and address
  Future<void> _getCurrentLocation() async {
    try {
      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      _currentLocation = LatLng(position.latitude, position.longitude);

      // Animate the camera to the current location
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 14),
      );

      // Get the address from the coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        _currentAddress =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }

      // Convert the icon to an image
      final Uint8List markerImage = await _createIconMarker(
        icon: Icons.location_on,
        color: Colors.red,
        size: 100,
      );

      // Add the marker to the map
      _mapController.clearSymbols();
      _mapController.addImage('current_location_icon', markerImage);
      _mapController.addSymbol(SymbolOptions(
        geometry: _currentLocation!,
        iconImage: 'current_location_icon',
        iconSize: 2.0,
      ));

      // Debug: Print the current location and address
      print("Current Location: $_currentLocation");
      print("Current Address: $_currentAddress");

      // Update the UI
      setState(() {});
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  // Helper method to convert a Flutter icon to a bitmap
  Future<Uint8List> _createIconMarker({
    required IconData icon,
    required Color color,
    required double size,
  }) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = color;

    // Draw the icon
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

    // Convert to image
    final ui.Image image = await pictureRecorder
        .endRecording()
        .toImage(size.toInt(), size.toInt());
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
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
            accessToken: 'pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ',
            initialCameraPosition: const CameraPosition(
              target: LatLng(9.938034, 76.321803),
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onMapClick: (point, latLng) async {
              setState(() {
                _selectedLocation = latLng;
              });

              List<Placemark> placemarks = await placemarkFromCoordinates(
                latLng.latitude,
                latLng.longitude,
              );
              if (placemarks.isNotEmpty) {
                Placemark place = placemarks.first;
                setState(() {
                  _selectedAddress =
                      "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
                });
              }

              final Uint8List markerImage = await _createIconMarker(
                icon: Icons.location_on,
                color: Colors.red,
                size: 100,
              );

              _mapController.clearSymbols();
              _mapController.addImage('selected_location_icon', markerImage);
              _mapController.addSymbol(SymbolOptions(
                geometry: latLng,
                iconImage: 'selected_location_icon',
                iconSize: 2.0,
              ));

              // Debug: Print the selected location data
              print("Selected Location: $_selectedLocation");
              print("Selected Address: $_selectedAddress");
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
                    print("Button Click: Current Location");
                  },
                  child: const Icon(Icons.my_location, color: Colors.white),
                ),
                SizedBox(height: 5),
                FloatingActionButton(
                  heroTag: 'confirm_location',
                  backgroundColor: Colors.green,
                  onPressed: () {
                    if (_selectedLocation != null) {
                      print("Confirm Button Clicked");
                      print("Final Selected Location: $_selectedLocation");
                      print("Final Selected Address: $_selectedAddress");

                      Navigator.pop(context, {
                        'latitude': _selectedLocation!.latitude,
                        'longitude': _selectedLocation!.longitude,
                        'address': _selectedAddress,
                      });
                    } else {
                      print("No location selected.");
                    }
                  },
                  child: const Icon(Icons.check, color: Colors.white),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
