import 'package:musa_app/Cubit/auth/ForgotPassword/forgot_password_state.dart';
import 'package:musa_app/Utility/packages.dart';

class ForgotPwCubit extends Cubit<ForgotPwState> {
  Repository repository = Repository();
  ForgotPwCubit() : super(ForgotPwInitial());

  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> emailKey = GlobalKey();

  forgotPassValidate({required BuildContext context}) {
    if (emailKey.currentState!.validate()) {
      forgotWithCred();
    }
  }

  forgotWithCred() async {
    emit(ForgotPwInitial());
    emit(ForgotPwLoading());
    await repository.forgotPassword(email: emailController.text).then((value) {
      value.fold((left) {
        Prefs.setString(PrefKeys.email, emailController.text);
        emit(ForgotPwSuccess());
      }, (right) {
        emit(ForgotPwFailureState(errorMessage: right.message));
      });
    });
  }
}
