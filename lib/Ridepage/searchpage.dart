
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_bloc.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_event.dart';
import 'package:rideuser/Ridepage/RequestRide/bloc/ride_state.dart';
import 'dart:async';

import 'package:rideuser/core/colors.dart';

// // DestinationSearchField.dart
class DestinationSearchField extends StatefulWidget {
  final Function(double, double, String) onLocationSelected;

  const DestinationSearchField({super.key, required this.onLocationSelected});

  @override
  _DestinationSearchFieldState createState() => _DestinationSearchFieldState();
}


class _DestinationSearchFieldState extends State<DestinationSearchField> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Destination',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: ThemeColors.darkGrey),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _searchController,
          style: const TextStyle(color: ThemeColors.darkGrey),
          decoration: InputDecoration(
            hintText: 'Enter destination',
            hintStyle: const TextStyle(color: ThemeColors.lightGrey),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: ThemeColors.darkGrey),
              borderRadius: BorderRadius.circular(20),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, color: ThemeColors.darkGrey),
              onPressed: () {
                if (_searchController.text.isNotEmpty) {
                  BlocProvider.of<RideBloc>(context).add(FetchSuggestions(_searchController.text));
                }
              },
            ),
          ),
          onChanged: (text) {
            // Cancel any previous debounce timer
            if (_debounce?.isActive ?? false) _debounce!.cancel();

            // Start a new debounce timer
            if (text.isNotEmpty) {
              _debounce = Timer(const Duration(seconds: 3), () {
                BlocProvider.of<RideBloc>(context).add(FetchSuggestions(text));
              });
            }
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
                      BlocProvider.of<RideBloc>(context).add(SelectSuggestion(state.suggestions[index]));
                    },
                  );
                },
              );
            } else if (state is AddressSelected) {
              // Update the text field when the address is selected
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _searchController.text = state.address;
                widget.onLocationSelected(state.latitude, state.longitude, state.address);
              });
              return const SizedBox.shrink();
            } else if (state is DestinationError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 80, color: Colors.red),
                    const SizedBox(height: 20),
                    Text(
                      'An error occurred',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_searchController.text.isNotEmpty) {
                          BlocProvider.of<RideBloc>(context).add(FetchSuggestions(_searchController.text));
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

  @override
  void dispose() {
    _debounce?.cancel();  // Cancel the timer when the widget is disposed
    super.dispose();
  }
}
