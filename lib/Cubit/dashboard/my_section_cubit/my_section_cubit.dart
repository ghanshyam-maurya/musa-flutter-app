import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';
import 'package:just_audio/just_audio.dart';

import '../../../Repository/AppResponse/my_section_album_list.dart';
import '../../../Repository/AppResponse/my_section_sub_album_list.dart';
import '../../../Repository/AppResponse/library_response.dart';
import '../../../Utility/packages.dart';
import 'my_section_state.dart';

class MySectionCubit extends Cubit<MySectionState> {
  MySectionCubit() : super(MySectionInitial());

  Repository repository = Repository();

  int selectedTab = 0;

  List<MySectionAlbumData>? myAlbumList = [];
  List<MySectionSubAlbumData>? subAlbumList = [];
  List<LibraryFile>? mediaLibrary = [];
  List<LibraryFile>? audioLibrary = [];
  List<LibraryFile>? videoLibrary = [];
  int subAlbumCount = 0;
  final Set<String> selectedMedia = {};

  String? audioFilePath;
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  bool albumDataLoaded = false;

  final ImagePicker _picker = ImagePicker();

  void changeTab(int index) {
    selectedTab = index;
    emit(TabUpdated()); // Update state
  }

  getAlbumList() async {
    try {
      await Connectivity().checkConnectivity().then((value) async {
        if (value != ConnectivityResult.none) {
          emit(MyAlbumLoading());
          final result = await repository.getMySectionAlbumList();
          result.fold(
            (left) {
              if (left.data != null) {
                myAlbumList = left.data;
              }
              albumDataLoaded = true;
              emit(MyAlbumSuccess());
            },
            (right) {
              emit(MyAlbumFailure(right.message!));
            },
          );
        } else {
          emit(MyAlbumFailure(StringConst.noInternetConnection));
        }
      });
    } catch (e) {
      debugPrint("error : $e");
      emit(MyAlbumFailure(e.toString()));
    }
  }

  getSubAlbumList({required String albumId}) async {
    try {
      await Connectivity().checkConnectivity().then((value) async {
        if (value != ConnectivityResult.none) {
          emit(MySubAlbumLoading());
          final result =
              await repository.getMySectionSubAlbumList(albumId: albumId);
          result.fold(
            (left) {
              if (left.data != null) {
                subAlbumList = left.data;
                subAlbumCount = left.data?.length ?? 0;
              }
              emit(MySubAlbumSuccess());
            },
            (right) {
              emit(MySubAlbumFailure(right.message!));
            },
          );
        } else {
          emit(MySubAlbumFailure(StringConst.noInternetConnection));
        }
      });
    } catch (e) {
      debugPrint("error : $e");
      emit(MySubAlbumFailure(e.toString()));
    }
  }

  getLibrary() async {
    try {
      await Connectivity().checkConnectivity().then((value) async {
        if (value != ConnectivityResult.none) {
          emit(MyLibraryLoading());
          final result = await repository.getLibrary();
          result.fold(
            (left) {
              mediaLibrary = left.imageFile;
              audioLibrary = left.voiceFile;
              // print(mediaLibrary);
              // print(audioLibrary);

              emit(MyLibrarySuccess());
            },
            (right) {
              emit(MyLibraryFailure(right.message!));
            },
          );
        } else {
          emit(MyLibraryFailure(StringConst.noInternetConnection));
        }
      });
    } catch (e) {
      debugPrint("error : $e");
      emit(MyLibraryFailure(e.toString()));
    }
  }

  getAllLibrary() async {
    try {
      await Connectivity().checkConnectivity().then((value) async {
        if (value != ConnectivityResult.none) {
          emit(MyLibraryLoading());
          final result = await repository.getAllLibrary();
          result.fold(
            (left) {
              mediaLibrary = left.imageFile;
              audioLibrary = left.voiceFile;
              videoLibrary = left.videoFile;
              // print(mediaLibrary);
              // print(audioLibrary);

              emit(MyLibrarySuccess());
            },
            (right) {
              emit(MyLibraryFailure(right.message!));
            },
          );
        } else {
          emit(MyLibraryFailure(StringConst.noInternetConnection));
        }
      });
    } catch (e) {
      debugPrint("error : $e");
      emit(MyLibraryFailure(e.toString()));
    }
  }

