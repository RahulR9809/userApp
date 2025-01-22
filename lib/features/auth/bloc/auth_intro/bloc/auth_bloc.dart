
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../service/auth_controller.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService,required context}) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        if (kDebugMode) {
          print('Checking authentication status...');
        }
        final googleToken = await authService.getGoogleToken();
        final emailToken = await authService.getEmailToken();
        if (googleToken != null) {
          emit(GoogleAuthenticatedState());
        } else if (emailToken != null) {
          emit(EmailAuthenticatedState());
        } 
      } catch (e) {
        emit(ErrorState(message: 'Failed checking authentication: ${e.toString()}'));
      }
    });

    on<SubmitOTPEvent>((event, emit) async {
      emit(LoginLoading());
      if (kDebugMode) {
        print('Verifying OTP: ${event.otp}');
      }
      try {
        final token = await authService.verifyOtp(event.otp);
        if (kDebugMode) {
          print('Verification Response: $token');
        }
        if (token != null) {
          emit(EmailAuthenticatedState());
        } else {
          emit(EmailUnAuthenticatedState());
        }
      } catch (e) {
        if (kDebugMode) {
          print('Verification Error: ${e.toString()}');
        }
        emit(ErrorState(message: 'Failed verifying OTP: ${e.toString()}'));
      }
    });

 on<SigninClickedEvent>((event, emit) async {
  emit(LoginLoading());
  try {
    final response = await authService.signInWithGoogle(context);

    if (response != null && response.containsKey('accessToken')) {
      emit(GoogleAuthenticatedState(
        token: response['accessToken'],
        userData: response['data'],
      ));
    } else if (response != null && response['error'] == '403') {
      emit(AuthBlocked());
    } else if(response !=null && response['error']=='400') {
      emit(GoogleUnAuthenticatedState());
    }
  } catch (e) {
    emit(GoogleAuthError(message: 'An error occurred: ${e.toString()}'));
  }
});

  }
}
