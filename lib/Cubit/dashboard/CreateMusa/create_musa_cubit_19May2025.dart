import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:musa_app/Cubit/dashboard/CreateMusa/create_musa_state.dart';
import 'package:musa_app/Repository/AppResponse/library_response.dart';
import 'package:musa_app/Repository/AppResponse/my_section_album_list.dart';
import 'package:musa_app/Repository/AppResponse/my_section_sub_album_list.dart';
import 'package:musa_app/Resources/api_url.dart';
import 'package:musa_app/Utility/packages.dart';

class CreateMusaCubit extends Cubit<CreateMusaState> {
  CreateMusaCubit() : super(CreateMusaInitial());
  Repository repository = Repository();

  final ValueNotifier<List<AssetEntity>> selectedAssets = ValueNotifier([]);
  MySectionAlbumData? selectedAlbum;
  MySectionSubAlbumData? selectedSubAlbum;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<MySectionAlbumData> musaAlbumList = [];
  List<MySectionSubAlbumData> musaSubAlbumList = [];
  Map<String, String> selectedContributors = {};
  final ValueNotifier<List<String>> selectedAudio = ValueNotifier([]);
  String isPublic = 'only_me';
  ValueNotifier<double> loadingTime = ValueNotifier(0.0);
  final FocusNode descriptionFocusNode = FocusNode();
  List<LibraryFile>? mediaLibrary = [];
  List<LibraryFile>? audioLibrary = [];

  bool isNewMusaCreated = false;

  init({required BuildContext context}) {
    getAlbumListApi(context: context);
  }

  Future<List<dynamic>> processSelectedAssets(List<AssetEntity> assets) async {
    List<dynamic> processedFiles = [];

    for (var asset in assets) {
      if (asset.id.startsWith('http')) {
        // If the asset ID is a URL, add it directly
        processedFiles.add(asset.id);
      } else {
        // If it's a local file, convert it to File
        File? file = await assetToFile(asset);
        if (file != null) {
          processedFiles.add(file);
        }
      }
    }

    return processedFiles;
  }

// Convert AssetEntity to File
  Future<File?> assetToFile(AssetEntity asset) async {
    File? file;
    try {
      String? filePath = (await asset.file)?.path;
      if (filePath != null) {
        file = File(filePath);
      }
    } catch (e) {
      print("Error converting asset to file: $e");
    }
    return file;
  }

  Future<List<dynamic>> processSelectedAudios(List<String> audioPaths) async {
    List<dynamic> processedFiles = [];

    for (var path in audioPaths) {
      if (path.startsWith('http')) {
        processedFiles.add(path);
      } else {
        processedFiles.add(File(path));
      }
    }

    return processedFiles;
  }

  removeContributor(String id) {
    selectedContributors.remove(id);
    emit(CreateMusaUpdated());
  }

