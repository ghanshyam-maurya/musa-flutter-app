import 'package:musa_app/Resources/CommonWidgets/audio_player.dart';
import 'package:musa_app/Screens/components/display_cast_mode_button.dart';

// import '../../../../Cubit/dashboard/home_dashboard_cubit/home_cubit.dart';
import '../../../../Repository/AppResponse/social_musa_list_response.dart';
import '../../../../Resources/CommonWidgets/comment_view.dart';
import '../../../../Utility/musa_widgets.dart';
import '../../../../Utility/packages.dart';
import 'musa_post_detail_with_comment.dart';
import 'package:musa_app/Screens/dashboard/my_section/my_album/edit_musa.dart';

class MusaPostDetailView extends StatefulWidget {
  final MusaData musaData;
  final Function? likeUpdateCallBack;
  final bool? isMyMusa;
  final bool? isHomeMusa;
  final bool? isOtherUserMusa;
  final Function()? deleteBtn;
  final bool isComeFromCarosel;

  final String? flowType;
  const MusaPostDetailView({
    super.key,
    required this.musaData,
    required this.flowType,
    this.likeUpdateCallBack,
    this.isMyMusa,
    this.isHomeMusa,
    this.isOtherUserMusa,
    this.deleteBtn,
    this.isComeFromCarosel = false,
  });

  @override
  State<MusaPostDetailView> createState() => _MusaPostDetailViewState(musaData);
}

class _MusaPostDetailViewState extends State<MusaPostDetailView> {
  late MusaData musaData;
  String userName = "", albumName = "", subAlbumName = "", userProfile = "";
  List<FileElement> mediaFiles = [];
  bool isFavorite = false;
  late int likeCount;
  final Repository repository = Repository();
  //_MusaPostDetailViewState(MusaDetailModel musaData){this.musaData=musaData;}

  _MusaPostDetailViewState(MusaData musaData) {
    this.musaData = musaData;
  }

  bool isSwitched = false;
  @override
  void initState() {
    setMusaDetails();
    super.initState();
  }

