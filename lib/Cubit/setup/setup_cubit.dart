import 'package:musa_app/Utility/packages.dart';

class SetupCubit extends Cubit<SetupState> {
  SetupCubit() : super(SetupInitial());

  Repository repository = Repository();

  init() {
    Future.delayed(const Duration(seconds: 3), () {
      autoLogin();
    });
  }

  Future<void> autoLogin() async {
    try {
      emit(SetupLoading());

      final String? token = Prefs.getString(PrefKeys.token);
      print(token);

      if (token != null && token.isNotEmpty && token != "") {
        emit(SetupFetched());
      } else {
        emit(SetupInitial());
      }
    } catch (e) {
      emit(SetupError(errorMessage: 'An error occurred: ${e.toString()}'));
    }
  }
}
