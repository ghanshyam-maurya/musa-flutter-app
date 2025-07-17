import 'dart:convert';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import 'package:musa_app/Repository/AppResponse/Responses/add_contributor_user_response.dart';
import 'package:musa_app/Repository/AppResponse/Responses/logged_in_response.dart';
import 'package:musa_app/Repository/AppResponse/Responses/signUp_register_response.dart';
import 'package:musa_app/Repository/AppResponse/library_response.dart';
import 'package:musa_app/Resources/api_url.dart';
import '../../Resources/user_data_response.dart';
import '../../Utility/packages.dart';
import '../AppResponse/ErrorHandlingResponse/failure.dart';
import '../AppResponse/add_contributors_in_musa_response.dart';
import '../AppResponse/create_album_respose.dart';
import '../AppResponse/create_sub_album_response.dart';
import '../AppResponse/delete_all_notification_response.dart';
import '../AppResponse/display_request_model.dart';
import '../AppResponse/display_request_update_model.dart';
import '../AppResponse/my_section_album_list.dart';
import '../AppResponse/my_section_sub_album_list.dart';
import '../AppResponse/notification_list_model.dart';
import '../AppResponse/remove_contributor_model.dart';
import '../AppResponse/social_musa_list_response.dart';
part 'repository_impl.dart';

