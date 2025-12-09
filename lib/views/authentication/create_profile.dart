import 'package:flutter/material.dart';
import 'package:lami_tag/views/authentication/auth_view_cubit.dart';
import 'package:lami_tag/views/authentication/widgets/create_profile_widget.dart';
import 'package:lami_tag/views/blue_flow/blue_screen.dart';
import 'package:lami_tag/views/common/default_background.dart';

class CreateProfile extends StatelessWidget {
  final AuthViewCubit bloc;

  const CreateProfile({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return DefaultBackground(
      child: CreateProfileWidget(
          onNext: () {
            bloc.createUserProfile();
            bloc.uploadProfileImage();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const BlueScreen()));
          },
          controller: bloc.userName,
          bloc: bloc,
        ),
    );
  }
}
