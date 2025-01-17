// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rideuser/customBottomNav/bloc/bottom_nav_bloc.dart';

// class CustomBottomNavBar extends StatelessWidget {
//   const CustomBottomNavBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<BottomNavBloc, BottomNavState>(
//       builder: (context, state) {
//         int currentIndex = 0; // Default index to home
//         if (state is BottomNavigationState) {
//           currentIndex = state.selectedIndex;
//         } else if (state is BottomNavInitial) {
//           currentIndex = 0; // Initial state
//         }
//         return BottomNavigationBar(
//           items: const <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: '',
//               backgroundColor: Colors.amber,
//             ),
//             // BottomNavigationBarItem(
//             //   icon: Icon(Icons.directions_car),
//             //   label: '',
//             // ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person),
//               label: '',
//             ),
//           ],
//           currentIndex: currentIndex, // Use the resolved index
//           onTap: (index) {
//             context.read<BottomNavBloc>().add(UpdateTab(index)); // Update tab
//           },
//           showSelectedLabels: false,
//           showUnselectedLabels: false,
//         );
//       },
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideuser/customBottomNav/bloc/bottom_nav_bloc.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBloc, BottomNavState>(
      builder: (context, state) {
        int currentIndex = 0; // Default index to home
        if (state is BottomNavigationState) {
          currentIndex = state.selectedIndex;
        } else if (state is BottomNavInitial) {
          currentIndex = 0; // Initial state
        }
        return BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
              backgroundColor: Colors.amber,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            ),
          ],
          currentIndex: currentIndex, // Use the resolved index
          onTap: (index) {
            context.read<BottomNavBloc>().add(UpdateTab(index)); // Update tab
          },
          showSelectedLabels: false,
          showUnselectedLabels: false,
        );
      },
    );
  }
}
