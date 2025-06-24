import 'dart:io';
import 'dart:convert';
import 'package:musa_app/Utility/packages.dart';
import 'package:musa_app/Resources/api_url.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:musa_app/Cubit/auth/Login/login_state.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:musa_app/Repository/ApiServices/api_client.dart';
import 'package:musa_app/Repository/AppResponse/library_response.dart';
import 'package:http/http.dart' as http;

class LoginCubit extends Cubit<LoginState> {
  Repository repository = Repository();
  final ApiClient _apiClient = ApiClient();
  LoginCubit() : super(LoginInitialState());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController dOBController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  String clientId = "";
  bool obsecureText = false;
  // added for audio upload by Sailee Agni
  List<LibraryFile>? mediaLibrary = [];
  List<LibraryFile>? audioLibrary = [];
  String? audioFilePath;
  String? transcribedText;

  GlobalKey<FormState> loginKey = GlobalKey();

  showPassword() {
    obsecureText = !obsecureText;
    emit(PasswordObsecure());
  }

  setPrefilledValues() {
    firstNameController.text = Prefs.getString(PrefKeys.firstName) ?? '';
    lastNameController.text = Prefs.getString(PrefKeys.lastName) ?? '';
  }

  loginFormValidate() {
    if (loginKey.currentState!.validate()) {
      loginWithCred(
          username: emailController.text, password: passwordController.text);
    }
  }

  // isEmailExist({username}) async {
  //   emit(LoginInitialState());
  //   emit(LoggedInLoadingState());
  //   await repository.isExists(email: username).then((value) {
  //     value.fold((left) {
  //       emit(UserLoginIncomplete());
  //       print(left);
  //       if (left.user?.isSignupComplete != true) {
  //         emit(LoginAuthorizedState());
  //       } else {
  //         emit(LoginFailureState(errorMessage: left.message));
  //       }
  //     }, (right) {
  //       print(right);
  //       emit(LoginFailureState(errorMessage: right.message));
  //     });
  //   });
  // }
  isEmailExist({username}) async {
    emit(LoginInitialState());
    emit(LoggedInLoadingState());

    await repository.isExists(email: username).then((value) {
      value.fold((left) {
        // Email does NOT exist — safe to proceed to signup
        emit(LoginAuthorizedState()); // Navigate to signup page
      }, (right) {
        // Email exists — show error
        emit(LoginFailureState(errorMessage: right.message));
      });
    });
  }

  loginWithCred({username, password}) async {
    emit(LoginInitialState());
    emit(LoggedInLoadingState());
    await repository.login(email: username, password: password).then((value) {
      value.fold((left) {
        print('Signup complete: ${left.user?.isSignupComplete}');

        if (left.user?.isSignupComplete != true) {
          // if (true) {
          // Check if profile is incomplete
          emit(UserLoginIncomplete());
        } else {
          Prefs.setString(PrefKeys.token, left.token.toString());
          Prefs.setString(PrefKeys.uId, left.user?.id ?? "");
          Prefs.setString(PrefKeys.userId,
              "${left.user?.firstName} ${left.user?.lastName}");
          Utilities.setUserData(userData: jsonEncode(left.user));
          emit(LoginAuthorizedState());
        }
      }, (right) {
        emit(LoginFailureState(errorMessage: right.message));
      });
    });
  }

