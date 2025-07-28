import 'package:intl/intl.dart';
import 'package:musa_app/Cubit/dashboard/my_section_cubit/my_section_cubit.dart';
import 'package:musa_app/Cubit/dashboard/my_section_cubit/my_section_state.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import 'package:musa_app/Utility/packages.dart';
import 'package:musa_app/Screens/dashboard/home/media_upload_page.dart';
import 'package:musa_app/Repository/AppResponse/library_response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:musa_app/Resources/CommonWidgets/audio_player.dart';

class MyMediaListView extends StatefulWidget {
  final MySectionCubit mySectionCubit;
  final bool? musa;
  const MyMediaListView({super.key, required this.mySectionCubit, this.musa});
  @override
  State<MyMediaListView> createState() => MyMediaListViewState();
}

class MyMediaListViewState extends State<MyMediaListView> {
  final GlobalKey _addButtonKey = GlobalKey();
  bool isUploading = false;
  List<LibraryFile> photos = [];
  List<LibraryFile> videos = [];
  bool isPhotoExpanded = false;
  bool isVideoExpanded = false;
  bool isAudioExpanded = false;
  bool _initialLoadComplete = false;

  @override
  void initState() {
    super.initState();
    // if (widget.mySectionCubit.mediaLibrary == null ||
    //     widget.mySectionCubit.mediaLibrary!.isEmpty) {
    // widget.mySectionCubit.getAllLibrary();
    // }
    if (widget.musa == true) {
      isUploading = true;
    }
    _loadMediaData();
  }

  Future<void> _loadMediaData() async {
    setState(() {
      _initialLoadComplete = false;
    });
    await widget.mySectionCubit.getAllLibrary();
    if (mounted) {
      setState(() {
        _initialLoadComplete = true;
      });
    }
  }

  void toggleSelection(String mediaId) {
    setState(() {
      if (widget.mySectionCubit.selectedMedia.contains(mediaId)) {
        widget.mySectionCubit.selectedMedia.remove(mediaId);
      } else {
        widget.mySectionCubit.selectedMedia.add(mediaId);
      }
    });
  }