class Repository implements RepositoryImpl {
  @override
  Future<Either<MySectionAlbumListResponse, Failure>> getAlbumList() async {
    Uri url = Uri.parse(ApiUrl.getMusaAlbum);
    var token = Prefs.getString(PrefKeys.token);
    try {
      http.Response response =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        return Left(
            MySectionAlbumListResponse.fromJson(jsonDecode(response.body)));
      } else if (response.statusCode == 401) {
        return Right(Failure.fromJson(jsonDecode(response.body)));
      }
      return Right(Failure(message: StringConst.somethingWentWrong));
    } catch (e) {
      debugPrint("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
  }

  @override
  Future<Either<MySectionSubAlbumListResponse, Failure>> getSubAlbumList(
      {required String albumId}) async {
    // TODO: implement getSubAlbumList
    Uri url = Uri.parse(ApiUrl.getMusaSubAlbum);
    final token = Prefs.getString(PrefKeys.token);
    try {
      http.Response response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({'album_id': albumId}));

      if (response.statusCode == 200) {
        return Left(
          MySectionSubAlbumListResponse.fromJson(jsonDecode(response.body)),
        );
      } else if (response.statusCode == 401) {
        return Right(
          Failure.fromJson(
            jsonDecode(response.body),
          ),
        );
      }
      return Right(Failure(message: StringConst.somethingWentWrong));
    } catch (e) {
      debugPrint("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
  }

  @override
  Future<Either<MySectionSubAlbumListResponse, Failure>>
      getMySectionSubAlbumList({required String albumId}) async {
    // TODO: implement getSubAlbumList
    Uri url = Uri.parse(ApiUrl.getMySectionSubAlbumList);
    final token = Prefs.getString(PrefKeys.token);
    try {
      http.Response response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({'album_id': albumId}));

      if (response.statusCode == 200) {
        return Left(
          MySectionSubAlbumListResponse.fromJson(jsonDecode(response.body)),
        );
      } else if (response.statusCode == 401) {
        return Right(
          Failure.fromJson(
            jsonDecode(response.body),
          ),
        );
      }
      return Right(Failure(message: StringConst.somethingWentWrong));
    } catch (e) {
      debugPrint("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
  }

  @override
  Future<Either<MySectionAlbumListResponse, Failure>>
      getMySectionAlbumList() async {
    // TODO: implement getSubAlbumList
    Uri url = Uri.parse(ApiUrl.getMySectionAlbumListApi);
    final token = Prefs.getString(PrefKeys.token);
    try {
      http.Response response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return Left(
          MySectionAlbumListResponse.fromJson(jsonDecode(response.body)),
        );
      } else if (response.statusCode == 401) {
        return Right(
          Failure.fromJson(
            jsonDecode(response.body),
          ),
        );
      }
      return Right(Failure(message: StringConst.somethingWentWrong));
    } catch (e) {
      debugPrint("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
  }

  @override
  Future<Either<CreateAlbumResponse, Failure>> createAlbum(title) async {
    Uri url = Uri.parse(ApiUrl.createAlbum);
    final token = Prefs.getString(PrefKeys.token);
    try {
      http.Response response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode({"title": title}));
      print("response.body=========Album");
      print(response.body);

      if (response.statusCode == 200) {
        return Left(CreateAlbumResponse.fromJson(jsonDecode(response.body)));
      } else if (response.statusCode == 401) {
        return Right(Failure.fromJson(jsonDecode(response.body)));
      }
      return Right(Failure(message: StringConst.somethingWentWrong));
    } catch (e) {
      debugPrint("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
  }

  @override
  Future<Either<CreateSubAlbumResponse, Failure>> createSubAlbum() async {
    // TODO: implement createSubAlbum
    Uri url = Uri.parse(ApiUrl.createAlbum);
    var token = Prefs.getString(PrefKeys.token);

    try {
      http.Response response =
          await http.post(url, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        return Left(
          CreateSubAlbumResponse.fromJson(
            jsonDecode(response.body),
          ),
        );
      } else if (response.statusCode == 401) {
        return Right(
          Failure.fromJson(
            jsonDecode(response.body),
          ),
        );
      }
      return Right(Failure(message: StringConst.somethingWentWrong));
    } catch (e) {
      debugPrint("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
  }

  @override
  Future<Either<DisplayRequestModel, Failure>> displayRequest(
      {required String musaId}) async {
    // TODO: implement displayRequest
    Uri url = Uri.parse(ApiUrl.displayRequest);
    var token = Prefs.getString(PrefKeys.token);
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var request = http.Request('POST', url);
      request.body = json.encode({"musa_id": musaId});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return Left(
          DisplayRequestModel.fromJson(
            jsonDecode(responseBody),
          ),
        );
      } else if (response.statusCode == 401) {
        return Right(
          Failure.fromJson(
            jsonDecode(responseBody),
          ),
        );
      }
    } catch (e) {
      print("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
    return Right(Failure(message: StringConst.somethingWentWrong));
  }

  @override
  Future<Either<NotificationListModel, Failure>> notificationList() async {
    // TODO: implement notificationList
    Uri url = Uri.parse(ApiUrl.notificationList);
    var token = Prefs.getString(PrefKeys.token);
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var request = http.MultipartRequest('GET', url);

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return Left(
          NotificationListModel.fromJson(
            jsonDecode(responseBody),
          ),
        );
      } else if (response.statusCode == 401) {
        return Right(
          Failure.fromJson(
            jsonDecode(responseBody),
          ),
        );
      }
    } catch (e) {
      print("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
    return Right(Failure(message: StringConst.somethingWentWrong));
  }

  @override
  Future<Either<DisplayRequestUpdate, Failure>> displayUpdateNotification(
      {required String notificationId, required String status}) async {
    // TODO: implement contributorUpdateNotification
    Uri url = Uri.parse(ApiUrl.displayUpdateUpdate);
    var token = Prefs.getString(PrefKeys.token);
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var request = http.Request('POST', url);
      request.body =
          json.encode({"notification_id": notificationId, "status": status});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return Left(
          DisplayRequestUpdate.fromJson(
            jsonDecode(responseBody),
          ),
        );
      } else if (response.statusCode == 401) {
        return Right(
          Failure.fromJson(
            jsonDecode(responseBody),
          ),
        );
      }
    } catch (e) {
      print("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
    return Right(Failure(message: StringConst.somethingWentWrong));
  }

  @override
  Future<Either<AddContributorUserResponse, Failure>>
      getUserListWithContributorStatus(
          {required String musaId, String? searchQuery}) async {
    // TODO: implement getUserListWithContributorStatus
    //final token = await SharedPreferencesHelper.getToken();
    // Uri url = Uri.parse(ApiUrl.contributorsList);
    Uri url = Uri.parse(ApiUrl.contributorsList);
    if (searchQuery != null && searchQuery.isNotEmpty) {
      url = Uri.parse('${ApiUrl.contributorsList}?search=$searchQuery');
    }
    var token = Prefs.getString(PrefKeys.token);
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var request = http.Request('POST', url);
      request.body = json.encode({
        "musa_id": musaId,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return Left(
          AddContributorUserResponse.fromJson(
            jsonDecode(responseBody),
          ),
        );
      } else if (response.statusCode == 401) {
        return Right(
          Failure.fromJson(
            jsonDecode(responseBody),
          ),
        );
      }
    } catch (e) {
      print("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
    return Right(Failure(message: StringConst.somethingWentWrong));
  }

  @override
  Future<Either<RemoveContributorResponse, Failure>> removeContributors(
      {required String contributorId, required String musaId}) async {
    // TODO: implement removeContributors

    // final token = await SharedPreferencesHelper.getToken();
    Uri url = Uri.parse(ApiUrl.removeContributor);
    var token = Prefs.getString(PrefKeys.token);
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var request = http.Request('POST', url);
      request.body =
          json.encode({"contribute_id": contributorId, "musa_id": musaId});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return Left(
          RemoveContributorResponse.fromJson(
            jsonDecode(responseBody),
          ),
        );
      } else if (response.statusCode == 401) {
        return Right(
          Failure.fromJson(
            jsonDecode(responseBody),
          ),
        );
      }
    } catch (e) {
      print("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
    return Right(Failure(message: StringConst.somethingWentWrong));
  }

  @override
  Future<Either<LoggedInResponse, Failure>> login(
      {required String email, required String password}) async {
    try {
      http.Response response = await http.post(Uri.parse(ApiUrl.loginApi),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}));
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        return Left(LoggedInResponse.fromJson(jsonDecode(response.body)));
      } else if (response.statusCode == 401) {
        return Right(Failure.fromJson(jsonDecode(response.body)));
      } else if (response.statusCode == 500) {
        return Right(Failure.fromJson(jsonDecode(response.body)));
      }
    } catch (e) {
      print("Error : $e");
      return Right(Failure(message: 'Something went wrong, try again later.'));
    }

    return Right(Failure(message: 'Something went wrong, try again later.'));
  }

  @override
  Future<Either<LoggedInResponse, Failure>> isExists(
      {required String email}) async {
    try {
      http.Response response = await http.post(Uri.parse(ApiUrl.isExists),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email}));
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody);

      if (response.statusCode == 200) {
        // return Left(LoggedInResponse.fromJson(responseBody));
        if (responseBody['exists'] == false) {
          // Email does not exist — OK to go to signup
          return Left(LoggedInResponse.fromJson(responseBody));
        } else {
          // Email already exists — show error
          return Right(Failure(message: responseBody['message']));
        }
      } else if (response.statusCode == 401) {
        return Right(Failure.fromJson(responseBody));
      }
    } catch (e) {
      print("Error : $e");
      return Right(Failure(message: 'Something went wrong, try again later.'));
    }

    return Right(Failure(message: 'Something went wrong, try again later.'));
  }

  @override
  Future<Either<SignUpRegisterResponse, Failure>> signUp(
      {required String email,
      required String password,
      required String firstName,
      required String lastName,
      required String phone,
      required String dateOfBirth,
      required String postalCode,
      required String bio,
      String? voiceFile}) async {
    try {
      // http.Response response = await http.post(Uri.parse(ApiUrl.signUpApi),
      //     headers: {'Content-Type': 'application/json'},
      //     body: json.encode({
      //       "email": email,
      //       "password": password,
      //       "first_name": firstName,
      //       "last_name": lastName,
      //       "phone": phone != '' ? phone : '',
      //       "date_of_birth": dateOfBirth,
      //       "postal_code": postalCode
      //     }));
      // print(response.body);
      var request = http.MultipartRequest('POST', Uri.parse(ApiUrl.signUpApi));
      request.fields.addAll({
        'email': email ?? '',
        "password": password,
        'first_name': firstName,
        'last_name': lastName,
        'date_of_birth': dateOfBirth,
        'postal_code': postalCode,
        'phone': phone != '' ? phone : '',
        'bio': bio,
      });
      if (voiceFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('voice_file', voiceFile));
      }

      http.StreamedResponse response = await request.send();
      final responseString =
          await response.stream.bytesToString(); // read the response body
      final responseData = jsonDecode(responseString); // decode the JSON
      print("Status code: $responseData");
      final statusCode = responseData['status'];

      if (statusCode == 200) {
        return Left(SignUpRegisterResponse.fromJson(responseData['user']));
      } else if (statusCode == 401) {
        // return Right(Failure.fromJson(responseData['message']));
        return Right(Failure(message: responseData['message']));
      }
    } catch (e) {
      print("Error : $e");
      return Right(Failure(message: 'Something went wrong, try again later.'));
    }

    return Right(Failure(message: 'Something went wrong, try again later.'));
  }

  @override
  Future<Either<LoggedInResponse, Failure>> otpVerification(
      {required String email, required String otp, screenType}) async {
    try {
      http.Response response = await http.post(Uri.parse(ApiUrl.verifyOTPApi),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "email": email,
            "email_verified_otp": otp,
          }));
      if (response.statusCode == 200) {
        return Left(LoggedInResponse.fromJson(jsonDecode(response.body)));
      } else if (response.statusCode == 401) {
        return Right(Failure.fromJson(jsonDecode(response.body)));
      }
    } catch (e) {
      print("Error : $e");
      return Right(Failure(message: 'Something went wrong, try again later.'));
    }

    return Right(Failure(message: 'Something went wrong, try again later.'));
  }

