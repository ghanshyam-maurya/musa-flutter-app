import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:musa_app/Cubit/Comment/comment_state.dart';
import 'package:musa_app/Repository/ApiServices/api_client.dart';
import 'package:musa_app/Repository/AppResponse/Responses/comment_list_response.dart';
import 'package:musa_app/Repository/AppResponse/social_musa_list_response.dart';
import 'package:http/http.dart' as http;
import 'package:musa_app/Resources/api_url.dart';
import 'package:musa_app/Utility/packages.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(CommentInitial());

  Repository repository = Repository();
  final ApiClient _apiClient = ApiClient();
  late List<MusaData>? socialMusaList;

  int commentCont = 0;
  List<Data> commentList = [];

  void incrementCommentCount() {
    commentCont += 1;
    emit(CommentUpdated(count: commentCont)); // Emit a new state
  }

  emitState(count) {
    commentCont = count;
    emit(CommentUpdated(count: commentCont));
  }

  //Event for like musa
  Future<void> likeUnlikeMusa({required String musaId}) async {
    if (musaId.isNotEmpty) {
      final token = Prefs.getString(PrefKeys.token);
      final response =
          await _apiClient.post(ApiUrl.likeUnlikeMusaApi, headers: {
        'Authorization': 'Bearer $token',
      }, body: {
        'musa_id': musaId
      });
      if (response['status'] == 200) {
        emit(CommentLikeLoaded());
      } else {
        emit(CommentFailure(errorMessage: response['message']));
      }
    }
  }

  //Event for post musa comment
  Future<void> postMusaComment(
      {required String musaId, required musaComment, recordeAudio}) async {
    emit(CommentLoading());
    if (musaId.isNotEmpty) {
      final token = Prefs.getString(PrefKeys.token);
      var headers = {'Authorization': 'Bearer $token'};
      var request =
          http.MultipartRequest('POST', Uri.parse(ApiUrl.postMusaComment));
      request.fields.addAll({'musa_id': musaId, 'text': musaComment});
      if (recordeAudio != null) {
        request.files
            .add(await http.MultipartFile.fromPath('musaFile', recordeAudio));
      }
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        getCommentApi(musaId: musaId);
        emit(CommentSuccess());
      } else {
        emit(CommentFailure(errorMessage: response.statusCode.toString()));
      }
    }
  }

  // Future<void> postMusaCommentNew(String musaId, musaComment, voiceFile) async {
  //   repository
  //       .postMusaCommentNew(
  //     musaId: '',
  //     musaComment: '',
  //     voiceFile: voiceFile,
  //   )
  //       .then((value) {
  //     value.fold((left) {
  //       emit(MusaCommentPostSuccess());
  //     }, (right) {
  //       emit(MusaCommentPostError());
  //     });
  //   });
  // }

  //Event for removing musa file
  Future<void> removeMusaFile({String? fileId, String? musaId}) async {
    emit(CommentLoading()); // Show loading state

    try {
      if (fileId != null && fileId.isNotEmpty) {
        final token = Prefs.getString(PrefKeys.token);
        final response = await _apiClient.post(
          ApiUrl.removeFileFromMusa,
          headers: {
            'Authorization': 'Bearer $token',
          },
          body: {
            'file_id': fileId,
            'musa_id': musaId ?? '', // Include musaId if available
          },
        );

        if (response['status'] == 200) {
          emit(CommentSuccess());
        } else {
          emit(CommentFailure(
              errorMessage: response['message'] ?? 'Failed to remove file'));
        }
      } else {
        emit(CommentFailure(errorMessage: 'No file specified for removal.'));
      }
    } catch (e) {
      print("Exception when removing file: $e");
      emit(CommentFailure(
          errorMessage: 'An error occurred while removing the file.'));
      rethrow; // Rethrow to handle in UI
    }
  }

  //Event for get comment list api
  Future<void> getCommentApi({required String musaId}) async {
    print(musaId);
    await Connectivity().checkConnectivity().then((value) async {
      if (value != ConnectivityResult.none) {
        try {
          emit(CommentLoading());
          if (musaId.isNotEmpty) {
            final token = Prefs.getString(PrefKeys.token);
            final response =
                await _apiClient.post(ApiUrl.getCommentList, headers: {
              'Authorization': 'Bearer $token',
            }, body: {
              'musa_id': musaId
            });
            if (response['status'] == 200) {
              var res = CommentListResponse.fromJson(response);
              commentCont = res.data?.length ?? 0;
              commentList = res.data ?? [];
              emit(CommentSuccess());
            } else {
              emit(
                  CommentFailure(errorMessage: 'Failed to fetch comment list'));
            }
          }
        } catch (e) {
          print(e);
        }
      } else {
        emit(CommentFailure(errorMessage: 'No internet'));
      }
    });
  }
}
