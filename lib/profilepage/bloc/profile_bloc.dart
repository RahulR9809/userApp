
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:rideuser/controller/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
   on<LoadProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final name = prefs.getString('name');
        final email = prefs.getString('email'); 
        final phone = prefs.getString('phone'); 
        
        emit(ProfileLoaded(name: name ?? 'No Name Available', email: email ?? 'No Email Available',phone:phone??'1234567890' ));
      } catch (error) {
        emit(ProfileError(message: 'Failed to load profile: $error'));
      }
    });

  on<UpdateProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
               
        final result = await ProfileService().updateProfile(event.profileimage,event.name, event.email, event.phone);
        if (result != null) {
        
        emit(ProfileLoaded(name: event.name , email: event.email ,phone:event.phone ));

        } else {
          emit(ProfileError(message: 'Failed to update profile'));
        }
      } catch (e) {
        emit(ProfileError(message: 'Error updating profile: $e'));
      }
    });
  }
}