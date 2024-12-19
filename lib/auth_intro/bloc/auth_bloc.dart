// import 'package:bloc/bloc.dart';
// import 'package:flutter/foundation.dart';
// import '../../controller/auth_controller.dart';

// part 'auth_event.dart';
// part 'auth_state.dart';
// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final AuthService authService;

//   AuthBloc({required this.authService}) : super(AuthInitial()) {
  
//    on<CheckAuthStatusEvent>((event, emit) async {
//       emit(LoginLoading());
//       try {
//         final googleToken = await authService.getGoogleToken();
//         final emailToken = await authService.getEmailToken();
//         if (googleToken != null) {
//           emit(GoogleAuthenticatedState());
//         } else if (emailToken != null) {
//           emit(EmailAuthenticatedState());
//         } else {
//           emit(UnauthenticatedState());
//         }
//       } catch (e) {
//         emit(ErrorState(message: 'Failed checking authentication: ${e.toString()}'));
//       }
//     });

// on<SubmitOTPEvent>((event, emit) async {
//   emit(LoginLoading());
//   if (kDebugMode) {
//     print('Verifying OTP: ${event.otp}');
//   } // Log entered OTP
//   try {
//     final token = await authService.verifyOtp(event.otp);
//     if (kDebugMode) {
//       print('Verification Response: $token');
//     } // Log response from backend

//     if (token != null) {
//       emit(EmailAuthenticatedState());
//     } else {
//       emit(EmailUnAuthenticatedState());
//     }
//   } catch (e) {
//     if (kDebugMode) {
//       print('Verification Error: ${e.toString()}');
//     } // Log any errors
//     emit(ErrorState(message: 'Failed verifying OTP: ${e.toString()}'));
//   }
// });


// on<SigninClickedEvent>((event, emit) async {
//   emit(LoginLoading());

//   try {
//     final token = await authService.signInWithGoogle();
//     //  if (token == '403') {
//     //      AuthBlocked();
//     //   } else if (token != null) {
//     //     emit(GoogleAuthenticatedState());
//     //   } else {
//     //   emit(GoogleUnAuthenticatedState());

//     //   }

//     if (token != null) {
//       emit(GoogleAuthenticatedState());
//     } else {
//       emit(GoogleUnAuthenticatedState());
//     }
//   } catch (e) {
//     emit(ErrorState(message: 'An error occurred: ${e.toString()}'));
//   }
// });
//   }}


import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../controller/auth_controller.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        print('Checking authentication status...');
        final googleToken = await authService.getGoogleToken();
        final emailToken = await authService.getEmailToken();
        if (googleToken != null) {
          emit(GoogleAuthenticatedState());
        } else if (emailToken != null) {
          emit(EmailAuthenticatedState());
        } else {
          emit(UnauthenticatedState());
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
        print('Attempting Google sign-in...');
        final token = await authService.signInWithGoogle();
        if (token != null) {
          emit(GoogleAuthenticatedState());
        } else {
          emit(GoogleUnAuthenticatedState());
        }
      } catch (e) {
        emit(ErrorState(message: 'An error occurred: ${e.toString()}'));
      }
    });
  }
}
