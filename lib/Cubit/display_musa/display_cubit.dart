import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:musa_app/Cubit/display_musa/display_state.dart';
import '../../../Repository/AppResponse/social_musa_list_response.dart';
import '../../../Utility/packages.dart';
import 'package:musa_app/Resources/api_url.dart';

class DisplayCubit extends Cubit<DisplayState> {
  DisplayCubit() : super(MyListInitial());
  Repository repository = Repository();

  String? userName;
  String? userProfilePicture;
  String? myUserId;

  int homePageNumber = 1;
  bool isLoadingMore = false;
  bool noDataNextPage = false;
  bool hasFeeds = false;

  List<MusaData> myMusaList = [];

  //Set user data
  setUserData() {
    var userData = Utilities.getUserData();
    userName = '${userData.firstName} ${userData.lastName}';
    userProfilePicture = userData.photo;
    myUserId = userData.id;
  }

  // Load cached posts first
  void loadCachedPosts() async {
    final box = Hive.box('postsBox');
    String? cachedData = box.get('cachedPosts');
    if (cachedData != null) {
      myMusaList = List<MusaData>.from(
          jsonDecode(cachedData).map((x) => MusaData.fromJson(x)));
      // Emit success so UI can show cached posts immediately
      emit(MyListSuccess());
    }
  }

  // Get social feeds
  getMyFeeds({required int page, required String userId}) async {
    print(
        "getSocialFeeds called with page---------------------------------------------->: $page");
    try {
      if (page == 1) {
        emit(MyListLoading());
      } else {
        isLoadingMore = true;
      }

      final result =
          await repository.getMyFeedsList(page: page, userId: userId);
      result.fold(
        (left) {
          if (left.data != null && left.data!.isNotEmpty) {
            if (page == 1) {
              noDataNextPage = false;
              myMusaList.clear();
              homePageNumber = 1;
            }
            homePageNumber = page;
            myMusaList.addAll(left.data!);
          } else {
            noDataNextPage = true;
          }

          // Save posts to cache
          Hive.box('postsBox').put('cachedPosts', jsonEncode(myMusaList));
          isLoadingMore = false;
          emit(MyListSuccess());
        },
        (right) {
          isLoadingMore = false;
          emit(MyListFailure(right.message!));
        },
      );
    } catch (e) {
      isLoadingMore = false;
      debugPrint("error : $e");
      emit(MyListFailure(e.toString()));
    }
  }

  // Load more feeds when user scrolls to bottom
  void loadMoreFeeds() {
    getMyFeeds(page: homePageNumber, userId: myUserId.toString());
  }

  updateMusa({required bool isHideDisplay, required String musaId}) async {
    print(
        "------------------------------------------->updateMusa called in display");
    print("musa id $musaId------------------hide $isHideDisplay");
    emit(EditMusaInitial());
    emit(EditMusaLoading());
    try {
      Dio dio = Dio();
      String? token = Prefs.getString(PrefKeys.token);
      var headers = {'Authorization': 'Bearer $token'};
      // First create the base map
      Map<String, dynamic> formMap = {
        'musa_id': musaId,
        'musa_type': isHideDisplay ? "only_me" : "public",
      };
      // Create FormData from the map
      FormData formData = FormData.fromMap(formMap);
      Response response = await dio.post(
        ApiUrl.updateMusa,
        data: formData,
        options: Options(
          headers: headers,
          validateStatus: (status) => status! < 500,
        ),
        // onSendProgress: (int sent, int total) {
        //   double progress = total > 0 ? (sent / total) : 0;
        //   loadingTime.value = progress;
        // },
      );
      if (response.statusCode == 200) {
        emit(EditMusaLoaded());
      } else {
        emit(EditMusaError(
            errorMessage: response.statusMessage ?? 'Error occurred.'));
      }
    } catch (e) {
      print("Error111: $e");
      emit(EditMusaError(errorMessage: 'Something went wrong.'));
    }
  }
}
