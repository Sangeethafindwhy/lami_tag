import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lami_tag/app_base_states/app_base_states.dart';
import 'package:lami_tag/res/lami_colors.dart';
import 'package:lami_tag/res/lami_images.dart';
import 'package:lami_tag/utils/sizedbox_extension.dart';
import 'package:lami_tag/views/profile/profile_cubit.dart';

import '../../res/lami_strings.dart';
import '../common/lami_button.dart';
import '../common/lami_text.dart';
import '../common/lami_text_field.dart';
import '../common/loading.dart';

class VerificationScreen extends StatelessWidget  {
  const VerificationScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LamiColors.black,
      body: BlocProvider(
        create: (context) => ProfileCubit(context: context),
        child: BlocBuilder<ProfileCubit, AppBaseState>(
          builder: (context, state) {
            final bloc = context.read<ProfileCubit>();
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      LamiIcons.horseIcon,
                      fit: BoxFit.fitWidth,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: LamiColors.white,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Form(
                        key: bloc.verificationFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const LamiText(
                              text: LamiString.welcomeBack,
                              fontSize: 35,
                              color: LamiColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            const LamiText(
                              text: LamiString.welcomeBackMessage,
                              fontSize: 16,
                              color: LamiColors.lightestGrey,
                              fontWeight: FontWeight.bold,
                              softWrap: true,
                            ),
                            20.ph,
                            LamiTextField(
                                hintText: LamiString.email,
                                controller: bloc.email,
                                validator: (value) {
                                  return bloc.validationServices.validateEmail(value);
                                }),
                            20.ph,
                            LamiTextField(
                                hintText: LamiString.password,
                                controller: bloc.password,
                                secureText: true,
                                validator: (value) {
                                  return bloc.validationServices.validatePassword(value);
                                }),
                            20.ph,
                            (state.busy) ? const Loading() : LamiButton(
                              onPressed: () {
                                if (bloc.verificationFormKey.currentState!.validate()) {
                                  bloc.confirmDeletion(context);
                                } else {
                                  //
                                }
                              },
                              text: LamiString.signIn,
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
                            (Platform.isIOS) ? Column(
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
                            ) : const Center(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}