// import 'dart:async'; // Import for Timer
// import 'package:flutter/material.dart';
// import 'package:rideuser/controller/ride_controller.dart';

// class DestinationSearchField extends StatefulWidget {
//   const DestinationSearchField({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _DestinationSearchFieldState createState() => _DestinationSearchFieldState();
// }

// class _DestinationSearchFieldState extends State<DestinationSearchField> {
//   final TextEditingController _searchController = TextEditingController();
//   final List<String> _suggestions = [];
//   final List<String> _filteredSuggestions = [];
//   bool _isLoading = false;
//   bool _isAddressSelected = false; // Flag to track if address is selected
//   Timer? _debounce; // To manage the timer for delay

//   // Fetch suggestions using RideService
//   Future<void> _fetchSuggestions(String query) async {
//     // Don't fetch if an address is already selected or query is empty
//     if (_isAddressSelected || query.isEmpty) {
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final suggestions = await RideService().fetchPickupLocation(query);
//       setState(() {
//         _suggestions
//           ..clear()
//           ..addAll(suggestions);
//         _filteredSuggestions
//           ..clear()
//           ..addAll(suggestions);
//       });
//     } catch (error) {
//       print('Error fetching suggestions: $error');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   // This function is called on each change in the TextField
//   void _onSearchChanged(String query) {
//     // Cancel any previous timer
//     if (_debounce?.isActive ?? false) _debounce?.cancel();
    
//     // Start a new timer to delay the API call by 2 seconds
//     _debounce = Timer(const Duration(seconds: 2), () {
//       _fetchSuggestions(query); // Fetch suggestions after the delay
//     });
//   }

//   void _filterSuggestions(String query) {
//     if (query.isEmpty) {
//       setState(() {
//         _filteredSuggestions.clear();
//         _filteredSuggestions.addAll(_suggestions);
//       });
//       return;
//     }

//     setState(() {
//       _filteredSuggestions.clear();
//       _filteredSuggestions.addAll(
//         _suggestions.where(
//           (suggestion) => suggestion.toLowerCase().contains(query.toLowerCase()),
//         ),
//       );
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(() {
//       _filterSuggestions(_searchController.text);
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _debounce?.cancel(); // Cancel the timer when disposing
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 10),
//         TextField(
//           controller: _searchController, // Make sure to use this controller
//           decoration: const InputDecoration(
//             labelText: 'Choose Destination',
//             hintText: 'Enter destination',
//             prefixIcon: Icon(Icons.location_pin),
//           ),
//           onChanged: _onSearchChanged, // Call _onSearchChanged on text change
//         ),
//         if (_isLoading) const LinearProgressIndicator(),
//         if (_filteredSuggestions.isNotEmpty)
//           Container(
//             margin: const EdgeInsets.only(top: 10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: _filteredSuggestions.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(_filteredSuggestions[index]),
//                   onTap: () {
//                     // Set the selected address in the TextField
//                     _searchController.text = _filteredSuggestions[index];
//                     // Set the flag to true to stop further fetches
//                     setState(() {
//                       _isAddressSelected = true;
//                       _filteredSuggestions.clear(); // Clear the suggestions list
//                     });
//                   },
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }
// }








// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:rideuser/controller/ride_controller.dart';
// import 'package:geocoding/geocoding.dart';

// class DestinationSearchField extends StatefulWidget {
//   final Function(double, double, String) onLocationSelected;

//   const DestinationSearchField({
//     Key? key,
//     required this.onLocationSelected,
//   }) : super(key: key);

//   @override
//   _DestinationSearchFieldState createState() => _DestinationSearchFieldState();
// }

// class _DestinationSearchFieldState extends State<DestinationSearchField> {
//   final TextEditingController _searchController = TextEditingController();
//   final List<String> _suggestions = [];
//   bool _isLoading = false;
//   bool _isAddressSelected = false;
//   Timer? _debounce;

//   void _onSearchChanged(String query) {
//     if (_debounce?.isActive ?? false) _debounce?.cancel();

//     _debounce = Timer(const Duration(seconds: 3), () {
//       _fetchSuggestions(query);
//     });
//   }