  void showPhotoPreviewPopup({
    required BuildContext context,
    required String imageUrl,
    required VoidCallback onDelete,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.45,
          minChildSize: 0.3,
          maxChildSize: 0.6,
          expand: false,
          builder: (_, scrollController) {
            return SafeArea(
              top: false,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Photo Preview',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.close, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        // width: double.infinity,
                        // height: 250,
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.3,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 200,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color: AppColor.primaryColor,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image, size: 80),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onDelete();
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.mySectionCubit.mediaLibrary ?? [];
    final photoCount = widget.mySectionCubit.mediaLibrary?.length ?? 0;
    final visiblePhotoCount =
        isPhotoExpanded ? photoCount : (photoCount > 6 ? 6 : photoCount);
    final remainingPhotoCount = photoCount - visiblePhotoCount;

    final videos = widget.mySectionCubit.videoLibrary ?? [];
    final videoCount = widget.mySectionCubit.videoLibrary?.length ?? 0;
    final visibleVideoCount =
        isVideoExpanded ? videoCount : (videoCount > 3 ? 3 : videoCount);
    final remainingVideoCount = videoCount - visibleVideoCount;

    final audios = widget.mySectionCubit.audioLibrary ?? [];
    final audioCount = widget.mySectionCubit.audioLibrary?.length ?? 0;
    final visibleAudioCount =
        isVideoExpanded ? audioCount : (audioCount > 3 ? 3 : audioCount);
    final remainingAudioCount = audioCount - visibleAudioCount;

    return BlocConsumer<MySectionCubit, MySectionState>(
      bloc: widget.mySectionCubit,
      listener: (context, state) {
        if (state is MyLibraryFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        if (state is MyLibraryLoading && !_initialLoadComplete) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: MusaWidgets.loader(context: context)),
          );
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              MusaWidgets.commonAppBar2(
                height: 110.0,
                row: Container(
                  padding: MusaPadding.appBarPadding,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => context.pop(),
                        child: IconButton(
                          icon: SvgPicture.asset(Assets.backIcon),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Media",
                        style: AppTextStyle.normalTextStyleNew(
                          size: 17,
                          color: AppColor.black,
                          fontweight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    ListView(
                      padding: EdgeInsets.all(16.w),
                      children: [
                        Center(
                          child: _buildDottedButton(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MediaUploadPage()),
                              );
                              if (result == true) {
                                await _loadMediaData();
                              }
                            },
                            icon: Assets.plusIcon,
                            label: StringConst.uploadMedia,
                            height: 21,
                            width: 21,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        // if (widget.mySectionCubit.mediaLibrary?.isEmpty ?? true)
                        if (_initialLoadComplete &&
                            photoCount == 0 &&
                            videoCount == 0 &&
                            audioCount == 0)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 12.h),
                              Center(
                                child: Text(
                                  'No media files found',
                                  style: TextStyle(
                                      fontSize: 16.sp, color: AppColor.grey),
                                ),
                              ),
                            ],
                          )
                        else ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (photoCount > 0) ...[
                                Text(
                                  "Photo Collections ($photoCount)",
                                  style: AppTextStyle.normalTextStyleNew(
                                    size: 16,
                                    color: AppColor.greyNew,
                                    fontweight: FontWeight.w600,
                                  ),
                                ),
                                // SizedBox(height: 5.h),
                                GridView.count(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 8.w,
                                    mainAxisSpacing: 8.h,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: photos
                                        .take(visiblePhotoCount)
                                        .toList()
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      int index = entry.key;
                                      var photo = entry.value;
                                      // print("Photo ---------->: ${photo.id}");
                                      return GestureDetector(
                                        onTap: () {
                                          showPhotoPreviewPopup(
                                            context: context,
                                            imageUrl: photo.fileLink ?? '',
                                            onDelete: () async {
                                              final result = await widget
                                                  .mySectionCubit
                                                  .removeMusaMediaFile(
                                                fileId: photo.id ?? '',
                                              );
                                              if (result == true) {
                                                setState(() {
                                                  photos.remove(photo);
                                                });
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Failed to delete photo. Please try again.'),
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                  ),
                                                );
                                              }
                                            },
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6.r),
                                          child: CachedNetworkImage(
                                            imageUrl: photo.fileLink ?? '',
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(
                                              color: Colors.grey[200],
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                color: AppColor.primaryColor,
                                              )),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        ),
                                      );
                                    }).toList()),
                                SizedBox(height: 12.h),
                                if (photoCount > 6)
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isPhotoExpanded = !isPhotoExpanded;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      // width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: AppColor.textInactive,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          isPhotoExpanded
                                              ? "Show Less"
                                              : "Show $remainingPhotoCount More",
                                          style:
                                              AppTextStyle.normalTextStyleNew(
                                            size: 15,
                                            color: AppColor.greenDark,
                                            fontweight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                              if (videoCount > 0) ...[
                                SizedBox(height: 24.h),
                                Text(
                                  "Video Collections (${videos.length})",
                                  style: AppTextStyle.normalTextStyleNew(
                                    size: 16,
                                    color: AppColor.greyNew,
                                    fontweight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                CommonDottedDivider(
                                  color: AppColor.greyDividerColor,
                                  height: 1,
                                ),
                                ...videos
                                    .take(isVideoExpanded ? videos.length : 3)
                                    .map((video) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: MusaWidgets.thumbnailViewNew(
                                          video.fileLink ?? '',
                                          imageWidth: 64.w,
                                          imageHeight: 40.h,
                                          radius: 4.r,
                                        ),
                                        title: Text(
                                          video.fileLink != null
                                              ? video.fileLink!.split('/').last
                                              : 'No file name',
                                        ),
                                        onTap: () {},
                                      ),
                                      CommonDottedDivider(
                                        color: AppColor.greyDividerColor,
                                        height: 1,
                                      ),
                                      SizedBox(height: 12.h),
                                    ],
                                  );
                                }).toList(),
                                if (videoCount > 3)
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isVideoExpanded = !isVideoExpanded;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      // width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: AppColor.textInactive,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          isVideoExpanded
                                              ? "Show Less"
                                              : "Show $remainingVideoCount More",
                                          style:
                                              AppTextStyle.normalTextStyleNew(
                                            size: 15,
                                            color: AppColor.greenDark,
                                            fontweight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                              if (audioCount > 0) ...[
                                SizedBox(height: 20.h),
                                Text(
                                  "Audio Collections (${audios.length})",
                                  style: AppTextStyle.normalTextStyleNew(
                                    size: 16,
                                    color: AppColor.greyNew,
                                    fontweight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                CommonDottedDivider(
                                  color: AppColor.greyDividerColor,
                                  height: 1,
                                ),
                                ...audios
                                    .take(isAudioExpanded ? audios.length : 3)
                                    .map((audio) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: SvgPicture.asset(
                                          Assets.music,
                                          height: 50,
                                          width: 50,
                                        ),
                                        title: Text(
                                          audio.fileLink != null
                                              ? audio.fileLink!.split('/').last
                                              : 'No file name',
                                        ),
                                        onTap: () {
                                          _showAudioSliderPopup(
                                            audio.fileLink!,
                                            () async {
                                              final result = await widget
                                                  .mySectionCubit
                                                  .removeMusaMediaFile(
                                                fileId: audio.id ?? '',
                                              );
                                              if (result == true) {
                                                setState(() {
                                                  audios.remove(audio);
                                                });
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Failed to delete audio. Please try again.'),
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                  ),
                                                );
                                              }
                                            },
                                          );
                                        },
                                      ),
                                      CommonDottedDivider(
                                        color: AppColor.greyDividerColor,
                                        height: 1,
                                      ),
                                      SizedBox(height: 12.h),
                                    ],
                                  );
                                }).toList(),
                                if (audioCount > 3)
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isAudioExpanded = !isAudioExpanded;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      // width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: AppColor.textInactive,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          isAudioExpanded
                                              ? "Show Less"
                                              : "Show $remainingAudioCount More",
                                          style:
                                              AppTextStyle.normalTextStyleNew(
                                            size: 15,
                                            color: AppColor.greenDark,
                                            fontweight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 20.h),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                    if (state is MyLibraryLoading)
                      Center(child: MusaWidgets.loader(context: context)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAudioSliderPopup(String filePath, VoidCallback onDelete) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.2,
          maxChildSize: 0.5,
          builder: (_, controller) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Close Button
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close, size: 24),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // File Name
                  Text(
                    filePath.split('/').last,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 15),

                  // Audio Player Widget
                  AudioPlayerPopup(
                    filePath: filePath,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onDelete();
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColor.greenTextbg, // Set your background color
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                height: height,
                width: width,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  label,
                  style: AppTextStyle.normalTextStyleNew(
                    size: 16,
                    color: AppColor.black,
                    fontweight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required VoidCallback onTap,
    required String icon,
    required String label,
    required double height,
    required double width,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
            color: Color.fromARGB(255, 172, 166, 166)), // Plain border
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            icon,
            height: height,
            width: width,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTextStyle.normalTextStyleNew(
                size: 16,
                color: AppColor.black,
                fontweight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<dynamic>> groupMediaByDate() {
    final Map<String, List<dynamic>> groupedMedia = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var media in widget.mySectionCubit.mediaLibrary ?? []) {
      final mediaDate = DateTime.parse(media.createdAt ?? '');
      final mediaDay = DateTime(mediaDate.year, mediaDate.month, mediaDate.day);

      String key;
      if (mediaDay == today) {
        key = 'Today';
      } else if (mediaDay == yesterday) {
        key = 'Yesterday';
      } else {
        key = DateFormat('MMMM d, y').format(mediaDay);
      }

      if (!groupedMedia.containsKey(key)) {
        groupedMedia[key] = [];
      }
      groupedMedia[key]!.add(media);
    }

    return groupedMedia;
  }

  void _showAddOptions() {
    final RenderBox button =
        _addButtonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + button.size.height,
        position.dx + button.size.width,
        position.dy + button.size.height + 100,
      ),
      items: [
        PopupMenuItem(
          onTap: () async {
            await Future.delayed(Duration.zero);
            widget.mySectionCubit.pickAndUploadImages(
              source: ImageSource.gallery,
              multiple: true,
            );
          },
          child: Row(
            children: [
              Icon(Icons.photo, color: Colors.black),
              SizedBox(width: 10.w),
              Text('Gallery'),
            ],
          ),
        ),
      ],
    );
  }
}
