
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rideuser/auth_intro/auth_intro.dart';
import 'package:rideuser/core/colors.dart';
import 'package:rideuser/profilepage/bloc/profile_bloc.dart';
import 'package:rideuser/widgets/ride_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}
 final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
class _UserProfilePageState extends State<UserProfilePage> {
  XFile? profileImage;

  @override
  void initState() {
    super.initState();
    loadProfileImage();
  }

  Future<void> loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profileimage');
    if (imagePath != null && imagePath.isNotEmpty) {
      setState(() {
        profileImage = XFile(imagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<ProfileBloc>().add(LoadProfileEvent());

    final size = MediaQuery.of(context).size;
    return Scaffold(
       key: _scaffoldKey, 
      appBar: AppBar(
        title: const Text('User Profile'),
        centerTitle: true,
        backgroundColor: ThemeColors.green, // Use green
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () async {
            _scaffoldKey.currentState?.openDrawer(); // Correct way to open the drawer
          },
        ),
        
        actions: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                return IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showEditProfileDialog(
                        context, state.name!, state.email!, state.phone!);
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
          drawer: Drawer(
  child: Column(
    children: <Widget>[
      // Drawer Header
      
      const Divider(), // Divider between the header and other items

      // Menu Items
      ListTile(
        leading: const Icon(Icons.home, color: ThemeColors.green),
        title: const Text('Home'),
        onTap: () {
          // Handle home navigation
        },
      ),
      ListTile(
        leading: const Icon(Icons.settings, color: ThemeColors.green),
        title: const Text('Settings'),
        onTap: () {
          // Handle settings navigation
        },
      ),
      ListTile(
        leading: const Icon(Icons.history, color: ThemeColors.green),
        title: const Text('Ride History'),
        onTap: () {
          // Handle ride history navigation
        },
      ),
      const Divider(),

      // Logout Button
  ListTile(
  leading: const Icon(Icons.exit_to_app, color: Colors.red),
  title: const Text('Logout', style: TextStyle(color: Colors.red)),
  onTap: () async {
    DialogHelper.showCustomDialog(
      context: context,
      title: 'Logout',
      content: 'Click OK to logout from this application.',
      primaryButtonText: 'OK',
      secondaryButtonText: 'Cancel',
      onPrimaryButtonPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const Intropage()),
        );
      },
      onSecondaryButtonPressed: () {
        // Do nothing, just close the dialog
        Navigator.of(context).pop();
      },
    );
  },
),

    ],
  ),
),


      body: Padding(
        padding: EdgeInsets.all(size.width * 0.05),
        child: Column(
          children: [
            CircleAvatar(
              radius: size.width * 0.15,
              backgroundColor: Colors.grey[300],
              backgroundImage: profileImage != null
                  ? FileImage(File(profileImage!.path))
                  : null,
              child: profileImage == null
                  ? const Icon(Icons.camera_alt, size: 50, color: ThemeColors.green) // Use green
                  : null,
            ),
            const SizedBox(height: 20),
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProfileLoaded) {
                  return buildProfileInfo(context, state.name!, state.email!,
                      state.phone ?? 'no phone found');
                } else if (state is ProfileError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('No profile data found.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileInfo(
      BuildContext context, String name, String email, String phone) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.01,
        horizontal: size.width * 0.04,
      ),
      decoration: BoxDecoration(
        color: ThemeColors.lightWhite, // Use brightWhite
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Column(
        children: [
          buildProfileTile(Icons.person, 'Name', name),
          buildProfileTile(Icons.email, 'Email', email),
          buildProfileTile(Icons.phone, 'Phone', phone),
        ],
      ),
    );
  }

  Widget buildProfileTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ListTile(
        leading: Icon(icon, color: ThemeColors.green), // Use royalPurple
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }

  void showEditProfileDialog(
      BuildContext context, String name, String email, String phone) {
    final TextEditingController nameController =
        TextEditingController(text: name);
    final TextEditingController emailController =
        TextEditingController(text: email);
    final TextEditingController phoneController =
        TextEditingController(text: phone);

    XFile? localProfileImage = profileImage;

    Future<void> pickImage(Function setDialogState) async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          profileImage = pickedFile;
          localProfileImage = pickedFile;
        });
        setDialogState(() {}); // Rebuild the dialog to reflect the new image
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: const Text('Edit Profile'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => pickImage(setDialogState), // Pass the setDialogState function
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: localProfileImage != null
                          ? FileImage(File(localProfileImage!.path))
                          : const AssetImage('assets/default_avatar.png')
                              as ImageProvider,
                      child: localProfileImage == null
                          ? const Icon(Icons.camera_alt, size: 40, color: ThemeColors.green) // Use royalPurple
                          : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    final id = prefs.getString('userid');

                    if (id != null) {
                      // ignore: use_build_context_synchronously
                      BlocProvider.of<ProfileBloc>(context).add(
                        UpdateProfileEvent(
                          id: id,
                          name: nameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                          profileimage: profileImage!,
                        ),
                      );

                      await prefs.setString('profileimage', profileImage!.path);
                      await prefs.setString('name', nameController.text);
                      await prefs.setString('email', emailController.text);
                      await prefs.setString('phone', phoneController.text);
                    }

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
  
}
