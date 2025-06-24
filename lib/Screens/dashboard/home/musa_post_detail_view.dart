import '../../../Cubit/dashboard/home_dashboard_cubit/home_cubit.dart';
import '../../../Repository/AppResponse/social_musa_list_response.dart';
import '../../../Resources/CommonWidgets/comment_view.dart';
import '../../../Utility/musa_widgets.dart';
import '../../../Utility/packages.dart';
import 'musa_post_detail_with_comment.dart';

class MusaPostDetailView extends StatefulWidget {
  final MusaData musaData;
  final Function? likeUpdateCallBack;
  final bool? isMyMusa;
  final bool? isHomeMusa;
  final bool? isOtherUserMusa;

  final String? flowType;
  const MusaPostDetailView(
      {super.key,
      required this.musaData,
      required this.flowType,
      this.likeUpdateCallBack,
      this.isMyMusa,
      this.isHomeMusa,
      this.isOtherUserMusa});

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
      backgroundColor: AppColor.bgGrey,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Column(
            children: [
              MusaWidgets.commonAppBar(
                height: 110.sp,
                row: Padding(
                  padding: MusaPadding.appBarPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          context.pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(Icons.arrow_back_ios,
                              color: AppColor.black, size: 22.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: MusaPadding.horizontalPadding,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.h),
                            Text(
                              musaData.title ?? '',
                              style: AppTextStyle.appBarTitleStyle,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  albumName,
                                  style: AppTextStyle.appBarTitleStyleBlack
                                      .copyWith(color: AppColor.primaryColor),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 5.sp, left: 4.sp, right: 4.sp),
                                  child: Icon(Icons.circle,
                                      color: AppColor.primaryColor, size: 6.sp),
                                ),
                                Text(
                                  subAlbumName,
                                  style: AppTextStyle.normalTextStyle1.copyWith(
                                      color: AppColor.primaryColor,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                            Text(
                              musaData.description ?? "",
                              style: AppTextStyle.normalTextStyle1
                                  .copyWith(fontSize: 12),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Divider(),
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
                                  child: Icon(
                                    Icons.favorite,
                                    color: musaData.isLikeByMe ?? false
                                        ? Colors.red
                                        : Colors.grey,
                                    size: 20,
                                  ),
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
                                      Image.asset(
                                        Assets.commentIcon,
                                        color: Colors.black,
                                        height: 20,
                                        width: 20,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        musaData.commentCount.toString(),
                                        style: AppTextStyle.normalTextStyle1
                                            .copyWith(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10.w),
                              ],
                            ),
                            Divider(),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              "Media(${musaData.file?.length})",
                              style: AppTextStyle.normalTextStyle1.copyWith(
                                  color: AppColor.black, fontSize: 15),
                            ),
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
                                String url = mediaFiles[index].fileLink ?? '';
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
                                        ? MusaWidgets.thumbnailView(url)
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
            child: Container(
              color: AppColor.bgGrey,
              width: MediaQuery.of(context).size.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Divider(),
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
                          margin: EdgeInsets.only(left: 30),
                          height: 30,
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.sp),
                              border: Border.all(
                                  width: 1.sp, color: AppColor.grey)),
                          child: Center(
                              child: Text(
                                  '  ${musaData.contributorCount ?? "0"} ${StringConst.isContributedText}  ',
                                  style: AppTextStyle.normalTextStyle1.copyWith(
                                      fontSize: 12, color: AppColor.grey))),
                        ),
                        (widget.isMyMusa != null && widget.isMyMusa!)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                      padding: MusaPadding.horizontalPadding,
                                      height: 40.sp,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Display Mode",
                                              style: AppTextStyle
                                                  .normalTextStyle1),
                                          Transform.scale(
                                            scale:
                                                0.65, // Adjust the scale factor to change the height and width proportionally
                                            child: Switch(
                                              value: isSwitched,
                                              onChanged: (value) {
                                                setState(() {
                                                  //isSwitched = value;
                                                  if (value) {
                                                    Utilities
                                                        .navigateToLandscapeScreen(
                                                      context,
                                                      displayViewItems:
                                                          musaData,
                                                    );
                                                  }
                                                });
                                              },
                                              activeTrackColor: Colors.white,
                                              activeColor: Colors.grey,
                                              inactiveTrackColor: Colors.white,
                                              inactiveThumbColor: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ))
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  (musaData.isDisplayLoading != null &&
                                          musaData.isDisplayLoading!)
                                      ? Container(
                                          margin: EdgeInsets.only(right: 30),
                                          height: 15,
                                          width: 15,
                                          child: CircularProgressIndicator(
                                            color: AppColor.primaryColor,
                                          ),
                                        )
                                      : Container(
                                          padding:
                                              MusaPadding.horizontalPadding,
                                          height: 40.sp,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          child: musaData.displayStatus !=
                                                      null &&
                                                  musaData.displayStatus
                                                          ?.status ==
                                                      "Accept"
                                              ? Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text("Display Mode",
                                                        style: AppTextStyle
                                                            .normalTextStyle1),
                                                    Transform.scale(
                                                      scale:
                                                          0.65, // Adjust the scale factor to change the height and width proportionally
                                                      child: Switch(
                                                        value: isSwitched,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            //isSwitched = value;
                                                            if (value) {
                                                              Utilities
                                                                  .navigateToLandscapeScreen(
                                                                context,
                                                                displayViewItems:
                                                                    musaData,
                                                              );
                                                            }
                                                          });
                                                        },
                                                        activeTrackColor:
                                                            Colors.white,
                                                        activeColor:
                                                            Colors.grey,
                                                        inactiveTrackColor:
                                                            Colors.white,
                                                        inactiveThumbColor:
                                                            Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : MusaWidgets.borderTextButton(
                                                  title: musaData
                                                              .displayStatus !=
                                                          null
                                                      ? musaData.displayStatus
                                                                  ?.status ==
                                                              "NotInitiated"
                                                          ? StringConst
                                                              .requested
                                                          : musaData.displayStatus
                                                                      ?.status ==
                                                                  "Accept"
                                                              ? StringConst
                                                                  .displayText
                                                              : StringConst
                                                                  .buttonDisplay
                                                      : StringConst
                                                          .buttonDisplay,
                                                  onPressed: () async {
                                                    if (musaData.displayStatus
                                                            ?.status ==
                                                        "Accept") {
                                                      Utilities
                                                          .navigateToLandscapeScreen(
                                                        context,
                                                        displayViewItems:
                                                            musaData,
                                                      );
                                                    } else if (musaData
                                                                .displayStatus ==
                                                            null ||
                                                        musaData.displayStatus
                                                                ?.status ==
                                                            "Reject") {
                                                      setState(() {
                                                        musaData.isDisplayLoading =
                                                            true;
                                                      });
                                                      await HomeCubit()
                                                          .displayRequest(
                                                              musaId:
                                                                  musaData.id ??
                                                                      '',
                                                              context: context)
                                                          .then((value) {
                                                        musaData.isDisplayLoading =
                                                            false;
                                                        setState(() {
                                                          musaData.displayStatus =
                                                              DisplayStatus(
                                                                  status:
                                                                      "NotInitiated",
                                                                  id: musaData
                                                                      .id);
                                                        });
                                                      });
                                                    }
                                                  },
                                                  borderColor:
                                                      AppColor.primaryColor,
                                                  borderWidth: 1,
                                                  fontSize: 12,
                                                  textcolor:
                                                      AppColor.primaryColor,
                                                ),
                                        )
                                ],
                              ),
                      ],
                    ),

                    SizedBox(
                      height: 30.h,
                    ),
                  ]),
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
