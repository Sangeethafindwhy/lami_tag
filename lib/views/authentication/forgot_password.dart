import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lami_tag/app_base_states/app_base_states.dart';
import 'package:lami_tag/res/lami_colors.dart';
import 'package:lami_tag/res/lami_images.dart';
import 'package:lami_tag/res/lami_strings.dart';
import 'package:lami_tag/utils/sizedbox_extension.dart';
import 'package:lami_tag/views/authentication/auth_view_cubit.dart';
import 'package:lami_tag/views/common/lami_button.dart';
import 'package:lami_tag/views/common/lami_text.dart';
import 'package:lami_tag/views/common/lami_text_field.dart';
import 'package:lami_tag/views/common/loading.dart';

class ForgotPassword extends StatelessWidget {
  final AuthViewCubit bloc;

  const ForgotPassword({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LamiColors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                LamiIcons.horseIcon,
                fit: BoxFit.fitWidth,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: LamiColors.white,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: LamiColors.black,
                      ),
                    ),
                    const LamiText(
                      text: LamiString.forgotPassword,
                      fontSize: 35,
                      color: LamiColors.black,
                      fontWeight: FontWeight.bold,

                    ),
                    const LamiText(
                      text: LamiString.forgotPasswordMessage,
                      fontSize: 16,
                      color: LamiColors.lightestGrey,
                      fontWeight: FontWeight.bold,
                      softWrap: true,
                    ),
                    20.ph,
                    LamiTextField(
                        hintText: LamiString.email,
                        controller: bloc.resetEmail,
                        validator: (value) {
                          return value;
                        }
                    ),
                    20.ph,
                    BlocProvider.value(
                      value: bloc,
                      child: BlocBuilder<AuthViewCubit, AppBaseState>(
                        builder: (context, state) {
                          final bloc = context.read<AuthViewCubit>();
                          return (state.busy) ? const Loading() : LamiButton(
                            onPressed: () {
                              bloc.resendPasswordResetLink(context);
                            },
                            text: LamiString.sendResetLink,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
