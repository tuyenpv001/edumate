import 'package:edumate/ui/themes/styles/color.dart';
import 'package:edumate/ui/themes/styles/logo.dart';
import 'package:flutter/material.dart';
import 'package:edumate/ui/helpers/helpers.dart';
import 'package:edumate/ui/screens/login/login_page.dart';
import 'package:edumate/ui/screens/login/register_page.dart';
import 'package:edumate/ui/themes/colors_theme.dart';
import 'package:edumate/ui/widgets/widgets.dart';

class StartedPage extends StatelessWidget {
  const StartedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(30.0),
                width: size.width,
                alignment: Alignment.center,
                child: LogoWidget(
                  fontSize: 40,
                )),
            const TextCustom(
              text: 'Xin chào !',
              letterSpacing: 2.0,
              color: ColorsCustom.secundary,
              fontWeight: FontWeight.w600,
              fontSize: 30,
            ),
            const SizedBox(height: 10.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextCustom(
                text: 'Chào mừng bạn đến với eduMate!',
                textAlign: TextAlign.center,
                maxLines: 5,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 10.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextCustom(
                text: 'bạn đồng hành cùng bạn trên con đường học tập!',
                textAlign: TextAlign.center,
                maxLines: 5,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 40.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                height: 50,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  // border: Border.all(color: Color(0xFF4A47F5), width: 1.5),
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary,
                    ],
                  ),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    // backgroundColor: ColorsCustom.secundary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                  ),
                  child: const TextCustom(
                      text: 'Đăng nhập', color: Colors.white, fontSize: 20),
                  onPressed: () => Navigator.push(
                      context, routeSlide(page: const LoginPage())),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                height: 50,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
                child: TextButton(
                  child: const TextCustom(
                    text: 'Đăng Ký',
                    fontSize: 20,
                  ),
                  onPressed: () => Navigator.push(
                      context, routeSlide(page: const RegisterPage())),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
