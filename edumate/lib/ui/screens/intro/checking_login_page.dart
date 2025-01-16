import 'package:edumate/ui/screens/home_user/home.dart';
import 'package:edumate/ui/themes/styles/color.dart';
import 'package:edumate/ui/themes/styles/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edumate/domain/blocs/blocs.dart';
import 'package:edumate/ui/helpers/helpers.dart';
import 'package:edumate/ui/screens/login/started_page.dart';
import 'package:edumate/ui/themes/colors_theme.dart';
import 'package:edumate/ui/widgets/widgets.dart';

class CheckingLoginPage extends StatefulWidget {
  const CheckingLoginPage({Key? key}) : super(key: key);

  @override
  State<CheckingLoginPage> createState() => _CheckingLoginPageState();
}

class _CheckingLoginPageState extends State<CheckingLoginPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.8).animate(_animationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _animationController.forward();
            }
          });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LogOut) {
          Navigator.pushAndRemoveUntil(
              context, routeSlide(page: const StartedPage()), (_) => false);
        } else if (state is SuccessAuthentication) {
          userBloc.add(OnGetUserAuthenticationEvent());
          Navigator.pushAndRemoveUntil(
              context, routeSlide(page: HomeScreen()), (_) => false);
        }
      },
      child: Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                color: AppColors.secondary,
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary_light,
                      AppColors.primary,
                      Colors.white
                    ])),
            child: Center(
              child: SizedBox(
                height: 200,
                child: Column(
                  children: [
                    LogoWidget(
                      fontSize: 40,
                    ),
                    const SizedBox(height: 10.0),
                    const TextCustom(text: 'Xác thực...', color: Colors.black87)
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
