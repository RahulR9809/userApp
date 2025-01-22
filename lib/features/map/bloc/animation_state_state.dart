part of 'animation_state_bloc.dart';

@immutable
sealed class AnimationStateState {}

final class AnimationStateInitial extends AnimationStateState {}


class AnimationState {
  final bool isAnimationComplete;

  AnimationState({required this.isAnimationComplete});

  AnimationState copyWith({bool? isAnimationComplete}) {
    return AnimationState(
      isAnimationComplete: isAnimationComplete ?? this.isAnimationComplete,
    );
  }
}

class ResetAnimation extends AnimationStateEvent {} 
