import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:musa_app/Cubit/dashboard/my_section_cubit/my_section_cubit.dart';
import 'package:musa_app/Cubit/dashboard/my_section_cubit/my_section_state.dart';
import 'package:musa_app/Resources/app_style.dart';
import 'package:musa_app/Resources/colors.dart';
import 'package:musa_app/Screens/dashboard/my_section/my_library/full_photo_preview.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import 'package:image_picker/image_picker.dart';

class MediaLibraryDetailView extends StatefulWidget {
  final MySectionCubit mySectionCubit;
  final bool? musa;
  const MediaLibraryDetailView(
      {super.key, required this.mySectionCubit, this.musa});

  @override
  State<MediaLibraryDetailView> createState() => _MediaLibraryDetailViewState();
}

class _MediaLibraryDetailViewState extends State<MediaLibraryDetailView> {
  final GlobalKey _addButtonKey = GlobalKey();
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    if (widget.mySectionCubit.mediaLibrary == null) {
      widget.mySectionCubit.getLibrary();
    }
    if (widget.musa == true) {
      isUploading = true;
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

  @override
  Widget build(BuildContext context) {
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
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              MusaWidgets.commonAppBar(
                height: 110.0,
                row: Container(
                  padding: MusaPadding.appBarPadding,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => context.pop(),
                        child: Icon(Icons.arrow_back_ios,
                            color: AppColor.black, size: 22),
                      ),
                      Text("Media Library",
                          style: AppTextStyle.appBarTitleStyle),
                      Spacer(),
                      IconButton(
                        key: _addButtonKey,
                        onPressed: _showAddOptions,
                        icon: Icon(Icons.add_circle,
                            color: AppColor.black, size: 25),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    if (widget.mySectionCubit.mediaLibrary?.isEmpty ?? true)
                      Center(
                        child: Text(
                          'No media files found',
                          style:
                              TextStyle(fontSize: 16.sp, color: AppColor.grey),
                        ),
                      )
                    else
                      ListView.builder(
                        padding: EdgeInsets.all(16.w),
                        itemCount: groupMediaByDate().length,
                        itemBuilder: (context, index) {
                          final dates = groupMediaByDate().keys.toList();
                          final date = dates[index];
                          final mediaList = groupMediaByDate()[date]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Text(
                                  date,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF555555),
                                  ),
                                ),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8.w,
                                  mainAxisSpacing: 8.h,
                                ),
                                itemCount: mediaList.length,
                                itemBuilder: (context, mediaIndex) {
                                  final media = mediaList[mediaIndex];
                                  final mediaId = media.fileLink ?? '';
                                  final isSelected = widget
                                      .mySectionCubit.selectedMedia
                                      .contains(mediaId);

                                  return GestureDetector(
                                    onTap: () {
                                      if (isUploading == true) {
                                        toggleSelection(mediaId);
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    ImagePreviewScreen(
                                                      imageUrl: mediaId,
                                                    )));
                                      }
                                    },
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          child: CachedNetworkImage(
                                            imageUrl: mediaId,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(
                                              color: Colors.grey[200],
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              color: Colors.grey[200],
                                              child: Icon(Icons.error),
                                            ),
                                          ),
                                        ),

                                        // Video Play Icon
                                        if (media.fileLink?.endsWith('.mp4') ??
                                            false)
                                          Positioned(
                                            left: 8.w,
                                            bottom: 8.h,
                                            child: Container(
                                              padding: EdgeInsets.all(4.w),
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                borderRadius:
                                                    BorderRadius.circular(4.r),
                                              ),
                                              child: Icon(Icons.play_arrow,
                                                  color: Colors.white,
                                                  size: 16.sp),
                                            ),
                                          ),
                                        if (isSelected)
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.green,
                                              ),
                                              padding: EdgeInsets.all(6),
                                              child: Icon(Icons.check,
                                                  color: Colors.white,
                                                  size: 10),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 16.h),
                            ],
                          );
                        },
                      ),
                    if (state is MyLibraryLoading)
                      Center(child: MusaWidgets.loader(context: context)),
                    if (widget.mySectionCubit.selectedMedia.isNotEmpty)
                      Positioned(
                        bottom: 16.h,
                        left: 16.w,
                        right: 16.w,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Just pop, as data is
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          child: Text(
                            'Add (${widget.mySectionCubit.selectedMedia.length})',
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
    // final RenderBox button =
    //     _addButtonKey.currentContext!.findRenderObject() as RenderBox;
    final context = _addButtonKey.currentContext;
    if (context == null) return;

    final button = context.findRenderObject();
    if (button is! RenderBox) return;

    final Offset position = button.localToGlobal(Offset.zero);

    showMenu(
      context: this.context,
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
