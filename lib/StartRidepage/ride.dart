import 'package:flutter/material.dart';


class RidePage extends StatefulWidget {
  const RidePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RidePageState createState() => _RidePageState();
}

class _RidePageState extends State<RidePage> {
  final TextEditingController _currentLocationController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  // Navigate to map page to select current location
  // void _selectCurrentLocation() async {
  //   final currentLocation = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => MapPage()),
  //   );

  //   if (currentLocation != null) {
  //     _currentLocationController.text = currentLocation; // Update the text field
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Booking'),
        backgroundColor: Colors.green,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade700, Colors.greenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              // onTap: _selectCurrentLocation, // Navigate to map on tap
              child: AbsorbPointer(
                child: TextField(
                  controller: _currentLocationController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    hintText: 'Enter your current location',
                    prefixIcon: const Icon(Icons.location_on, color: Colors.green),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Choose Destination',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                hintText: 'Enter your destination',
                prefixIcon: const Icon(Icons.place, color: Colors.green),
              ),
            ),
            const SizedBox(height: 20),

            // Available Vehicles Heading
            const Text(
              'Available Electric Vehicles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // List of Available Vehicles
            Expanded(
              child: ListView(
                children: const [
                  VehicleCard(
                    vehicleName: 'Electric Car',
                    imageUrl: 'https://example.com/electric_car.jpg',
                    vehicleType: 'Auto',
                  ),
                  VehicleCard(
                    vehicleName: 'Electric Bike',
                    imageUrl: '', // No image to demonstrate placeholder
                    vehicleType: 'Bike',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Rest of your VehicleCard class remains unchanged

// Custom Widget for Vehicle Card
class VehicleCard extends StatelessWidget {
  final String vehicleName;
  final String vehicleType;
  final String imageUrl;

  const VehicleCard({
    super.key,
    required this.vehicleName,
    required this.vehicleType,
    required this.imageUrl,
  });

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Ride Request'),
          content: Text('Do you want to request a ride with $vehicleName?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Add confirmation action here (e.g., navigating or processing the ride request)
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ride requested successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showConfirmDialog(context), // Show dialog on tap
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              // Vehicle Image with Placeholder
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.image, color: Colors.grey.shade600),
                          );
                        },
                      )
                    : Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.image, color: Colors.grey.shade600),
                      ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicleName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      vehicleType,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.green.shade700,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
