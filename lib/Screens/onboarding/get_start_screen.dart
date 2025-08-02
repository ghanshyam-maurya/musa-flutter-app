// Welcome  Back Screen
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:musa_app/Cubit/auth/Login/login_cubit.dart';
import 'package:musa_app/Cubit/auth/Login/login_state.dart';
import 'package:musa_app/Screens/auth/social_login.dart';
import 'package:musa_app/Utility/packages.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

class GetStartScreen extends StatefulWidget {
  const GetStartScreen({super.key});

  @override
  State<GetStartScreen> createState() => _GetStartScreenState();
}

class _GetStartScreenState extends State<GetStartScreen>
    with SingleTickerProviderStateMixin {
  // LoginCubit loginCubit = LoginCubit();
  late LoginCubit loginCubit;
  @override
  void initState() {
    loginCubit = LoginCubit();
    getFcmToken();
    super.initState();
  }

  getFcmToken() async {
    // Get FCM Token
    // await FirebaseMessaging.instance.getToken().then(setToken);
  }

  setToken(String? fcmToken) async {
    print("fcmToken : $fcmToken");
    await Prefs.setString(PrefKeys.fcmToken, fcmToken.toString());
    // cubit.updateFcmToken(fcmToken);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.white),
    );
    return BlocProvider<LoginCubit>.value(
      value: loginCubit,
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          // print(
          //     "BlocConsumer triggered. Cubit hash: ${context.read<LoginCubit>().hashCode}");
          // print(state);
          if (state is LoginFailureState) {
            MusaPopup.popUpDialouge(
                context: context,
                onPressed: () => context.pop(true),
                buttonText: 'Okay',
                title: 'Error',
                description: state.errorMessage);
          } else if (state is UserLoginIncomplete) {
            // print(
            //     "HERE after login successful from backend UserLoginIncomplete");
            // context.go(RouteTo.completeProfile); // Adjust route as needed
            // context.push(RouteTo.signup);
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => SocialLogin()));
          } else if (state is LoginAuthorizedState ||
              state is LoginPlateFormState) {
            // print(
            //     "HERE after login successful from backend LoginAuthorizedState");
            context.go(RouteTo.bottomNavBar);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        padding: MusaPadding.horizontalPadding,
                        child: SvgPicture.asset(Assets.musaLogo),
                        // ShaderMask(
                        //   shaderCallback: (bounds) =>
                        //       AppColor.primaryGreenGradient.createShader(
                        //     Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        //   ),
                        //   blendMode: BlendMode.srcIn,
                        //   child: SvgPicture.asset(Assets.musaLogo),
                        // ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      StringConst.welcomeBack,
                      style: AppTextStyle.boldTextStyleNew(
                        size: 25,
                        color: AppColor.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      StringConst.pleaseSignInMusa,
                      style: AppTextStyle.normalTextStyleNew(
                        size: 14,
                        color: AppColor.black,
                        fontweight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch, // Ensures max width
                        children: [
                          _buildSocialButton(
                            onTap: () {
                              loginCubit.loginWithGoogle(context);
                            },
                            icon: Assets.googleLogo2,
                            label: StringConst.continueWithGoogle,
                            height: 25,
                            width: 25,
                          ),
                          const SizedBox(height: 16),
                          if (Platform.isIOS)
                            _buildSocialButton(
                              onTap: () {
                                loginCubit.loginWithApple(context);
                              },
                              icon: Assets.appleLogo,
                              label: StringConst.continueWithApple,
                              height: 25,
                              width: 25,
                            ),
                          // SignInWithAppleButton(
                          //   onPressed: () {
                          //     loginCubit.loginWithApple(context);
                          //   },
                          // ),
                          if (Platform.isIOS) const SizedBox(height: 11),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch, // Ensures max width
                        children: [
                          _buildSocialButton(
                            onTap: () {
                              context.push(RouteTo.login);
                            },
                            icon: Assets.emailInbox,
                            label: StringConst.continueWithEmail,
                            height: 18.75,
                            width: 25,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          StringConst.dontHaveAcc,
                          style: AppTextStyle.normalTextStyleNew(
                            size: 16,
                            color: AppColor.black,
                            fontweight: FontWeight.w400,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // context.go(RouteTo.signup);
                            context.go(RouteTo.getStartSignUp);
                          },
                          child: Text(
                            StringConst.signUp,
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
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: StringConst.agreeText,
                          style: AppTextStyle.normalTextStyleNew(
                            size: 15,
                            color: AppColor.greyNew,
                            fontweight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: StringConst.termsText,
                              style: AppTextStyle.normalTextStyleNew(
                                size: 15,
                                color: AppColor.black,
                                fontweight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.push(RouteTo.termsAndPrivacy
                                      .replaceFirst(':flowType', 'Terms'));
                                },
                            ),
                            TextSpan(
                              text: " and ",
                              style: AppTextStyle.normalTextStyleNew(
                                size: 15,
                                color: AppColor.greyNew,
                                fontweight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: StringConst.privacyText,
                              style: AppTextStyle.normalTextStyleNew(
                                size: 15,
                                color: AppColor.black,
                                fontweight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.push(RouteTo.termsAndPrivacy
                                      .replaceFirst(':flowType', 'Privacy'));
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onTap,
    required String icon,
    required String label,
    required double height,
    required double width,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
            color: Color.fromARGB(255, 172, 166, 166)), // Plain border
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            height: height,
            width: width,
          ),
          const SizedBox(width: 12),
          Text(
            // label,
            // style: const TextStyle(
            //   color: Colors.black,
            //   fontSize: 16,
            // ),
            label,
            style: AppTextStyle.normalTextStyleNew(
              size: 16,
              color: AppColor.black,
              fontweight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
