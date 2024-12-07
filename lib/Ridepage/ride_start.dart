import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class RideStart extends StatelessWidget {
  final MapController _mapController = MapController();

   RideStart({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(),
        children: [
          TileLayer(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ",
            additionalOptions: const {
              'accessToken':
                  'pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ',
            },
          ),
        ],
      ),
    );
  }
}
