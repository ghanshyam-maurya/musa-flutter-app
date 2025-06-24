import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:musa_app/Utility/shared_preferences.dart';
import '../../../Repository/ApiServices/api_client.dart';
import '../../../Repository/AppResponse/social_musa_list_response.dart';
import '../../../Repository/ApiServices/repository.dart';
import '../../../Resources/api_url.dart';
import '../../../Resources/string_const.dart';
import 'sub_album_musa_state.dart';

class SubAlbumMusaCubit extends Cubit<SubAlbumMusaState> {
  SubAlbumMusaCubit() : super(SubAlbumMusaInitial());

  Repository repository = Repository();
  List<MusaData> subAlbumMusaList = [];
  ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;
  final ApiClient _apiClient = ApiClient();

  Future<void> getSubAlbumMusaList({required String subAlbumId}) async {
    try {
      await Connectivity().checkConnectivity().then((value) async {
        if (value != ConnectivityResult.none) {
          emit(SubAlbumMusaLoading());
          final userId = Prefs.getString(PrefKeys.uId);
          final result = await repository.getSubAlbumMusaList(
              subAlbumId: subAlbumId, userId: userId ?? '');
          result.fold(
            (left) {
              if (left.data != null) {
                subAlbumMusaList = left.data!;
              }
              emit(SubAlbumMusaSuccess());
            },
            (right) {
              emit(SubAlbumMusaFailure(right.message!));
            },
          );
        } else {
          emit(SubAlbumMusaFailure(StringConst.noInternetConnection));
        }
      });
    } catch (e) {
      debugPrint("error : $e");
      emit(SubAlbumMusaFailure(e.toString()));
    }
  }

  // Method to handle like/unlike MUSA
  Future<void> handleLikeUnlike(String musaId) async {
    // Implement like/unlike functionality
  }

  // Method to handle share MUSA
  Future<void> handleShare(String musaId) async {
    // Implement share functionality
  }

  void deleteMusa(MusaData musaData) {
    subAlbumMusaList.removeWhere((item) => item.id == musaData.id);
    deleteMusaApi(musaId: musaData.id.toString(),
        userId: musaData.userId);
  }

  //Event for delete musa api
  Future<void> deleteMusaApi({required String musaId, userId}) async {
    emit(SubAlbumMusaLoading());
    await Connectivity().checkConnectivity().then((value) async {
      if (value != ConnectivityResult.none) {
        try {
          final token = Prefs.getString(PrefKeys.token);
          final response = await _apiClient.post(ApiUrl.deleteMusa,
              headers: {'Authorization': 'Bearer $token'},
              body: {'musa_id': musaId});
          if (response['status'] == 200) {

            print("DELETED SSSSSSSSSSS");
            emit(SubAlbumMusaSuccess());
          } else {}
        } catch (e) {
          print(e);
        }
      }
    });
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
} 