import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lami_tag/app_base_states/app_base_states.dart';
import 'package:lami_tag/services/auth_service.dart';
import 'package:lami_tag/services/blue_service.dart';
import 'package:lami_tag/services/storage_service.dart';
import 'package:lami_tag/views/authentication/authentication.dart';
import 'package:lami_tag/views/home/home.dart';

class SplashViewCubit extends Cubit<AppBaseState> {
  final BuildContext context;

  SplashViewCubit({required this.context}) : super(AppBaseState.idle()) {
    checkAgreementStatus(context: context);
  }

  final authService = AuthService();
  final storageService = StorageService();
  final blueService = BlueService();

  void checkAgreementStatus({required BuildContext context}) async {
    try {
      if (authService.firebaseAuth.currentUser != null) {
        await storageService
            .getCurrentUser(authService.firebaseAuth.currentUser!.uid);
        if (context.mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const EquinesHome()));
        }
      } else {
        Future.delayed(const Duration(seconds: 2)).then((value) {
          if(context.mounted){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const AuthScreen()));
          }
        });
      }
    } catch (e) {
      authService.signOut();
      Future.delayed(const Duration(seconds: 2)).then((value) {
        if(context.mounted){
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AuthScreen()));
        }
      });
    }
  }
}
