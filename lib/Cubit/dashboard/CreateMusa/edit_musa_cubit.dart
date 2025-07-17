import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:musa_app/Cubit/dashboard/CreateMusa/edit_musa_state.dart';
import 'package:musa_app/Repository/AppResponse/library_response.dart';
import 'package:musa_app/Repository/AppResponse/my_section_album_list.dart';
import 'package:musa_app/Repository/AppResponse/my_section_sub_album_list.dart';
import 'package:musa_app/Resources/api_url.dart';
import 'package:musa_app/Utility/packages.dart';

class EditMusaCubit extends Cubit<EditMusaState> {
  final String musaId;
  EditMusaCubit({required this.musaId}) : super(EditMusaInitial());
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

  bool isRecurringDisplay = false;
  TextEditingController recurringDateController = TextEditingController();
  String? selectedRecurringInterval;
  bool shouldAutoSelectNewAlbum = false;
  bool shouldAutoSelectNewSubAlbum = false;
  String? audioFilePath;
  List<String>? remoteMediaFilesTodelete = []; // List of remote media file URLs
  int? initialTotalRemoteFiles = 0; // ID of remote audio file to delete
  String? remoteAudioComments = '';

  final ImagePicker _picker = ImagePicker();

  // Method to update description field state
  void updateDescription(String description) {
    descriptionController.text = description;
    emit(EditMusaDescriptionUpdated(description: description));
  }

