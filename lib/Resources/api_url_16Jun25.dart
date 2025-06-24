abstract class ApiUrl {
  /// Dev url.
  static const String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3NzNlYTA5MTliMTgxZTI5ZWNmYmJkNCIsImVtYWlsIjoic2hha3RpMDJAeW9wbWFpbC5jb20iLCJpYXQiOjE3Mzc5NjgyOTh9.2cuygyccmpDIkmKzOYW-ufmlfggxfhQqse7cw_cgfIY';

  // static const String baseUrl = 'http://3.95.185.46:3000/api';
  static const String baseUrl = 'https://dev.musa.art/api';
  // static const String baseUrl = 'http://localhost:8080/api';

  // static const String baseUrl = 'http://192.168.31.52:8080/api';
  // static const String baseUrl = 'http://3.95.185.46:3000/api';

  // static const String baseUrl = 'https://78c2-2401-4900-7b35-46da-6c5e-67a5-a6a4-482.ngrok-free.app/api';
  static const String loginApi = '$baseUrl/users/login';
  static const String isExists = '$baseUrl/users/is-email-exist';
  static const String signUpApi = '$baseUrl/users/signup';
  static const String verifyOTPApi = '$baseUrl/users/verify-otp';
  static const String forgotPasswordApi = '$baseUrl/users/forgot';
  static const String resendOTPApi = '$baseUrl/users/resend-otp';
  static const String updateBioApi = '$baseUrl/users/update-bio';
  static const String changePasswordApi = '$baseUrl/users/change-password';
  static const String socialLoginApi = '$baseUrl/users/google';
  static const String completeUserInfo =
      '$baseUrl/users/social-profile-complete';

  static const String logOutUser = '$baseUrl/users/logout';
  static const String getUserDetails = '$baseUrl/users/detail';
  static const String deleteAccount = '$baseUrl/users/delete';
  static const String updateUserDetail = '$baseUrl/users/update-user';
  static const String getMusaAlbum = '$baseUrl/users/musa/category/list';
  static const String getMusaSubAlbum = '$baseUrl/users/musa/sub-category/list';
  static const String addMusa = '$baseUrl/users/musa/create';
  static const String getLibrary = '$baseUrl/users/library/images_files';
  static const String getAllLibrary = '$baseUrl/users/library/all_files';
  static const String createAlbum = '$baseUrl/users/musa/category/create';
  static const String createSubAlbum = '$baseUrl/users/musa/sub-album/create';
  static const String getMyMusaAlbumData = '$baseUrl/users/musa/my-musa/list';
  static const String getMySectionAlbumListApi =
      '$baseUrl/users/musa/my-musa/list';
  static const String getSocialMusaListApi =
      '$baseUrl/users/musa/social/list?page&limit';
  static const String getMySectionSubAlbumList =
      '$baseUrl/users/musa/my-musa/sub-album';
  static const String getUserList = '$baseUrl/users/list';
  static const String inviteContributor =
      '$baseUrl/users/musa/contributor/invite';
  static const String getProfileMusaListApi =
      '$baseUrl/users/musa/profile/my-musa';
  static const String getProfileContributedMusaListApi =
      '$baseUrl/users/musa/profile/my-contributed-musa';
  static const String likeUnlikeMusaApi = '$baseUrl/users/musa/likes';
  static const String getGroupList = '$baseUrl/chats/grouplist';
  static const String chatHistory = '$baseUrl/chats/history';
  static const String addLibrary = '$baseUrl/users/musa/upload-file/library';
  static const String getCommentList = '$baseUrl/users/musa/comment/list';
  static const String postMusaComment = '$baseUrl/users/musa/comment';
  static const String musaContributors =
      '$baseUrl/users/musa/contributor/users';
  static const String removeContributor =
      '$baseUrl/users/musa/contributor/remove';
  static const String deleteMusa = '$baseUrl/users/musa/delete';
  static const String searchSocial =
      '$baseUrl/users/musa/social/search?search=';
  static const String userListSearch = '$baseUrl/users/list/search?search=';
  static const String displayRequest = '$baseUrl/users/display-request';
  static const String notificationList =
      '$baseUrl/users/notification-list?page&limit&subject_type';
  static const String contributorUpdate = '$baseUrl/users/contributor-update';
  static const String displayUpdateUpdate = '$baseUrl/users/display-update';
  static const String contributorsList = '$baseUrl/users/musa/contributor/list';
  static const String chatsSend = '$baseUrl/chats/send';
  static const String removeContributorsList =
      '$baseUrl/users/musa/contributor/remove';
  static const String getSubAlbumMusaList =
      '$baseUrl/users/musa/profile/musa-by-subalbum';
  static const String deleteAllNotifications =
      '$baseUrl/users/delete-notifications';
  static const String speechToText = '$baseUrl/users/speech-to-text';
}
