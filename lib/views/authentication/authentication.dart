import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lami_tag/app_base_states/app_base_states.dart';
import 'package:lami_tag/res/lami_colors.dart';
import 'package:lami_tag/res/lami_images.dart';
import 'package:lami_tag/views/authentication/auth_view_cubit.dart';
import 'package:lami_tag/views/authentication/widgets/login_view.dart';
import 'package:lami_tag/views/authentication/widgets/signup_view.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {


  bool _showLogin = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  void _toggleView() {
    if (_showLogin) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LamiColors.black,
      body: BlocProvider(
        create: (context) => AuthViewCubit(context: context),
        child: BlocBuilder<AuthViewCubit, AppBaseState>(
          builder: (context, state) {
            final bloc = context.read<AuthViewCubit>();
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      LamiIcons.horseIcon,
                      fit: BoxFit.fitWidth,
                    ),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        final isFront = _animation.value < 0.5;
                        final angle = _animation.value *
                            3.14; // Rotate 180 degrees (pi radians)
                        return Transform(
                          transform: isFront
                              ? Matrix4.rotationY(angle)
                              : (Matrix4.rotationY(angle)
                            ..rotateY(3.14)),
                          alignment: Alignment.center,
                          child: isFront
                              ? LoginView(onSwitch: _toggleView, bloc: bloc, state: state)
                              : SignupView(onSwitch: _toggleView, bloc: bloc, state: state),
                        );
                      },
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





