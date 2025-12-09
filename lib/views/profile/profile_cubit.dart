import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lami_tag/app_base_states/app_base_states.dart';
import 'package:lami_tag/res/lami_strings.dart';
import 'package:lami_tag/services/auth_service.dart';
import 'package:lami_tag/services/image_service.dart';
import 'package:lami_tag/services/snack_service.dart';
import 'package:lami_tag/services/storage_service.dart';
import 'package:lami_tag/services/time_service.dart';
import 'package:lami_tag/services/validation_services.dart';
import 'package:lami_tag/views/common/dialogs/select_option.dart';
import 'package:lami_tag/views/profile/verification_screen.dart';
import 'package:lami_tag/views/splash/splash_view.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileCubit extends Cubit<AppBaseState> {
  final BuildContext context;

  ProfileCubit({required this.context}) : super(AppBaseState.idle()) {
    setUserProfileData();
  }

  final authService = AuthService();
  final storageService = StorageService();
  final timeService = TimeService();
  final imageService = ImageService();
  final validationServices = ValidationServices();
  final SnackService snackService = SnackService();

  BehaviorSubject<String> $profileImage = BehaviorSubject<String>.seeded('');
  BehaviorSubject<bool> $profileUpdate = BehaviorSubject<bool>.seeded(false);
  final verificationFormKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  Future<void> singOut() async {
    log('Trying to sign out');
    await authService.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SplashView()));
    }
  }

  Future<void> deleteAccount() async {
    try {
      log('Trying to delete account');
      await authService.deleteUser();
      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SplashView()));
      }
    } catch (e) {
      if(context.mounted){
        snackService.showSnackBar(context: context, message: "You need to login again due to sensitivity of this action");
        Navigator.push(context, MaterialPageRoute(builder: (context) => const VerificationScreen()));
      }
    }
  }

  Future<void> uploadProfileImage() async {
    log('Trying to upload profile image');
    if ($profileImage.value.isNotEmpty) {
      try {
        String downloadURL =
            await storageService.uploadImage($profileImage.value, authService.firebaseAuth.currentUser!.uid);
        $profileImage.add(downloadURL);
        // storageService
        //     .getCurrentUser(authService.firebaseAuth.currentUser!.uid);
      } catch (e) {
        log('Error uploading image: $e');
      }
    }
  }

  selectProfileImage(BuildContext dropDownContext) async {
    log('Trying to select profile immage');
    int? value = await showSelectionSheet(
        dropDownContext, LamiString.imageSourceOptions, [Icons.camera_alt, Icons.photo_library]);

    if (value != null) {
      File? imageFile =
          await imageService.pickImage(imageSource: value == 0 ? ImageSource.camera : ImageSource.gallery);
      if (imageFile != null) {
        updateProfileImage(imageFile.path);
      }
    }
  }

  updateProfileImage(String value) {
    log('Trying to update profile image');
    $profileImage.add(value);
    changedProfileData();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController memberSinceController = TextEditingController();
  BehaviorSubject<String?> $selectedItem = BehaviorSubject<String>();

  setUserProfileData() async {
    log('Trying to update profile data for screen view');
    nameController.text = storageService.$userProfile.value.name;
    emailController.text = storageService.$userProfile.value.email;
    memberSinceController.text = timeService.convertEpochToHumanReadable(storageService.$userProfile.value.createdOn);
    updateSelectedRole(storageService.$userProfile.value.role);
  }

  updateSelectedRole(String value) {
    log('Trying to update role');
    $selectedItem.add(value);
  }

  updateUserProfile() async {
    log('Trying to update user profile');
    emit(AppBaseState.busy());

    if (nameController.text != storageService.$userProfile.value.name ||
        $selectedItem.value! != storageService.$userProfile.value.role) {
      log('Updating profile');

      await storageService.createUserProfile(
        authService.firebaseAuth.currentUser!.uid,
        nameController.text,
        $selectedItem.value!,
      );
    }

    if ($profileImage.value.isNotEmpty) {
      await uploadProfileImage();
      await storageService.updateUserProfileImage(authService.firebaseAuth.currentUser!.uid, $profileImage.value);
    }

    await storageService.getCurrentUser(authService.firebaseAuth.currentUser!.uid);

    changedProfileData(value: false);
    emit(AppBaseState.idle());
  }

  changedProfileData({bool value = true}) async {
    log('Profile is updated');
    $profileUpdate.add(value);
  }

  Future<void> launchMyUrl(String url) async {
    Uri link = Uri.parse(url);
    if (!await launchUrl(link)) {
      throw Exception('Could not launch $link');
    }
  }

  Future<void> confirmDeletion(BuildContext context) async {
    emit(AppBaseState.busy());
    try {
      await authService.signInWithEmailAndPassword(email.text, password.text);
      await authService.deleteUser();
      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SplashView()));
      }
    } catch (e) {
      if (context.mounted) {
        snackService.showSnackBar(context: context, message: e.toString());
      }
    }
    emit(AppBaseState.idle());
  }

  Future<void> signInWithGoogle() async {
    UserCredential? userCredential = await authService.signInWithGoogle();
    if (userCredential != null) {
      await authService.deleteUser();
      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SplashView()));
      }
    } else {
      log('Failed to sign in with google');
    }
  }

  Future<void> signInWithApple() async {
    //
  }
}
