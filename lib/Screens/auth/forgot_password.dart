import 'package:musa_app/Cubit/auth/ForgotPassword/forgot_password_cubit.dart';
import 'package:musa_app/Cubit/auth/ForgotPassword/forgot_password_state.dart';
import 'package:musa_app/Utility/app_validations.dart';
import 'package:musa_app/Utility/packages.dart';

import '../../Utility/musa_widgets.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  ForgotPwCubit forgotPwCubit = ForgotPwCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ForgotPwCubit, ForgotPwState>(
        bloc: forgotPwCubit,
        listener: (context, state) {
          if (state is ForgotPwSuccess) {
            context.push(RouteTo.otp, extra: {
              'email': forgotPwCubit.emailController.text,
              'comingFrom': 'Forgot Password'
            });
          }
          if (state is ForgotPwFailureState) {
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
              buildForgotScreen(context),
              state is ForgotPwLoading
                  ? MusaWidgets.loader(context: context, isForFullHeight: true)
                  : Container(),
            ],
          );
        },
      ),
    );
  }

  buildForgotScreen(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.backgound),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 20),
            child: Form(
              key: forgotPwCubit.emailKey,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Icon(Icons.arrow_back_ios_new)),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    StringConst.forgotPassword,
                    style: AppTextStyle.mediumTextStyle(
                      color: AppColor.black,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    StringConst.enterYourEmailToReset,
                    style: AppTextStyle.normalTextStyle(
                      color: AppColor.secondaryTextColor,
                      size: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Email TextField with dynamic border
                  CommonTextField(
                    controller: forgotPwCubit.emailController,
                    hintText: StringConst.email,
                    prefixIconPath: Assets.email,
                    validator: MusaValidator.validatorEmail,
                  ),
                  const SizedBox(height: 20),
                  CommonButton(
                      title: StringConst.send,
                      onTap: () {
                        forgotPwCubit.forgotPassValidate(context: context);
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
