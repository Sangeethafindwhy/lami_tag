import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lami_tag/app_base_states/app_base_states.dart';
import 'package:lami_tag/utils/responsive_height_width.dart';
import 'package:lami_tag/views/authentication/widgets/create_profile_widget.dart';
import 'package:lami_tag/views/blue_flow/blue_cubit.dart';
import 'package:lami_tag/views/common/default_background.dart';
import 'package:lami_tag/views/home/home.dart';

class BlueConnectivityScreen extends StatelessWidget {
  final Function()? onNext;

  const BlueConnectivityScreen({super.key, this.onNext});

  @override
  Widget build(BuildContext context) {
    return DefaultBackground(
      height: displayHeight(context) / 1.3,
      child: BlocProvider(
        create: (context) => BlueCubit(context: context),
        child: BlocBuilder<BlueCubit, AppBaseState>(
          builder: (context, state) {
            final bloc = context.read<BlueCubit>();
            return EnlistDeviceWidget(
              bloc: bloc,
              state: state,
              onNext: () {
                if (onNext != null) {
                  onNext!();
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EquinesHome()));
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class BlueScreen extends StatelessWidget {
  const BlueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultBackground(
      child: ConnectDeviceWidget(
        onNext: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const BlueConnectivityScreen()));
        },
      ),
    );
  }
}
