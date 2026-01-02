import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mail_messanger/core/app_state_manager.dart';
import 'package:mail_messanger/core/common/widget/primary_button.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/core/routes/route_name.dart';
import 'package:mail_messanger/core/utils/app_logger.dart';
import 'package:mail_messanger/core/utils/common_utils.dart';
import 'package:mail_messanger/core/utils/phone_hash_utils.dart';
import 'package:mail_messanger/features/profile/domain/entities/app_user.dart';
import 'package:mail_messanger/features/profile/presentation/provider/profile_image_provider.dart';
import 'package:mail_messanger/features/profile/presentation/provider/user_provder.dart';
import 'package:provider/provider.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const .all(16),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Text(
                "Profile info",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: ColorConstants.primaryColor,
                  fontFamily: 'LuckiestGuy',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Please provide your name and an optional\nprofile photo.",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: ColorConstants.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Profile avatar
              Consumer<ProfileImageProvider>(
                builder: (context, imageProvider, _) => GestureDetector(
                  onTap: () async {
                    try {
                      await imageProvider.pickProfileImage();
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color.fromARGB(255, 50, 47, 82),
                    backgroundImage: imageProvider.selectedImage != null
                        ? FileImage(imageProvider.selectedImage!)
                        : null,
                    child: imageProvider.selectedImage == null
                        ? Icon(
                            Ionicons.camera_outline,
                            size: 40,
                            color: Colors.blue.shade900,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 50),

              // Inputfield - name
              TextField(
                controller: _nameController,
                cursorColor: ColorConstants.primary,
                cursorHeight: 22,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: ColorConstants.textfieldFillColor,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorConstants.textfieldBorderColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorConstants.textfieldBorderColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorConstants.primaryColor),
                  ),
                  hintText: "Enter your name",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: ColorConstants.white,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
              const Spacer(),
              Consumer<UserProvder>(
                builder: (context, userProvider, _) => PrimaryBtnWidget(
                  progress: 1,
                  label: "Create Profile",
                  onTap: () async {
                    debugPrint("Create Profile button tapped");

                    final imageProvider = context.read<ProfileImageProvider>();

                    final name = _nameController.text.trim();

                    if (name.isNotEmpty) {
                      try {
                        // Upload image if user select one
                        String? imageUrl;

                        if (imageProvider.selectedImage != null) {
                          imageUrl = await imageProvider.uploadProfileImage();
                        }

                        AppLogger.i(imageUrl);

                        // App user model
                        final firebaseUser = FirebaseAuth.instance.currentUser;

                        if (firebaseUser == null) {
                          AppLogger.e("User not authenticated");
                          throw Exception('User not authenticated');
                        }

                        // User model
                        final user = AppUser(
                          uid: firebaseUser.uid,
                          phone: firebaseUser.phoneNumber ?? '',
                          phoneHash: PhoneHashUtils.hash(
                            firebaseUser.phoneNumber!,
                          ),
                          name: _nameController.text.trim(),
                          photoUrl: imageUrl,
                        );

                        // await userProvider.saveUserUsecase(user);
                        await userProvider.onOtpVerified(user);

                        AppLogger.i("User stored successfully");
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(
                            context,
                            RouteName.contactPermissionScreen,
                          );

                          await AppStateManager.setProfileCompleted(); // Profile completed flag
                        }
                      } catch (e) {
                        if (context.mounted) {
                          CommonUtils.showSnakckbar(context, e.toString());
                        }
                      }
                    } else {
                      CommonUtils.showSnakckbar(
                        context,
                        "Username is required",
                      );
                    }
                  },
                  isLoading: userProvider.isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