  setMusaDetails() {
    setState(() {
      if (musaData.userDetail != null && musaData.userDetail!.isNotEmpty) {
        userName =
            '${musaData.userDetail![0].firstName} ${musaData.userDetail![0].lastName}';
        userProfile = '${musaData.userDetail![0].photo}';
      }

      if (musaData.albumDetail != null && musaData.albumDetail!.isNotEmpty) {
        albumName = musaData.albumDetail?[0].title ?? '';
      }

      if (musaData.subAlbumDetail != null &&
          musaData.subAlbumDetail!.isNotEmpty) {
        subAlbumName = musaData.subAlbumDetail?[0].title ?? '';
      }

      if (musaData.file != null && musaData.file!.isNotEmpty) {
        mediaFiles = musaData.file!;
      }

      likeCount = musaData.likeCount ?? 0;
      isFavorite = musaData.isLikeByMe ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Column(
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
                        musaData.title ?? '',
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
              // MusaWidgets.commonAppBar(
              //   height: 110.sp,
              //   row: Padding(
              //     padding: MusaPadding.appBarPadding,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         InkWell(
              //           onTap: () {
              //             context.pop();
              //           },
              //           child: Padding(
              //             padding: const EdgeInsets.all(10.0),
              //             child: Icon(Icons.arrow_back_ios,
              //                 color: AppColor.black, size: 22.sp),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Expanded(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 0.h),
                            Text(
                              musaData.description ?? '',
                              style: AppTextStyle.normalTextStyleNew(
                                size: 14,
                                color: AppColor.black,
                                fontweight: FontWeight.w500,
                              ),
                            ),
                            if (musaData.description != null &&
                                musaData.description!.isNotEmpty)
                              SizedBox(height: 6.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  albumName,
                                  style: AppTextStyle.normalTextStyleNew(
                                    size: 14,
                                    color: Color(0xFFABABAB),
                                    fontweight: FontWeight.w500,
                                  ),
                                ),
                                if (subAlbumName.isNotEmpty) ...[
                                  Text(
                                    ' / ',
                                    style: AppTextStyle.normalTextStyleNew(
                                      size: 14,
                                      color: Color(0xFFABABAB),
                                      fontweight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    subAlbumName,
                                    style: AppTextStyle.normalTextStyleNew(
                                      size: 14,
                                      color: Color(0xFFABABAB),
                                      fontweight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            if (albumName.isNotEmpty || subAlbumName.isNotEmpty)
                              SizedBox(
                                height: 15.h,
                              ),
                            Divider(color: Color(0xFFE9E9E9)),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (musaData.isLikeByMe == true) {
                                        musaData.isLikeByMe = false;
                                        musaData.likeCount =
                                            (musaData.likeCount ?? 0) - 1;
                                      } else if (musaData.isLikeByMe == false) {
                                        musaData.isLikeByMe = true;
                                        musaData.likeCount =
                                            (musaData.likeCount ?? 0) + 1;
                                      }
                                    });
                                    widget.likeUpdateCallBack!(
                                        musaData.isLikeByMe,
                                        musaData.likeCount);
                                    // Check is Album Id or id only
                                    repository.likeMusa(
                                        musaId: musaData.id ?? "");
                                  },
                                  // child: Icon(
                                  //   Icons.favorite,
                                  //   color: musaData.isLikeByMe ?? false
                                  //       ? Colors.red
                                  //       : Colors.grey,
                                  //   size: 20,
                                  // ),
                                  child: SvgPicture.asset(
                                    musaData.isLikeByMe ?? false
                                        ? 'assets/svgs/like-true.svg'
                                        : 'assets/svgs/like-false.svg',
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  musaData.likeCount.toString(),
                                  style: AppTextStyle.normalTextStyle1
                                      .copyWith(fontSize: 12),
                                ),
                                SizedBox(width: 10.w),
                                InkWell(
                                  onTap: () {
                                    buildCommentViewDetails(context);
                                  },
                                  child: Row(
                                    children: [
                                      // Image.asset(
                                      //   Assets.commentIcon,
                                      //   color: Colors.black,
                                      //   height: 20,
                                      //   width: 20,
                                      // ),
                                      SvgPicture.asset(
                                        'assets/svgs/comment.svg',
                                        height: 18,
                                        width: 18,
                                        // colorFilter: const ColorFilter.mode(
                                        //   Colors.black,
                                        //   BlendMode.srcIn,
                                        // ),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        musaData.textCommentCount.toString(),
                                        style: AppTextStyle.normalTextStyle1
                                            .copyWith(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                InkWell(
                                  onTap: () {
                                    buildCommentViewDetails(context);
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svgs/record.svg',
                                        height: 18,
                                        width: 18,
                                        // colorFilter: const ColorFilter.mode(
                                        //   Colors.black,
                                        //   BlendMode.srcIn,
                                        // ),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        musaData.audioCommentCount.toString(),
                                        style: AppTextStyle.normalTextStyle1
                                            .copyWith(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  height: 28,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFE6F6EE),
                                      borderRadius: BorderRadius.circular(6.sp),
                                      border: Border.all(
                                          width: 1.sp,
                                          color: AppColor.greenDark)),
                                  child: Center(
                                      child: Text(
                                          '  ${musaData.contributorCount ?? "0"} ${StringConst.isContributedText}  ',
                                          style: AppTextStyle.normalTextStyle1
                                              .copyWith(
                                                  fontSize: 12,
                                                  color: AppColor.greenDark))),
                                ),
                              ],
                            ),
                            Divider(color: Color(0xFFE9E9E9)),
                            // SizedBox(
                            //   height: 10.h,
                            // ),
                            // Text(
                            //   "Media(${musaData.file?.length})",
                            //   style: AppTextStyle.normalTextStyle1.copyWith(
                            //       color: AppColor.black, fontSize: 15),
                            // ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: MusaPadding.horizontalPadding,
                        child: Column(
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: mediaFiles.length,
                              itemBuilder: (context, index) {
                                String url =
                                    (mediaFiles[index].previewLink != null &&
                                            mediaFiles[index]
                                                .previewLink!
                                                .isNotEmpty)
                                        ? mediaFiles[index].previewLink!
                                        : mediaFiles[index].fileLink ?? '';
                                return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MusaPostDetailWithCommentView(
                                                    musaId: musaData.id ?? "",
                                                    isVideo:
                                                        Utilities.isVideoUrl(
                                                                url)
                                                            .toString(),
                                                    url: url,
                                                    commentCount: musaData
                                                        .commentCount
                                                        .toString(),
                                                  )));
                                    },
                                    child: Utilities.isVideoUrl(url)
                                        ? MusaWidgets.autoPlayVideoView(
                                            url,
                                            width: double.infinity,
                                            height: double.infinity,
                                          )
                                        : Utilities.isAudioUrl(url)
                                            ? Utilities.getAudioPlayerView(url)
                                            : MusaWidgets.getPhotoView(url));
                              },
                            ),
                            SizedBox(
                              height: 100,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Positioned(
            bottom: 0,
            child: SafeArea(
              child: Container(
                color: AppColor.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if ((musaData.audioComments?.isNotEmpty ?? false) &&
                          musaData.audioComments!.first != '') ...[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: AudioPlayerPopup(
                            filePath: musaData.audioComments!.first,
                          ),
                        ),
                      ],
                      Divider(color: Color(0xFFE9E9E9)),
                      //=============uncomment for previous view==========
                      // (widget.flowType.toString() == "Album")
                      //     ? Container()
                      //     : Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           MusaWidgets.userProfileAvatar(
                      //             imageUrl: userProfile,
                      //             radius: 18.sp,
                      //             borderWidth: 3.sp,
                      //           ),
                      //           Text(
                      //             userName,
                      //             style: AppTextStyle.normalBoldTextStyle
                      //                 .copyWith(fontSize: 13),
                      //           ),
                      //         ],
                      //       ),

                      SizedBox(
                        height: 5.h,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            height: 28,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: AppColor.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.sp),
                                  side: BorderSide(
                                    color: AppColor.white,
                                    width: 1.sp,
                                  ),
                                ),
                                minimumSize: Size(0, 28), // height: 28
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Delete MUSA'),
                                    content: Text(
                                        'Are you sure you want to delete this MUSA?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text('No',
                                            style: TextStyle(
                                                color: AppColor.primaryColor)),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: Text('Yes',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  if (musaData.id != null &&
                                      musaData.id!.isNotEmpty) {
                                    widget.deleteBtn!();
                                    Navigator.of(context)
                                        .pop(); // Go back after delete
                                  }
                                }
                              },
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svgs/delete_icon.svg',
                                      width: 14,
                                      height: 14,
                                    ),
                                    SizedBox(width: 6.sp),
                                    Text(
                                      'Delete',
                                      style: AppTextStyle.normalTextStyle1
                                          .copyWith(
                                        fontSize: 14,
                                        color: Color(0xFFFF4343),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            // margin: EdgeInsets.only(left: 10),
                            height: 28,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: AppColor.white,
                                padding: EdgeInsets.all(1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.sp),
                                  side: BorderSide(
                                    color: AppColor.white,
                                    width: 1.sp,
                                  ),
                                ),
                                minimumSize: Size(0, 28), // height: 28
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditMusa(
                                      musaData: musaData,
                                      isComeFromCarosel:
                                          widget.isComeFromCarosel,
                                    ),
                                  ),
                                );
                              },
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svgs/edit_icon.svg',
                                      width: 14,
                                      height: 14,
                                    ),
                                    SizedBox(width: 6.sp),
                                    Text(
                                      'Edit MUSA',
                                      style: AppTextStyle.normalTextStyle1
                                          .copyWith(
                                        fontSize: 14,
                                        color: AppColor.greenDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          DisplayCastModeWidget(
                            padding: EdgeInsets.only(right: 10.sp),
                            fileList: musaData.file ?? [],
                            onPressed: () async {
                              // Your onPressed logic here
                            },
                            height: 30.sp,
                            fontSize: 14.sp,
                          ),
                          // (widget.isMyMusa != null && widget.isMyMusa!)
                          //     ? Row(
                          //         mainAxisAlignment: MainAxisAlignment.end,
                          //         children: [
                          //           Container(
                          //               // padding: MusaPadding.horizontalPadding,
                          //               height: 30.sp,
                          //               // width: 4.sp,
                          //               child: Row(
                          //                 mainAxisSize: MainAxisSize.min,
                          //                 children: [
                          //                   Text("Display Mode",
                          //                       style: TextStyle(
                          //                         color: AppColor.greenDark,
                          //                         fontSize: 14.sp,
                          //                       )),
                          //                   Transform.scale(
                          //                     scale:
                          //                         0.65, // Adjust the scale factor to change the height and width proportionally
                          //                     child: Switch(
                          //                       value: isSwitched,
                          //                       onChanged: (value) {
                          //                         setState(() {
                          //                           //isSwitched = value;
                          //                           if (value) {
                          //                             Utilities
                          //                                 .navigateToLandscapeScreen(
                          //                               context,
                          //                               displayViewItems:
                          //                                   musaData,
                          //                             );
                          //                           }
                          //                         });
                          //                       },
                          //                       activeTrackColor:
                          //                           AppColor.greenDark,
                          //                       activeColor: Color(0xFFE6F6EE),
                          //                       inactiveTrackColor:
                          //                           Color(0xFFE6F6EE),
                          //                       inactiveThumbColor:
                          //                           AppColor.greenDark,
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ))
                          //         ],
                          //       )
                          //     : Row(
                          //         mainAxisAlignment: MainAxisAlignment.end,
                          //         children: [
                          //           (musaData.isDisplayLoading != null &&
                          //                   musaData.isDisplayLoading!)
                          //               ? Container(
                          //                   margin: EdgeInsets.only(right: 30),
                          //                   height: 15,
                          //                   width: 15,
                          //                   child: CircularProgressIndicator(
                          //                     color: AppColor.primaryColor,
                          //                   ),
                          //                 )
                          //               : Container(
                          //                   padding:
                          //                       MusaPadding.horizontalPadding,
                          //                   height: 30.sp,
                          //                   // width: MediaQuery.of(context)
                          //                   //         .size
                          //                   //         .width /
                          //                   //     3,
                          //                   child: musaData.displayStatus !=
                          //                               null &&
                          //                           musaData.displayStatus
                          //                                   ?.status ==
                          //                               "Accept"
                          //                       ? Row(
                          //                           mainAxisSize:
                          //                               MainAxisSize.min,
                          //                           children: [
                          //                             Text("Display Mode",
                          //                                 style: TextStyle(
                          //                                   color: AppColor
                          //                                       .greenDark,
                          //                                   fontSize: 14.sp,
                          //                                 )),
                          //                             Transform.scale(
                          //                               scale:
                          //                                   0.65, // Adjust the scale factor to change the height and width proportionally
                          //                               child: Switch(
                          //                                 value: isSwitched,
                          //                                 onChanged: (value) {
                          //                                   setState(() {
                          //                                     //isSwitched = value;
                          //                                     if (value) {
                          //                                       Utilities
                          //                                           .navigateToLandscapeScreen(
                          //                                         context,
                          //                                         displayViewItems:
                          //                                             musaData,
                          //                                       );
                          //                                     }
                          //                                   });
                          //                                 },
                          //                                 activeTrackColor:
                          //                                     AppColor
                          //                                         .greenDark,
                          //                                 activeColor:
                          //                                     Color(0xFFE6F6EE),
                          //                                 inactiveTrackColor:
                          //                                     Color(0xFFE6F6EE),
                          //                                 inactiveThumbColor:
                          //                                     AppColor
                          //                                         .greenDark,
                          //                               ),
                          //                             ),
                          //                           ],
                          //                         )
                          //                       :
                          //                       //  MusaWidgets.borderTextButton(
                          //                       //     title: musaData
                          //                       //                 .displayStatus !=
                          //                       //             null
                          //                       //         ? musaData.displayStatus
                          //                       //                     ?.status ==
                          //                       //                 "NotInitiated"
                          //                       //             ? StringConst
                          //                       //                 .requested
                          //                       //             : musaData.displayStatus
                          //                       //                         ?.status ==
                          //                       //                     "Accept"
                          //                       //                 ? StringConst
                          //                       //                     .displayText
                          //                       //                 : StringConst
                          //                       //                     .buttonDisplay
                          //                       //         : StringConst
                          //                       //             .buttonDisplay,
                          //                       //     onPressed: () async {
                          //                       //       if (musaData.displayStatus
                          //                       //               ?.status ==
                          //                       //           "Accept") {
                          //                       //         Utilities
                          //                       //             .navigateToLandscapeScreen(
                          //                       //           context,
                          //                       //           displayViewItems:
                          //                       //               musaData,
                          //                       //         );
                          //                       //       } else if (musaData
                          //                       //                   .displayStatus ==
                          //                       //               null ||
                          //                       //           musaData.displayStatus
                          //                       //                   ?.status ==
                          //                       //               "Reject") {
                          //                       //         setState(() {
                          //                       //           musaData.isDisplayLoading =
                          //                       //               true;
                          //                       //         });
                          //                       //         await HomeCubit()
                          //                       //             .displayRequest(
                          //                       //                 musaId:
                          //                       //                     musaData.id ??
                          //                       //                         '',
                          //                       //                 context: context)
                          //                       //             .then((value) {
                          //                       //           musaData.isDisplayLoading =
                          //                       //               false;
                          //                       //           setState(() {
                          //                       //             musaData.displayStatus =
                          //                       //                 DisplayStatus(
                          //                       //                     status:
                          //                       //                         "NotInitiated",
                          //                       //                     id: musaData
                          //                       //                         .id);
                          //                       //           });
                          //                       //         });
                          //                       //       }
                          //                       //     },
                          //                       //     borderColor:
                          //                       //         AppColor.greenDark,
                          //                       //     borderWidth: 1,
                          //                       //     fontSize: 12,
                          //                       //     textcolor: AppColor.greenDark,
                          //                       //   ),
                          //                       Container(
                          //                           height: 26,
                          //                           child: Material(
                          //                             elevation: 0,
                          //                             child: InkWell(
                          //                               onTap: () async {
                          //                                 if (musaData
                          //                                         .displayStatus
                          //                                         ?.status ==
                          //                                     "Accept") {
                          //                                   Utilities
                          //                                       .navigateToLandscapeScreen(
                          //                                     context,
                          //                                     displayViewItems:
                          //                                         musaData,
                          //                                   );
                          //                                 } else if (musaData
                          //                                             .displayStatus ==
                          //                                         null ||
                          //                                     musaData.displayStatus
                          //                                             ?.status ==
                          //                                         "Reject") {
                          //                                   setState(() {
                          //                                     musaData.isDisplayLoading =
                          //                                         true;
                          //                                   });
                          //                                   await HomeCubit()
                          //                                       .displayRequest(
                          //                                           musaId:
                          //                                               musaData.id ??
                          //                                                   '',
                          //                                           context:
                          //                                               context)
                          //                                       .then((value) {
                          //                                     musaData.isDisplayLoading =
                          //                                         false;
                          //                                     setState(() {
                          //                                       musaData.displayStatus =
                          //                                           DisplayStatus(
                          //                                               status:
                          //                                                   "NotInitiated",
                          //                                               id: musaData
                          //                                                   .id);
                          //                                     });
                          //                                   });
                          //                                 }
                          //                               },
                          //                               child: Container(
                          //                                 decoration:
                          //                                     BoxDecoration(
                          //                                   color: Color(
                          //                                       0xFFE6F6EE),
                          //                                   borderRadius:
                          //                                       BorderRadius
                          //                                           .circular(
                          //                                               6.sp),
                          //                                   border: Border.all(
                          //                                     color: AppColor
                          //                                         .greenDark,
                          //                                     width: 1.sp,
                          //                                   ),
                          //                                 ),
                          //                                 padding: EdgeInsets
                          //                                     .symmetric(
                          //                                         horizontal:
                          //                                             2.sp,
                          //                                         vertical:
                          //                                             2.sp),
                          //                                 child: Center(
                          //                                   child: Text(
                          //                                     musaData.displayStatus !=
                          //                                             null
                          //                                         ? musaData.displayStatus
                          //                                                     ?.status ==
                          //                                                 "NotInitiated"
                          //                                             ? StringConst
                          //                                                 .requested
                          //                                             : musaData.displayStatus?.status ==
                          //                                                     "Accept"
                          //                                                 ? StringConst
                          //                                                     .displayText
                          //                                                 : StringConst
                          //                                                     .buttonDisplay
                          //                                         : StringConst
                          //                                             .buttonDisplay,
                          //                                     style: TextStyle(
                          //                                       color: AppColor
                          //                                           .greenDark,
                          //                                       fontSize: 12.sp,
                          //                                       fontFamily:
                          //                                           'Manrope',
                          //                                       fontWeight:
                          //                                           FontWeight
                          //                                               .w500,
                          //                                     ),
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ),
                          //                         ))
                          //         ],
                          //       ),
                        ],
                      ),

                      SizedBox(
                        height: 30.h,
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> buildCommentViewDetails(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(16),
              child: CommentView(
                musaId: musaData.id.toString(),
                commentCountBtn: (int count) {
                  setState(() {
                    musaData.commentCount = count;
                  });
                },
              ),
            );
          },
        );
      },
    );
  }
}
