// Sign Up with Email Page
import 'package:musa_app/Cubit/auth/Login/login_cubit.dart';
import 'package:musa_app/Cubit/auth/Login/login_state.dart';
import 'package:musa_app/Utility/app_validations.dart';
import 'package:musa_app/Utility/packages.dart';
import '../../Utility/musa_widgets.dart';

class SignupEmail extends StatefulWidget {
  const SignupEmail({super.key});

  @override
  State<SignupEmail> createState() => _SignupEmailState();
}

class _SignupEmailState extends State<SignupEmail> {
  final GlobalKey<FormState> signUpKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obsecureText = true;
  LoginCubit loginCubit = LoginCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          StringConst.createAnAccount,
          style: AppTextStyle.normalTextStyleNew(
            size: 18,
            color: AppColor.black,
            fontweight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // body: Container(
      //   color: Colors.white,
      //   child: SafeArea(
      //     child: SingleChildScrollView(
      //       child: Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 23.0),
      //         child: buildSignUpSection(context),
      //       ),
      //     ),
      //   ),
      // ),
      body: Container(
        color: Colors.white,
        child: BlocConsumer<LoginCubit, LoginState>(
          bloc: loginCubit,
          listener: (context, state) {
            if (state is LoginAuthorizedState || state is LoginPlateFormState) {
              Prefs.setString(PrefKeys.email, emailController.text);
              Prefs.setString(PrefKeys.tempPassword, passwordController.text);
              context.go(RouteTo.signup);
            }
            if (state is UserLoginIncomplete) {
              // context.push(RouteTo.signup);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Signup()));
            }
            if (state is LoginFailureState) {
              MusaPopup.popUpDialouge(
                  context: context,
                  onPressed: () => context.pop(true),
                  buttonText: 'Okay',
                  title: 'Error',
                  description: state.errorMessage);
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                buildSignUpSection(context),
                state is LoggedInLoadingState
                    ? MusaWidgets.loader(
                        context: context, isForFullHeight: true)
                    : Container()
              ],
            );
          },
        ),
      ),
    );
  }

  buildSignUpSection(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        // image: DecorationImage(
        //   image: AssetImage(Assets.backgound),
        //   fit: BoxFit.cover,
        // ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23.0),
            child: buildSignupForm(context),
          ),
        ),
      ),
    );
  }

  buildSignupForm(BuildContext context) {
    return Form(
      key: signUpKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Text(
            StringConst.createAccountEmail,
            style: AppTextStyle.normalTextStyleNew(
              size: 14,
              color: AppColor.black,
              fontweight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          // Email TextField with dynamic border
          CommonTextField(
            controller: emailController,
            hintText: StringConst.email,
            prefixIconPath: Assets.emailInboxGreen,
            validator: MusaValidator.validatorEmail,
          ),
          const SizedBox(height: 16),
          // Password TextField with dynamic border
          CommonTextField(
            controller: passwordController,
            hintText: StringConst.password,
            prefixIconPath: Assets.passKey,
            isPassword: true,
            validator: MusaValidator.validatorLoginPass,
            obscureText: obsecureText,
            onToggleObscure: () {
              setState(() {
                obsecureText = !obsecureText;
              });
            },
          ),
          const SizedBox(height: 24),
          CommonButton(
            title: StringConst.continueText,
            onTap: () {
              if (signUpKey.currentState!.validate()) {
                loginCubit.isEmailExist(username: emailController.text);
              }
              // if (signUpKey.currentState!.validate()) {
              //   Prefs.setString(PrefKeys.email, emailController.text);
              //   Prefs.setString(PrefKeys.tempPassword, passwordController.text);
              //   context.push(RouteTo.signup);
              //   // Navigator.pushNamed(
              //   //   context,
              //   //   RouteTo.signup, // Assuming RouteTo.signup is defined properly
              //   //   arguments: {
              //   //     'email': emailController.text,
              //   //     'password': passwordController.text,
              //   //   },
              //   // );
              // }
            },
            color: AppColor.greenDark,
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                StringConst.alreadyHaveAcc,
                style: AppTextStyle.normalTextStyleNew(
                  size: 16,
                  color: AppColor.black,
                  fontweight: FontWeight.w400,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.go(RouteTo.getStart);
                },
                child: Text(
                  StringConst.signIn,
                  style: AppTextStyle.normalTextStyleNew(
                    size: 16,
                    color: AppColor.black,
                    fontweight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
