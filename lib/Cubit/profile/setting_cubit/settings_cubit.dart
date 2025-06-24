import 'package:google_sign_in/google_sign_in.dart';
import 'package:musa_app/Cubit/profile/setting_cubit/settings_state.dart';
import '../../../Repository/ApiServices/api_client.dart';
import '../../../Resources/api_url.dart';
import '../../../Utility/packages.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  final ApiClient _apiClient = ApiClient();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  init() {}

  Future<void> logOut() async {
    emit(SettingsLoading());
   
    try {
      final token = Prefs.getString(PrefKeys.token);

     
      if (token == null) {
        emit(LogoOutError("Token not found. Please log in again."));
        return;
      }

      final response = await _apiClient.post(
        ApiUrl.logOutUser,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final statusCode = response['status'];
      if (statusCode == 200) {

        emit(LogoOutSuccess(response['message']));

        await _googleSignIn.signOut();
        Prefs.clear();
        Prefs.clear();
      } else {
        emit(LogoOutError(response['message'] ?? "Unexpected error occurred."));
      }
    } catch (e) {
      emit(LogoOutError("Failed to logout: ${e.toString()}"));
    }
  }

  Future<void> deleteAccount() async {
    emit(SettingsLoading());
    try {
      final token = Prefs.getString(PrefKeys.token);

      debugPrint(token.toString());

      if (token == null) {
        emit(LogoOutError("Token not found. Please log in again."));
        return;
      }

      final response = await _apiClient.post(
        ApiUrl.deleteAccount,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final statusCode = response['status'];
      if (statusCode == 200) {
        emit(LogoOutSuccess(response['message']));
        await _googleSignIn.signOut();
       Prefs.clear();
      } else {
        emit(LogoOutError(response['message'] ?? "Unexpected error occurred."));
      }
    } catch (e) {
      emit(LogoOutError("Failed to delete: ${e.toString()}"));
    }
  }
}
