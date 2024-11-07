part of 'bottom_nav_bloc.dart';

@immutable
sealed class BottomNavEvent {}


class UpdateTab extends BottomNavEvent {
  final int newIndex;

  UpdateTab(this.newIndex);
}