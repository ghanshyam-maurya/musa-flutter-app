import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musa_app/Cubit/dashboard/my_section_cubit/my_section_cubit.dart';
import 'package:musa_app/Cubit/dashboard/my_section_cubit/my_section_state.dart';
import 'package:musa_app/Resources/colors.dart';
import 'package:musa_app/Screens/dashboard/my_section/my_library/media_library_detail_view.dart';
import 'package:musa_app/Screens/dashboard/my_section/my_library/audio_library_detail_view.dart';
import 'package:musa_app/Utility/musa_widgets.dart';

class MyLibrariesView extends StatefulWidget {
  const MyLibrariesView({super.key, required this.mySectionCubit, this.musa});
  final MySectionCubit mySectionCubit;
  final bool? musa;

  @override
  State<MyLibrariesView> createState() => _MyLibrariesViewState();
}

class _MyLibrariesViewState extends State<MyLibrariesView> {
  bool isUploading = false;
  @override
  void initState() {
    super.initState();
    widget.mySectionCubit.getLibrary();
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
      bloc: widget.mySectionCubit,
      listener: (context, state) {
        if (state is MyLibraryFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        return Material(
          color: Colors.white,
          child: Column(
            children: [
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
                        _buildAudioLibrary(),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.5),
              if (widget.mySectionCubit.selectedMedia.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                          context, widget.mySectionCubit.selectedMedia);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(
                      'Done (${widget.mySectionCubit.selectedMedia.length})',
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
    if (widget.mySectionCubit.mediaLibrary == null ||
        widget.mySectionCubit.mediaLibrary!.isEmpty) {
      double itemHeight = 150.sp;
      double itemWidth = MediaQuery.of(context).size.width * 0.5 - 30.sp;
      return InkWell(
        onTap: () {
          openMediaLibrary(widget.mySectionCubit);
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
          images: widget.mySectionCubit.mediaLibrary!,
          bgColor: Colors.white,
          albumName: "Media Library",
          flowType: "LibraryMedia",
          subAlbumCount: widget.mySectionCubit.mediaLibrary!.length.toString(),
          showSubAlbum: true,
          onTap: () {
            openMediaLibrary(widget.mySectionCubit);
          },
        ),
      ],
    );
  }

  Widget _buildAudioLibrary() {
    if (widget.mySectionCubit.audioLibrary == null ||
        widget.mySectionCubit.audioLibrary!.isEmpty) {
      double itemHeight = 150.sp;
      double itemWidth = MediaQuery.of(context).size.width * 0.5 - 30.sp;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              openAudioLibrary(widget.mySectionCubit);
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
          images: widget.mySectionCubit.audioLibrary!,
          bgColor: Colors.white,
          albumName: "Audio Collection",
          flowType: "AudioFile",
          subAlbumCount: widget.mySectionCubit.audioLibrary!.length.toString(),
          showSubAlbum: true,
          onTap: () {
            openAudioLibrary(widget.mySectionCubit);
          },
        ),
      ],
    );
  }
}
