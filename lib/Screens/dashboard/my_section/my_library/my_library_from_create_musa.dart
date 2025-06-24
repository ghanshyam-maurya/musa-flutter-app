import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musa_app/Cubit/dashboard/my_section_cubit/my_section_cubit.dart';
import 'package:musa_app/Cubit/dashboard/my_section_cubit/my_section_state.dart';
import 'package:musa_app/Resources/colors.dart';
import 'package:musa_app/Screens/dashboard/my_section/my_library/media_library_detail_view.dart';
import 'package:musa_app/Screens/dashboard/my_section/my_library/audio_library_detail_view.dart';
import 'package:musa_app/Utility/musa_widgets.dart';

import '../../../../Resources/app_style.dart';

class MyLibrariesFromCreateMusaView extends StatefulWidget {
  const MyLibrariesFromCreateMusaView({super.key, this.musa});
  final bool? musa;

  @override
  State<MyLibrariesFromCreateMusaView> createState() => _MyLibrariesViewState();
}

class _MyLibrariesViewState extends State<MyLibrariesFromCreateMusaView> {
  bool isUploading = false;
  MySectionCubit mySectionCubit = MySectionCubit();

  @override
  void initState() {
    super.initState();
    mySectionCubit.getLibrary();
    if (widget.musa == true) {
      isUploading = true;
    }
  }

  openMediaLibrary(MySectionCubit mySectionCubit) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MediaLibraryDetailView(
            mySectionCubit: mySectionCubit, musa: isUploading),
      ),
    );
    setState(() {});
  }

  openAudioLibrary(MySectionCubit mySectionCubit) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AudioLibraryDetailView(
          mySectionCubit: mySectionCubit,
          musa: widget.musa,
        ),
      ),
    );
    setState(() {}); // Refresh UI after returning
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MySectionCubit, MySectionState>(
      bloc: mySectionCubit,
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
                    ],
                  ),
                ),
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMediaLibrary(),
                        SizedBox(width: 10.w),
                        // _buildAudioLibrary(),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.5),
              if (mySectionCubit.selectedMedia.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, mySectionCubit.selectedMedia);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(
                      'Done (${mySectionCubit.selectedMedia.length})',
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMediaLibrary() {
    if (mySectionCubit.mediaLibrary == null ||
        mySectionCubit.mediaLibrary!.isEmpty) {
      double itemHeight = 150.sp;
      double itemWidth = MediaQuery.of(context).size.width * 0.5 - 30.sp;
      return InkWell(
        onTap: () {
          openMediaLibrary(mySectionCubit);
        },
        child: Card(
          elevation: 2.0,
          color: AppColor.white,
          shadowColor: AppColor.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.sp),
          ),
          child: Container(
            height: itemHeight,
            width: itemWidth,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(width: 1.5.sp, color: AppColor.white)),
            child: Text(
              'No Media',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColor.grey,
              ),
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 16.w,
      runSpacing: 16.h,
      children: [
        MusaWidgets.commonAlbumFolderGridContainer(
          context,
          images: mySectionCubit.mediaLibrary!,
          bgColor: Colors.white,
          albumName: "Media Library",
          flowType: "LibraryMedia",
          subAlbumCount: mySectionCubit.mediaLibrary!.length.toString(),
          showSubAlbum: true,
          onTap: () {
            openMediaLibrary(mySectionCubit);
          },
        ),
      ],
    );
  }

  Widget _buildAudioLibrary() {
    if (mySectionCubit.audioLibrary == null ||
        mySectionCubit.audioLibrary!.isEmpty) {
      double itemHeight = 150.sp;
      double itemWidth = MediaQuery.of(context).size.width * 0.5 - 30.sp;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              openAudioLibrary(mySectionCubit);
            },
            child: Card(
              elevation: 2.0,
              color: AppColor.white,
              shadowColor: AppColor.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.sp),
              ),
              child: Container(
                height: itemHeight,
                width: itemWidth,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: 1.5.sp, color: AppColor.white)),
                child: Text(
                  'No Audio',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColor.grey,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
        ],
      );
    }

    return Wrap(
      spacing: 16.w,
      runSpacing: 16.h,
      children: [
        MusaWidgets.commonAlbumFolderGridContainer(
          context,
          images: mySectionCubit.audioLibrary!,
          bgColor: Colors.white,
          albumName: "Audio Collection",
          flowType: "AudioFile",
          subAlbumCount: mySectionCubit.audioLibrary!.length.toString(),
          showSubAlbum: true,
          onTap: () {
            openAudioLibrary(mySectionCubit);
          },
        ),
      ],
    );
  }
}
