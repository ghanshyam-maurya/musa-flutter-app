part of 'repository.dart';

abstract class RepositoryImpl {
  Future<Either<MySectionAlbumListResponse, Failure>> getAlbumList();
  Future<Either<LibraryResponse, Failure>> getLibrary();
  Future<Either<LibraryResponse, Failure>> getAllLibrary();
  Future<Either<SocialMusaListResponse, Failure>> getSubAlbumMusaList(
      {required String subAlbumId, required String userId});
  Future<Either<dynamic, Failure>> uploadLibraryFiles({
    required List<File> musaFiles,
  });
  Future<Either<dynamic, Failure>> speechToText({
    required List<File> musaFiles,
  });
  Future<Either<MySectionSubAlbumListResponse, Failure>> getSubAlbumList(
      {required String albumId});
  Future<Either<CreateAlbumResponse, Failure>> createAlbum(title);
  Future<Either<CreateSubAlbumResponse, Failure>> createSubAlbum();
  Future<Either<DisplayRequestModel, Failure>> displayRequest(
      {required String musaId});
  Future<Either<NotificationListModel, Failure>> notificationList();
  Future<Either<AddContributorUserResponse, Failure>>
      getUserListWithContributorStatus({required String musaId});
  Future<Either<RemoveContributorResponse, Failure>> removeContributors(
      {required String contributorId, required String musaId});
  Future<Either<DisplayRequestUpdate, Failure>> displayUpdateNotification(
      {required String notificationId, required String status});
  Future<Either<UserDataResponse, Failure>> getOtherUserProfile(
      {required String userId});
  Future<Either<AddContributorsInMusaResponse, Failure>> addContributors(
      {required String musaId, required List<String> userId});

// Future<Either<UserRetrievedResponse, Failure>> updateUserStatus(

  Future<Either<LoggedInResponse, Failure>> login(
      {required String email, required String password});

  Future<Either<LoggedInResponse, Failure>> isExists({required String email});

  Future<Either<DeleteAllNotificationsResponse, Failure>>
      deleteAllNotifications();

  // Future<Either<UserRetrievedResponse, Failure>> updateUserStatus(
  //     {required String userId});

  Future<Either<SignUpRegisterResponse, Failure>> signUp(
      {required String email,
      required String password,
      required String firstName,
      required String lastName,
      required String phone,
      required String dateOfBirth,
      required String postalCode,
      required String bio,
      String? voiceFile});

  Future<Either<LoggedInResponse, Failure>> otpVerification({
    required String email,
    required String otp,
  });
  Future<Either<SignUpRegisterResponse, Failure>> forgotPassword({
    required String email,
  });
  Future<Either<SignUpRegisterResponse, Failure>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<LoggedInResponse, Failure>> createMusaApi({
    required String title,
    required String albumId,
    required String subAlbumId,
    required String musaType,
    required List<File> musaFiles,
    required String description,
    required List? contributorId,
    required List<String> audioFile,
    required imageType,
    required Function(double) onProgress,
  });

  Future<Either<AddContributorUserResponse, Failure>> getContributorUsers();
  Future<Either<int, Failure>> createMusaSubAlbum(
      {required String title, required String albumId});

  Future<Either<int, Failure>> likeMusa({
    required String musaId,
  });

  Future<Either<SocialMusaListResponse, Failure>> getSocialMusaList(
      {required int page});
  Future<Either<SocialMusaListResponse, Failure>> getMyFeedsList(
      {required int page, required String userId});
  Future<Either<SocialMusaListResponse, Failure>> getMyContributedFeedsList(
      {required int page, required String userId});
}