  Future<void> uploadLibraryFiles(List<File> files) async {
    try {
      await Connectivity().checkConnectivity().then((value) async {
        if (value != ConnectivityResult.none) {
          emit(MyLibraryLoading());
          final result = await repository.uploadLibraryFiles(musaFiles: files);
          result.fold(
            (left) async {
              await getLibrary();
              emit(MyLibrarySuccess());
            },
            (right) {
              emit(MyLibraryFailure(right.message!));
            },
          );
        } else {
          emit(MyLibraryFailure(StringConst.noInternetConnection));
        }
      });
    } catch (e) {
      debugPrint("error : $e");
      emit(MyLibraryFailure(e.toString()));
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
        List<File> files =
            pickedFiles.map((xFile) => File(xFile.path)).toList();
        await uploadLibraryFiles(files);
      }
    } catch (e) {
      emit(MyLibraryFailure(e.toString()));
    }
  }

  Future<void> pickAndUploadMedia({
    required ImageSource source,
    bool multiple = true,
    bool isVideo = false,
  }) async {
    try {
      List<File> files = [];

      if (isVideo) {
        final XFile? pickedVideo = await _picker.pickVideo(source: source);
        if (pickedVideo != null) {
          files.add(File(pickedVideo.path));
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
          files.addAll(pickedFiles.map((xFile) => File(xFile.path)));
        }
      }

      if (files.isNotEmpty) {
        await uploadLibraryFiles(
            files); // You can internally distinguish type by file extension
      }
    } catch (e) {
      emit(MyLibraryFailure(e.toString()));
    }
  }

  Future<void> createAlbum(String title) async {
    try {
      await Connectivity().checkConnectivity().then((value) async {
        if (value != ConnectivityResult.none) {
          emit(MyAlbumLoading());
          final result = await repository.createAlbum(title);
          result.fold(
            (left) async {
              await getAlbumList(); // Refresh album list after creation
              emit(MyAlbumSuccess());
            },
            (right) {
              emit(MyAlbumFailure(right.message!));
            },
          );
        } else {
          emit(MyAlbumFailure(StringConst.noInternetConnection));
        }
      });
    } catch (e) {
      debugPrint("error : $e");
      emit(MyAlbumFailure(e.toString()));
    }
  }

  Future<void> createMusaSubAlbum(
      {required String title, required String albumId}) async {
    try {
      await Connectivity().checkConnectivity().then((value) async {
        if (value != ConnectivityResult.none) {
          emit(MySubAlbumLoading());
          final result = await repository.createMusaSubAlbum(
              title: title, albumId: albumId);
          result.fold(
            (left) async {
              await getSubAlbumList(
                  albumId: albumId); // Refresh sub album list after creation
              emit(MySubAlbumSuccess());
            },
            (right) {
              emit(MySubAlbumFailure(right.message!));
            },
          );
        } else {
          emit(MySubAlbumFailure(StringConst.noInternetConnection));
        }
      });
    } catch (e) {
      debugPrint("error : $e");
      emit(MySubAlbumFailure(e.toString()));
    }
  }

  void searchAlbums(String query) {
    // if (query.isEmpty) {
    //   emit(MySectionLoadedState(myAlbumList));
    // } else {
    //   List<MySectionAlbumData> filtered = myAlbumList
    //       !.where((album) => album.toLowerCase().contains(query.toLowerCase()))
    //       .toList();
    //   emit(MySectionLoadedState(filtered));
    // }
  }

  Future<bool> removeMusaMediaFile({String? fileId}) async {
    emit(EditMediaLoading()); // Optional: show a loading state

    try {
      print("Attempting to remove media file: $fileId ");
      var response;
      if (fileId != null && fileId.isNotEmpty) {
        response = await repository.removeMediaFile(fileId: fileId);
      } else {
        emit(EditMediaError(errorMessage: 'No file specified for removal.'));
        return false;
      }
      // Handle Either<Success, Failure> response
      bool isSuccess = false;
      response.fold(
        (success) {
          emit(EditMediaFileRemove());
          print("Successfully removed file");
          isSuccess = true;
        },
        (failure) {
          String errorMessage = failure.message ?? 'Failed to remove file.';
          print("API Error: $errorMessage");
          emit(EditMediaError(errorMessage: errorMessage));
          isSuccess = false;
        },
      );
      return isSuccess;
    } catch (e) {
      print("Exception when removing file: $e");
      emit(EditMediaError(
          errorMessage: 'An error occurred while removing the file.'));
      return false;
    }
  }
}
