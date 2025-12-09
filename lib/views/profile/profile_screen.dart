import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lami_tag/app_base_states/app_base_states.dart';
import 'package:lami_tag/res/constants.dart';
import 'package:lami_tag/res/lami_colors.dart';
import 'package:lami_tag/res/lami_strings.dart';
import 'package:lami_tag/utils/sizedbox_extension.dart';
import 'package:lami_tag/views/common/default_background.dart';
import 'package:lami_tag/views/common/lami_button.dart';
import 'package:lami_tag/views/common/lami_drop_down.dart';
import 'package:lami_tag/views/common/lami_text.dart';
import 'package:lami_tag/views/common/lami_text_field.dart';
import 'package:lami_tag/views/common/loading.dart';
import 'package:lami_tag/views/common/profile_image.dart';
import 'package:lami_tag/views/profile/profile_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => ProfileCubit(context: context),
        child: BlocBuilder<ProfileCubit, AppBaseState>(
          builder: (context, state) {
            final bloc = (context).read<ProfileCubit>();
            return DefaultBackground(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close,
                          color: LamiColors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        bloc.selectProfileImage(context);
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          StreamBuilder(
                              stream: bloc.$profileImage,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  String image = snapshot.data!;
                                  if(image.isNotEmpty){
                                    return ProfileImage(image: image);
                                  }
                                }
                                return ProfileImage(image: bloc.storageService.$userProfile.value.imageURL,);
                              }
                              ),
                          const Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: LamiColors.red,
                              radius: 15,
                              child: Icon(
                                Icons.edit,
                                color: LamiColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.ph,
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: LamiText(
                        text: LamiString.email,
                        color: LamiColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    LamiTextField(
                        hintText: LamiString.email,
                        controller: bloc.emailController,
                        enabled: false,
                        onChanged: (value) {
                          //
                        },
                        validator: (value) {
                          return null;
                        }),
                    10.ph,
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: LamiText(
                        text: LamiString.memberSince,
                        color: LamiColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    LamiTextField(
                        hintText: LamiString.memberSince,
                        controller: bloc.memberSinceController,
                        enabled: false,
                        onChanged: (value) {
                          //
                        },
                        validator: (value) {
                          return null;
                        }),
                    10.ph,
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: LamiText(
                        text: LamiString.fullName,
                        color: LamiColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    LamiTextField(
                        hintText: LamiString.fullName,
                        controller: bloc.nameController,
                        onChanged: (value) {
                          bloc.changedProfileData();
                        },
                        validator: (value) {
                          return bloc.validationServices.validateField(value);
                        }),
                    10.ph,
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: LamiText(
                        text: LamiString.role,
                        color: LamiColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    StreamBuilder(
                      stream: bloc.$selectedItem,
                      builder: (context, snapshot) {
                        final selectedItem = snapshot.data;
                        return LamiDropDown(
                          hintText: LamiString.role,
                          items: LamiConstants.roles,
                          selectedItem: selectedItem,
                          onChanged: (newValue) {
                            bloc.updateSelectedRole(newValue!);
                            bloc.changedProfileData();
                          },
                          validator: (value) {
                            return bloc.validationServices.validateDropDown(value);
                          },
                        );
                      },
                    ),
                    20.ph,
                    StreamBuilder(
                        stream: bloc.$profileUpdate,
                        builder: (context, profileUpdateSnapshot){
                          final bool data = profileUpdateSnapshot.data ?? false;
                          return (state.busy)? const Loading() : LamiButton(
                            text: LamiString.updateChanges,
                            backgroundColor: (data) ? LamiColors.red : LamiColors.mediumGrey,
                            onPressed: () {
                              if(data){
                                bloc.updateUserProfile();
                              }else{
                                log('Nothing is changed');
                              }
                            },
                          );
                        }
                    ),
                    10.ph,
                    LamiButton(
                      text: LamiString.logout,
                      onPressed: () {
                        bloc.singOut();
                        },
                ),
                    10.ph,
                    LamiButton(
                      backgroundColor: LamiColors.white,
                      textColor: LamiColors.red,
                      text: LamiString.privacyPolicy,
                      onPressed: () {
                        bloc.launchMyUrl("https://sites.google.com/view/lami-tag/privacy-policy");
                      },
                    ),
                    10.ph,
                    LamiButton(
                      backgroundColor: LamiColors.white,
                      textColor: LamiColors.red,
                      text: LamiString.termsAndConditions,
                      onPressed: () {
                        bloc.launchMyUrl("https://sites.google.com/view/lami-tag/term-conditions");
                      },
                    ),
                    10.ph,
                    LamiButton(
                      backgroundColor: LamiColors.white,
                      textColor: LamiColors.red,
                      text: LamiString.deleteAccount,
                      onPressed: () {
                        bloc.deleteAccount();
                      },
                    ),

                  ],
            ));
          },
        ),
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final String heading;
  final String value;
  const ProfileWidget({super.key, required this.heading, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LamiText(
          text: '$heading: ',
          color: LamiColors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),

        LamiText(
          text: value,
          color: LamiColors.black,
          fontWeight: FontWeight.normal,
          fontSize: 24,
          softWrap: true,
        ),

      ],
    );
  }
}



