import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:musa_app/Utility/packages.dart';
import 'package:musa_app/Utility/video_thubnail_cache.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import '../Cubit/profile/profile_cubit/profile_cubit.dart';
import '../Repository/AppResponse/social_musa_list_response.dart';
import 'fixed_height_bottom_sheet.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:typed_data';

abstract class MusaWidgets {
  //Widget for add shimmer animation effect
  static Widget shimmerAnimation({required height, required width, radius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height, // Adjust the height accordingly
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 15)),
        ),
      ),
    );
  }

  // Widget for open bottom sheet
  // you can pass your own widget in bottom sheet
  static void openBottomSheet(
      {required context,
      required Widget requireWidget,
      Function()? closeCallback}) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: AppColor.white,
      // Allows the sheet to expand to content height
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20), // Top-left and top-right corners
        ),
      ),
      builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Spacer(),
                  InkWell(
                    onTap: () {
                      if (closeCallback != null) {
                        closeCallback();
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 60,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 16, top: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        if (closeCallback != null) {
                          closeCallback();
                        }
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close),
                    ),
                  ),
                  SizedBox(width: 20)
                ],
              ),
              SizedBox(
                height: 10,
              ),
              FixedHeightBottomSheet(
                requiredWidget: requireWidget,
              )
            ],
          ),
        );
      },
    );
  }

  static void requestSuccessful(BuildContext context, eventName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.sp)),
          elevation: 16,
          child: Container(
            height: 200.sp,
            decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(12.sp)),
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      color: AppColor.black,
                      size: 15.sp,
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 10.sp,
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.check, color: Colors.white, size: 25),
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    Text(
                      '$eventName ${StringConst.successDialogText}',
                      style: AppTextStyle.appBarTitleStyle,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget commonAppBar({
    double? height,
    final Widget? row,
    Color? backgroundColor,
  }) =>
      Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(40),
            ),
            // Only add gradient if backgroundColor is null
            gradient:
                backgroundColor == null ? AppColor.appBarGradient() : null),
        child: row ?? SizedBox.shrink(),
      );

  static Widget commonAppBar2({
    double? height,
    final Widget? row,
  }) =>
      Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(40),
          ),
          // gradient: AppColor.appBarGradient(),
        ),
        child: row ?? SizedBox.shrink(),
      );

  static Widget loader(
      {required BuildContext context, isForFullHeight = false}) {
    return Container(
      height: isForFullHeight
          ? MediaQuery.of(context).size.height
          : MediaQuery.of(context).size.height - 350,
      color: Color.fromRGBO(255, 255, 255, 0.5),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColor.primaryColor,
          strokeWidth: 4,
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }

  static Widget userProfileAvatarEdit({
    String? imageUrl,
    File? localImageFile,
    required radius,
    required borderWidth,
  }) =>
      Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(0xFFE6F6EE),
            width: borderWidth,
          ),
        ),
        child: CircleAvatar(
          radius: radius,
          backgroundImage: localImageFile != null
              ? FileImage(localImageFile)
              : (imageUrl != null && imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : AssetImage(Assets.userProfilePlaceholder)) as ImageProvider,
          backgroundColor: Colors.transparent,
        ),
      );

  static Widget progressLoader({
    required BuildContext context,
    isForFullHeight = false,
    required Widget precentage,
  }) {
    return Container(
      height: isForFullHeight
          ? MediaQuery.of(context).size.height
          : MediaQuery.of(context).size.height - 350,
      color: Color.fromRGBO(255, 255, 255, 0.5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColor.primaryColor,
              strokeWidth: 4,
              strokeCap: StrokeCap.round,
            ),
            precentage,
          ],
        ),
      ),
    );
  }

  static Widget userProfileAvatar({
    String? imageUrl,
    File? localImageFile,
    required double radius,
    required double borderWidth,
  }) =>
      Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: borderWidth,
          ),
        ),
        child:
            ClipRect(child: MusaWidgets.getPhotoView(imageUrl, radius: radius)),
      );

  static Widget getPhotoView(String? url, {imageWidth, imageHeight, radius}) {
    return CachedNetworkImage(
      imageUrl: (url != null && url.isNotEmpty && url != "null")
          ? url
          : 'https://cdn.pixabay.com/photo/2023/02/18/11/00/icon-7797704_1280.png',
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 15)),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) =>
          MusaWidgets.shimmerAnimation(width: imageWidth, height: imageHeight),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  static Material primaryTextButton(
          {required void Function()? onPressed,
          required String title,
          Color? bgcolor,
          Color? textcolor,
          double? minWidth,
          double? borderRadius,
          double? fontSize,
          FontWeight? fontWeight}) =>
      Material(
        elevation: 5.0, // Optional: Add elevation for button shadow
        borderRadius: BorderRadius.circular(10.0),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF02A959), Color(0xFF008C45)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius ?? 10.sp),
          ),
          child: MaterialButton(
            onPressed: onPressed,
            padding: EdgeInsets.all(12.sp),
            minWidth: minWidth ?? double.maxFinite,
            // color: bgcolor ?? AppColor.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10.sp),
            ),
            child: Text(
              title,
              style: AppTextStyle.buttonTextStyle
                  .copyWith(color: textcolor ?? AppColor.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );

  static Material secondaryTextButton({
    required void Function()? onPressed,
    required String title,
    Color? bgcolor,
    Color? textcolor,
    double? minWidth,
    double? minHeight, // Corrected the typo here
    double? borderRadius,
    double? fontSize,
    FontWeight? fontWeight,
    Widget? prefixIcon,
  }) =>
      Material(
        elevation: 5.0, // Optional: Add elevation for button shadow
        borderRadius: BorderRadius.circular(10.0),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF02A959), Color(0xFF008C45)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius ?? 5),
          ),
          child: MaterialButton(
            onPressed: onPressed,
            minWidth: minWidth ?? double.maxFinite,
            height: minHeight ?? 40.sp,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (prefixIcon != null) ...[
                  prefixIcon,
                  SizedBox(width: 8.0),
                ],
                Text(
                  title,
                  style: TextStyle(
                    color: textcolor ?? Colors.white,
                    fontSize: fontSize ?? 10,
                    fontWeight: fontWeight ?? FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );

  static Material borderTextButton({
    required void Function()? onPressed,
    required String title,
    Color? borderColor, // Add border color property
    double? borderWidth, // Add border width property
    Color? textcolor,
    double? minWidth,
    double? minHeight, // Height property
    double? borderRadius,
    double? fontSize,
    FontWeight? fontWeight,
  }) =>
      Material(
        elevation: 5.0, // Optional: Add elevation for button shadow
        borderRadius: BorderRadius.circular(10.0),
        child: Ink(
          decoration: BoxDecoration(
            color: Color(0xFFE6F6EE), // Transparent background
            borderRadius: BorderRadius.circular(borderRadius ?? 5),
            border: Border.all(
              color: borderColor ?? Colors.blue, // Default border color (blue)
              width: borderWidth ?? 2.0, // Default border width
            ),
          ),
          child: MaterialButton(
            onPressed: onPressed,
            minWidth: minWidth ?? double.maxFinite,
            height: minHeight ?? double.maxFinite,
            // Default height if not provided
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 5),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: textcolor ?? Colors.grey, // Default text color (blue)
                  fontSize: fontSize ?? 10, // Default  font size
                  fontWeight:
                      fontWeight ?? FontWeight.w400, // Default font weight
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );

  // static Widget thumbnailView1(url,
  //     {imageHeight, imageWidth, radius, BorderRadiusGeometry? customRadius}) {
  //   return SizedBox(
  //     width: imageWidth,
  //     height: imageHeight,
  //     child: Stack(
  //       children: [
  //         FutureBuilder<XFile?>(
  //             future: Utilities.generateVideoThumbnailFromUrl(
  //                 videoUrl: url, imageWidth: imageWidth),
  //             builder: (BuildContext context, AsyncSnapshot snapshot) {
  //               if (snapshot.hasData) {
  //                 return Container(
  //                   width: imageWidth,
  //                   height: imageHeight,
  //                   decoration: BoxDecoration(
  //                     shape: BoxShape.rectangle,
  //                     borderRadius: customRadius ??
  //                         BorderRadius.all(Radius.circular(radius ?? 10)),
  //                     image: DecorationImage(
  //                       image: FileImage(File(snapshot.data.path)),
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                 );
  //               } else if (snapshot.hasError) {
  //                 return Center(
  //                   child: Icon(Icons.error),
  //                 );
  //               } else {
  //                 return MusaWidgets.shimmerAnimation(
  //                     width: imageWidth, height: imageHeight);
  //               }
  //             }),
  //         SizedBox(
  //           width: imageWidth,
  //           height: imageHeight,
  //           child: Center(
  //               child: Icon(
  //                 Icons.play_arrow,
  //                 color: Colors.white,
  //                 size: 40,
  //               )),
  //         )
  //       ],
  //     ),
  //   );
  // }

  //Get thumbnail view for video0
  // static Widget thumbnailView(url,
  //     {imageHeight, imageWidth, radius, BorderRadiusGeometry? customRadius}) {
  //   return SizedBox(
  //     width: imageWidth,
  //     height: imageHeight,
  //     child: Stack(
  //       children: [
  //         FutureBuilder<File?>(
  //           future: VideoThumbnailCache.getVideoThumbnail(url, imageHeight),
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState == ConnectionState.waiting) {
  //               return MusaWidgets.shimmerAnimation(
  //                   width: imageWidth, height: imageHeight);
  //             } else if (snapshot.hasError || snapshot.data == null) {
  //               return Icon(Icons.error); // Show error icon
  //             } else {
  //               return Container(
  //                 width: imageWidth,
  //                 height: imageHeight,
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.rectangle,
  //                   borderRadius: customRadius ??
  //                       BorderRadius.all(Radius.circular(radius ?? 10)),
  //                   image: DecorationImage(
  //                     image: FileImage(File(snapshot.data!.path)),
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //               );
  //             }
  //           },
  //         ),
  //         SizedBox(
  //           width: imageWidth,
  //           height: imageHeight,
  //           child: Center(
  //               child: Icon(
  //             Icons.play_arrow,
  //             color: Colors.white,
  //             size: 40,
  //           )),
  //         )
  //       ],
  //     ),
  //   );
  // }
  static Widget thumbnailView(url,
      {imageHeight, imageWidth, radius, BorderRadiusGeometry? customRadius}) {
    return SizedBox(
      width: imageWidth,
      height: imageHeight,
      child: Stack(
        children: [
          FutureBuilder<File?>(
            future: VideoThumbnailCache.getVideoThumbnail(
              url,
              height: imageHeight?.toInt(),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return MusaWidgets.shimmerAnimation(
                    width: imageWidth, height: imageHeight);
              } else if (snapshot.hasError || snapshot.data == null) {
                return Icon(Icons.error); // Show error icon
              } else {
                return Container(
                  width: imageWidth,
                  height: imageHeight,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: customRadius ??
                        BorderRadius.all(Radius.circular(radius ?? 10)),
                    image: DecorationImage(
                      image: FileImage(File(snapshot.data!.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }
            },
          ),
          SizedBox(
            width: imageWidth,
            height: imageHeight,
            child: Center(
                child: Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 40,
            )),
          )
        ],
      ),
    );
  }
  // static Widget thumbnailView(
  //   String url, {
  //   double? imageHeight,
  //   double? imageWidth,
  //   double? radius,
  //   BorderRadiusGeometry? customRadius,
  // }) {
  //   return SizedBox(
  //     width: imageWidth,
  //     height: imageHeight,
  //     child: Stack(
  //       children: [
  //         Container(
  //           width: imageWidth,
  //           height: imageHeight,
  //           decoration: BoxDecoration(
  //             shape: BoxShape.rectangle,
  //             borderRadius: customRadius ??
  //                 BorderRadius.all(Radius.circular(radius ?? 10)),
  //             image: DecorationImage(
  //               image: AssetImage('assets/images/video_placeholder.png'),
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           width: imageWidth,
  //           height: imageHeight,
  //           child: Center(
  //             child: Icon(
  //               Icons.play_arrow,
  //               color: Colors.white,
  //               size: 40,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  static Widget thumbnailViewNew(
    String videoPath, {
    double? imageHeight,
    double? imageWidth,
    double? radius,
    BorderRadiusGeometry? customRadius,
  }) {
    print("Video Path: $videoPath");
    return FutureBuilder<Uint8List?>(
      future: VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxHeight: (imageHeight?.toInt() ??
            150), // specify the height of the thumbnail, let width auto-scaled to keep the source aspect ratio
        quality: 75,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MusaWidgets.shimmerAnimation(
            width: imageWidth,
            height: imageHeight,
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          return Icon(Icons.error);
        } else {
          return Container(
            width: imageWidth,
            height: imageHeight,
            decoration: BoxDecoration(
              borderRadius: customRadius ?? BorderRadius.circular(radius ?? 10),
              image: DecorationImage(
                image: MemoryImage(snapshot.data!),
                fit: BoxFit.cover,
              ),
            ),
          );
        }
      },
    );
  }

  static Widget userStatusRow({
    String? imageUrl,
    String? userName,
    String? status,
    bool? isContributed,
    required bool isMyMUSA,
    bool? isHomeMusa,
    Function()? deleteBtn,
    required BuildContext context,
    MusaData? musaData,
    ProfileCubit? profileCubit,
    UserDetail? userData,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            userProfileAvatar(
              imageUrl: imageUrl,
              radius: 23.0,
              borderWidth: 3.sp,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName ?? "Dummy User",
                  style:
                      AppTextStyle.appBarTitleStyleBlack.copyWith(fontSize: 12),
                ),
                Text(
                  status ?? '',
                  style: AppTextStyle.normalTextStyle1.copyWith(fontSize: 10),
                ),
              ],
            ),
          ],
        ),
        isHomeMusa == true
            ? Container()
            : Row(
                children: [
                  InkWell(onTap: deleteBtn, child: Text("DELETE")),
                  isMyMUSA
                      ? InkWell(
                          onTap: () {
                            // MusaWidgets.openBottomSheet(
                            //     context: context,
                            //     requireWidget: ContributorsInMusaList(
                            //       musaData: musaData,
                            //       contributorCount:  musaData!.contributorCount??0,
                            //     ));
                          },
                          child: Container(
                            height: 20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.sp),
                                border: Border.all(
                                    width: 1.sp, color: AppColor.grey)),
                            child: Center(
                                child: Text(
                                    '  ${musaData?.contributorCount.toString()} ${StringConst.isContributedText}  ',
                                    style: AppTextStyle.normalTextStyle1
                                        .copyWith(
                                            fontSize: 8,
                                            color: AppColor.grey))),
                          ),
                        )
                      : Container(),
                  isHomeMusa == true
                      ? Container()
                      : !isMyMUSA
                          ? Container()
                          : !isContributed!
                              ? PopupMenuButton<String>(
                                  color: AppColor.white,
                                  icon: Icon(Icons.more_vert,
                                      color: AppColor.black),
                                  onSelected: (value) {
                                    switch (value) {
                                      case 'Display Mode':
                                        break;
                                      case 'Add Contributor':
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         AddContributorView(
                                        //           onImagesSelected: (List<String>
                                        //           selectedImages) {},
                                        //           musaId: musaData!.id ?? '',
                                        //           selectedUsersCount: (count){
                                        //
                                        //           },
                                        //         ), // Replace with your new screen
                                        //   ),
                                        // );
                                        break;
                                      case 'Delete':
                                        // Handle Delete action
                                        if (musaData != null &&
                                            musaData.id!.isNotEmpty) {
                                          // profileCubit?.deleteMusaApi(
                                          //     musaId: musaData.id ?? "",
                                          //     userId: musaData.userId);
                                        }
                                        break;
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'Display Mode',
                                      child: Text(
                                        'Display Mode',
                                        style: AppTextStyle.normalTextStyle1,
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'Add Contributor',
                                      child: Text(
                                        'Add Contributor',
                                        style: AppTextStyle.normalTextStyle1,
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'Delete',
                                      child: Text(
                                        'Delete',
                                        style: AppTextStyle.normalTextStyle1,
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                ],
              )
      ],
    );
  }

  static Widget commonAlbumFolderGridContainer(
    BuildContext context, {
    required List<dynamic> images,
    required Color bgColor,
    GestureTapCallback? onTap,
    required String albumName,
    required flowType,
    String? folderId,
    bool? showSubAlbum = true,
    String? subAlbumCount,
  }) {
    // print('album name is------------------> $albumName');
    double itemHeight = 150.sp;
    double itemWidth = MediaQuery.of(context).size.width * 0.5 - 30.sp;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap ?? () {},
          child: Card(
            elevation: 0.0,
            color: AppColor.white,
            shadowColor: AppColor.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.sp),
            ),
            child: Container(
              height: itemHeight,
              width: itemWidth,
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(width: 1.5.sp, color: AppColor.white)),
              child: (images.length == 1)
                  ? (flowType == "AudioFile")
                      ? Image.asset(Assets.audioFile)
                      : Utilities.isVideoUrl(images[0].fileLink ?? '')
                          ? thumbnailView(images[0].fileLink ?? '',
                              imageHeight: 150.0,
                              imageWidth:
                                  MediaQuery.of(context).size.width * 0.5 -
                                      30.sp,
                              radius: 10.0)
                          : CachedNetworkImage(
                              imageUrl: images[0].fileLink ?? '',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: MediaQuery.of(context).size.width * 0.20,
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  image: DecorationImage(
                                    image: NetworkImage(images[0].fileLink),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.primaryColor,
                                ),
                              ),
                              // MusaWidgets.shimmerAnimation(
                              //   height: itemHeight,
                              //   width: itemWidth,
                              // ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )
                  : (images.length == 2)
                      ? SizedBox(
                          width: itemWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              (flowType == "AudioFile")
                                  ? Container(
                                      width: itemWidth / 2 - 10,
                                      decoration: BoxDecoration(
                                          color: bgColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          image: DecorationImage(
                                              image: AssetImage(
                                            Assets.audioFile,
                                          ))),
                                    )
                                  : Utilities.isVideoUrl(
                                          images[0].fileLink ?? '')
                                      ? thumbnailView(images[0].fileLink ?? '',
                                          imageHeight: itemHeight,
                                          imageWidth: itemWidth / 2 - 10,
                                          radius: 10.0)
                                      : CachedNetworkImage(
                                          imageUrl: images[0].fileLink ?? '',
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: itemWidth / 2 - 10,
                                            decoration: BoxDecoration(
                                              color: bgColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    images[0].fileLink),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) => Center(
                                              child: CircularProgressIndicator(
                                            color: AppColor.primaryColor,
                                          )),
                                          // MusaWidgets.shimmerAnimation(
                                          //     width: itemWidth / 2 - 10,
                                          //     height: itemHeight),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                              (flowType == "AudioFile")
                                  ? Container(
                                      width: itemWidth / 2 - 10,
                                      decoration: BoxDecoration(
                                          color: bgColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          image: DecorationImage(
                                              image: AssetImage(
                                            Assets.audioFile,
                                          ))),
                                    )
                                  : Utilities.isVideoUrl(
                                          images[1].fileLink ?? '')
                                      ? thumbnailView(images[1].fileLink ?? '',
                                          imageHeight: itemHeight,
                                          imageWidth: itemWidth / 2 - 10,
                                          radius: 10.0)
                                      : CachedNetworkImage(
                                          imageUrl: images[1].fileLink ?? '',
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: itemWidth / 2 - 10,
                                            decoration: BoxDecoration(
                                              color: bgColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    images[1].fileLink),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) => Center(
                                              child: CircularProgressIndicator(
                                            color: AppColor.primaryColor,
                                          )),
                                          // MusaWidgets.shimmerAnimation(
                                          //     width: itemWidth / 2 - 10,
                                          //     height: itemHeight),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                            ],
                          ),
                        )
                      : (images.length == 3)
                          ? SizedBox(
                              width: itemWidth,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  (flowType == "AudioFile")
                                      ? Container(
                                          width: itemWidth / 2,
                                          decoration: BoxDecoration(
                                              color: bgColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                Assets.audioFile,
                                              ))),
                                        )
                                      : Utilities.isVideoUrl(
                                              images[0].fileLink ?? '')
                                          ? thumbnailView(
                                              images[0].fileLink ?? '',
                                              imageHeight: itemHeight,
                                              imageWidth: itemWidth / 2 - 10,
                                              radius: 10.0)
                                          : CachedNetworkImage(
                                              imageUrl:
                                                  images[0].fileLink ?? '',
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width: itemWidth / 2,
                                                decoration: BoxDecoration(
                                                  color: bgColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 2),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        images[0].fileLink),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                color: AppColor.primaryColor,
                                              )),
                                              // MusaWidgets.shimmerAnimation(
                                              //   width: itemWidth / 2,
                                              //   height: itemHeight,
                                              // ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      (flowType == "AudioFile")
                                          ? Container(
                                              width: itemWidth / 2 - 10,
                                              height: itemHeight / 2,
                                              decoration: BoxDecoration(
                                                  color: bgColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 2),
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                    Assets.audioFile,
                                                  ))),
                                            )
                                          : Utilities.isVideoUrl(
                                                  images[1].fileLink ?? '')
                                              ? thumbnailView(
                                                  images[1].fileLink ?? '',
                                                  imageHeight:
                                                      itemHeight / 2 - 10,
                                                  imageWidth:
                                                      itemWidth / 2 - 10,
                                                  radius: 10.0)
                                              : CachedNetworkImage(
                                                  imageUrl:
                                                      images[1].fileLink ?? '',
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    width: itemWidth / 2 - 10,
                                                    height: itemHeight / 2 - 10,
                                                    decoration: BoxDecoration(
                                                      color: bgColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            images[1].fileLink),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                    color:
                                                        AppColor.primaryColor,
                                                  )),
                                                  // MusaWidgets
                                                  //     .shimmerAnimation(
                                                  //   width: itemWidth / 2 - 10,
                                                  //   height: itemHeight / 2 - 10,
                                                  // ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                      (flowType == "AudioFile")
                                          ? Container(
                                              width: itemWidth / 2 - 10,
                                              height: itemHeight / 2 - 10,
                                              decoration: BoxDecoration(
                                                  color: bgColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 2),
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                    Assets.audioFile,
                                                  ))),
                                            )
                                          : Utilities.isVideoUrl(
                                                  images[2].fileLink ?? '')
                                              ? thumbnailView(
                                                  images[2].fileLink ?? '',
                                                  imageHeight:
                                                      itemHeight / 2 - 10,
                                                  imageWidth:
                                                      itemWidth / 2 - 10,
                                                  radius: 10.0)
                                              : CachedNetworkImage(
                                                  imageUrl:
                                                      images[2].fileLink ?? '',
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    width: itemWidth / 2 - 10,
                                                    height: itemHeight / 2 - 10,
                                                    decoration: BoxDecoration(
                                                      color: bgColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            images[2].fileLink),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                    color:
                                                        AppColor.primaryColor,
                                                  )),
                                                  // MusaWidgets
                                                  //     .shimmerAnimation(
                                                  //   width: itemWidth / 2 - 10,
                                                  //   height: itemHeight / 2 - 10,
                                                  // ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  double itemWidth =
                                      (constraints.maxWidth - 4) / 2;
                                  double itemHeight = 150.sp / 2 - 5;

                                  return Wrap(
                                    spacing: 2.0,
                                    runSpacing: 2.0,
                                    children: List.generate(
                                        images.length > 4 ? 4 : images.length,
                                        (index) {
                                      if (index == 3 && images.length > 3) {
                                        return SizedBox(
                                          width: itemWidth,
                                          height: itemHeight,
                                          child: (flowType == "AudioFile")
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(10),
                                                    ),
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          Assets.audioFile),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '+${images.length - 3} more',
                                                      style: AppTextStyle
                                                          .appBarTitleStyle
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColor.white,
                                                        fontSize: 13.sp,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Utilities.isVideoUrl(
                                                      images[index].fileLink ??
                                                          '')
                                                  ? thumbnailView(
                                                      images[index].fileLink ??
                                                          '',
                                                      imageHeight: itemHeight,
                                                      imageWidth: itemWidth,
                                                      customRadius:
                                                          BorderRadius.only(
                                                        bottomRight:
                                                            Radius.circular(10),
                                                      ))
                                                  : CachedNetworkImage(
                                                      imageUrl: images[index]
                                                              .fileLink ??
                                                          '',
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: bgColor,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                images[index]
                                                                    .fileLink),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            '+${images.length - 3} more',
                                                            style: AppTextStyle
                                                                .appBarTitleStyle
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: AppColor
                                                                  .white,
                                                              fontSize: 13.sp,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                        color: AppColor
                                                            .primaryColor,
                                                      )),
                                                      // MusaWidgets
                                                      //     .shimmerAnimation(
                                                      //   width: itemWidth,
                                                      //   height: itemHeight,
                                                      // ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                        );
                                      }

                                      return SizedBox(
                                        width: itemWidth,
                                        height: itemHeight,
                                        child: (flowType == "AudioFile")
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: index == 0
                                                        ? Radius.circular(10)
                                                        : Radius.zero,
                                                    topRight: index == 1
                                                        ? Radius.circular(10)
                                                        : Radius.zero,
                                                    bottomLeft: index == 2
                                                        ? Radius.circular(10)
                                                        : Radius.zero,
                                                    bottomRight: index == 3
                                                        ? Radius.circular(10)
                                                        : Radius.zero,
                                                  ),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        Assets.audioFile),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            : Utilities.isVideoUrl(
                                                    images[index].fileLink ??
                                                        '')
                                                ? thumbnailView(
                                                    images[index].fileLink ??
                                                        '',
                                                    imageHeight: itemHeight,
                                                    imageWidth: itemWidth,
                                                    customRadius:
                                                        BorderRadius.only(
                                                      topLeft: index == 0
                                                          ? Radius.circular(10)
                                                          : Radius.zero,
                                                      topRight: index == 1
                                                          ? Radius.circular(10)
                                                          : Radius.zero,
                                                      bottomLeft: index == 2
                                                          ? Radius.circular(10)
                                                          : Radius.zero,
                                                      bottomRight: index == 3
                                                          ? Radius.circular(10)
                                                          : Radius.zero,
                                                    ),
                                                  )
                                                : CachedNetworkImage(
                                                    imageUrl: images[index]
                                                            .fileLink ??
                                                        '',
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft: index == 0
                                                              ? Radius.circular(
                                                                  10)
                                                              : Radius.zero,
                                                          topRight: index == 1
                                                              ? Radius.circular(
                                                                  10)
                                                              : Radius.zero,
                                                          bottomLeft: index == 2
                                                              ? Radius.circular(
                                                                  10)
                                                              : Radius.zero,
                                                          bottomRight: index ==
                                                                  3
                                                              ? Radius.circular(
                                                                  10)
                                                              : Radius.zero,
                                                        ),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              images[index]
                                                                  .fileLink),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    placeholder: (context,
                                                            url) =>
                                                        Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                      color:
                                                          AppColor.primaryColor,
                                                    )),
                                                    // MusaWidgets
                                                    //     .shimmerAnimation(
                                                    //   width: itemWidth,
                                                    //   height: itemHeight,
                                                    // ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                      );
                                    }),
                                  );
                                },
                              ),
                            ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Text(
                albumName,
                style: AppTextStyle.semiMediumTextStyleNew(
                    color: Colors.black, size: 14.sp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              (showSubAlbum != null && showSubAlbum)
                  ? (flowType == "AudioFile" || flowType == "LibraryMedia")
                      ? Text(
                          '${subAlbumCount.toString()} files',
                          style: AppTextStyle.normalTextStyle(
                              color: AppColor.grey, size: 14),
                        )
                      : Text(
                          '${subAlbumCount.toString()} Sub Collection',
                          style: AppTextStyle.normalTextStyle(
                              color: AppColor.grey, size: 14),
                        )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  static Widget commonTextField({
    FocusNode? focusNode,
    int? inputMaxLine,
    Widget? suffixIcon,
    bool? obscureText,
    Widget? prefixIcon,
    TextEditingController? inputController,
    String? inputHintText,
    int? maxLength,
    String? Function(String?)? validator,
    bool readOnly = false,
    Key? key,
    void Function()? onTap,
    void Function(String)? onChanged,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    void Function()? onEditingComplete,
    Color? bgColor,
    void Function(String?)? onSaved,
    List<TextInputFormatter>?
        inputFormatters, // Added parameter for input formatters
  }) =>
      Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Container(
          color: bgColor ?? AppColor.white,
          child: TextFormField(
            key: key,
            readOnly: readOnly,
            obscureText: obscureText ?? false,
            onTap: onTap,
            onChanged: onChanged,
            onEditingComplete: onEditingComplete,
            onSaved: onSaved,
            maxLines: inputMaxLine,
            maxLength: maxLength,
            validator: validator,
            controller: inputController,
            keyboardType: keyboardType ?? TextInputType.text,
            textInputAction: textInputAction ?? TextInputAction.done,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: inputFormatters, // Pass input formatters here
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              hintText: inputHintText,
              hintStyle: AppTextStyle.semiMediumTextStyle(
                  color: AppColor.primaryTextColor, size: 14),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(inputMaxLine == 1 ? 10 : 10),
                borderSide: BorderSide(color: AppColor.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(inputMaxLine == 1 ? 10 : 10),
                borderSide: BorderSide(color: AppColor.primaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(inputMaxLine == 1 ? 10 : 10),
                borderSide: BorderSide(color: AppColor.grey),
              ),
            ),
          ),
        ),
      );

  static Widget shimmerAnimationLoadingForHomeScreenMyFeeds() {
    return Positioned(
      top: 150.sp,
      left: 25.sp,
      right: 25.sp,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: MusaWidgets.shimmerAnimation(
              height: 210.sp, width: double.infinity, radius: 10.0),
        ),
      ),
    );
  }

  static Widget searchTextField(
          {FocusNode? focusNode,
          int? inputMaxLine,
          Widget? suffixIcon,
          bool? obscureText,
          Widget? prefixIcon,
          TextEditingController? inputController,
          String? inputHintText,
          int? maxLength,
          String? Function(String?)? validator,
          bool readOnly = false,
          Key? key,
          void Function()? onTap,
          void Function(String)? onChanged,
          TextInputType? keyboardType,
          TextInputAction? textInputAction,
          void Function()? onEditingComplete,
          List<TextInputFormatter>? inputFormatters,
          Color? bgColor,
          void Function(String?)? onSaved}) =>
      Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: bgColor ?? AppColor.white,
          ),
          child: TextFormField(
            key: key,
            readOnly: readOnly,
            obscureText: obscureText ?? false,
            inputFormatters: inputFormatters,
            // textCapitalization: TextCapitalization.sentences,
            onTap: onTap,
            onChanged: onChanged,
            onEditingComplete: onEditingComplete,
            onSaved: onSaved,
            maxLines: inputMaxLine,
            maxLength: maxLength,
            validator: validator,
            controller: inputController,
            keyboardType: keyboardType ?? TextInputType.text,
            style: AppTextStyle.normalTextStyle(
                color: AppColor.primaryTextColor, size: 14),
            textInputAction: textInputAction ?? TextInputAction.done,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              // Icon inside the border
              prefixIcon: prefixIcon,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              hintText: inputHintText,
              hintStyle: AppTextStyle.normalTextStyle1,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: AppColor.grey)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: AppColor.primaryColor)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: AppColor.grey)),
            ),
          ),
        ),
      );

  static Widget searchAppBar({
    required BuildContext context,
    required TextEditingController searchController,
    required Widget body,
    required Function(String) onChangedSearch,
    Color? backgroundColor,
    VoidCallback? onClearSearch,
  }) =>
      Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(0),
                bottomLeft: Radius.circular(0),
              ),
              gradient: backgroundColor != null
                  ? null
                  : AppColor
                      .appBarGradient(), // Check if backgroundColor exists
              color: backgroundColor,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ), // Apply backgroundColor if it exists
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 26),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 11),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios_new_rounded)),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: MusaWidgets.searchTextField(
                        inputHintText: "Search",
                        bgColor: Color(0xFFF8FDFA),
                        inputController: searchController,
                        suffixIcon: GestureDetector(
                            onTap: () {
                              searchController.clear();
                              if (onClearSearch != null) {
                                onClearSearch();
                              }
                            },
                            child: Icon(Icons.clear)),
                        onChanged: onChangedSearch),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: body,
          ),
        ],
      );

  static Widget autoPlayVideoView(String url,
      {double? width, double? height, double? radius}) {
    return _AutoPlayVideoView(
      url: url,
      width: width,
      height: height,
      radius: radius,
    );
  }
}

// Add this private StatefulWidget at the bottom of musa_widgets.dart (or in a suitable place)
class _AutoPlayVideoView extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final double? radius;

  const _AutoPlayVideoView({
    required this.url,
    this.width,
    this.height,
    this.radius,
  });

  @override
  State<_AutoPlayVideoView> createState() => _AutoPlayVideoViewState();
}

class _AutoPlayVideoViewState extends State<_AutoPlayVideoView> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(true);
        _controller.setVolume(0.0);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius ?? 10),
      child: _isInitialized
          ? SizedBox(
              width: widget.width,
              height: widget.height,
              child: VideoPlayer(_controller),
            )
          : Container(
              width: widget.width,
              height: widget.height,
              color: Colors.black12,
              child: Center(
                child: CircularProgressIndicator(color: AppColor.primaryColor),
              ),
            ),
    );
  }
}
