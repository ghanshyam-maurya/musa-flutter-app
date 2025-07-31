import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:musa_app/Cubit/dashboard/my_section_cubit/my_section_cubit.dart';
import 'package:musa_app/Cubit/dashboard/my_section_cubit/my_section_state.dart';
import 'package:musa_app/Resources/app_style.dart';
import 'package:musa_app/Resources/assets.dart';
import 'package:musa_app/Resources/colors.dart';
import 'package:musa_app/Screens/dashboard/my_section/my_album/sub_album_view.dart';
import 'package:musa_app/Utility/musa_widgets.dart';

class MyAlbums extends StatefulWidget {
  final MySectionCubit mySectionCubit;
  const MyAlbums({super.key, required this.mySectionCubit});

  @override
  State<MyAlbums> createState() => _MyAlbumsState();
}

class _MyAlbumsState extends State<MyAlbums> {
  final TextEditingController _albumNameController = TextEditingController();

  @override
  void dispose() {
    _albumNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MySectionCubit, MySectionState>(
      bloc: widget.mySectionCubit,
      listener: (context, state) {
        if (state is MyAlbumFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            myAlbumSection(),
            if (state is MyAlbumLoading)
              Center(child: MusaWidgets.loader(context: context)),
          ],
        );
      },
    );
  }

  void _showAddAlbumDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 30.h,
                  bottom: 30.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add MUSA Collection',
                          style: AppTextStyle.mediumTextStyle(
                            color: AppColor.black,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    TextField(
                      cursorColor: AppColor.greenDark,
                      controller: _albumNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter Collection Name',
                        hintStyle: AppTextStyle.normalTextStyle(
                          color: AppColor.greyNew,
                          size: 14,
                        ),
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColor.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColor.greenDark),
                        ),
                        focusColor: AppColor.greenDark,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 15.h),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_albumNameController.text.trim().isNotEmpty) {
                            widget.mySectionCubit.createAlbum(
                              _albumNameController.text.trim(),
                            );
                            Navigator.pop(context);
                            _albumNameController.clear();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.greenDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                        ),
                        child: Text(
                          'Create',
                          style: AppTextStyle.mediumTextStyle(
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 5,
                right: 15,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: AppColor.black, size: 25.sp),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget myAlbumSection() {
    return BlocConsumer(
      bloc: widget.mySectionCubit,
      listener: (context, state) {
        if (state is MyAlbumFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            state is MyAlbumSuccess || widget.mySectionCubit.albumDataLoaded
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = 2;

                        double itemWidth =
                            (constraints.maxWidth - 8.0 * crossAxisCount) /
                                crossAxisCount;
                        return Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: List.generate(
                            widget.mySectionCubit.myAlbumList!.length + 1,
                            (index) {
                              // If it's the last index, show the "Add Album" container
                              if (index ==
                                  widget.mySectionCubit.myAlbumList!.length) {
                                return SizedBox(
                                  width: itemWidth,
                                  child: addAlbumContainer(context),
                                );
                              }

                              // If album list is empty, show empty album container
                              if (widget.mySectionCubit.myAlbumList!.isEmpty) {
                                return SizedBox(
                                  width: itemWidth,
                                  child: addAlbumContainer(context),
                                );
                              }

                              // return Container();

                              //Otherwise, show the album data
                              final albumData =
                                  widget.mySectionCubit.myAlbumList![index];

                              return SizedBox(
                                  width: itemWidth,
                                  child: albumData.file?.isEmpty ?? true
                                      ? emptyAlbumContainer(
                                          context,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyScreenSubAlbumView(
                                                    albumId: albumData.id ?? '',
                                                    albumName: albumData.title
                                                        .toString(),
                                                    album: albumData,
                                                    subAlbumCount: albumData
                                                            .subAlbumCount ??
                                                        0,
                                                  ),
                                                ));
                                          },
                                          albumName: albumData.title.toString(),
                                          folderId: albumData.id.toString(),
                                          subAlbumCount:
                                              albumData.subAlbumCount ?? 0,
                                        )
                                      : MusaWidgets
                                          .commonAlbumFolderGridContainer(
                                          context,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MyScreenSubAlbumView(
                                                  albumId: albumData.id ?? '',
                                                  albumName: albumData.title
                                                      .toString(),
                                                  subAlbumCount:
                                                      albumData.subAlbumCount ??
                                                          0,
                                                  album: albumData,
                                                ),
                                              ),
                                            );
                                          },
                                          images: albumData.file as List,
                                          bgColor: Colors.white,
                                          albumName: albumData.title.toString(),
                                          flowType: "MyMusa",
                                          folderId: albumData.id.toString(),
                                          showSubAlbum: true,
                                          subAlbumCount: albumData.subAlbumCount
                                              .toString(),
                                        ));
                              //);
                            },
                          ),
                        );
                      },
                    ),
                  )
                : Container(),
            state is MyAlbumLoading
                ? MusaWidgets.loader(context: context)
                : Container()
          ],
        );
      },
    );
  }

  Widget addAlbumContainer(BuildContext context) {
    return Container(
      height: 148.sp,
      margin: EdgeInsets.only(top: 10.h),
      width: MediaQuery.of(context).size.width * 0.5 - 30,
      child: Padding(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: InkWell(
          onTap: () {
            _showAddAlbumDialog();
          },
          child: DottedBorder(
            color: const Color(0xFFB4C7B9),
            dashPattern: const [5, 5],
            strokeWidth: 1,
            borderType: BorderType.RRect,
            radius: const Radius.circular(8),
            child: Container(
              // padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
              color: const Color(0xFFF8FDFA),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SvgPicture.asset(
                      'assets/svgs/add-media.svg',
                      width: 21,
                      height: 21,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: const Text(
                      "Add Collection",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF00674E),
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 16 / 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget emptyAlbumContainer(BuildContext context,
      {required albumName,
      required folderId,
      required subAlbumCount,
      required GestureTapCallback onTap}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Card(
            elevation: 0,
            color: AppColor.white,
            // shadowColor: AppColor.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.sp),
            ),
            child: Container(
              height: 148.sp,
              width: MediaQuery.of(context).size.width * 0.5 - 30,
              decoration: BoxDecoration(
                color: Color(0xFFF8FDFA),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 1,
                  color: Color(0xFFB4C7B9),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    Assets.media,
                    fit: BoxFit.cover,
                    height: 25.sp,
                    width: 25.sp,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'No Media',
                    style: AppTextStyle.normalBoldTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 13,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                albumName ?? "",
                style: AppTextStyle.semiMediumTextStyleNew(
                    color: Colors.black, size: 14.sp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subAlbumCount > 0
                  ? Text(
                      '${subAlbumCount.toString()} Sub Collection',
                      style: AppTextStyle.normalTextStyle(
                          color: AppColor.grey, size: 14),
                    )
                  : Text(
                      'No Sub Collection',
                      style: AppTextStyle.normalTextStyle(
                          color: AppColor.grey, size: 14),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
