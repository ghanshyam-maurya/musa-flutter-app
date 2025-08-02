import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'package:musa_app/Cubit/dashboard/my_section_cubit/my_section_cubit.dart';
import 'package:musa_app/Cubit/dashboard/my_section_cubit/my_section_state.dart';
import 'package:musa_app/Resources/CommonWidgets/audio_recoder.dart';
import 'package:musa_app/Screens/dashboard/my_section/my_library/media_library_detail_view.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import 'package:musa_app/Utility/packages.dart';

class MediaUploadPage extends StatefulWidget {
  const MediaUploadPage({super.key});

  @override
  State<MediaUploadPage> createState() => _MediaUploadPageState();
}

class _MediaUploadPageState extends State<MediaUploadPage> {
  MySectionCubit mySectionCubit = MySectionCubit();
  bool _hasShownSuccessSnackbar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.white,
        body: BlocConsumer<MySectionCubit, MySectionState>(
            bloc: mySectionCubit,
            listener: (BuildContext context, MySectionState state) {
              if (state is MyLibraryFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage)),
                );
                _hasShownSuccessSnackbar = false;
              }
              if (state is MyLibraryLoading) {
                _hasShownSuccessSnackbar = false;
              }
              if (state is MyLibrarySuccess && !_hasShownSuccessSnackbar) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('File Uploaded Successfully!'),
                    backgroundColor: AppColor.greenDark,
                  ),
                );
                _hasShownSuccessSnackbar = true;
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  buildUploadMediaSection(context),
                  state is MyLibraryLoading
                      ? MusaWidgets.loader(
                          context: context, isForFullHeight: true)
                      : Container(),
                ],
              );
            }));
  }

  buildUploadMediaSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MusaWidgets.commonAppBar2(
          height: 110.0,
          row: Padding(
            padding: MusaPadding.appBarPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Icon(Icons.close, color: AppColor.black, size: 22),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Add Media',
                  style: AppTextStyle.normalTextStyleNew(
                    size: 18,
                    color: AppColor.black,
                    fontweight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 45,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MediaLibraryDetailView(
                          mySectionCubit: mySectionCubit,
                          // musa: isUploading,
                        ),
                      ),
                    );
                    // onRecordButtonPressed();
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
        // SizedBox(height: 20.h),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 30.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text(
        //         StringConst.libraryView,
        //         style: AppTextStyle.mediumTextStyle(
        //             color: AppColor.black, size: 18),
        //       ),
        //       InkWell(
        //         onTap: () {
        //           if (bottomNavBarKey.currentState != null) {
        //             Navigator.pop(context);
        //             bottomNavBarKey.currentState!.pageIndex = 1;
        //             bottomNavBarKey.currentState!.onItemTapped(1);
        //           }
        //         },
        //         child: Padding(
        //           padding: const EdgeInsets.only(right: 8.0),
        //           child: Text(
        //             StringConst.view,
        //             style: AppTextStyle.normalTextStyle(
        //               color: AppColor.primaryColor,
        //               size: 13,
        //               decoration: TextDecoration.underline,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        SizedBox(height: 20.h),
        Expanded(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildDottedButton(
                        onTap: () {
                          _pickAudioFile();
                          // loginCubit.loginWithGoogle(context);
                        },
                        icon: Assets.audioFile_1,
                        label: StringConst.audioLibrary,
                        height: 21,
                        width: 21,
                      ),
                    ),
                    SizedBox(width: 16), // Reduce the gap if needed
                    Expanded(
                      child: _buildDottedButton(
                        onTap: () {
                          onRecordButtonPressed();
                          // loginCubit.loginWithGoogle(context);
                        },
                        icon: Assets.recordAudioSvg,
                        label: StringConst.recordText,
                        height: 21,
                        width: 21,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildDottedButton(
                        onTap: () {
                          // mySectionCubit.pickAndUploadImages(
                          //   source: ImageSource.gallery,
                          //   multiple: true,
                          // );
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.photo_library),
                                    title: Text("Pick Images"),
                                    onTap: () {
                                      Navigator.pop(context, true);
                                      mySectionCubit.pickAndUploadMedia(
                                        source: ImageSource.gallery,
                                        multiple: true,
                                        isVideo: false,
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.video_library),
                                    title: Text("Pick Videos"),
                                    onTap: () {
                                      Navigator.pop(context, true);
                                      mySectionCubit.pickAndUploadMedia(
                                        source: ImageSource.gallery,
                                        multiple: true,
                                        isVideo: true,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        icon: Assets.media,
                        label: StringConst.uploadMedia,
                        height: 21,
                        width: 21,
                      ),
                    ),
                    SizedBox(width: 16), // Reduce gap if needed
                    Expanded(
                      child: _buildDottedButton(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => SafeArea(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.camera_alt),
                                      title: Text("Capture Photo"),
                                      onTap: () {
                                        Navigator.pop(context);
                                        mySectionCubit.pickAndUploadMedia(
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
                                        mySectionCubit.pickAndUploadMedia(
                                          source: ImageSource.camera,
                                          isVideo: true,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        icon: Assets.camera,
                        label: StringConst.captureMedia,
                        height: 21,
                        width: 21,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )),

        // SizedBox(height: 10.h),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20),
        //   child: MusaWidgets.primaryTextButton(
        //       onPressed: () {
        //         mySectionCubit.pickAndUploadImages(
        //           source: ImageSource.gallery,
        //           multiple: true,
        //         );
        //       },
        //       title: "Media"),
        // ),
        // SizedBox(height: 10.h),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20),
        //   child: MusaWidgets.primaryTextButton(
        //       onPressed: () {
        //         onRecordButtonPressed();
        //       },
        //       title: "Record"),
        // ),
        // SizedBox(height: 10.h),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20),
        //   child: MusaWidgets.primaryTextButton(
        //       onPressed: () {
        //         mySectionCubit.pickAndUploadImages(
        //           source: ImageSource.camera,
        //           multiple: false,
        //         );
        //       },
        //       title: "Camera"),
        // ),
      ],
    );
  }

  Future<void> _pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );

      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        await mySectionCubit.uploadLibraryFiles(files);
      }
    } catch (e) {
      debugPrint('Error picking audio: $e');
    }
  }

  void onRecordButtonPressed() {
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
                onRecordingComplete: (selectedRecordPath) async {
                  mySectionCubit.audioFilePath = selectedRecordPath;
                  await mySectionCubit
                      .uploadLibraryFiles([File(selectedRecordPath)]);
                  Navigator.pop(context);
                },
                recordUploadBtn: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
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
}
