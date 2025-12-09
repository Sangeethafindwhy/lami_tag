import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lami_tag/app_base_states/app_base_states.dart';
import 'package:lami_tag/res/lami_colors.dart';
import 'package:lami_tag/res/lami_images.dart';
import 'package:lami_tag/res/lami_strings.dart';
import 'package:lami_tag/utils/sizedbox_extension.dart';
import 'package:lami_tag/views/authentication/auth_view_cubit.dart';
import 'package:lami_tag/views/common/lami_button.dart';
import 'package:lami_tag/views/common/lami_text.dart';
import 'package:lami_tag/views/common/lami_text_field.dart';

class SignupView extends StatelessWidget {
  final VoidCallback onSwitch;
  final AppBaseState state;
  final AuthViewCubit bloc;

  const SignupView(
      {super.key,
      required this.onSwitch,
      required this.bloc,
      required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: LamiColors.white, borderRadius: BorderRadius.circular(20)),
      child: Form(
        key: bloc.signUpFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LamiText(
              text: LamiString.getStarted,
              fontSize: 35,
              color: LamiColors.black,
              fontWeight: FontWeight.bold,
            ),
            const LamiText(
              text: LamiString.getStartedMessage,
              fontSize: 16,
              color: LamiColors.lightestGrey,
              fontWeight: FontWeight.bold,
              softWrap: true,
            ),
            20.ph,
            LamiTextField(
                hintText: LamiString.email,
                controller: bloc.signUpEmail,
                validator: (value) {
                  return bloc.validationServices.validateEmail(value);
                }),
            20.ph,
            LamiTextField(
                hintText: LamiString.password,
                controller: bloc.signUpPassword,
                secureText: true,
                validator: (value) {
                  return bloc.validationServices.validatePassword(value);
                }),
            20.ph,
            LamiTextField(
                hintText: LamiString.confirmPassword,
                controller: bloc.confirmPassword,
                secureText: true,
                validator: (value) {
                  return bloc.validationServices.validatePassword(value);
                }),
            20.ph,
            LamiButton(
              onPressed: () {
                if (bloc.signUpFormKey.currentState!.validate()) {
                  bloc.createAccount();
                } else {
                  //
                }
              },
              text: LamiString.signUp,
            ),
            10.ph,
            const SizedBox(
              width: double.infinity,
              child: LamiText(
                text: LamiString.orSignInWith,
                fontSize: 12,
                color: LamiColors.mediumGrey,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
            ),
            10.ph,
            LamiButton(
              onPressed: () {
                bloc.signInWithGoogle();
              },
              text: LamiString.continueWithGoogle,
              icon: LamiIcons.google,
              backgroundColor: LamiColors.transparent,
              textColor: LamiColors.black,
            ),
            20.ph,
            (Platform.isIOS)
                ? Column(
                    children: [
                      LamiButton(
                        onPressed: () {
                          bloc.signInWithApple();
                        },
                        text: LamiString.continueWithApple,
                        icon: LamiIcons.apple,
                        backgroundColor: LamiColors.transparent,
                        textColor: LamiColors.black,
                      ),
                      20.ph,
                    ],
                  )
                : const Center(),
            SizedBox(
              width: double.infinity,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: '${LamiString.alreadyHaveAnAccount} ',
                    style: const TextStyle(color: LamiColors.black),
                    children: [
                      TextSpan(
                        text: LamiString.signInHere,
                        style: const TextStyle(
                          color: LamiColors.red,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            onSwitch();
                          },
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
