import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lami_tag/app_base_states/app_base_states.dart';
import 'package:lami_tag/res/lami_colors.dart';
import 'package:lami_tag/res/lami_images.dart';
import 'package:lami_tag/views/splash/splash_view_cubit.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LamiColors.black,
      body: BlocProvider(
        create: (context) => SplashViewCubit(context: context),
        child: BlocBuilder<SplashViewCubit, AppBaseState>(
          builder: (context, state) {
            return Center(
              child: Image.asset(
                LamiIcons.horseIcon,
                fit: BoxFit.fitWidth,
              ),
            );
          },
        ),
      ),
    );
  }
}
