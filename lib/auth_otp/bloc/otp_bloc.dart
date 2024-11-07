
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import '../../controller/auth_controller.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final AuthService authService;
  OtpBloc({required this.authService}) : super(OtpInitial()) {
   on<ResendOtPEvent>((event, emit)async {
     emit(LoadingState());
     try{
      
await authService.getOTP(event.email);
emit(LoadedState());
     }catch(e){
   emit(OtpErrorState(message: 'failed to send otp'));
     }
   },);


  }
}
