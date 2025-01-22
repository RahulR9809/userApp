
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:rideuser/features/map/bloc/animation_state_bloc.dart';
import 'package:rideuser/widgets/ride_completed_widget.dart';
import 'package:rideuser/widgets/ride_widget.dart';

class MapboxWidget extends StatelessWidget {
  const MapboxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
     
        children: [
          TileLayer(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ",
            additionalOptions: const {
              'access_token':
                  'pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ',
            },
          ),
        ],
      ),
    );
  }
}


class MapboxLoading extends StatelessWidget {
  const MapboxLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          children: [
            TileLayer(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ",
              additionalOptions: const {
                'access_token':
                    'pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ',
              },
            ),
          ],
        ),
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5), 
            child: const Center(
              child: LoadingScreenDialog(),
            ),
          ),
        ),
      ],
    );
  }
}






class MapboxPicupSimulation extends StatefulWidget {
  final LatLng startPoint;
  final LatLng endPoint;

  const MapboxPicupSimulation({
    required this.startPoint,
    required this.endPoint,
    super.key,
  });

  @override
  State<MapboxPicupSimulation> createState() => _MapboxPicupSimulationState();
}

class _MapboxPicupSimulationState extends State<MapboxPicupSimulation>
    with SingleTickerProviderStateMixin {
  static const String accessToken =
      'pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ';

  late MapboxMapController mapController;
  late List<LatLng> routeCoordinates;
  late Symbol startSymbol;
  Line? routeLine;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _loadCustomIcons();
    _simulateRoute();
  }

  Future<void> _loadCustomIcons() async {
    try {
      final ByteData startIconData = await rootBundle.load('assets/start.png');
      final ByteData endIconData = await rootBundle.load('assets/end.png');

      final Uint8List startIconBytes = startIconData.buffer.asUint8List();
      final Uint8List endIconBytes = endIconData.buffer.asUint8List();

      await mapController.addImage("start_icon", startIconBytes);
      await mapController.addImage("end_icon", endIconBytes);

      mapController.addSymbol(SymbolOptions(
        geometry: widget.endPoint,
        iconImage: "end_icon",
        iconSize: 0.15,
      ));
    } catch (e) {
      debugPrint("Error loading custom icons: $e");
    }
  }

  Future<void> _simulateRoute() async {
    routeCoordinates =
        await _getRouteCoordinates(widget.startPoint, widget.endPoint) ?? [];

    if (routeCoordinates.isNotEmpty) {
      routeLine = await mapController.addLine(LineOptions(
        geometry: routeCoordinates,
        lineColor: "#0015ff",
        lineWidth: 5.0,
      ));

      startSymbol = await mapController.addSymbol(SymbolOptions(
        geometry: widget.startPoint,
        iconImage: "start_icon",
        iconSize: 0.10,
      ));

      await Future.delayed(const Duration(seconds: 8));
      _animateSymbolAlongRoute();
    }
  }

  Future<List<LatLng>?> _getRouteCoordinates(LatLng start, LatLng end) async {
    final url =
        'https://api.mapbox.com/directions/v5/mapbox/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson&access_token=$accessToken';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final coordinates =
            data['routes'][0]['geometry']['coordinates'] as List;
        return coordinates
            .map((coord) => LatLng(coord[1], coord[0]))
            .toList();
      } else {
        debugPrint('Failed to fetch route: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching route: $e');
    }
    return null;
  }

  List<LatLng> _interpolatePoints(LatLng start, LatLng end, int steps) {
    List<LatLng> interpolatedPoints = [];
    for (int i = 0; i <= steps; i++) {
      double lat = start.latitude + (end.latitude - start.latitude) * i / steps;
      double lng =
          start.longitude + (end.longitude - start.longitude) * i / steps;
      interpolatedPoints.add(LatLng(lat, lng));
    }
    return interpolatedPoints;
  }

  void _animateSymbolAlongRoute() async {
    const totalDuration = 30;
    final steps = routeCoordinates.length - 1;
    final stepDuration = totalDuration / steps;
    const interpolationSteps = 50;

    if (routeLine != null) {
      await mapController
          .updateLine(routeLine!, LineOptions(geometry: routeCoordinates));
    }

    for (int i = 0; i < steps; i++) {
      LatLng start = routeCoordinates[i];
      LatLng end = routeCoordinates[i + 1];

      List<LatLng> interpolatedPoints =
          _interpolatePoints(start, end, interpolationSteps);

      for (LatLng currentPosition in interpolatedPoints) {
        await mapController.updateSymbol(
            startSymbol, SymbolOptions(geometry: currentPosition));

        List<LatLng> updatedRoute = [
          currentPosition,
          ...routeCoordinates.sublist(i + 1)
        ];
        await mapController
            .updateLine(routeLine!, LineOptions(geometry: updatedRoute));

        await Future.delayed(
            Duration(milliseconds: (stepDuration * 1000 / interpolationSteps).toInt()));
      }
    }

    _triggerReachedAnimation();
  }

  void _triggerReachedAnimation() {
    ReachedDialog.showLocationReachedDialog(context,text:'Your driver is now at your location. Please be ready to begin your ride.',title: 'Driver Has Reached Your Location',type: QuickAlertType.success);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapboxMap(
        accessToken: accessToken,
        initialCameraPosition: CameraPosition(
          target: widget.startPoint,
          zoom: 14,
        ),
        onMapCreated: _onMapCreated,
        styleString: MapboxStyles.MAPBOX_STREETS,
      ),
    );
  }
}




