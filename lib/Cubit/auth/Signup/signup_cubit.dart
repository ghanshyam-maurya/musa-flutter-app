import 'dart:io';
import 'package:musa_app/Cubit/auth/Signup/signup_state.dart';
import 'package:musa_app/Utility/packages.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../Repository/AppResponse/library_response.dart';

class SignupCubit extends Cubit<SignupState> {
  Repository repository = Repository();
  SignupCubit() : super(SignupInitial());

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  GlobalKey<FormState> signUpKey = GlobalKey();

  bool obsecureText1 = true;
  bool obsecureText2 = true;

  bool checkBox = false;
  // added for audio upload by Sailee Agni
  List<LibraryFile>? mediaLibrary = [];
  List<LibraryFile>? audioLibrary = [];
  String? audioFilePath;

  showPassword1() {
    obsecureText1 = !obsecureText1;
    emit(SignUpShowPassword());
  }

  showPassword2() {
    obsecureText2 = !obsecureText2;
    emit(SignUpShowPassword());
  }

  checkBoxClick(bool value) {
    checkBox = value;
    emit(SignUpCheckBox());
  }

  registerFormValid({required BuildContext context}) {
    if (signUpKey.currentState!.validate()) {
      signUpWithCred();
    }
  }

  signUpWithCred() async {
    var email = Prefs.getString(PrefKeys.email) ?? '';
    var password = Prefs.getString(PrefKeys.tempPassword) ?? '';
    emit(SignupInitial());
    emit(SignupLoading());
    await repository
        .signUp(
            email: email,
            password: password,
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            phone: mobileController.text,
            dateOfBirth: dobController.text,
            postalCode: zipCodeController.text,
            bio: bioController.text,
            voiceFile: audioFilePath)
        .then((value) {
      value.fold((left) {
        emit(SignupSuccess());
      }, (right) {
        emit(SignUpFailureState(errorMessage: right.message));
      });
    });
  }

  // getLibrary() async {
  //   try {
  //     await Connectivity().checkConnectivity().then((value) async {
  //       if (value != ConnectivityResult.none) {
  //         emit(SignupLoading());
  //         final result = await repository.getLibrary();
  //         result.fold(
  //           (left) {
  //             mediaLibrary = left.imageFile;
  //             audioLibrary = left.voiceFile;
  //             emit(SpeechToTextSuccess());
  //           },
  //           (right) {
  //             emit(SpeechToTextFailure(right.message!));
  //           },
  //         );
  //       } else {
  //         emit(SpeechToTextFailure(StringConst.noInternetConnection));
  //       }
  //     });
  //   } catch (e) {
  //     debugPrint("error : $e");
  //     emit(SpeechToTextFailure(e.toString()));
  //   }
  // }

  Future<void> speechToText() async {
    try {
      await Connectivity().checkConnectivity().then((value) async {
        if (value != ConnectivityResult.none) {
          emit(SignupLoading());
          final result =
              await repository.speechToText(musaFiles: [File(audioFilePath!)]);
          result.fold(
            (left) async {
              // await getLibrary();
              bioController.text = left['finalTranscript'];
              emit(SpeechToTextSuccess());
            },
            (right) {
              emit(SpeechToTextFailure(right.message!));
            },
          );
        } else {
          emit(SpeechToTextFailure(StringConst.noInternetConnection));
        }
      });
    } catch (e) {
      debugPrint("error : $e");
      emit(SpeechToTextFailure(e.toString()));
    }
  }
}