  openContributorScreen({required BuildContext context}) async {
    Map<String, String>? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddContributor(
          initialSelectedContributors: selectedContributors.keys.toList(),
          isComeFromProfile: false,
        ),
      ),
    );

    if (result != null) {
      selectedContributors = result;
      FocusScope.of(context).unfocus();
      emit(CreateMusaDataFetched());
    }
  }

  getAlbumListApi({required BuildContext context}) async {
    emit(CreateMusaInitial());
    emit(CreateMusaAlbumLoading());
    await repository.getAlbumList().then((value) {
      value.fold((left) {
        musaAlbumList = left.data ?? [];
        emit(CreateMusaAlbumLoaded());
      }, (right) {
        emit(CreateMusaError(errorMessage: right.message));
      });
    });
  }

  getSubAlbumListApi(
      {required BuildContext context, required String albumId}) async {
    emit(CreateMusaInitial());
    emit(CreateMusaSubAlbumLoading());
    await repository.getSubAlbumList(albumId: albumId).then((value) {
      value.fold((left) {
        musaSubAlbumList = left.data ?? [];
        emit(CreateMusaSubAlbumLoaded());
      }, (right) {
        emit(CreateMusaError(errorMessage: right.message));
      });
    });
  }

  createSubAlbum(BuildContext context, String title, String albumId) async {
    repository.createMusaSubAlbum(title: title, albumId: albumId).then((value) {
      value.fold((left) {
        getSubAlbumListApi(context: context, albumId: albumId);
        context.pop(true);
      }, (right) {
        emit(CreateMusaError(errorMessage: right.message ?? ''));
      });
    });
  }

  createAlbum(BuildContext context, String album) {
    repository.createAlbum(album).then((value) {
      value.fold((left) {
        print(left.data);
        getAlbumListApi(context: context);
        context.pop(true);
      }, (right) {
        emit(CreateMusaError(errorMessage: right.message ?? ''));
      });
    });
  }

  createMusa(BuildContext context) async {
    emit(CreateMusaInitial());
    emit(CreateMusaLoading());
    try {
      List<dynamic> mediaFiles =
          await processSelectedAssets(selectedAssets.value);
      List<dynamic> audioFiles =
          await processSelectedAudios(selectedAudio.value);
      var mediaUrl = [];
      var mediaFile = [];
      var audioUrl = [];
      var audioFile = [];
      for (var media in mediaFiles) {
        if (media.toString().startsWith("http")) {
          mediaUrl.add(media.toString());
        } else if (media.toString().startsWith("File:")) {
          mediaFile.add(media.toString());
        }
      }
      for (var media in audioFiles) {
        if (media.toString().startsWith("http")) {
          audioUrl.add(media.toString());
        } else if (media.toString().startsWith("File:")) {
          audioFile.add(media.toString());
        }
      }

      List<String> contributorIds = selectedContributors.keys.toList();

      Dio dio = Dio();
      String? token = Prefs.getString(PrefKeys.token);
      var headers = {'Authorization': 'Bearer $token'};
      FormData formData = FormData.fromMap({
        'title': titleController.text,
        'album_id': selectedAlbum?.id ?? "",
        'sub_album_id': selectedSubAlbum?.id ?? '',
        'musa_type': isPublic,
        'description': descriptionController.text.isNotEmpty
            ? descriptionController.text
            : '',
      });

      // Add contributors
      if (contributorIds.isNotEmpty) {
        for (int i = 0; i < contributorIds.length; i++) {
          formData.fields.add(
              MapEntry("contributor_id[$i]", contributorIds[i].toString()));
        }
      }
      try {
        for (int file = 0; file < mediaFile.length; file++) {
          var data =
              mediaFile[file].replaceAll("File: '", "").replaceAll("'", "");
          formData.files.add(MapEntry(
            'musaFiles',
            await MultipartFile.fromFile(data,
                filename: data.toString().split('/').last),
          ));
        }
      } catch (e) {
        print("Media local file: $e");
      }
      try {
        for (int file = 0; file < mediaUrl.length; file++) {
          formData.files.add(
              MapEntry('musaFiles', MultipartFile.fromString(mediaUrl[file])));
        }
      } catch (e) {
        print("mediaUrl: $e");
      }

      try {
        for (int filePath = 0; filePath < audioFile.length; filePath++) {
          var localAudio =
              audioFile[filePath].replaceAll("File: '", "").replaceAll("'", "");
          print("Uploading local audio: $localAudio");

          formData.files.add(MapEntry(
            'musaFiles',
            await MultipartFile.fromFile(localAudio,
                filename: localAudio.split('/').last),
          ));
        }
      } catch (e) {
        print("audioFile error: $e");
      }
      try {
        for (int filePathUrl = 0;
            filePathUrl < audioUrl.length;
            filePathUrl++) {
          formData.files.add(MapEntry(
            'musaFiles',
            MultipartFile.fromString(audioUrl[filePathUrl]),
          ));
        }
      } catch (e) {
        print("audioUrl: $e");
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
          loadingTime.value = progress;
        },
      );
      if (response.statusCode == 200) {
        isNewMusaCreated = true;
        emit(CreateMusaLoaded());
      } else {
        emit(CreateMusaError(
            errorMessage: response.statusMessage ?? 'Error occurred.'));
      }
    } catch (e) {
      print("Error: $e");
      emit(CreateMusaError(errorMessage: 'Something went wrong.'));
    }
  }

  Future<void> pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.audio, allowMultiple: true);
    if (result != null && result.files.isNotEmpty) {
      List<String> audioFiles = result.paths.whereType<String>().toList();

      selectedAudio.value.addAll(audioFiles);
      emit(CreateMusaFileUpdated());
    }
  }

  Future<void> recordAudio(path) async {
    selectedAudio.value.add(path);
    emit(CreateMusaFileUpdated());
  }

  Future<void> recordRemoveAudio(path) async {
    selectedAudio.value.remove(path);
    emit(CreateMusaFileUpdated());
  }

  void removeSelectedAudio(int index) {
    selectedAudio.value = List.from(selectedAudio.value)..removeAt(index);
    selectedAudio.notifyListeners();
    emit(CreateMusaFileUpdated()); // Notify UI
  }

  getLibrary() async {
    try {
      emit(CreateMusaMediaLoading());
      await Connectivity().checkConnectivity().then((value) async {
        if (value != ConnectivityResult.none) {
          final result = await repository.getLibrary();
          result.fold(
            (left) {
              mediaLibrary = left.imageFile;
              audioLibrary = left.voiceFile;
              emit(CreateMusaMediaLibrary());
            },
            (right) {
              emit(CreateMusaMediaLibrary());
            },
          );
        } else {
          emit(CreateMusaError(errorMessage: StringConst.noInternetConnection));
        }
      });
    } catch (e) {
      debugPrint("error : $e");
      emit(CreateMusaError(errorMessage: e.toString()));
    }
  }
}