class MapboxDropSimulation extends StatefulWidget {
  final LatLng startPoint;
  final LatLng endPoint;

  const MapboxDropSimulation({
    required this.startPoint,
    required this.endPoint,
    super.key,
  });

  @override
  State<MapboxDropSimulation> createState() => _MapboxDropSimulationState();
}

class _MapboxDropSimulationState extends State<MapboxDropSimulation>
    with SingleTickerProviderStateMixin {
  static const String accessToken =
      'pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ';

  late MapboxMapController mapController;
  late List<LatLng> routeCoordinates;
  late Symbol startSymbol;
  Line? routeLine;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _loadCustomIcons();
    _simulateRoute();
  }

  Future<void> _loadCustomIcons() async {
    try {
      final ByteData startIconData = await rootBundle.load('assets/start.png');
      final ByteData endIconData = await rootBundle.load('assets/end.png');

      final Uint8List startIconBytes = startIconData.buffer.asUint8List();
      final Uint8List endIconBytes = endIconData.buffer.asUint8List();

      await mapController.addImage("start_icon", startIconBytes);
      await mapController.addImage("end_icon", endIconBytes);

      mapController.addSymbol(SymbolOptions(
        geometry: widget.endPoint,
        iconImage: "end_icon",
        iconSize: 0.15,
      ));
    } catch (e) {
      debugPrint("Error loading custom icons: $e");
    }
  }

  Future<void> _simulateRoute() async {
    routeCoordinates =
        await _getRouteCoordinates(widget.startPoint, widget.endPoint) ?? [];

    if (routeCoordinates.isNotEmpty) {
      routeLine = await mapController.addLine(LineOptions(
        geometry: routeCoordinates,
        lineColor: "#0015ff",
        lineWidth: 5.0,
      ));

      startSymbol = await mapController.addSymbol(SymbolOptions(
        geometry: widget.startPoint,
        iconImage: "start_icon",
        iconSize: 0.10,
      ));

      await Future.delayed(const Duration(seconds: 8));
      _animateSymbolAlongRoute();
    }
  }

  Future<List<LatLng>?> _getRouteCoordinates(LatLng start, LatLng end) async {
    final url =
        'https://api.mapbox.com/directions/v5/mapbox/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson&access_token=$accessToken';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final coordinates =
            data['routes'][0]['geometry']['coordinates'] as List;
        return coordinates
            .map((coord) => LatLng(coord[1], coord[0]))
            .toList();
      } else {
        debugPrint('Failed to fetch route: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching route: $e');
    }
    return null;
  }

  List<LatLng> _interpolatePoints(LatLng start, LatLng end, int steps) {
    List<LatLng> interpolatedPoints = [];
    for (int i = 0; i <= steps; i++) {
      double lat = start.latitude + (end.latitude - start.latitude) * i / steps;
      double lng =
          start.longitude + (end.longitude - start.longitude) * i / steps;
      interpolatedPoints.add(LatLng(lat, lng));
    }
    return interpolatedPoints;
  }

  void _animateSymbolAlongRoute() async {
    const totalDuration = 30;
    final steps = routeCoordinates.length - 1;
    final stepDuration = totalDuration / steps;
    const interpolationSteps = 50;

    if (routeLine != null) {
      await mapController
          .updateLine(routeLine!, LineOptions(geometry: routeCoordinates));
    }

    for (int i = 0; i < steps; i++) {
      LatLng start = routeCoordinates[i];
      LatLng end = routeCoordinates[i + 1];

      List<LatLng> interpolatedPoints =
          _interpolatePoints(start, end, interpolationSteps);

      for (LatLng currentPosition in interpolatedPoints) {
        await mapController.updateSymbol(
            startSymbol, SymbolOptions(geometry: currentPosition));

        List<LatLng> updatedRoute = [
          currentPosition,
          ...routeCoordinates.sublist(i + 1)
        ];
        await mapController
            .updateLine(routeLine!, LineOptions(geometry: updatedRoute));

        await Future.delayed(
            Duration(milliseconds: (stepDuration * 1000 / interpolationSteps).toInt()));
      }
    }

    _triggerReachedAnimation();
  }

  void _triggerReachedAnimation() {

    ReachedDialog.showLocationReachedDialog(context,title: 'Location Reached!',text: 'You have arrived at your destination.',type: QuickAlertType.success,onConfirm: (){
            context.read<AnimationStateBloc>().add(AnimationCompleted());

    });
 

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapboxMap(
        accessToken: accessToken,
        initialCameraPosition: CameraPosition(
          target: widget.startPoint,
          zoom: 14,
        ),
        onMapCreated: _onMapCreated,
        styleString: MapboxStyles.MAPBOX_STREETS,
      ),
    );
  }
}



