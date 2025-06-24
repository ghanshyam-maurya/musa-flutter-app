import 'dart:convert';

import 'package:musa_app/Cubit/auth/Otp/otp_state.dart';
import 'package:musa_app/Repository/ApiServices/api_client.dart';
import 'package:musa_app/Resources/api_url.dart';
import 'package:musa_app/Utility/packages.dart';

class OtpCubit extends Cubit<OtpState> {
  Repository repository = Repository();
  final ApiClient _apiClient = ApiClient();
  OtpCubit() : super(OtpInitial());

  TextEditingController otpController = TextEditingController();
  String email = '';
  String screenType = '';

  GlobalKey<FormState> otpKey = GlobalKey();

  // @override
  // Future<void> close() {
  //   otpController.dispose();
  //   return super.close();
  // }

  otpValideForm({required BuildContext context}) {
    if (otpKey.currentState!.validate()) {
      otpWithCred();
    }
  }

  otpWithCred() async {
    emit(OtpInitial());
    emit(OtpLoading());
    await repository
        .otpVerification(email: email, otp: otpController.text)
        .then((value) {
      value.fold((left) {
        Prefs.setString(PrefKeys.uId, left.user?.id ?? '');
        Prefs.setString(PrefKeys.token, left.token.toString());
        Utilities.setUserData(userData: jsonEncode(left.user));
        emit(OtpSuccess());
      }, (right) {
        emit(OtpFailureState(errorMessage: right.message));
      });
    });
  }

  Future<void> resendOTP() async {
    emit(OtpLoading());
    try {
      final response =
          await _apiClient.post(ApiUrl.resendOTPApi, body: {'email': email});
      final statusCode = response['status'];
      if (statusCode == 200) {
        emit(OtpResend(message: response['message']));
      } else {
        emit(OtpFailureState(errorMessage: response['message']));
      }
    } catch (e) {
      emit(OtpFailureState(errorMessage: "An error occurred: $e"));
    }
  }
}
