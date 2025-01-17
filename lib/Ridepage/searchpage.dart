
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_bloc.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_event.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_state.dart';
import 'dart:async';

import 'package:rideuser/core/colors.dart';
class DestinationSearchField extends StatefulWidget {
  final Function(double, double, String) onLocationSelected;

  const DestinationSearchField({super.key, required this.onLocationSelected});

  @override
  // ignore: library_private_types_in_public_api
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
        const Text(
          'Choose Destination',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: ThemeColors.darkGrey),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _searchController,
            style: const TextStyle(color: ThemeColors.darkGrey), // Set text color to white

          decoration: InputDecoration(
            hintText: 'Enter destination',hintStyle:const TextStyle(color: ThemeColors.lightGrey),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: ThemeColors.darkGrey),
              borderRadius: BorderRadius.circular(20),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search,color: ThemeColors.darkGrey,),
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
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: ThemeColors.darkGrey),
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
                    _searchController.text = state.address; 
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
              return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 80, color: Colors.red),
          const SizedBox(height: 20),
          const Text(
            'Unable to fetch destination.\nPlease check your internet connection.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: (){
                  if (_searchController.text.isNotEmpty) {
                  BlocProvider.of<RideBloc>(context)
                      .add(FetchSuggestions(_searchController.text));
                }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Retry', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
