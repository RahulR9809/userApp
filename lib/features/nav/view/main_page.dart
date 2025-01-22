import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/features/nav/bloc/bottom_nav_bloc.dart';
import 'package:rideuser/features/nav/view/nav_page.dart';
import 'package:rideuser/features/ride/view/ride.dart';
import 'package:rideuser/features/profile/view/profile.dart';
import 'package:rideuser/features/ride/view/ride_details.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _pages = [
    const StartRide(),        
    const TripDetailPage(),
    const UserProfilePage(),   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          int currentIndex = 0; 
          if (state is BottomNavigationState) {
            currentIndex = state.selectedIndex;
          }
          return IndexedStack(
            index: currentIndex,
            children: _pages,
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(), 
    );
  }
}
