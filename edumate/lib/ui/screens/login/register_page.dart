import 'package:edumate/ui/themes/styles/color.dart';
import 'package:edumate/ui/themes/styles/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:edumate/constants.dart';
import 'package:edumate/domain/blocs/blocs.dart';
import 'package:edumate/ui/helpers/helpers.dart';
import 'package:edumate/ui/screens/login/login_page.dart';
import 'package:edumate/ui/themes/colors_theme.dart';
import 'package:edumate/ui/widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController fullNameController;
  late TextEditingController userController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    userController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    userController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is LoadingUserState) {
          modalLoading(context, 'Vui lòng đợi...');
        } else if (state is SuccessUserState) {
          Navigator.pop(context);
          modalSuccess(context, 'Tài khoản đã được đăng ký',
              onPressed: () => Navigator.pushAndRemoveUntil(context,
                  routeSlide(page: const LoginPage()), (route) => false));
        } else if (state is FailureUserState) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text("Đăng ký", style: TextStyle(color: Colors.white70)),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const LogoWidget(fontSize: 40),
                  const SizedBox(height: 20),
                  Text(
                    'Đăng ký tài khoản nếu bạn chưa có!',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _keyForm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          // decoration: BoxDecoration(
                          //   color: Colors.white,
                          //   borderRadius: BorderRadius.circular(14.0),
                          //   boxShadow: const [
                          //     BoxShadow(
                          //       color: kShadowColor,
                          //       offset: Offset(0, 12),
                          //       blurRadius: 16.0,
                          //     ),
                          //   ],
                          // ),
                          child: Column(
                            children: [
                              TextFieldCustom(
                                icon: const Icon(
                                  Icons.person_4_outlined,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                controller: fullNameController,
                                hintText: 'Họ và tên',
                                validator: RequiredValidator(
                                    errorText: 'Vui lòng điền họ tên'),
                              ),
                              const SizedBox(height: 40.0),
                              TextFieldCustom(
                                icon: const Icon(
                                  Icons.account_circle_outlined,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                controller: userController,
                                hintText: 'Username',
                                validator: RequiredValidator(
                                    errorText: 'Vui lòng nhập người dùng'),
                              ),
                              const SizedBox(height: 40.0),
                              TextFieldCustom(
                                icon: const Icon(
                                  Icons.email,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                controller: emailController,
                                hintText: 'Email',
                                keyboardType: TextInputType.emailAddress,
                                validator: validatedEmail,
                              ),
                              const SizedBox(height: 40.0),
                              TextFieldCustom(
                                icon: const Icon(
                                  Icons.lock,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                controller: passwordController,
                                hintText: 'Mật khẩu',
                                isPassword: true,
                                validator: passwordValidator,
                              ),
                              // const SizedBox(height: 60.0),
                              // const TextCustom(
                              //   text: 'Đồng ý với các điều khoản của chúng tôi?',
                              //   fontSize: 15,
                              //   maxLines: 2,
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40.0),
                        Btn(
                            backgroundColor: AppColors.primary,
                            text: 'Đăng ký',
                            width: size.width,
                            onPressed: () {
                              if (_keyForm.currentState!.validate()) {
                                userBloc.add(OnRegisterUserEvent(
                                    fullNameController.text.trim(),
                                    userController.text.trim(),
                                    emailController.text.trim(),
                                    passwordController.text.trim()));
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