  Future<void> loginWithApple(BuildContext context) async {
    emit(LoggedInLoadingState());

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print("Apple Sign-In Success");
      print("Email: ${appleCredential.email}");
      print(
          "Full Name: ${appleCredential.givenName} ${appleCredential.familyName}");

      // Use identityToken if available, else use authorizationCode
      if (appleCredential.identityToken == null) {
        throw Exception("Apple identity token is null. Unable to sign in.");
      }

      // final OAuthCredential credential = OAuthProvider("apple.com").credential(
      //   idToken: appleCredential.identityToken,
      //   accessToken: appleCredential.authorizationCode, // Might be required
      // );

      // print("Firebase OAuth Credential: $credential");

      // // Sign in to Firebase
      // final UserCredential userCredential =
      //     await FirebaseAuth.instance.signInWithCredential(credential);
      // final user = userCredential.user;

      // if (user != null) {
      // Use stored email if not returned
      final userDisplayName =
          "${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}"
              .trim();

      // String userEmail = user.email ?? appleCredential.email ?? "No email";

      // Call your API for social login
      await socialLogin(
        appleCredential.email ?? "No email",
        appleCredential.identityToken ?? "",
        'apple',
        {
          'displayName': userDisplayName,
          'email': appleCredential.email,
        },
      );
      // } else {
      //   emit(LoginFailureState(errorMessage: "Apple sign-in failed."));
      // }
    } catch (e) {
      print("Apple Login Error: ${e.toString()}");
      emit(LoginFailureState(
          errorMessage: "Failed to sign in with Apple: ${e.toString()}"));
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    emit(LoginInitialState());
    emit(LoggedInLoadingState());

    try {
      if (Platform.isIOS) {
        clientId =
            //"1040555097165-itjm02kvfd1rrci0p27m9sm0qv7elqme.apps.googleusercontent.com";
            "996750277788-sa8los5nl373khifrbb18l0pfdttonfq.apps.googleusercontent.com";
      } else {
        clientId =
            //"1040555097165-h0gvnj1llbb7u5qk6uvjvctl0rjq266b.apps.googleusercontent.com";
            "996750277788-ltnkt462ga372hl7vnul379t1652pids.apps.googleusercontent.com";
      }
      final GoogleSignIn googleSignIn = GoogleSignIn(
          serverClientId: clientId,
          // serverClientId:
          //     '1040555097165-h0gvnj1llbb7u5qk6uvjvctl0rjq266b.apps.googleusercontent.com',
          scopes: ['email', 'profile']);
      await googleSignIn.signOut();
      emit(LoggedInLoadingState());

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        emit(LoginFailureState(errorMessage: "Google sign-in was cancelled."));
        return;
      }
      emit(LoggedInLoadingState());
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final idToken = googleAuth.idToken;
      if (idToken == null) {
        emit(LoginFailureState(errorMessage: "Google ID token not found."));
        return;
      }
      await socialLogin(googleUser.email, idToken, "google", googleUser);
      // final OAuthCredential credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth.accessToken,
      //   idToken: googleAuth.idToken,
      // );

      // final UserCredential userCredential =
      //     await FirebaseAuth.instance.signInWithCredential(credential);
      // final user = userCredential.user;

      // if (user != null) {
      //   print("user.email========");
      //   print(user.email);

      // } else {
      //   emit(LoginFailureState(errorMessage: "Google sign-in failed."));
      // }
    } catch (e) {
      // print(e);
      print("Error during Google Sign-In: $e");
      emit(LoginFailureState(
          errorMessage: "Failed to sign in with Google: ${e.toString()}"));
    }
  }

  Future<void> socialLogin(
    String email,
    String socialToken,
    loginSource,
    dynamic user,
  ) async {
    // print(ApiUrl.socialLoginApi);
    try {
      final response = await _apiClient.post(
        ApiUrl.socialLoginApi,
        body: {
          // 'login_source': loginSource,
          'token': socialToken,
          // 'email': email
        },
      );
      print("API response: $response");

      final statusCode = response['status'];
      if (statusCode == 200) {
        String userId = response['user']['id'];
        String userEmail = response['user']['email'];
        Prefs.setString(PrefKeys.email, userEmail);
        Prefs.setString(PrefKeys.userType, "social");
        bool isCompleteUserInfo = response['user']['is_signup_complete'];
        // print("isCompleteUserInfo : $isCompleteUserInfo");
        if (isCompleteUserInfo == false) {
          try {
            final nameParts = user.displayName?.split(' ') ?? [];
            if (nameParts.isNotEmpty) {
              Prefs.setString(PrefKeys.firstName, nameParts[0]);
              if (nameParts.length > 1) {
                Prefs.setString(
                    PrefKeys.lastName, nameParts.sublist(1).join(' '));
              }
            }
            // print(nameParts);
          } catch (e) {
            debugPrint(e.toString());
          }
          print("Emitting UserLoginIncomplete...hashCode: $hashCode");
          // emit(UserLoginIncomplete());
          // Future.delayed(Duration(milliseconds: 300), () {
          //   emit(UserLoginIncomplete());
          // });
          emit(UserLoginIncomplete());
        } else {
          String token = response['token'];
          Prefs.setString(PrefKeys.token, token);
          Prefs.setString(PrefKeys.uId, userId);
          Prefs.setString(PrefKeys.userId, userId);

          Prefs.setString(PrefKeys.userName,
              "${response['user']['first_name']} ${response['user']['last_name']}");
          Utilities.setUserData(userData: jsonEncode(response['user']));
          emit(LoginPlateFormState());
        }
      } else if (statusCode == 400 || statusCode == 401) {
        emit(LoginFailureState(errorMessage: response['message']));
      } else if (statusCode == 500) {
        emit(LoginFailureState(
            errorMessage: "Server error. Please try again later."));
      } else {
        emit(LoginFailureState(
            errorMessage: response['message'] ?? "Unexpected error occurred."));
      }
    } catch (e) {
      emit(LoginFailureState(
          errorMessage: "Failed to complete social login: ${e.toString()}"));
    }
  }

  Future<void> completeUserInfo() async {
    if (loginKey.currentState!.validate()) {
      var email = Prefs.getString(PrefKeys.email);
      emit(LoggedInLoadingState());
      try {
        // final body = {
        //   'email': email,
        //   'first_name': firstNameController.text,
        //   'last_name': lastNameController.text,
        //   'date_of_birth': dOBController.text,
        //   'postal_code': zipController.text,
        //   'phone': mobileController.text,
        //   'bio': bioController.text,
        //   // 'voice_file': audioFilePath,
        // };

        // if (mobileController.text != '' && mobileController.text.isNotEmpty) {
        //   body['phone'] = mobileController.text;
        // }

        // final response =
        //     await _apiClient.post(ApiUrl.completeUserInfo, body: body);
        // print("API RESPONSE: $response");

        var request =
            http.MultipartRequest('POST', Uri.parse(ApiUrl.completeUserInfo));
        request.fields.addAll({
          'email': email ?? '',
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'date_of_birth': dOBController.text,
          'postal_code': zipController.text,
          'phone': mobileController.text,
          'bio': bioController.text,
        });
        if (audioFilePath != null) {
          request.files.add(
              await http.MultipartFile.fromPath('voice_file', audioFilePath!));
        }

        http.StreamedResponse response = await request.send();
        final responseString =
            await response.stream.bytesToString(); // read the response body
        final responseData = jsonDecode(responseString); // decode the JSON
        final statusCode = responseData['status'];

        if (statusCode == 200) {
          String userId = responseData['user']['id'];
          String userEmail = responseData['user']['email'];
          String token = responseData['token'];
          Prefs.setString(PrefKeys.token, token);
          Prefs.setString(PrefKeys.uId, userId);
          Prefs.setString(PrefKeys.userId,
              "${responseData['user']['first_name']} ${responseData['user']['last_name']}");
          Utilities.setUserData(userData: jsonEncode(responseData['user']));
          emit(UserInfoUpdate());
        } else if (statusCode == 400 || statusCode == 401) {
          emit(LoginFailureState(errorMessage: responseData['message']));
        } else if (statusCode == 500) {
          emit(LoginFailureState(
              errorMessage: "Server error. Please try again later."));
        } else {
          emit(LoginFailureState(errorMessage: "Unexpected error occurred."));
        }
      } catch (e) {
        emit(LoginFailureState(errorMessage: e.toString()));
      }
    }
  }

  Future<List<dynamic>> processSelectedAudios(List<String> audioPaths) async {
    List<dynamic> processedFiles = [];

    for (var path in audioPaths) {
      if (path.startsWith('http')) {
        processedFiles.add(path);
      } else {
        processedFiles.add(File(path));
      }
    }

    return processedFiles;
  }

  // getLibrary() async {
  //   try {
  //     await Connectivity().checkConnectivity().then((value) async {
  //       if (value != ConnectivityResult.none) {
  //         emit(LoggedInLoadingState());
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
          emit(LoggedInLoadingState());
          final result =
              await repository.speechToText(musaFiles: [File(audioFilePath!)]);
          result.fold(
            (left) async {
              bioController.text = left['finalTranscript'];
              // await getLibrary();
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
