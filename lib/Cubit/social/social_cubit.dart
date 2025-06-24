import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:musa_app/Cubit/social/social_state.dart';
import 'package:musa_app/Repository/ApiServices/api_client.dart';
import 'package:musa_app/Repository/AppResponse/Responses/search_user_response.dart';
import 'package:musa_app/Resources/api_url.dart';

import '../../../Repository/AppResponse/social_musa_list_response.dart';
import '../../../Utility/musa_widgets.dart';
import '../../../Utility/packages.dart';

class SocialCubit extends Cubit<SocialState> {
  SocialCubit() : super(SocialListInitial());
  final ApiClient _apiClient = ApiClient();
  Repository repository = Repository();
  final ScrollController scrollController = ScrollController();

  String? userName;
  String? userProfilePicture;
  String? myUserId;

  int homePageNumber = 1;
  bool isLoadingMore = false;
  bool myFeedsLoaded = false;
  bool noDataNextPage = false;
  bool hasFeeds = false;

  List<MusaData> socialMusaList = [];
  List<MusaData> socialSearchMusaList = [];
  List<MusaData> myFeedsList = [];

  bool isFirstComeMusa = true;
  bool isFirstComeUser = true;

  int isSelectedIndex = 0;
  List<Users> searchUser = [];
  List<String> searchItem = ['MUSA', 'User'];

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
      socialMusaList = List<MusaData>.from(
          jsonDecode(cachedData).map((x) => MusaData.fromJson(x)));
      // Emit success so UI can show cached posts immediately
      emit(SocialListSuccess());
    }
  }

  // Get social feeds
  getSocialFeeds({required int page}) async {
    print("getSocialFeeds called with page: $page");
    try {
      if (page == 1) {
        emit(SocialListLoading());
      } else {
        isLoadingMore = true;
      }

      final result = await repository.getSocialMusaList(page: page);
      result.fold(
        (left) {
          if (left.data != null && left.data!.isNotEmpty) {
            if (page == 1) {
              noDataNextPage = false;
              socialMusaList.clear();
            }
            homePageNumber++;
            socialMusaList.addAll(left.data!);
          } else {
            noDataNextPage = true;
          }

          // Save posts to cache
          Hive.box('postsBox').put('cachedPosts', jsonEncode(socialMusaList));
          isLoadingMore = false;
          emit(SocialListSuccess());
        },
        (right) {
          isLoadingMore = false;
          emit(SocialListFailure(right.message!));
        },
      );
    } catch (e) {
      isLoadingMore = false;
      debugPrint("error : $e");
      emit(SocialListFailure(e.toString()));
    }
  }

  getSocialSearchFeeds({required int page}) async {
    try {
      if (isSelectedIndex == 0) {
        isFirstComeMusa = false;
      }
      if (isSelectedIndex == 1) {
        isFirstComeUser = false;
      }
      emit(HomeMusaSearchLoading());
      final result = await repository.getSocialMusaList(page: 1);
      result.fold(
        (left) {
          socialSearchMusaList.addAll(left.data!);
          emit(SocialListSearchSuccess());
        },
        (right) {
          emit(HomeMusaSearchError(right.message!));
        },
      );
    } catch (e) {
      debugPrint("error : $e");
      emit(HomeMusaSearchError(e.toString()));
    }
  }

  // Get my latest feeds
  // getMyFeeds({required int page, required String userId}) async {
  //   try {
  //     emit(MyFeedsListLoading());
  //     final result =
  //         await repository.getMyFeedsList(page: page, userId: userId);
  //     result.fold(
  //       (left) {
  //         if (left.data != null && left.data!.isNotEmpty) {
  //           myFeedsLoaded = true;
  //           myFeedsList.addAll(left.data!);
  //         }
  //         emit(MyFeedsListSuccess());
  //       },
  //       (right) {
  //         emit(MyFeedsListFailure(right.message!));
  //       },
  //     );
  //   } catch (e) {
  //     debugPrint("error : $e");
  //     emit(MyFeedsListFailure(e.toString()));
  //   }
  // }
  getMyFeeds({required int page, required String userId}) async {
    print("getMyFeeds called with page: $page");
    try {
      emit(MyFeedsListLoading());

      final result =
          await repository.getMyFeedsList(page: page, userId: userId);
      result.fold(
        (left) {
          if (left.data != null && left.data!.isNotEmpty) {
            hasFeeds = true;
            myFeedsList.addAll(left.data!);
          } else {
            hasFeeds = false;
          }

          emit(MyFeedsListSuccess());
        },
        (right) {
          hasFeeds = false;
          emit(MyFeedsListFailure(right.message!));
        },
      );
    } catch (e) {
      hasFeeds = false;
      debugPrint("error : $e");
      emit(MyFeedsListFailure(e.toString()));
    }
    print("getMyFeeds completed with hasFeeds: $hasFeeds");
  }

  // Display request api
  Future<void> displayRequest({required String musaId, context}) async {
    await Connectivity().checkConnectivity().then((value) async {
      if (value != ConnectivityResult.none) {
        emit(DisplayRequestCalled());
        await repository
            .displayRequest(
          musaId: musaId,
        )
            .then((value) {
          value.fold((left) {
            if (left.data != null) {
              MusaWidgets.requestSuccessful(context, "  Display");
            }
          },
              (right) => DisplayRequestFailure(
                  right.message ?? StringConst.somethingWentWrong));
        });
      } else {
        emit(DisplayRequestFailure(StringConst.noInternetConnection));
      }
    });
  }

  // Load more feeds when user scrolls to bottom
  void loadMoreFeeds() {
    getSocialFeeds(page: homePageNumber);
  }

  itemSelection(index) {
    emit(HomeMusaSearchLoading());
    isSelectedIndex = index;
    emit(SearchMusaSearchSuccess());
  }

  Future<void> getSearchMusaList(searchItem, selectedIndex) async {
    await Connectivity().checkConnectivity().then((value) async {
      if (value != ConnectivityResult.none) {
        try {
          emit(HomeMusaSearchLoading());
          final token = Prefs.getString(PrefKeys.token);
          final response = await _apiClient.post(
              selectedIndex == 0
                  ? "${ApiUrl.searchSocial}$searchItem"
                  : "${ApiUrl.userListSearch}$searchItem",
              headers: {'Authorization': 'Bearer $token'});
          if (response['status'] == 200) {
            final Object myMusaListData;
            if (selectedIndex == 0) {
              myMusaListData = SocialMusaListResponse.fromJson(response);
              // emit(SearchMusaSearchLoaded(myMusaListData));
              emit(SocialListSuccess());
            } else {
              myMusaListData = SearchUserResponse.fromJson(response);
              // searchUser = myMusaListData.users;
              print("searchUser=========");
              // print(searchUser.length);
              emit(SearchUserListLoaded());
              emit(SocialListSuccess());
            }
          } else {
            emit(HomeMusaSearchError(
                'Failed to fetch my musa list: ${response['message']}'));
          }
        } catch (e) {
          emit(HomeMusaSearchError('An error occurred: $e'));
        }
      } else {
        emit(HomeMusaSearchError('An error occurred:'));
      }
    });
  }

  void toggleLike(
      {required String musaId,
      required bool isLiked,
      required int likeCount}) async {
    try {
      bool newLikeStatus = !isLiked;
      int newLikeCount = newLikeStatus ? likeCount + 1 : likeCount - 1;

      // API Call
      await repository.likeMusa(musaId: musaId);

      // Emit the new state
      emit(LikeUpdatedState(isLiked: newLikeStatus, likeCount: newLikeCount));
    } catch (e) {
      print("Error updating like: $e");
    }
  }
}
