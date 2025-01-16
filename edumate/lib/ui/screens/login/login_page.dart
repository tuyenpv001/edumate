import 'package:edumate/ui/screens/home_user/home.dart';
import 'package:edumate/ui/screens/login/register_page.dart';
import 'package:edumate/ui/themes/styles/color.dart';
import 'package:edumate/ui/themes/styles/logo.dart';
import 'package:edumate/ui/themes/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edumate/constants.dart';
import 'package:edumate/domain/blocs/blocs.dart';
import 'package:edumate/ui/helpers/helpers.dart';
import 'package:edumate/ui/screens/login/forgot_password_page.dart';
import 'package:edumate/ui/screens/login/verify_email_page.dart';
import 'package:edumate/ui/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.clear();
    emailController.dispose();
    passwordController.clear();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoadingAuthentication) {
          modalLoading(context, 'Vui lòng chờ...');
        } else if (state is FailureAuthentication) {
          Navigator.pop(context);

          if (state.error == 'Vui lòng kiểm tra email') {
            Navigator.push(
                context,
                routeSlide(
                    page: VerifyEmailPage(email: emailController.text.trim())));
          }

          errorMessageSnack(context, state.error);
        } else if (state is SuccessAuthentication) {
          userBloc.add(OnGetUserAuthenticationEvent());
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
              context, routeSlide(page: HomeScreen()), (_) => false);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title:
              const Text("Đăng nhập", style: TextStyle(color: Colors.white70)),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
            // shrinkWrap: true,
            child: Column(
          children: [
            const SizedBox(height: 40),
            // Logo
            const LogoWidget(fontSize: 40),
            const SizedBox(height: 20),
            // Welcome Text
            Text(
              'Xin chào!',
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Bạn đã trở lại hãy đăng nhập để tiếp tục.!',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Form(
              key: _keyForm,
              child: Container(
                // transform: Matrix4.translationValues(0, -250, 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          constraints: const BoxConstraints(
                            minHeight: 130.0,
                          ),
                          // height: 130.0,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: kShadowColor,
                                      offset: Offset(0, 12),
                                      blurRadius: 16.0,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 5.0,
                                        right: 16.0,
                                        left: 16.0,
                                      ),
                                      child: TextFieldCustom(
                                        icon: const Icon(
                                          Icons.email,
                                          color: AppColors.primary,
                                          size: 20.0,
                                        ),
                                        controller: emailController,
                                        hintText: 'Email',
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: validatedEmail,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 5.0,
                                        right: 16.0,
                                        left: 16.0,
                                      ),
                                      child: TextFieldCustom(
                                        icon: const Icon(
                                          Icons.lock,
                                          color: AppColors.primary,
                                          size: 20.0,
                                        ),
                                        controller: passwordController,
                                        hintText: 'Mật khẩu',
                                        isPassword: true,
                                        validator: passwordValidator,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        const SizedBox(height: 20),
                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context,
                                  routeSlide(page: const ForgotPasswordPage()));
                            },
                            child: Text('Quên mật khẩu?',
                                style: TextStyle(color: AppColors.secondary)),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Divider(),

                        // Btn(
                        //   text: 'Đăng nhập',
                        //   width: size.width,
                        //   onPressed: () {
                        //     if (_keyForm.currentState!.validate()) {
                        //       authBloc.add(OnLoginEvent(
                        //           emailController.text.trim(),
                        //           passwordController.text.trim()));
                        //     }
                        //   },
                        // ),
                        ElevatedButton(
                          onPressed: () {
                            if (_keyForm.currentState!.validate()) {
                              authBloc.add(OnLoginEvent(
                                  emailController.text.trim(),
                                  passwordController.text.trim()));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text('Đăng nhập',
                              style: AppTextStyles.buttonText),
                        ),
                        const SizedBox(height: 20),
                        // Sign Up Prompt
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Bạn không có tài khoản?',
                                style: Theme.of(context).textTheme.bodyLarge),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context,
                                    routeSlide(page: const RegisterPage()));
                              },
                              child: Text('Đăng ký',
                                  style: TextStyle(color: AppColors.primary)),
                            ),
                          ],
                        ),
                        // const SizedBox(height: 15.0),
                        // Center(
                        //     child: InkWell(
                        //         onTap: () => Navigator.push(
                        //             context,
                        //             routeSlide(
                        //                 page: const ForgotPasswordPage())),
                        //         child:
                        //             const TextCustom(text: 'Quên mật khẩu?')))
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        )
            // ],
            ),
      ),
    );
  }
}
