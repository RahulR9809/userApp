import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'animation_state_event.dart';
part 'animation_state_state.dart';


class AnimationStateBloc extends Bloc<AnimationStateEvent, AnimationState> {
  AnimationStateBloc() : super(AnimationState(isAnimationComplete: false)) {
    on<AnimationCompleted>(_onAnimationCompleted);
    on<ResetAnimation>(_onResetAnimation);
  }

  // Separate method to handle the AnimationCompleted event
  void _onAnimationCompleted(AnimationCompleted event, Emitter<AnimationState> emit) {
    print('AnimationCompleted event received');
    emit(state.copyWith(isAnimationComplete: true));
    print('Animation completed: ${state.isAnimationComplete}');
  }

  // Separate method to handle the ResetAnimation event
  void _onResetAnimation(ResetAnimation event, Emitter<AnimationState> emit) {
    print('ResetAnimation event received');
    emit(state.copyWith(isAnimationComplete: false)); // Reset to false
    print('Animation reset: ${state.isAnimationComplete}');
  }
}
