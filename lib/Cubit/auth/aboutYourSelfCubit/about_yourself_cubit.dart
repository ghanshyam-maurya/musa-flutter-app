import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:musa_app/Cubit/auth/aboutYourSelfCubit/about_yourself_state.dart';
import 'package:musa_app/Resources/api_url.dart';
import 'package:musa_app/Utility/packages.dart';
import 'package:http/http.dart' as http;

class AboutyourselfCubit extends Cubit<AboutyourselfState> {
  AboutyourselfCubit() : super(AboutyourselfInitial());

  TextEditingController bioController = TextEditingController();
  String? audioFilePath;
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  updateBio() async {
    var userID = Prefs.getString(PrefKeys.uId);
    emit(AboutyourselfInitial());
    emit(AboutyourselfLoading());
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(ApiUrl.updateBioApi));
      if (bioController.text.isNotEmpty) {
        request.fields
            .addAll({'user_id': userID.toString(), 'bio': bioController.text});
        Prefs.setString(PrefKeys.about, bioController.text);
      } else if (audioFilePath != null) {
        request.files.add(await http.MultipartFile.fromPath('voice_file',
            audioFilePath != null ? audioFilePath.toString() : ""));
      } else if (bioController.text.isNotEmpty && audioFilePath != null) {
        request.fields
            .addAll({'user_id': userID.toString(), 'bio': bioController.text});
        request.files.add(await http.MultipartFile.fromPath('voice_file',
            audioFilePath != null ? audioFilePath.toString() : ""));
      } else {}
      http.StreamedResponse response = await request.send();
      var responseBody = await http.Response.fromStream(response);
      print(userID);
      print(responseBody.body);
      var res = jsonDecode(responseBody.body);
      if (response.statusCode == 200) {
        emit(AboutyourselfSuccess());
      } else {
        emit(AboutyourselfFailure(res['message']));
      }
    } catch (e) {
      emit(
          AboutyourselfFailure("An error occurred while updating the bio: $e"));
    }
  }
}
