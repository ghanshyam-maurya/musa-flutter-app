import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:musa_app/Resources/api_url.dart';
import 'package:musa_app/Utility/packages.dart';
import 'package:musa_app/models/my_musa_contributor_model.dart';
import 'mymusa_contributor_state.dart';

class MyMusaContributorsCubit extends Cubit<MyMusaContributorsState> {
  MyMusaContributorsCubit() : super(MyMusaContributorsInitial());

  Future<void> fetchMyMusaContributors() async {
    emit(MyMusaContributorsLoading());
    final token = Prefs.getString(PrefKeys.token);

    if (token == null || token.isEmpty) {
      emit(const MyMusaContributorsError("Authentication token not found."));
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(ApiUrl.getMyMusaContributors),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final musaResponse = MusaContributorsResponse.fromJson(responseBody);

        if (musaResponse.data != null && musaResponse.data!.isNotEmpty) {
          emit(MyMusaContributorsSuccess(musaResponse.data!));
        } else {
          emit(const MyMusaContributorsError("No contributors found."));
        }
      } else {
        final responseBody = json.decode(response.body);
        emit(MyMusaContributorsError(
            responseBody['message'] ?? "Failed to fetch contributors."));
      }
    } catch (e) {
      emit(MyMusaContributorsError(
          "An unexpected error occurred: ${e.toString()}"));
    }
  }

  Future<void> removeContributor({
    required String musaId,
    required String contributeId,
  }) async {
    // Emit loading state to show the loader on screen
    emit(ContributorRemovalLoading());
    final token = Prefs.getString(PrefKeys.token);

    try {
      final response = await http.post(
        // Ensure 'removeContributor' is defined in your ApiUrl class
        Uri.parse(ApiUrl.removeContributor),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'musa_id': musaId,
          'contribute_id': contributeId,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        // Emit success to show the snackbar
        emit(ContributorRemovalSuccess(responseBody['message']));
        // As requested, immediately fetch the latest list to refresh the UI
        await fetchMyMusaContributors();
      } else {
        final responseBody = json.decode(response.body);
        emit(ContributorRemovalError(
            responseBody['message'] ?? 'Failed to remove contributor.'));
      }
    } catch (e) {
      emit(ContributorRemovalError('An error occurred: ${e.toString()}'));
    }
  }
}
