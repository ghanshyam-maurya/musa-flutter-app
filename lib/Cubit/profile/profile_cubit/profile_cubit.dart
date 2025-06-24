import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:musa_app/Cubit/profile/profile_cubit/profile_state.dart';
import 'package:musa_app/Utility/packages.dart';

import '../../../Repository/ApiServices/api_client.dart';
import '../../../Repository/AppResponse/Responses/logged_in_response.dart';
import '../../../Repository/AppResponse/musa_contributors_list_modal.dart';
import '../../../Repository/AppResponse/social_musa_list_response.dart';
import 'package:http/http.dart' as http;

import '../../../Resources/api_url.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  Repository repository = Repository();
  final ApiClient _apiClient = ApiClient();

  String? userName;
  String? userProfilePicture;
  String? userBio;
  String? userEmail;
  String? userVoiceAudio;

  bool isMyProfile = false;

  int musaCount = 0;
  int contributedCount = 0;
  User userData = Utilities.getUserData();

  String? myUserId;
  int selectedTabIndex = 0;

  bool myFeedsLoaded = false;
  bool myFeedsLoading = false;

  bool contributedFeedsLoaded = false;
  bool contributedFeedsLoading = false;

  bool myFeedsLoadedFailed = false;
  bool contributedFeedsLoadedFailed = false;

  List<MusaData> myFeedsList = [];
  List<MusaData> contributedFeedsList = [];
  final ValueNotifier<int> selectedTabIndexValue = ValueNotifier(0);

  onTabChange(index, userId) {
    selectedTabIndex = index;
    selectedTabIndexValue.value = index;
    if (selectedTabIndex == 1) {
      getContributedFeeds(page: 1, userId: userId);
    }
    if (selectedTabIndex == 0) {
      getMyFeeds(page: 1, userId: userId);
    }
    emit(TabChangeState());
    if (myFeedsLoaded) {
      emit(ProfileMyFeedsListSuccess());
    }
    if (contributedFeedsLoaded) {
      emit(ProfileContributedFeedsListSuccess());
    }
  }

  checkIsMyProfile({required String userId}) {
    myUserId = userData.id ?? Prefs.getString(PrefKeys.uId);
    if (myUserId == userId || userId.isEmpty) {
      isMyProfile = true;
      setUserData(userData: userData);
    } else {
      isMyProfile = false;
      getOtherUserProfile(userId: userId);
    }
    if (!myFeedsLoaded) {
      getMyFeeds(page: 1, userId: userId);
    }
    if (!contributedFeedsLoaded) {
      getContributedFeeds(page: 1, userId: userId);
    }
  }

  void deleteMusa(MusaData musaData) {
    myFeedsList.removeWhere((item) => item.id == musaData.id);
    deleteMusaApi(musaId: musaData.id.toString(), userId: musaData.userId);
    musaCount = myFeedsList.length;
  }

  //Event for delete musa api
  Future<void> deleteMusaApi({required String musaId, userId}) async {
    emit(ProfileMyFeedsListLoading());
    await Connectivity().checkConnectivity().then((value) async {
      if (value != ConnectivityResult.none) {
        try {
          final token = Prefs.getString(PrefKeys.token);
          final response = await _apiClient.post(ApiUrl.deleteMusa,
              headers: {'Authorization': 'Bearer $token'},
              body: {'musa_id': musaId});
          if (response['status'] == 200) {
            print("DELETED SSSSSSSSSSS");
            emit(ProfileMyFeedsListSuccess());
          } else {}
        } catch (e) {
          print(e);
        }
      }
    });
  }

  //Set user data
  setUserData({User? userData}) {
    if (userData != null) {
      userName = '${userData.firstName} ${userData.lastName}';
      userProfilePicture = userData.photo;
      userBio = userData.bio;
      userEmail = userData.email;
      userVoiceAudio = userData.voiceFile ?? '';
    }
  }

  //Get other user profile
  getOtherUserProfile({required String userId}) async {
    try {
      await Connectivity().checkConnectivity().then((value) async {
        if (value != ConnectivityResult.none) {
          emit(OtherUserProfileLoading());
          final result = await repository.getOtherUserProfile(userId: userId);
          result.fold(
            (left) {
              if (left.user != null) {
                setUserData(userData: left.user);
              }
              emit(OtherUserProfileSuccess());
            },
            (right) {
              emit(OtherUserProfileFailure(right.message!));
            },
          );
        } else {
          emit(OtherUserProfileFailure(StringConst.noInternetConnection));
        }
      });
    } catch (e) {
      debugPrint("error : $e");
      emit(OtherUserProfileFailure(e.toString()));
    }
  }

  // Get my  feeds
  getMyFeeds({required int page, required String userId}) async {
    try {
      myFeedsList.clear();
      emit(ProfileMyFeedsListLoading());
      myFeedsLoading = true;
      final result =
          await repository.getMyFeedsList(page: page, userId: userId);
      result.fold(
        (left) {
          if (left.data != null && left.data!.isNotEmpty) {
            musaCount = left.data!.length;
            myFeedsList.addAll(left.data!);
          }
          myFeedsLoaded = true;
          myFeedsLoadedFailed = false;
          myFeedsLoading = false;
          emit(ProfileMyFeedsListSuccess());
        },
        (right) {
          myFeedsLoadedFailed = true;
          myFeedsLoaded = false;
          myFeedsLoading = false;
          emit(ProfileMyFeedsListFailure(right.message!));
        },
      );
    } catch (e) {
      debugPrint("error : $e");
      myFeedsLoading = false;
      myFeedsLoadedFailed = true;
      myFeedsLoaded = false;
      emit(ProfileMyFeedsListFailure(e.toString()));
    }
  }

  // Get contributed  feeds
  getContributedFeeds({required int page, required String userId}) async {
    try {
      contributedFeedsList.clear();
      emit(ProfileContributedFeedsListLoading());
      contributedFeedsLoading = true;
      final result = await repository.getMyContributedFeedsList(
          page: page, userId: userId);
      result.fold(
        (left) {
          if (left.data != null && left.data!.isNotEmpty) {
            contributedCount = left.data!.length;
            contributedFeedsList.addAll(left.data!);
          }
          contributedFeedsLoaded = true;
          contributedFeedsLoadedFailed = false;
          contributedFeedsLoading = false;
          emit(ProfileContributedFeedsListSuccess());
        },
        (right) {
          contributedFeedsLoaded = false;
          contributedFeedsLoading = false;
          contributedFeedsLoadedFailed = true;
          emit(ProfileContributedFeedsListFailure(right.message!));
        },
      );
    } catch (e) {
      debugPrint("error : $e");
      contributedFeedsLoaded = false;
      contributedFeedsLoading = false;
      contributedFeedsLoadedFailed = true;
      emit(ProfileContributedFeedsListFailure(e.toString()));
    }
  }

  //Event for get contributors list in a particular musa api
  Future<void> getContributorListOfMusaApi({required String musaId}) async {
    await Connectivity().checkConnectivity().then((value) async {
      if (value != ConnectivityResult.none) {
        try {
          emit(MusaContributorsListLoading());
          if (musaId.isNotEmpty) {
            final token = Prefs.getString(PrefKeys.token);

            debugPrint(token.toString());

            var headers = {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
            };
            var request =
                http.Request('GET', Uri.parse(ApiUrl.musaContributors));
            request.body = json.encode({"musa_id": musaId});
            request.headers.addAll(headers);
            http.StreamedResponse response = await request.send();
            /* final response = await _apiClient.post(
                        ApiUrl.getCommentList,
                        headers: {
                          'Authorization': 'Bearer $token',
                        },
                        body: {
                          'musa_id':musaId
                        }
                    );*/

            if (response.statusCode == 200) {
              //print("response :${response.stream.bytesToString()}");

              final responseBody = await response.stream.bytesToString();

              final musaCommentList =
                  MusaContributorListModel.fromJson(jsonDecode(responseBody));

              debugPrint(musaCommentList.toString());

              emit(MusaContributorsListLoaded(musaCommentList));
            } else {
              emit(MusaContributorsListError('Failed to fetch comment list'));
            }
          }
        } catch (e) {
          print(e);
        }
      } else {
        emit(MusaContributorsListNoInternetState());
      }
    });
  }

  void updateContributorsList(MusaContributorListModel updatedList) {
    emit(MusaContributorsListLoaded(updatedList));
  }

  //Event for remove contributor api
  Future<bool> removeContributorApi(
      {required String musaId, required String contributorId}) async {
    await Connectivity().checkConnectivity().then((value) async {
      if (value != ConnectivityResult.none) {
        try {
          if (musaId.isNotEmpty && contributorId.isNotEmpty) {
            final token = Prefs.getString(PrefKeys.token);

            debugPrint(token.toString());
            //  emit(RemoveContributorLoading(contributorId)); // Emit loading state

            var headers = {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            };
            var request =
                http.Request('POST', Uri.parse(ApiUrl.removeContributor));
            request.body = json
                .encode({'musa_id': musaId, 'contribute_id': contributorId});
            request.headers.addAll(headers);

            http.StreamedResponse response = await request.send();

            if (response.statusCode == 200) {
              //  emit(RemoveContributorSuccess(contributorId)); // Emit success state
              return true;
            } else {
              // emit(RemoveContributorFailure(contributorId, ''));
              return false;
            }
          } else {
            return false;
          }
        } catch (e) {
          print(e);
          // emit(RemoveContributorFailure(contributorId, e.toString()));
          return false;
        }
      } else {
        //  emit(RemoveContributorFailure(contributorId, StringConst.noInternetConnection));
        return false;
      }
    });
    return false;
  }
}
