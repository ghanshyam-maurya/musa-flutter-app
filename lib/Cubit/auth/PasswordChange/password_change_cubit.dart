import 'package:musa_app/Cubit/auth/PasswordChange/password_change_state.dart';
import 'package:musa_app/Utility/packages.dart';

class ChangePwCubit extends Cubit<ChangePwState> {
  Repository repository = Repository();
  ChangePwCubit() : super(ChangePwInitial());

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  GlobalKey<FormState> changePwKey = GlobalKey<FormState>();

  bool obsecureText1 = true;
  bool obsecureText2 = true;

  showPassword1() {
    obsecureText1 = !obsecureText1;
    emit(ShowPassword());
  }

  showPassword2() {
    obsecureText2 = !obsecureText2;
    emit(ShowPassword());
  }

  changePassValidate({required BuildContext context}) {
    if (changePwKey.currentState!.validate()) {
      changePasswordWithCred();
    }
  }

  changePasswordWithCred() async {
    var email = Prefs.getString(PrefKeys.email);
    emit(ChangePwInitial());
    emit(ChangePwLoading());
    await repository
        .changePassword(
            currentPassword: passwordController.text,
            newPassword: confirmController.text)
        .then((value) {
      value.fold((left) {
        emit(ChangePwSuccess(message: left.message));
      }, (right) {
        emit(ChangePwFailureState(errorMessage: right.message));
      });
    });
  }
}
