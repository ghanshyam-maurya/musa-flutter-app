import 'package:musa_app/Cubit/dashboard/CreateMusa/create_musa_cubit.dart';
// import 'package:musa_app/Cubit/dashboard/CreateMusa/create_musa_state.dart';
import 'package:musa_app/Resources/CommonWidgets/audio_recoder.dart';
import 'package:musa_app/Resources/CommonWidgets/gallery_picker.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import 'package:musa_app/Utility/packages.dart';
import 'package:video_player/video_player.dart';

import '../my_section/my_library/my_library_from_create_musa.dart';

class MediaPickerBottomSheet extends StatefulWidget {
  final dynamic cubit;
  const MediaPickerBottomSheet({super.key, this.cubit});

  @override
  State<MediaPickerBottomSheet> createState() => MediaPickerBottomSheetState();
}

class MediaPickerBottomSheetState extends State<MediaPickerBottomSheet> {
  static final Map<AssetEntity, Uint8List> thumbnails = {};
  final ValueNotifier<List<AssetEntity>> _selectedAssets = ValueNotifier([]);
  final ValueNotifier<List<String>> selectedLibrary = ValueNotifier([]);
  final ValueNotifier<String> selectedTab = ValueNotifier("Gallery");
  List<AssetEntity> _assets = [];
  final Map<String, VideoPlayerController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _selectedAssets.value = widget.cubit!.selectedAssets.value;
    fetchMedia();
  }

  /// Fetch images and videos from the gallery
  Future<void> fetchMedia() async {
    final PermissionState permission =
        await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) return;

    List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
        type: RequestType.all, onlyAll: true);
    if (paths.isNotEmpty) {
      _assets = await paths.first.getAssetListRange(start: 0, end: 100);

      await Future.wait(_assets.map((asset) async {
        bool isAvailable = await asset.isLocallyAvailable();
        if (!isAvailable) {
          final file = await asset.loadFile();
          if (file == null) {
            print("Failed to load iCloud file: ${asset.id}");
            return;
          }
        }
        if (!thumbnails.containsKey(asset)) {
          final thumb =
              await asset.thumbnailDataWithSize(const ThumbnailSize(200, 200));
          thumbnails[asset] = thumb ?? Uint8List(0);
        }
      }));
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.all(8.0),
        // child: Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     SizedBox(height: 10),
        //     // _buildTopIndicator(),
        //     SizedBox(height: 5),
        //     _buildHeader(),
        //     Divider(),
        //     _buildMediaOptions(),
        //     Divider(),
        //     SizedBox(height: 5),
        //     BlocBuilder<CreateMusaCubit, CreateMusaState>(
        //       bloc: widget.cubit,
        //       builder: (context, state) {
        //         if (state is CreateMusaMediaLoading) {
        //           return CircularProgressIndicator();
        //         }
        //         if (state is CreateMusaMediaLibrary) {
        //           return _buildMediaList();
        //         }
        //         return _buildMediaList();
        //       },
        //     ),
        //     selectedTab.value == 'Library' || selectedTab.value == 'Audio'
        //         ? SizedBox()
        //         : _buildBottomOptions(),
        //   ],
        // ),
        child: buildUploadMediaSection(widget.cubit),
      ),
    );
  }

  /// Top indicator bar
  Widget _buildTopIndicator() {
    return Container(
      alignment: Alignment.center,
      width: 80,
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey,
      ),
    );
  }

  /// Header with title and done button
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(),
          Text(
            StringConst.bottomSheetTitle,
            style: AppTextStyle.semiTextStyle(
                color: AppColor.primaryTextColor, size: 18),
          ),
          Spacer(),
          InkWell(
            onTap: () {
              List<String> selectedAssetsPaths =
                  _selectedAssets.value.map((asset) => asset.id).toList();
              var dataMediaList = selectedLibrary.value + selectedAssetsPaths;
              Navigator.pop(context, dataMediaList);
            },
            child: Text(StringConst.doneText,
                style: AppTextStyle.mediumTextStyle(
                    color: AppColor.splashColor, size: 14)),
          ),
        ],
      ),
    );
  }

  /// Media options (Gallery, Library, Selected Count)
  Widget _buildMediaOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          _buildIconOption(Assets.bottomSheetGalley, "Gallery", () {
            selectedTab.value = "Gallery";
          }),
          SizedBox(width: 20),
          _buildIconOption(Assets.bottomSheetLibrary, "Library", () async {
            selectedTab.value = "Library";
            // context.pop();
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => MyLibrariesFromCreateMusaView(
                        musa: true,
                      )),
            );
            if (result != null) {
              for (var media in result) {
                if (media
                    .toString()
                    .contains(RegExp(r'\.(jpg|jpeg|png|gif|mp4|mov|avi)$'))) {
                  //selectedLibrary.value.add(media.toString());
                  selectedLibrary.value = List.from(selectedLibrary.value)
                    ..add(media.toString());
                } else if (media
                    .toString()
                    .contains(RegExp(r'\.(mp3|wav|flac|aac|m4a)$'))) {
                  if (widget.cubit != null) {
                    widget.cubit?.selectedAudio.value =
                        List.from(widget.cubit!.selectedAudio.value)
                          ..add(media.toString());
                  }
                }
              }
              setState(() {
                List<String> selectedAssetsPaths =
                    _selectedAssets.value.map((asset) => asset.id).toList();
                var dataMediaList = selectedLibrary.value + selectedAssetsPaths;
                Navigator.pop(context, dataMediaList);
              });
            }
            // else{
            //   Navigator.pop(context);
            // }
          }),
          SizedBox(width: 20),
          // _buildIconOption(Assets.bottomSheetLibrary, "Audio", () {
          //   selectedTab.value = "Audio";
          //   widget.cubit?.getLibrary();
          // }),
          Spacer(),
          ValueListenableBuilder<List<AssetEntity>>(
            valueListenable: _selectedAssets,
            builder: (_, selectedAssets, __) {
              return ValueListenableBuilder<List<String>>(
                valueListenable: selectedLibrary,
                builder: (_, selectedLibraryList, __) {
                  return ValueListenableBuilder<List<String>>(
                    valueListenable: widget.cubit!.selectedAudio,
                    builder: (_, selectedAudioList, __) {
                      return Text(
                        "Selected ${selectedAssets.length + selectedLibraryList.length + selectedAudioList.length}",
                      );
                    },
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildMediaList() {
    return ValueListenableBuilder<String>(
      valueListenable: selectedTab,
      builder: (_, selectedTab, __) {
        switch (selectedTab) {
          case "Gallery":
            return _buildGalleryView();
          // case "Library":
          //   return Center(
          //     child: Text("No data found"),
          //   ); //_buildLibraryView();
          // case "Audio":
          //   return _buildAudioView();
          default:
            return _buildGalleryView();
        }
      },
    );
  }

  /// Media list (thumbnails)
  Widget _buildGalleryView() {
    return SizedBox(
      height: 120,
      child: _assets.isEmpty
          ? MusaWidgets.loader(context: context, isForFullHeight: true)
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _assets.length,
              itemBuilder: (_, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        buildCameraSection();
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(width: 1, color: AppColor.black)),
                        child: Center(
                          child: Icon(Icons.photo_camera),
                        ),
                      ),
                    ),
                  );
                } else {
                  return _buildMediaItem(index);
                }
              },
            ),
    );
  }

  //
  // Widget _buildAudioView() {
  //   return SizedBox(
  //     height: 320,
  //     child: ValueListenableBuilder<List<String>>(
  //       valueListenable: widget.cubit!.selectedAudio,
  //       builder: (context, selectedAudio, _) {
  //         return GridView.builder(
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 3,
  //             crossAxisSpacing: 8,
  //             mainAxisSpacing: 8,
  //             childAspectRatio: 1.3,
  //           ),
  //           itemCount: widget.cubit?.audioLibrary?.length ?? 0,
  //           itemBuilder: (context, audioIndex) {
  //             final audio = widget.cubit?.audioLibrary?[audioIndex];
  //             final isSelected = selectedAudio.contains(audio?.fileLink);
  //             return GestureDetector(
  //               onTap: () {
  //                 if (isSelected) {
  //                   widget.cubit?.selectedAudio.value =
  //                       List.from(widget.cubit!.selectedAudio.value)
  //                         ..remove(audio?.fileLink);
  //                 } else {
  //                   widget.cubit?.selectedAudio.value =
  //                       List.from(widget.cubit!.selectedAudio.value)
  //                         ..add(audio?.fileLink ?? '');
  //                 }
  //                 setState(() {}); // Ensure UI updates
  //               },
  //               child: Column(
  //                 children: [
  //                   if (isSelected)
  //                     Icon(Icons.check_circle, color: Colors.green, size: 24),
  //                   Image.asset(Assets.audioFile, height: 50.sp, width: 50.sp),
  //                   Text("Audio-${audioIndex + 1}"),
  //                 ],
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }
  //
  // Widget _buildLibraryView() {
  //   return SizedBox(
  //     height: 320,
  //     child: ValueListenableBuilder<List<String>>(
  //       valueListenable: selectedLibrary,
  //       builder: (context, selectedLibraryList, _) {
  //         return GridView.builder(
  //           shrinkWrap: true,
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 3,
  //             crossAxisSpacing: 8.w,
  //             mainAxisSpacing: 8.h,
  //             childAspectRatio: 1.3,
  //           ),
  //           itemCount: widget.cubit?.mediaLibrary?.length ?? 0,
  //           itemBuilder: (context, mediaIndex) {
  //             final media = widget.cubit?.mediaLibrary?[mediaIndex];
  //             final isSelected = selectedLibraryList.contains(media?.fileLink);
  //
  //             bool isVideo =
  //                 media?.fileLink?.toLowerCase().endsWith('.mp4') ?? false;
  //
  //             return GestureDetector(
  //               onTap: () {
  //                 if (isSelected) {
  //                   selectedLibrary.value = List.from(selectedLibrary.value)
  //                     ..remove(media?.fileLink);
  //                 } else {
  //                   selectedLibrary.value = List.from(selectedLibrary.value)
  //                     ..add(media?.fileLink.toString() ?? '');
  //                 }
  //               },
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(0),
  //                 child: Stack(
  //                   fit: StackFit.expand,
  //                   children: [
  //                     if (!isVideo)
  //                       CachedNetworkImage(
  //                         imageUrl: media?.fileLink ?? "",
  //                         fit: BoxFit.cover,
  //                         placeholder: (context, url) => Container(
  //                           color: Colors.grey[200],
  //                           child: Center(
  //                             child: Icon(Icons.download_outlined,
  //                                 color: Colors.grey),
  //                           ),
  //                         ),
  //                         errorWidget: (context, url, error) => Container(
  //                           color: Colors.grey[200],
  //                           child: Icon(Icons.error, color: Colors.red),
  //                         ),
  //                       ),
  //                     if (isVideo)
  //                       Stack(
  //                         children: [
  //                           FutureBuilder(
  //                             future: _getVideoController(media?.fileLink ?? '')
  //                                 .initialize(),
  //                             builder: (context, snapshot) {
  //                               if (snapshot.connectionState ==
  //                                   ConnectionState.waiting) {
  //                                 return Center(
  //                                     child: Icon(Icons.download_outlined,
  //                                         color: Colors.grey));
  //                               } else if (snapshot.hasError ||
  //                                   !snapshot.hasData) {
  //                                 return Center(child: Icon(Icons.error));
  //                               } else {
  //                                 return VideoPlayer(_getVideoController(
  //                                     media?.fileLink ?? ''));
  //                               }
  //                             },
  //                           ),
  //                           Positioned(
  //                             left: 8.w,
  //                             bottom: 8.h,
  //                             child: Container(
  //                               padding: EdgeInsets.all(4.w),
  //                               decoration: BoxDecoration(
  //                                 color: Colors.black.withOpacity(0.6),
  //                                 borderRadius: BorderRadius.circular(4.r),
  //                               ),
  //                               child: Icon(Icons.play_arrow,
  //                                   color: Colors.white, size: 16.sp),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     if (isSelected)
  //                       const Positioned(
  //                         top: 5,
  //                         right: 5,
  //                         child: Icon(Icons.check_circle,
  //                             color: Colors.green, size: 24),
  //                       ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  // VideoPlayerController _getVideoController(String videoUrl) {
  //   if (_controllers.containsKey(videoUrl)) {
  //     return _controllers[videoUrl]!;
  //   } else {
  //     final controller = VideoPlayerController.network(videoUrl)
  //       ..initialize().then((_) {
  //         setState(() {});
  //       }).catchError((error) {
  //         print("Video initialization error: $error");
  //       });
  //     _controllers[videoUrl] = controller;
  //     return controller;
  //   }
  // }

  /// Media item widget
  Widget _buildMediaItem(int index) {
    final asset = _assets[index];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          if (_selectedAssets.value.contains(asset)) {
            _selectedAssets.value = List.from(_selectedAssets.value)
              ..remove(asset);
          } else {
            _selectedAssets.value = List.from(_selectedAssets.value)
              ..add(asset);
          }
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(8), // Optional: rounded corners
              child: Image.memory(
                thumbnails[asset]!,
                fit: BoxFit.cover, // Ensure it scales properly
                width: 100, // Set fixed width
                height: 100, // Set fixed height
              ),
            ),
            if (asset.type == AssetType.video)
              const Positioned(
                bottom: 5,
                right: 5,
                child: Icon(Icons.videocam, color: Colors.white, size: 20),
              ),
            ValueListenableBuilder<List<AssetEntity>>(
              valueListenable: _selectedAssets,
              builder: (_, selectedAssets, __) {
                return selectedAssets.contains(asset)
                    ? const Positioned(
                        top: 5,
                        right: 5,
                        child: Icon(Icons.check_circle,
                            color: Colors.green, size: 24),
                      )
                    : const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom options (View All, Upload Audio, Record Audio)
  Widget _buildBottomOptions() {
    return Column(
      children: [
        _buildOption(Icons.view_timeline_outlined, 'View all', () async {
          final List<AssetEntity>? newSelection =
              await showModalBottomSheet<List<AssetEntity>>(
            context: context,
            isScrollControlled: true,
            builder: (_) =>
                FullGalleryPicker(selectedAssets: _selectedAssets.value),
          );
          if (newSelection != null) {
            _selectedAssets.value = List.from(newSelection);
          }
        }),
        _buildOption(Icons.audio_file, 'Upload an audio', () {
          widget.cubit?.pickAudioFile();
        }),
        _buildOption(Icons.mic, 'Record an audio clip', () {
          onRecordButtonPressed();
        }),
      ],
    );
  }

  onRecordButtonPressed() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 300,
              child: AudioCommentPopup(
                onRecordingComplete: (selectedRecordPath) {
                  widget.cubit?.recordAudio(selectedRecordPath);
                  if (mounted) {
                    context.pop();
                  }
                  setState(() {});
                },
                recordUploadBtn: () {
                  if (mounted) context.pop();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  buildCameraSection() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? imageFile =
          await picker.pickImage(source: ImageSource.camera);
      if (imageFile != null) {
        final PermissionState permission =
            await PhotoManager.requestPermissionExtend();
        if (!permission.isAuth) {
          print("Gallery permission denied");
          return;
        }
        final AssetEntity capturedAsset =
            await PhotoManager.editor.saveImageWithPath(imageFile.path);
        final Uint8List? thumbnail = await capturedAsset
            .thumbnailDataWithSize(const ThumbnailSize(200, 200));
        setState(() {
          _assets.insert(0, capturedAsset);
          thumbnails[capturedAsset] = thumbnail ?? Uint8List(0);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Widget _buildIconOption(String assetPath, String label, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Image.asset(assetPath,
              fit: BoxFit.fill, color: AppColor.primaryColor),
        ),
        Text(label,
            style: TextStyle(color: AppColor.primaryColor, fontSize: 12)),
      ],
    );
  }

  Widget _buildOption(IconData icon, String title, VoidCallback onTapCallback) {
    return GestureDetector(
      onTap: onTapCallback,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 8),
            Text(title),
          ],
        ),
      ),
    );
  }

  buildUploadMediaSection(dynamic cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MusaWidgets.commonAppBar2(
          height: 80,
          row: Padding(
            padding: MusaPadding.appBarPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 0,
                ),
                InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: Icon(Icons.close, color: AppColor.black, size: 22),
                ),
                SizedBox(
                  width: 14,
                ),
                Text(
                  'Add Media',
                  style: AppTextStyle.normalTextStyleNew(
                    size: 18,
                    color: AppColor.black,
                    fontweight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () async {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MediaLibraryDetailView(
                    //       mySectionCubit: mySectionCubit,
                    //       // musa: isUploading,
                    //     ),
                    //   ),
                    // );
                    // // onRecordButtonPressed();
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => MyLibrariesFromCreateMusaView(
                                musa: true,
                              )),
                    );
                    if (result != null) {
                      for (var media in result) {
                        if (media.toString().contains(
                            RegExp(r'\.(jpg|jpeg|png|gif|mp4|mov|avi)$'))) {
                          //selectedLibrary.value.add(media.toString());
                          selectedLibrary.value =
                              List.from(selectedLibrary.value)
                                ..add(media.toString());
                        }
                        // else if (media
                        //     .toString()
                        //     .contains(RegExp(r'\.(mp3|wav|flac|aac|m4a)$'))) {
                        //   if (widget.cubit != null) {
                        //     widget.cubit?.selectedAudio.value =
                        //         List.from(widget.cubit!.selectedAudio.value)
                        //           ..add(media.toString());
                        //   }
                        // }
                      }
                      setState(() {
                        List<String> selectedAssetsPaths = _selectedAssets.value
                            .map((asset) => asset.id)
                            .toList();
                        var dataMediaList =
                            selectedLibrary.value + selectedAssetsPaths;
                        Navigator.pop(context, dataMediaList);
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColor.textInactive, // light green background
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          StringConst.viewMedia,
                          style: AppTextStyle.normalTextStyleNew(
                            size: 14,
                            color: AppColor.greenDark,
                            fontweight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     _buildDottedButton(
              //       onTap: () {
              //         widget.cubit?.pickAudioFile();
              //       },
              //       icon: Assets.audioFile_1,
              //       label: StringConst.audioLibrary,
              //       height: 21,
              //       width: 21,
              //     ),
              //     SizedBox(
              //       width: 30,
              //     ),
              //     _buildDottedButton(
              //       onTap: () {
              //         onRecordButtonPressed();
              //       },
              //       icon: Assets.recordAudioSvg,
              //       label: StringConst.recordText,
              //       height: 21,
              //       width: 21,
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildDottedButton(
                        // onTap: () {
                        //   cubit?.pickAndUploadImages(
                        //     source: ImageSource.gallery,
                        //     multiple: true,
                        //   );
                        // },
                        onTap: () {
                          cubit?.pickAndUploadMediaUnified(
                              context: context, multiple: true);
                        },
                        icon: Assets.media,
                        label: StringConst.uploadMedia,
                        height: 21,
                        width: 21,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: _buildDottedButton(
                        onTap: () {
                          // cubit?.pickAndUploadImages(
                          //   source: ImageSource.camera,
                          //   multiple: false,
                          // );
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.camera_alt),
                                    title: Text("Capture Photo"),
                                    onTap: () {
                                      print("Capture Photo");
                                      Navigator.pop(context);
                                      cubit?.pickAndUploadMedia(
                                        source: ImageSource.camera,
                                        multiple: false,
                                        isVideo: false,
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.videocam),
                                    title: Text("Capture Video"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      cubit?.pickAndUploadMedia(
                                          source: ImageSource.camera,
                                          isVideo: true,
                                          multiple: true);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                          // loginCubit.loginWithGoogle(context);
                        },
                        icon: Assets.camera,
                        label: StringConst.captureMedia,
                        height: 21,
                        width: 21,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildDottedButton({
    required VoidCallback onTap,
    required String icon,
    required String label,
    required double height,
    required double width,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        color: AppColor.greenTextbd,
        borderType: BorderType.RRect,
        radius: Radius.circular(8),
        dashPattern: [3, 3],
        strokeWidth: 1,
        child: Container(
          width: 166,
          height: 94,
          decoration: BoxDecoration(
            color: AppColor.greenTextbg,
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                height: height,
                width: width,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                label,
                style: AppTextStyle.normalTextStyleNew(
                  size: 14,
                  color: AppColor.greenText,
                  fontweight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Container(
        //   width: 166,
        //   height: 94,
        //   padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        //   decoration: BoxDecoration(
        //     color: AppColor.greenTextbg, // Set your background color
        //     borderRadius: BorderRadius.circular(8),
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       SvgPicture.asset(
        //         icon,
        //         height: height,
        //         width: width,
        //       ),
        //       const SizedBox(width: 12),
        //       Flexible(
        //         child: Text(
        //           label,
        //           style: AppTextStyle.normalTextStyleNew(
        //             size: 16,
        //             color: AppColor.black,
        //             fontweight: FontWeight.w600,
        //           ),
        //           overflow: TextOverflow.ellipsis,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) {
      controller.dispose(); // Dispose controllers when the widget is disposed
    });
    super.dispose();
  }
}
