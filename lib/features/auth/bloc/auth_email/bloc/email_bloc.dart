import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import '../../../service/auth_controller.dart';

part 'email_event.dart';
part 'email_state.dart';

class EmailBloc extends Bloc<EmailEvent, EmailState> {
  final AuthService authService;
  EmailBloc({required this.authService}) : super(EmailInitial()) {
   on<SendOTpButtonClickedEvent>((event, emit) async{
     emit(LoadingState());
     try{
     await authService.getOTP(
      event.email
     );
     emit(LoadedState());
     }catch(e){
      emit(ErrorState(message: 'no email found'));
     } 
   },);
  }
}
