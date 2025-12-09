import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lami_tag/app_base_states/app_base_states.dart';
import 'package:lami_tag/res/lami_strings.dart';
import 'package:lami_tag/services/auth_service.dart';
import 'package:lami_tag/services/image_service.dart';
import 'package:lami_tag/services/session_management_service.dart';
import 'package:lami_tag/services/snack_service.dart';
import 'package:lami_tag/services/storage_service.dart';
import 'package:lami_tag/services/validation_services.dart';
import 'package:lami_tag/views/authentication/create_profile.dart';
import 'package:lami_tag/views/common/dialogs/select_option.dart';
import 'package:lami_tag/views/home/home.dart';
import 'package:rxdart/rxdart.dart';

class AuthViewCubit extends Cubit<AppBaseState> {
  final BuildContext context;

  AuthViewCubit({required this.context}) : super(AppBaseState.idle()) {
    //

    //
  }

  final sessionManagementService = SessionManagementService();
  final snackService = SnackService();
  final validationServices = ValidationServices();
  final authService = AuthService();
  final storageService = StorageService();
  final imageService = ImageService();

  final signInEmail = TextEditingController();
  final signInPassword = TextEditingController();
  final signInFormKey = GlobalKey<FormState>();

  final resetEmail = TextEditingController();

  final signUpEmail = TextEditingController();
  final signUpPassword = TextEditingController();
  final confirmPassword = TextEditingController();
  final signUpFormKey = GlobalKey<FormState>();

  final userName = TextEditingController();
  final createProfileFormKey = GlobalKey<FormState>();

  BehaviorSubject<String?> $selectedItem = BehaviorSubject<String>();
  BehaviorSubject<String> $profileImage = BehaviorSubject<String>.seeded('');

  Future<void> createAccount() async {
    emit(AppBaseState.busy());

    if (signUpPassword.text == confirmPassword.text) {
      //sign up here

      try {
        await authService.signUpWithEmailAndPassword(signUpEmail.text, signUpPassword.text);

        await addUserData();
      } catch (e) {
        if (context.mounted) {
          snackService.showSnackBar(context: context, message: e.toString());
        }
      }
    } else {
      snackService.showSnackBar(context: context, message: LamiString.passwordDoesNotMatch);
    }

    emit(AppBaseState.idle());
  }

  Future<void> loginUser(BuildContext context) async {
    emit(AppBaseState.busy());
    try {
      await authService.signInWithEmailAndPassword(signInEmail.text, signInPassword.text);
      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EquinesHome()));
      }
    } catch (e) {
      if (context.mounted) {
        snackService.showSnackBar(context: context, message: e.toString());
      }
    }
    emit(AppBaseState.idle());
  }

  Future<void> resendPasswordResetLink(BuildContext context) async {
    emit(AppBaseState.busy());
    try {
      await authService.sendPasswordResetEmail(resetEmail.text);
      if (context.mounted) {
        snackService.showSnackBar(context: context, message: "Password reset link has been sent at ${resetEmail.text}");
        Navigator.pop(context);
      }
    } catch (e) {
      log('Failed to send password reset email');
    }
    emit(AppBaseState.idle());
  }

  Future<void> addUserData({bool moveOn = true}) async {
    await storageService.addUserData(
      authService.firebaseAuth.currentUser!.uid,
      authService.firebaseAuth.currentUser!.email!,
    );

    if (context.mounted && moveOn) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateProfile(bloc: this)));
    }
  }

  Future<void> createUserProfile() async {
    await storageService.createUserProfile(
      authService.firebaseAuth.currentUser!.uid,
      userName.text,
      $selectedItem.value!,
    );
  }

  updateSelectedRole(String value) {
    $selectedItem.add(value);
  }

  updateProfileImage(String value) {
    $profileImage.add(value);
  }

  selectProfileImage(BuildContext dropDownContext) async {
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

  Future<void> uploadProfileImage() async {
    if ($profileImage.value.isNotEmpty) {
      try {
        String downloadURL =
            await storageService.uploadImage($profileImage.value, authService.firebaseAuth.currentUser!.uid);
        storageService.updateUserProfileImage(authService.firebaseAuth.currentUser!.uid, downloadURL);
      } catch (e) {
        log('Error uploading image: $e');
      }
    }
  }

  Future<void> signInWithGoogle() async {
    UserCredential? userCredential = await authService.signInWithGoogle();
    if (userCredential != null) {
      log('Signed in user: ${userCredential.user?.displayName}');
      String uid = userCredential.user!.uid;
      try {
        await _checkUserInFirestore(uid, userCredential.user?.displayName ?? getUsernameFromEmail(userCredential.user?.email ?? '') ?? '');
      } catch (error, stackTrack) {
        log('error:: $error');
        log('stackTrack:: $stackTrack');
      }
    } else {
      log('Failed to sign in with google');
    }
  }

  String? getUsernameFromEmail(String email) {
    return email.split('@').first; // Split and take the first part
  }

  Future<void> signInWithApple() async {
    UserCredential? userCredential = await authService.goshSignInWithApple();
    if (userCredential != null) {
      log('Signed in user: ${userCredential.user?.displayName}');
      String uid = userCredential.user!.uid;
      try {
        await _checkUserInFirestore(uid, userCredential.user?.displayName ?? getUsernameFromEmail(userCredential.user?.email ?? '') ?? '');
      } catch (error, stackTrack) {
        log('error:: $error');
        log('stackTrack:: $stackTrack');
      }
    } else {
      log('Failed to sign in');
    }
  }

  Future<void> _checkUserInFirestore(String uid, String username) async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      log('User already exists, navigating to home');
    } else {
      log('User does not exist, adding to Firestore');
      await addUserData(moveOn: false);

      await storageService.createUserProfile(
        authService.firebaseAuth.currentUser!.uid,
        username,
        "Other",
      );

    }
    if (context.mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EquinesHome()));
    }
  }
}
