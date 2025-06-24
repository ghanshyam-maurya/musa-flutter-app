import 'package:musa_app/Cubit/auth/PasswordChange/password_change_cubit.dart';
import 'package:musa_app/Cubit/auth/PasswordChange/password_change_state.dart';

import 'package:musa_app/Utility/app_validations.dart';
import 'package:musa_app/Utility/packages.dart';

import '../../Utility/musa_widgets.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  ChangePwCubit changePwCubit = ChangePwCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ChangePwCubit, ChangePwState>(
        bloc: changePwCubit,
        listener: (context, state) {
          if (state is ChangePwSuccess) {
            MusaPopup.popUpDialouge(
                context: context,
                onPressed: () {
                  context.pushReplacement(RouteTo.login);
                },
                buttonText: 'Okay',
                title: 'Success!',
                description: state.message);
          }
          if (state is ChangePwFailureState) {
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
              buildChangePassword(context),
              state is ChangePwLoading
                  ? MusaWidgets.loader(context: context, isForFullHeight: true)
                  : Container(),
            ],
          );
        },
      ),
    );
  }

  buildChangePassword(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage(Assets.backgound),
          //   fit: BoxFit.cover,
          // ),
          color: AppColor.white),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 20),
            child: Form(
              key: changePwCubit.changePwKey,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: Icon(Icons.close)),
                      SizedBox(
                          width: 26.sp), // Added spacing of 10 logical pixels
                      Text(
                        StringConst.changePassword,
                        style: AppTextStyle.semiMediumTextStyleNew(
                            color: Color(0xFF222222), size: 19.sp),
                      ),
                      Spacer(), // This will push the button to the right
                      // CommonButton(
                      //   title: 'save',
                      //   color: AppColor.greenDark,
                      //   onTap: () {
                      //     changePwCubit.changePassValidate(context: context);
                      //   },
                      // ),
                      GestureDetector(
                        onTap: () {
                          changePwCubit.changePassValidate(context: context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8),
                          decoration: BoxDecoration(
                            color: Color(0xFF00674E),
                            borderRadius: BorderRadius.circular(10),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black.withOpacity(0.25),
                            //     spreadRadius: 1,
                            //     blurRadius: 5,
                            //     offset: Offset(0, 3),
                            //   ),
                            // ],
                          ),
                          child: Text(
                            'Save',
                            style: AppTextStyle.semiTextStyle(
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  const SizedBox(height: 20),
                  CommonTextField(
                    controller: changePwCubit.passwordController,
                    hintText: 'Current Password',
                    prefixIconPath: Assets.key,
                    isPassword: true,
                    // validator: MusaValidator.validatorPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      if (value.length < 8) {
                        return "Password must be at least 8 characters";
                      }
                      return null;
                    },
                    obscureText: changePwCubit.obsecureText1,
                    onToggleObscure: () {
                      changePwCubit.showPassword1();
                    },
                  ),
                  const SizedBox(height: 20),
                  CommonTextField(
                    controller: changePwCubit.confirmController,
                    hintText: 'New Password',
                    prefixIconPath: Assets.key,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      if (value.length < 8) {
                        return "Password must be at least 8 characters";
                      }
                      return null;
                    },
                    obscureText: changePwCubit.obsecureText2,
                    onToggleObscure: () {
                      changePwCubit.showPassword2();
                    },
                  ),
                  SizedBox(
                    height: 20,
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