  // Optionally, add any form validation for the description field if required
  bool validateDescription() {
    return descriptionController.text.isNotEmpty &&
        descriptionController.text.length <= 500;
  }

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
    emit(EditMusaUpdated());
  }

  openContributorScreen({required BuildContext context}) async {
    Map<String, String>? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddContributor(
          initialSelectedContributors: [],
          isComeFromProfile: false,
          isComeFromEditMusa: true,
          musaId: musaId,
        ),
      ),
    );

    if (result != null) {
      selectedContributors = result;
      FocusScope.of(context).unfocus();
      emit(EditMusaDataFetched());
    }
  }

  getAlbumListApi({required BuildContext context}) async {
    emit(EditMusaInitial());
    emit(EditMusaAlbumLoading());
    await repository.getAlbumList().then((value) {
      value.fold((left) {
        musaAlbumList = left.data ?? [];
        emit(EditMusaAlbumLoaded());
      }, (right) {
        emit(EditMusaError(errorMessage: right.message));
      });
    });
  }

  getSubAlbumListApi(
      {required BuildContext context, required String albumId}) async {
    emit(EditMusaInitial());
    emit(EditMusaSubAlbumLoading());
    await repository.getSubAlbumList(albumId: albumId).then((value) {
      value.fold((left) {
        musaSubAlbumList = left.data ?? [];
        emit(EditMusaSubAlbumLoaded());
      }, (right) {
        emit(EditMusaError(errorMessage: right.message));
      });
    });
  }

  createSubAlbum(BuildContext context, String title, String albumId) async {
    repository.createMusaSubAlbum(title: title, albumId: albumId).then((value) {
      value.fold((left) {
        getSubAlbumListApi(context: context, albumId: albumId);
        context.pop(true);
      }, (right) {
        emit(EditMusaError(errorMessage: right.message ?? ''));
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
        emit(EditMusaError(errorMessage: right.message ?? ''));
      });
    });
  }

  updateMusa(BuildContext context) async {
    // validation check for minimum one media file is required
    if (selectedAssets.value.isEmpty) {
      if ((initialTotalRemoteFiles! - remoteMediaFilesTodelete!.length) <= 0) {
        emit(EditMusaInitial());
        emit(EditMusaError(
            errorMessage: 'At least one media file is required.'));
      }
      return;
    }

    emit(EditMusaInitial());
    emit(EditMusaLoading());
    try {
      // 1. Filter the lists to get ONLY NEW, LOCAL files for upload.
      // Existing remote files have IDs/paths that start with 'http'.
      final newLocalMediaAssets = selectedAssets.value
          .where((asset) => !asset.id.startsWith('http'))
          .toList();

      final newLocalAudioPaths = selectedAudio.value
          .where((path) => !path.startsWith('http'))
          .toList();

      List<dynamic> mediaFiles =
          await processSelectedAssets(newLocalMediaAssets);
      List<dynamic> audioFiles =
          await processSelectedAudios(newLocalAudioPaths);
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
      // print(isRecurringDisplay);
      // print(selectedRecurringInterval);
      // print(recurringDateController.text);
      // FormData formData = FormData.fromMap({
      //   'title': titleController.text,
      //   'album_id': selectedAlbum?.id ?? "",
      //   'sub_album_id': selectedSubAlbum?.id ?? '',
      //   'musa_type': isPublic,
      //   'description': descriptionController.text.isNotEmpty
      //       ? descriptionController.text
      //       : '',
      //   'recurring_display': isRecurringDisplay,
      //   'recurring_date': recurringDateController.text,
      //   'recurring_interval': selectedRecurringInterval,
      // });
      // First create the base map
      Map<String, dynamic> formMap = {
        'musa_id': musaId,
        'title': titleController.text,
        'album_id': selectedAlbum?.id ?? "",
        'sub_album_id': selectedSubAlbum?.id ?? '',
        'musa_type': isPublic,
        'description': descriptionController.text.isNotEmpty
            ? descriptionController.text
            : '',
      };
      formMap['recurring_display'] = isRecurringDisplay;
      formMap['recurring_date'] = recurringDateController.text;
      formMap['recurring_interval'] = selectedRecurringInterval?.toLowerCase();
      // Add recurring fields conditionally
      // if (isRecurringDisplay) {
      //   formMap['recurring_display'] = isRecurringDisplay;

      //   if (recurringDateController.text.isNotEmpty) {
      //     formMap['recurring_date'] = recurringDateController.text;
      //   }

      //   if (selectedRecurringInterval != null &&
      //       selectedRecurringInterval!.isNotEmpty) {
      //     formMap['recurring_interval'] =
      //         selectedRecurringInterval!.toLowerCase();
      //   }
      // }
      // Create FormData from the map
      FormData formData = FormData.fromMap(formMap);

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

      // add this audioFilePath path to the formData
      if (audioFilePath != null && audioFilePath!.isNotEmpty) {
        // print("Uploading single recorded audio file: $audioFilePath");
        formData.files.add(MapEntry(
          'audioComments',
          await MultipartFile.fromFile(audioFilePath!,
              filename: audioFilePath!.split('/').last),
        ));
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

      // api call to delete remote audio comments
      if (remoteAudioComments != null && remoteAudioComments!.isNotEmpty) {
        await repository.removeFileFromMusa(
          audioComments: remoteAudioComments,
          musaId: musaId,
        );
      }
      // api call to delete remote media files
      if ((remoteMediaFilesTodelete != null &&
          remoteMediaFilesTodelete!.isNotEmpty)) {
        await repository.removeFileFromMusa(
            musaId: musaId, mediaFiles: remoteMediaFilesTodelete);
      }

      Response response = await dio.post(
        ApiUrl.updateMusa,
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

  Future<void> pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.audio, allowMultiple: true);
    if (result != null && result.files.isNotEmpty) {
      List<String> audioFiles = result.paths.whereType<String>().toList();

      selectedAudio.value.addAll(audioFiles);
      emit(EditMusaFileUpdated());
    }
  }

  Future<void> recordAudio(path) async {
    selectedAudio.value.add(path);
    emit(EditMusaFileUpdated());
  }

  Future<void> recordRemoveAudio(path) async {
    selectedAudio.value.remove(path);
    emit(EditMusaFileUpdated());
  }

  void removeSelectedAudio(int index) {
    selectedAudio.value = List.from(selectedAudio.value)..removeAt(index);
    selectedAudio.notifyListeners();
    emit(EditMusaFileUpdated()); // Notify UI
  }

  getLibrary() async {
    try {
      emit(EditMusaMediaLoading());
      await Connectivity().checkConnectivity().then((value) async {
        if (value != ConnectivityResult.none) {
          final result = await repository.getLibrary();
          result.fold(
            (left) {
              mediaLibrary = left.imageFile;
              audioLibrary = left.voiceFile;
              emit(EditMusaMediaLibrary());
            },
            (right) {
              emit(EditMusaMediaLibrary());
            },
          );
        } else {
          emit(EditMusaError(errorMessage: StringConst.noInternetConnection));
        }
      });
    } catch (e) {
      debugPrint("error : $e");
      emit(EditMusaError(errorMessage: e.toString()));
    }
  }

  Future<void> pickAndUploadImages(
      {required ImageSource source, bool multiple = true}) async {
    try {
      List<XFile>? pickedFiles;
      if (multiple) {
        pickedFiles = await _picker.pickMultiImage();
      } else {
        final XFile? pickedFile = await _picker.pickImage(source: source);
        if (pickedFile != null) {
          pickedFiles = [pickedFile];
        }
      }

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        List<AssetEntity> assetEntities = [];

        for (XFile file in pickedFiles) {
          try {
            // Save the file to gallery and get AssetEntity
            final AssetEntity? asset =
                await PhotoManager.editor.saveImageWithPath(
              file.path,
              title: "IMG_${DateTime.now().millisecondsSinceEpoch}",
            );

            if (asset != null) {
              assetEntities.add(asset);
            }
          } catch (e) {
            print("Error saving image: $e");
            // Fallback: create a simple AssetEntity with file path as ID
            final mockAsset = AssetEntity(
              id: file.path,
              typeInt: AssetType.image.index,
              width: 0,
              height: 0,
              duration: 0,
              orientation: 0,
              isFavorite: false,
              title: file.name,
              createDateSecond: DateTime.now().millisecondsSinceEpoch ~/ 1000,
              modifiedDateSecond: DateTime.now().millisecondsSinceEpoch ~/ 1000,
              relativePath: '',
              latitude: null,
              longitude: null,
            );
            assetEntities.add(mockAsset);
          }
        }

        selectedAssets.value = [...selectedAssets.value, ...assetEntities];
        print('selected assests: ${selectedAssets.value}');
        print('selected assests length: ${selectedAssets.value.length}');
        emit(EditMusaFileUpdated());
      }
    } catch (e) {
      emit(EditMusaError(errorMessage: e.toString()));
    }
  }

  Future<void> pickAndUploadMedia({
    required ImageSource source,
    required bool multiple,
    required bool isVideo,
  }) async {
    try {
      List<File> files = [];

      if (isVideo) {
        final XFile? pickedVideo = await _picker.pickVideo(source: source);
        if (pickedVideo != null) {
          files.add(File(pickedVideo.path));

          // Save the video to gallery and get AssetEntity
          final AssetEntity? asset = await PhotoManager.editor.saveVideo(
            File(pickedVideo.path),
            title: "VID_${DateTime.now().millisecondsSinceEpoch}",
          );

          if (asset != null) {
            selectedAssets.value = [...selectedAssets.value, asset];
          } else {
            // Fallback: create a mock AssetEntity for video
            final mockAsset = AssetEntity(
              id: pickedVideo.path,
              typeInt: AssetType.video.index,
              width: 0,
              height: 0,
              duration: 0,
              orientation: 0,
              isFavorite: false,
              title: pickedVideo.name,
              createDateSecond: DateTime.now().millisecondsSinceEpoch ~/ 1000,
              modifiedDateSecond: DateTime.now().millisecondsSinceEpoch ~/ 1000,
              relativePath: '',
              latitude: null,
              longitude: null,
            );
            selectedAssets.value = [...selectedAssets.value, mockAsset];
          }
          print('picked video: ${pickedVideo.path}');
          emit(EditMusaFileUpdated());
        } else {
          emit(EditMusaError(errorMessage: 'No video selected'));
          return;
        }
      } else {
        List<XFile>? pickedFiles;
        if (multiple) {
          pickedFiles = await _picker.pickMultiImage();
        } else {
          final XFile? pickedFile = await _picker.pickImage(source: source);
          if (pickedFile != null) {
            pickedFiles = [pickedFile];
          }
        }

        if (pickedFiles != null && pickedFiles.isNotEmpty) {
          List<AssetEntity> assetEntities = [];

          for (XFile file in pickedFiles) {
            try {
              final AssetEntity? asset =
                  await PhotoManager.editor.saveImageWithPath(
                file.path,
                title: "IMG_${DateTime.now().millisecondsSinceEpoch}",
              );

              if (asset != null) {
                assetEntities.add(asset);
              }
            } catch (e) {
              print("Error saving image: $e");
              final mockAsset = AssetEntity(
                id: file.path,
                typeInt: AssetType.image.index,
                width: 0,
                height: 0,
                duration: 0,
                orientation: 0,
                isFavorite: false,
                title: file.name,
                createDateSecond: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                modifiedDateSecond:
                    DateTime.now().millisecondsSinceEpoch ~/ 1000,
                relativePath: '',
                latitude: null,
                longitude: null,
              );
              assetEntities.add(mockAsset);
            }
          }

          selectedAssets.value = [...selectedAssets.value, ...assetEntities];
          print('selected assets: ${selectedAssets.value}');
          print('selected assets length: ${selectedAssets.value.length}');
          emit(EditMusaFileUpdated());
        }
      }
    } catch (e) {
      emit(EditMusaError(errorMessage: e.toString()));
    }
  }

  Future<void> pickAndUploadMediaUnified({
    required BuildContext context,
    bool multiple = true,
  }) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('Select Image'),
              onTap: () async {
                //Navigator.pop(context);
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
                await pickAndUploadImages(
                    source: ImageSource.gallery, multiple: multiple);
              },
            ),
            ListTile(
              leading: Icon(Icons.videocam),
              title: Text('Select Video'),
              onTap: () async {
                //Navigator.pop(context);
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
                await pickAndUploadMedia(
                  source: ImageSource.gallery,
                  multiple: true, // image_picker does not support multi-video
                  isVideo: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> removeMusaFile({String? fileId, String? audioComments}) async {
    emit(EditMusaLoading()); // Optional: show a loading state

    try {
      print("Attempting to remove file: $fileId for MUSA: $musaId");
      // EXAMPLE REPOSITORY CALL:
      var response;
      if (fileId != null && fileId.isNotEmpty) {
        response =
            await repository.removeFileFromMusa(fileId: fileId, musaId: musaId);
      } else if (audioComments != null && audioComments.isNotEmpty) {
        response = await repository.removeFileFromMusa(
          audioComments: audioComments,
          musaId: musaId,
        );
      } else {
        emit(EditMusaError(errorMessage: 'No file specified for removal.'));
      }
      // Handle Either<Success, Failure> response
      response.fold(
        (success) {
          // Left side - Success
          emit(EditMusaFileRemove());
          print("Successfully removed file");
        },
        (failure) {
          // Right side - Failure
          String errorMessage = failure.message ?? 'Failed to remove file.';
          print("API Error: $errorMessage");
          emit(EditMusaError(errorMessage: errorMessage));
        },
      );
    } catch (e) {
      print("Exception when removing file: $e");
      emit(EditMusaError(
          errorMessage: 'An error occurred while removing the file.'));
    }
  }
}
