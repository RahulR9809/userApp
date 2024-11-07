part of 'bottom_nav_bloc.dart';

sealed class BottomNavState {}

final class BottomNavInitial extends BottomNavState { final int selectedIndex = 0;}

class BottomNavigationState extends BottomNavState{
    final int selectedIndex;

  BottomNavigationState({required this.selectedIndex});

}