  @override
  Future<Either<SignUpRegisterResponse, Failure>> forgotPassword(
      {required String email}) async {
    try {
      http.Response response = await http.post(
          Uri.parse(ApiUrl.forgotPasswordApi),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({"email": email}));
      print(response.body);
      if (response.statusCode == 200) {
        return Left(SignUpRegisterResponse.fromJson(jsonDecode(response.body)));
      } else if (response.statusCode == 401 || response.statusCode == 404) {
        return Right(Failure.fromJson(jsonDecode(response.body)));
      }
    } catch (e) {
      print("Error : $e");
      return Right(Failure(message: 'Something went wrong, try again later.'));
    }

    return Right(Failure(message: 'Something went wrong, try again later.'));
  }

  @override
  Future<Either<SignUpRegisterResponse, Failure>> changePassword(
      {required String currentPassword, required String newPassword}) async {
    try {
      var token = Prefs.getString(PrefKeys.token);
      http.Response response = await http.post(
          Uri.parse(ApiUrl.changePasswordApi),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode(
              {"oldPassword": currentPassword, 'newPassword': newPassword}));
      // print(response.body);
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Left(SignUpRegisterResponse.fromJson(jsonDecode(response.body)));
      } else if (response.statusCode == 401 ||
          response.statusCode == 404 ||
          response.statusCode == 400) {
        // print("response-----------> : ${response.body}");
        // Extract message from response
        String errorMessage =
            responseData['message'] ?? 'Unknown error occurred';
        return Right(Failure(message: errorMessage));
      }
    } catch (e) {
      // print("Error------------------> : $e");
      return Right(Failure(message: 'Something went wrong, try again later.'));
    }
    return Right(Failure(message: 'Something went wrong, try again later.'));
  }

  @override
  Future<Either<SocialMusaListResponse, Failure>> getSocialMusaList(
      {required int page}) async {
    // TODO: implement getSocialMusaList
    Uri url = Uri.parse(ApiUrl.getSocialMusaListApi);
    var token = Prefs.getString(PrefKeys.token);
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var request = http.Request('POST', url);
      request.body = json.encode({"page": page});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return Left(
          SocialMusaListResponse.fromJson(
            jsonDecode(responseBody),
          ),
        );
      } else if (response.statusCode == 401) {
        return Right(
          Failure.fromJson(
            jsonDecode(responseBody),
          ),
        );
      }
      return Right(Failure(message: StringConst.somethingWentWrong));
    } catch (e) {
      debugPrint("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
  }

  @override
  Future<Either<SocialMusaListResponse, Failure>> getArtMusaList(
      {required int page}) async {
    // TODO: implement getSocialMusaList
    Uri url = Uri.parse(ApiUrl.getArtMusaListApi);
    var token = Prefs.getString(PrefKeys.token);
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var request = http.Request('POST', url);
      request.body = json.encode({"page": page});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return Left(
          SocialMusaListResponse.fromJson(
            jsonDecode(responseBody),
          ),
        );
      } else if (response.statusCode == 401) {
        return Right(
          Failure.fromJson(
            jsonDecode(responseBody),
          ),
        );
      }
      return Right(Failure(message: StringConst.somethingWentWrong));
    } catch (e) {
      debugPrint("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
  }

  @override
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
  }) async {
    Dio dio = Dio();
    try {
      String? token = Prefs.getString(PrefKeys.token);

      var headers = {'Authorization': 'Bearer $token'};
      print(token);
      print(description);
      FormData formData = FormData.fromMap({
        'title': title,
        'album_id': albumId,
        'sub_album_id': subAlbumId,
        'musa_type': musaType,
        'description': description.isNotEmpty ? description : null,
      });
      if (contributorId != null && contributorId.isNotEmpty) {
        for (int i = 0; i < contributorId.length; i++) {
          formData.fields
              .add(MapEntry("contributor_id[$i]", contributorId[i].toString()));
        }
      }

      // Add image/video files
      for (File file in musaFiles) {
        formData.files.add(MapEntry(
          'musaFiles',
          await MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last),
        ));
      }

      // Add audio files
      for (String filePath in audioFile) {
        formData.files.add(MapEntry(
          'musaFiles',
          await MultipartFile.fromFile(filePath,
              filename: filePath.split('/').last),
        ));
      }

      Response response = await dio.post(
        ApiUrl.addMusa,
        data: formData,
        options: Options(
          headers: headers,
          validateStatus: (status) => status! < 500,
        ),
        onSendProgress: (int sent, int total) {
          double progress = total > 0 ? (sent / total) : 0;
          onProgress(progress);
        },
      );
      if (response.statusCode == 200) {
        return Left(LoggedInResponse.fromJson(response.data));
      } else {
        return Right(Failure.fromJson(response.data));
      }
    } catch (e) {
      print("Error: $e");
      return Right(Failure(message: 'Something went wrong, try again later.'));
    }
  }

  @override
  Future<Either<AddContributorUserResponse, Failure>> getContributorUsers(
      {String? searchQuery}) async {
    final token = Prefs.getString(PrefKeys.token);
    // Uri url = Uri.parse(ApiUrl.getUserList);
    Uri url = Uri.parse(ApiUrl.getUserList);
    if (searchQuery != null && searchQuery.isNotEmpty) {
      url = Uri.parse('${ApiUrl.getUserList}?search=$searchQuery');
    }
    try {
      http.Response response =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        return Left(
            AddContributorUserResponse.fromJson(jsonDecode(response.body)));
      } else {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        String errorMessage =
            responseJson['message'] ?? 'Unknown error occurred.';
        if (response.statusCode == 401) {
          return Right(Failure(message: errorMessage));
        } else {
          return Right(Failure(message: errorMessage));
        }
      }
    } catch (e) {
      return Right(Failure(message: 'Something went wrong, try again later.'));
    }
  }

  @override
  Future<Either<int, Failure>> createMusaSubAlbum(
      {required String title, required String albumId}) async {
    final token = Prefs.getString(PrefKeys.token);
    Uri url = Uri.parse(ApiUrl.createSubAlbum);
    try {
      http.Response response = await http.post(url, headers: {
        'Authorization': 'Bearer $token',
      }, body: {
        'title': title,
        'album_id': albumId
      });
      print("response.body=========SubAlbum");
      print(response.body);
      if (response.statusCode == 200) {
        return Left(1);
      } else {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        String errorMessage =
            responseJson['message'] ?? 'Unknown error occurred.';
        return Right(Failure(message: errorMessage));
      }
    } catch (e) {
      return Right(Failure(message: 'Something went wrong, try again later.'));
    }
  }

  @override
  Future<Either<UserDataResponse, Failure>> getOtherUserProfile(
      {required String userId}) async {
    // TODO: implement getOtherUserProfile
    Uri url = Uri.parse(ApiUrl.getUserDetails);
    var token = Prefs.getString(PrefKeys.token);
    try {
      http.Response response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'user_id': userId}));

      if (response.statusCode == 200) {
        return Left(UserDataResponse.fromJson(jsonDecode(response.body)));
      } else if (response.statusCode == 401) {
        return Right(Failure.fromJson(jsonDecode(response.body)));
      }
      return Right(Failure(message: StringConst.somethingWentWrong));
    } catch (e) {
      debugPrint("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
  }

  @override
  Future<Either<LibraryResponse, Failure>> getLibrary() async {
    Uri url = Uri.parse(ApiUrl.getLibrary);
    final token = Prefs.getString(PrefKeys.token);
    try {
      http.Response response =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        return Left(LibraryResponse.fromJson(jsonDecode(response.body)));
      } else if (response.statusCode == 401) {
        return Right(Failure.fromJson(jsonDecode(response.body)));
      }
      return Right(Failure(message: StringConst.somethingWentWrong));
    } catch (e) {
      debugPrint("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
  }

  @override
  Future<Either<LibraryResponse, Failure>> getAllLibrary() async {
    Uri url = Uri.parse(ApiUrl.getAllLibrary);
    final token = Prefs.getString(PrefKeys.token);
    try {
      http.Response response =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        return Left(LibraryResponse.fromJson(jsonDecode(response.body)));
      } else if (response.statusCode == 401) {
        return Right(Failure.fromJson(jsonDecode(response.body)));
      }
      return Right(Failure(message: StringConst.somethingWentWrong));
    } catch (e) {
      debugPrint("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
  }

  @override
  Future<Either<SocialMusaListResponse, Failure>> getMyFeedsList(
      {required int page, required String userId, String? filterDate}) async {
    // TODO: implement getMyFeedsList
    Uri url = Uri.parse(
        '${ApiUrl.getProfileMusaListApi}?page=$page&filter_date=$filterDate');
    // Uri url = Uri.parse(ApiUrl.getProfileMusaListApi);
    var token = Prefs.getString(PrefKeys.token);
    try {
      http.Response response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'user_id': userId}));

      if (response.statusCode == 200) {
        return Left(
          SocialMusaListResponse.fromJson(
            jsonDecode(response.body),
          ),
        );
      } else if (response.statusCode == 401) {
        return Right(
          Failure.fromJson(
            jsonDecode(response.body),
          ),
        );
      }
      return Right(Failure(message: StringConst.somethingWentWrong));
    } catch (e) {
      debugPrint("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
  }

  @override
  Future<Either<dynamic, Failure>> uploadLibraryFiles({
    required List<File> musaFiles,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(ApiUrl.addLibrary));

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer ${Prefs.getString(PrefKeys.token)}',
      });

      // Add multiple files with the same field name 'musaFiles'
      for (var file in musaFiles) {
        var multipartFile =
            await http.MultipartFile.fromPath('musaFiles', file.path);
        request.files.add(multipartFile);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        return Left(jsonDecode(response.body));
      } else {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        String errorMessage =
            responseJson['message'] ?? 'Unknown error occurred.';
        return Right(Failure(message: errorMessage));
      }
    } catch (e) {
      debugPrint("Upload error: $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
  }

  @override
  Future<Either<dynamic, Failure>> speechToText({
    required List<File> musaFiles,
  }) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(ApiUrl.speechToText));
      var multipartFile =
          await http.MultipartFile.fromPath('voice_file', musaFiles.first.path);
      request.files.add(multipartFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        return Left(jsonDecode(response.body));
      } else {
        try {
          final Map<String, dynamic> responseJson = jsonDecode(response.body);
          String errorMessage =
              responseJson['message'] ?? 'Unknown error occurred.';
          return Right(Failure(message: errorMessage));
        } catch (_) {
          return Right(
              Failure(message: 'Server error: ${response.statusCode}'));
        }
      }
    } catch (e) {
      debugPrint("Upload error: $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
  }

  @override
  Future<Either<SocialMusaListResponse, Failure>> getMyContributedFeedsList(
      {required int page, required String userId}) async {
    // TODO: implement getMyContributedFeedsList
    Uri url = Uri.parse(ApiUrl.getProfileContributedMusaListApi);
    var token = Prefs.getString(PrefKeys.token);
    try {
      http.Response response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'user_id': userId}));

      if (response.statusCode == 200) {
        return Left(
          SocialMusaListResponse.fromJson(
            jsonDecode(response.body),
          ),
        );
      } else if (response.statusCode == 401) {
        return Right(
          Failure.fromJson(
            jsonDecode(response.body),
          ),
        );
      }
      return Right(Failure(message: StringConst.somethingWentWrong));
    } catch (e) {
      debugPrint("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
  }

  @override
  Future<Either<SocialMusaListResponse, Failure>> getSubAlbumMusaList(
      {required String subAlbumId, required String userId}) async {
    Uri url = Uri.parse(ApiUrl.getSubAlbumMusaList);
    var token = Prefs.getString(PrefKeys.token);
    try {
      http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'sub_album_id': subAlbumId, 'user_id': userId}),
      );

      if (response.statusCode == 200) {
        return Left(SocialMusaListResponse.fromJson(jsonDecode(response.body)));
      } else if (response.statusCode == 401) {
        return Right(Failure.fromJson(jsonDecode(response.body)));
      }
      return Right(Failure(message: StringConst.somethingWentWrong));
    } catch (e) {
      debugPrint("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
  }

  @override
  Future<Either<int, Failure>> likeMusa({
    required String musaId,
  }) async {
    var token = Prefs.getString(PrefKeys.token);
    Uri url = Uri.parse(
      ApiUrl.likeUnlikeMusaApi,
    );
    try {
      http.Response response = await http.post(url, headers: {
        'Authorization': 'Bearer $token',
      }, body: {
        'musa_id': musaId
      });

      debugPrint(' likeMusa Response Status: ${response.statusCode}');
      debugPrint(' likeMusa Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return Left(1);
      } else {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        String errorMessage =
            responseJson['message'] ?? 'Unknown error occurred.';
        return Right(Failure(message: errorMessage));
      }
    } catch (e) {
      return Right(Failure(message: 'Something went wrong, try again later.'));
    }
  }

  @override
  Future<Either<AddContributorsInMusaResponse, Failure>> addContributors(
      {required String musaId, required List<String> userId}) async {
    // TODO: implement addContributors
    var token = Prefs.getString(PrefKeys.token);
    Uri url = Uri.parse(
      ApiUrl.inviteContributor,
    );
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var request = http.Request('POST', url);
      request.body =
          json.encode({"musa_id": musaId, "contributor_ids": userId});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return Left(
          AddContributorsInMusaResponse.fromJson(
            jsonDecode(responseBody),
          ),
        );
      } else if (response.statusCode == 401) {
        return Right(
          Failure.fromJson(
            jsonDecode(responseBody),
          ),
        );
      }
    } catch (e) {
      print("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
    return Right(Failure(message: StringConst.somethingWentWrong));
  }

  @override
  Future<Either<DeleteAllNotificationsResponse, Failure>>
      deleteAllNotifications() async {
    // TODO: implement deleteAllNotifications
    var token = Prefs.getString(PrefKeys.token);
    Uri url = Uri.parse(
      ApiUrl.deleteAllNotifications,
    );
    try {
      var headers = {
        'Authorization': 'Bearer $token',
      };
      var request = http.Request('POST', url);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return Left(
          DeleteAllNotificationsResponse.fromJson(
            jsonDecode(responseBody),
          ),
        );
      } else if (response.statusCode == 401) {
        return Right(
          Failure.fromJson(
            jsonDecode(responseBody),
          ),
        );
      }
    } catch (e) {
      print("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
    return Right(Failure(message: StringConst.somethingWentWrong));
  }

  @override
  Future removeFileFromMusa(
      {String? fileId,
      String? audioComments,
      required String musaId,
      List<String>? mediaFiles}) async {
    Uri url = Uri.parse(ApiUrl.removeFileFromMusa);
    var token = Prefs.getString(PrefKeys.token);
    try {
      var bodydata;
      if (fileId != null && fileId.isNotEmpty) {
        bodydata = {'file_id': fileId, 'musa_id': musaId};
      }
      if (audioComments != null && audioComments.isNotEmpty) {
        bodydata = {
          'audio_comments': audioComments,
          'musa_id': musaId,
        };
      }
      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        bodydata = {'musa_id': musaId, 'media_files': mediaFiles};
      }
      http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(bodydata),
      );

      if (response.statusCode == 200) {
        return Left(SocialMusaListResponse.fromJson(jsonDecode(response.body)));
      } else if (response.statusCode == 401) {
        return Right(Failure.fromJson(jsonDecode(response.body)));
      }
      return Right(Failure(message: StringConst.somethingWentWrong));
    } catch (e) {
      debugPrint("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
  }

  @override
  Future<Either<dynamic, Failure>> sendContactMessage({
    required String subject,
    required String message,
  }) async {
    Uri url = Uri.parse(ApiUrl.contactUs);
    var token = Prefs.getString(PrefKeys.token);
    try {
      http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'subject': subject,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        return Left(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        return Right(Failure.fromJson(jsonDecode(response.body)));
      }
      return Right(Failure(message: StringConst.somethingWentWrong));
    } catch (e) {
      debugPrint("error : $e");
      return Right(Failure(message: StringConst.somethingWentWrong));
    }
  }
}
