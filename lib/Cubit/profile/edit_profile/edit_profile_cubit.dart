import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:musa_app/Cubit/profile/edit_profile/edit_profile_state.dart';
import 'package:musa_app/Repository/ApiServices/api_client.dart';
import 'package:musa_app/Resources/api_url.dart';
import 'package:musa_app/Utility/packages.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../Repository/AppResponse/Responses/user_detail_modle.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());
  Repository repository = Repository();
  final ApiClient _apiClient = ApiClient();
  File? selectedImageFile;
  FocusNode phoneFocusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dOBController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  ImagePicker imagePicker = ImagePicker();
  String? userImage;
  String? audioFilePath;
  String? removeProfilePic = '';
  String? removeBioFile = '';
  String? removeBioText = '';
  String? uploadedAudioFilePath;
  String? intialBioText;

  init() async {
    var userId = Prefs.getString(PrefKeys.uId);
    print("userId");
    print(userId);
    getUserDetails(userId: userId);
  }

  setUserDetail(UserDetail userDetail) {
    firstNameController.text = userDetail.user?.firstName ?? '';
    lastNameController.text = userDetail.user?.lastName ?? '';
    emailController.text = userDetail.user?.email ?? '';
    phoneController.text = userDetail.user?.phone ?? '';
    dOBController.text = userDetail.user?.dateOfBirth ?? '';
    zipController.text =
        userDetail.user?.postalCode ?? ''; // POST CODE is missing in api
    bioController.text = userDetail.user?.bio ?? '';
    userImage = userDetail.user?.photo ?? '';
    uploadedAudioFilePath = userDetail.user?.voiceFile ?? '';
    intialBioText = userDetail.user?.bio ?? '';
  }

  Future<void> getUserDetails({required userId}) async {
    emit(EditProfileLoading());
    try {
      final token = Prefs.getString(PrefKeys.token);
      final response = await _apiClient.post(ApiUrl.getUserDetails, headers: {
        'Authorization': 'Bearer $token',
      }, body: {
        'user_id': '$userId'
      });

      if (response['status'] == 200) {
        final userDetail = UserDetail.fromJson(response);
        debugPrint(userDetail.toString());
        setUserDetail(userDetail);
        emit(UserDetailsLoaded(userDetail));
      } else {
        emit(EditProfileError(
            'Failed to fetch user details: ${response['message']}'));
      }
    } catch (e) {
      emit(EditProfileError('An error occurred: $e'));
    }
  }

  Future<void> updateUser() async {
    emit(EditProfileLoading());
    final token = Prefs.getString(PrefKeys.token);

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiUrl.updateUserDetail),
      );
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      request.fields['first_name'] = firstNameController.text;
      request.fields['last_name'] = lastNameController.text;
      request.fields['date_of_birth'] = dOBController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['bio'] = bioController.text;
      request.fields['postal_code'] = zipController.text;
      print('selected image file ---------->$selectedImageFile');
      if (selectedImageFile != null) {
        print('selected image file ---------->$selectedImageFile');
        request.files.add(await http.MultipartFile.fromPath(
          'photo',
          selectedImageFile?.path ?? "",
          contentType: MediaType('image', 'jpeg'),
        ));
      }
      print('audioFilePath ---------->$audioFilePath');
      if (audioFilePath != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'voice_file',
          audioFilePath!,
          contentType: MediaType('audio', 'mp3'),
        ));
      }
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final responseBody = json.decode(responseData.body);
        print('response bofy ----------->$responseBody');
        Prefs.setString(PrefKeys.userId,
            "${responseBody['data']['first_name']} ${responseBody['data']['last_name']}");
        Utilities.setUserData(userData: jsonEncode(responseBody['data']));
        emit(editProfileSuccess(responseBody['message']));
      } else {
        final responseData = await http.Response.fromStream(response);
        final responseBody = json.decode(responseData.body);
        emit(EditProfileError(
            responseBody['message'] ?? "Unexpected error occurred."));
      }
    } catch (e) {
      emit(EditProfileError("Failed to update: ${e.toString()}"));
    }
  }

  Future<void> removePrfilePicBio() async {
    emit(EditProfileLoading());
    final token = Prefs.getString(PrefKeys.token);

    try {
      final response = await http.post(
        Uri.parse(ApiUrl.removeBionPic),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'remove_profilepic': removeProfilePic,
          'remove_biofile': removeBioFile,
          'remove_biotext': removeBioText
        }),
      );
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        // print("responsebody----------->$responseBody");
        Prefs.setString(PrefKeys.userId,
            "${responseBody['data']['first_name']} ${responseBody['data']['last_name']}");
        Utilities.setUserData(userData: jsonEncode(responseBody['data']));
        emit(ProfilePicUpdateSuccess(responseBody['message']));
      } else {
        final responseBody = json.decode(response.body);
        // print("responsebody----------->$responseBody");
        emit(EditProfileError(
            responseBody['message'] ?? "Unexpected error occurred."));
      }
    } catch (e) {
      emit(EditProfileError("Failed to update: ${e.toString()}"));
    }
  }

  Future<void> speechToText() async {
    try {
      await Connectivity().checkConnectivity().then((value) async {
        if (value != ConnectivityResult.none) {
          emit(EditProfileLoading());
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