//   Future<void> _fetchSuggestions(String query) async {
//     if (_isAddressSelected || query.isEmpty) {
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final suggestions = await RideService().fetchPickupLocation(query);
//       setState(() {
//         _suggestions
//           ..clear()
//           ..addAll(suggestions);
//       });
//     } catch (error) {
//       print('Error fetching suggestions: $error');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _onSuggestionSelected(String address) async {
//     try {
//       List<Location> locations = await locationFromAddress(address);
//       if (locations.isNotEmpty) {
//         Location location = locations.first;

//         widget.onLocationSelected(
//           location.latitude,
//           location.longitude,
//           address,
//         );

//         setState(() {
//           _searchController.text = address;
//           _isAddressSelected = true;
//           _suggestions.clear();
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching location details: $e')),
//       );
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(() {
//       if (!_isAddressSelected) {
//         _onSearchChanged(_searchController.text);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }

//   Widget _buildLocationInputField({
//     required String label,
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     required VoidCallback onPressed,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(height: 10),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             hintText: hint,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             suffixIcon: IconButton(
//               icon: Icon(icon),
//               onPressed: onPressed,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildLocationInputField(
//           label: 'Choose Destination',
//           controller: _searchController,
//           hint: 'Enter destination',
//           icon: Icons.search,
//           onPressed: () {
//             if (_searchController.text.isNotEmpty) {
//               _fetchSuggestions(_searchController.text);
//             }
//           },
//         ),
//         if (_isLoading) const LinearProgressIndicator(),
//         if (_suggestions.isNotEmpty)
//           Container(
//             margin: const EdgeInsets.only(top: 10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: _suggestions.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(_suggestions[index]),
//                   onTap: () => _onSuggestionSelected(_suggestions[index]),
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_bloc.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_event.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_state.dart';
import 'dart:async';

import 'package:rideuser/core/colors.dart';
class DestinationSearchField extends StatefulWidget {
  final Function(double, double, String) onLocationSelected;

  const DestinationSearchField({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  _DestinationSearchFieldState createState() => _DestinationSearchFieldState();
}

class _DestinationSearchFieldState extends State<DestinationSearchField> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel(); // Cancel debounce timer when disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Updated Label with Desired Style
        Text(
          'Choose Destination',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: ThemeColors.brightWhite),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _searchController,
            style: const TextStyle(color: ThemeColors.brightWhite), // Set text color to white

          decoration: InputDecoration(
            hintText: 'Enter destination',hintStyle:TextStyle(color: ThemeColors.lightgrey),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeColors.brightWhite),
              borderRadius: BorderRadius.circular(20),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search,color: ThemeColors.brightWhite,),
              onPressed: () {
                if (_searchController.text.isNotEmpty) {
                  BlocProvider.of<RideBloc>(context)
                      .add(FetchSuggestions(_searchController.text));
                }
              },
            ),
          ),
          onChanged: (text) {
            if (_debounce?.isActive ?? false) _debounce?.cancel();
            _debounce = Timer(const Duration(seconds: 2), () {
              if (text.isNotEmpty) {
                BlocProvider.of<RideBloc>(context).add(FetchSuggestions(text));
              }
            });
          },
        ),
        const SizedBox(height: 10),
        BlocBuilder<RideBloc, RideState>(
          builder: (context, state) {
            if (state is SuggestionsLoading) {
              return const LinearProgressIndicator();
            } else if (state is SuggestionsLoaded) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: state.suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      state.suggestions[index],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: ThemeColors.brightWhite),
                    ),
                    onTap: () {
                      BlocProvider.of<RideBloc>(context)
                          .add(SelectSuggestion(state.suggestions[index]));
                    },
                  );
                },
              );
            } else if (state is AddressSelected) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_searchController.text != state.address) {
                  setState(() {
                    _searchController.text = state.address; // Update text controller safely
                  });
                }
                widget.onLocationSelected(
                  state.latitude,
                  state.longitude,
                  state.address,
                );
              });
              return const SizedBox.shrink();
            } else if (state is DestinationError) {
              return Text(
                state.error,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.red),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
