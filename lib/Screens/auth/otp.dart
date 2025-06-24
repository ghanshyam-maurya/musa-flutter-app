import 'package:flutter/gestures.dart';
import 'package:musa_app/Cubit/auth/Otp/otp_cubit.dart';
import 'package:musa_app/Cubit/auth/Otp/otp_state.dart';
import 'package:musa_app/Utility/app_validations.dart';
import 'package:musa_app/Utility/packages.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../Utility/musa_widgets.dart';

class Otp extends StatefulWidget {
  final String email;
  final String comingFrom;

  const Otp({required this.email, required this.comingFrom, super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  OtpCubit otpCubit = OtpCubit();

  @override
  void initState() {
    super.initState();
    otpCubit.email = widget.email;
    otpCubit.screenType = widget.comingFrom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OtpCubit, OtpState>(
        bloc: otpCubit,
        listener: (context, state) {
          if (state is OtpSuccess) {
            if (otpCubit.screenType == 'Forgot Password') {
              context.push(RouteTo.changePassword);
            } else {
              context.push(RouteTo.bottomNavBar);
            }
          }
          if (state is OtpResend) {
            MusaPopup.popUpDialouge(
                context: context,
                onPressed: () => context.pop(true),
                buttonText: 'Okay',
                title: 'Successful',
                description: state.message);
          }
          if (state is OtpFailureState) {
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
              buildOtpVerification(context),
              state is OtpLoading
                  ? MusaWidgets.loader(context: context, isForFullHeight: true)
                  : Container()
            ],
          );
        },
      ),
    );
  }

  Widget buildOtpVerification(BuildContext context) {
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
              key: otpCubit.otpKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: Icon(Icons.arrow_back_ios_new),
                  ),
                  SizedBox(height: 30),
                  Text(
                    StringConst.otpVerification,
                    style: AppTextStyle.normalTextStyleNew(
                      size: 24,
                      color: AppColor.black,
                      fontweight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: StringConst.weSentSmsWith6Digit,
                      style: AppTextStyle.normalTextStyleNew(
                        size: 14,
                        color: AppColor.greyNew,
                        fontweight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: ' ${widget.email}. ',
                          style: AppTextStyle.normalTextStyleNew(
                            size: 14,
                            color: AppColor.greyNew,
                            fontweight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: '${StringConst.changeEmail}\n',
                          style: AppTextStyle.normalTextStyleNew(
                            color: AppColor.primaryColor,
                            size: 14,
                            fontweight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        TextSpan(
                          text: StringConst.pleaseEnterItSoWeCanBeSure,
                          style: AppTextStyle.normalTextStyleNew(
                            color: AppColor.greyNew,
                            size: 14,
                            fontweight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  PinCodeTextField(
                    appContext: context,
                    controller: otpCubit.otpController,
                    length: 6,
                    keyboardType: TextInputType.number,
                    textStyle: AppTextStyle.mediumTextStyle(
                        color: AppColor.black, size: 24),
                    validator: MusaValidator.validatorOTP,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      fieldHeight: 45,
                      fieldWidth: 48,
                      inactiveColor: AppColor.hintTextColor,
                      activeColor: AppColor.primaryColor,
                      selectedColor: AppColor.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CommonButton(
                    title: StringConst.verify,
                    onTap: () {
                      otpCubit.otpValideForm(context: context);
                    },
                    color: AppColor.greenDark,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          StringConst.didntRecieveOTP,
                          style: AppTextStyle.normalTextStyleNew(
                            size: 14,
                            color: AppColor.greyNew,
                            fontweight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            otpCubit.resendOTP();
                            // Handle resend OTP
                          },
                          child: Text(
                            StringConst.sendOtpAgain,
                            style: AppTextStyle.normalTextStyleNew(
                              size: 14,
                              color: AppColor.primaryColor,
                              fontweight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
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
