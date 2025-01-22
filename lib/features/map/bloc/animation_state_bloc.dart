import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'animation_state_event.dart';
part 'animation_state_state.dart';


class AnimationStateBloc extends Bloc<AnimationStateEvent, AnimationState> {
  AnimationStateBloc() : super(AnimationState(isAnimationComplete: false)) {
    on<AnimationCompleted>(_onAnimationCompleted);
    on<ResetAnimation>(_onResetAnimation);
  }

  void _onAnimationCompleted(AnimationCompleted event, Emitter<AnimationState> emit) {
    emit(state.copyWith(isAnimationComplete: true));
  }

  void _onResetAnimation(ResetAnimation event, Emitter<AnimationState> emit) {
    emit(state.copyWith(isAnimationComplete: false)); 
  }
}
