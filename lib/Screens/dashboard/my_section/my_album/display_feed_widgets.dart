import 'package:audioplayers/audioplayers.dart';
import 'package:musa_app/Screens/components/display_cast_mode_button.dart';
// import '../../../../Cubit/dashboard/home_dashboard_cubit/home_cubit.dart';
import '../../../../Repository/AppResponse/social_musa_list_response.dart';
import 'musa_image_video_container.dart';
import '../../../../Utility/musa_widgets.dart';
import '../../../../Utility/packages.dart';
import 'package:timeago/timeago.dart' as timeago;
// import '../profile/my_profile.dart';
import '../../home/contributors_in_musa.dart';
import 'musa_post_detail_view.dart';
import 'package:musa_app/Resources/CommonWidgets/audio_player.dart';

class CommonSubWidgets extends StatefulWidget {
  final bool isMyMUSA;
  final bool isContributed;
  final bool isHomeMUSA;
  final MusaData musaData;
  final int commentCount;
  final int textCommentCount;
  final int audioCommentCount;
  final Function() commentBtn;
  final Function()? deleteBtn;

  const CommonSubWidgets({
    super.key,
    required this.isMyMUSA,
    required this.isContributed,
    required this.isHomeMUSA,
    required this.musaData,
    required this.commentCount,
    required this.textCommentCount,
    required this.audioCommentCount,
    required this.commentBtn,
    this.deleteBtn,
    //this.cubit, this.profileCubit, this.subAlbumMusaCubit,
  });

  @override
  _CommonSubWidgetsState createState() => _CommonSubWidgetsState();
}

class _CommonSubWidgetsState extends State<CommonSubWidgets> {
  late MusaData musaData;
  int commentCount = 0;
  int textCommentCount = 0;
  int audioCommentCount = 0;
  String firstName = "", lastName = "", userProfileImage = "";
  String timeStatus = "", albumName = "", subAlbumName = "";
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String? audioFileUrl;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  int contributorCount = 0;
  bool _isDisposed = false;

  List<FileElement> imageVideoFileList = [];

  UserDetail userData = UserDetail();
  final Repository repository = Repository();
  @override
  void initState() {
    musaData = widget.musaData;
    // print('musaData--------------->${musaData.toJson()}');
    // print('text comment count-------------> ${musaData.textCommentCount}');
    if (musaData.userDetail != null && musaData.userDetail!.isNotEmpty) {
      firstName = musaData.userDetail![0].firstName ?? "";
      lastName = musaData.userDetail![0].lastName ?? "";
      userProfileImage = '${musaData.userDetail![0].photo}';
    }
    if (musaData.createdAt != null) {
      timeStatus = timeago.format(DateTime.parse('${musaData.createdAt}'));
    }

    if (musaData.albumDetail != null && musaData.albumDetail!.isNotEmpty) {
      albumName = musaData.albumDetail?[0].title ?? '';
    }

    if (musaData.subAlbumDetail != null &&
        musaData.subAlbumDetail!.isNotEmpty) {
      subAlbumName = musaData.subAlbumDetail?[0].title ?? '';
    }
    if (musaData.contributorCount != null) {
      contributorCount = musaData.contributorCount!;
    }
    if (musaData.file != null) {
      for (var file in musaData.file!) {
        if (Utilities.isAudioUrl(file.fileLink.toString())) {
          audioFileUrl = file.fileLink;
          break; // Stop after finding the first audio file
        } else {
          imageVideoFileList.add(file);
        }
      }
    }
    if (audioFileUrl != null) {
      _preloadAudio();
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CommonSubWidgets oldWidget) {
    musaData.commentCount = widget.commentCount;
    musaData.textCommentCount = widget.textCommentCount;
    musaData.audioCommentCount = widget.audioCommentCount;
    super.didUpdateWidget(oldWidget);
  }

  void playPauseAudio() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      if (duration.inSeconds == 0) {
        _preloadAudio();
      }
      await audioPlayer.play(UrlSource(audioFileUrl!));
    }
    if (!_isDisposed) {
      setState(() {
        isPlaying = !isPlaying;
      });
    }
  }

  void seekAudio(double value) {
    final seekPosition = Duration(seconds: value.toInt());
    audioPlayer.seek(seekPosition);
  }

  String formatDuration(Duration duration) {
    if (duration.inSeconds == 0) return "--:--";
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  void _preloadAudio() async {
    if (audioFileUrl == null) return;
    await audioPlayer.setSourceUrl(audioFileUrl!);

    final newDuration = await audioPlayer.getDuration();
    if (!_isDisposed && newDuration != null) {
      setState(() {
        duration = newDuration;
      });
    }

    audioPlayer.onPositionChanged.listen((newPosition) {
      if (!_isDisposed) {
        setState(() {
          position = newPosition;
        });
      }
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      if (!_isDisposed) {
        setState(() {
          duration = newDuration;
        });
      }
    });

    audioPlayer.onPlayerComplete.listen((_) {
      if (!_isDisposed) {
        setState(() {
          isPlaying = false;
          position = Duration.zero;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Duration remainingTime = duration - position;
    if (remainingTime.isNegative) remainingTime = Duration.zero;
    return Padding(
      padding: MusaPadding.bottomPadding,
      child: Card(
        elevation: 0,
        color: AppColor.white,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 1.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          // onTap: () {
                          //   if (musaData.userId != null &&
                          //       musaData.userId.toString().trim().isNotEmpty) {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => MyProfile(
                          //           userId: musaData.userId,
                          //         ),
                          //       ),
                          //     );
                          //   }
                          // },
                          child: Row(
                            children: [
                              MusaWidgets.userProfileAvatar(
                                imageUrl: userProfileImage,
                                radius: 23.0,
                                borderWidth: 3.sp,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (() {
                                    final totalLength = (firstName + lastName)
                                        .replaceAll(" ", "")
                                        .length;
                                    if (firstName.isEmpty && lastName.isEmpty) {
                                      return Text("Dummy User");
                                    } else if (totalLength >= 28) {
                                      // threshold, adjust as needed
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(firstName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                          Text(lastName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                        ],
                                      );
                                    } else {
                                      return Text(
                                        (firstName +
                                            (lastName.isNotEmpty
                                                ? ' ' + lastName
                                                : '')),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    }
                                  })(),
                                  Text(
                                    timeStatus,
                                    style: AppTextStyle.normalTextStyle1
                                        .copyWith(fontSize: 10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        widget.isHomeMUSA == true
                            ? Container()
                            : Row(
                                children: [
                                  // InkWell(onTap: widget.deleteBtn,
                                  //
                                  //      child: Text("DELETE")),

                                  widget.isMyMUSA
                                      ? Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                // BottomSheetContainer(
                                                //   requiredWidget:
                                                //       ContributorsInMusaList(
                                                //     musaData: musaData,
                                                //     contributorCount:
                                                //         contributorCount ??
                                                //             0,
                                                //   ),
                                                // );
                                                MusaWidgets.openBottomSheet(
                                                    context: context,
                                                    closeCallback: () {
                                                      setState(() {});
                                                    },
                                                    requireWidget:
                                                        ContributorsInMusaList(
                                                      musaData: musaData,
                                                      contributorCount:
                                                          contributorCount,
                                                      contributorRemoveCount:
                                                          (count) {
                                                        setState(() {
                                                          contributorCount =
                                                              contributorCount -
                                                                  count;
                                                        });
                                                      },
                                                    ));
                                              },
                                              child: Container(
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.sp),
                                                    border: Border.all(
                                                        width: 1.sp,
                                                        color: AppColor.white)),
                                                child: Center(
                                                    child: Text(
                                                        '  $contributorCount ${StringConst.isContributedText}  ',
                                                        style: AppTextStyle
                                                            .normalTextStyle1
                                                            .copyWith(
                                                                fontSize: 14,
                                                                color: AppColor
                                                                    .txtColor))),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                // Use async/await to get the result
                                                final result =
                                                    await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddContributor(
                                                      musaId: musaData.id ?? '',
                                                      initialSelectedContributors: [],
                                                      isComeFromProfile: true,
                                                      contributorAddCount:
                                                          (count) {
                                                        setState(() {
                                                          contributorCount =
                                                              contributorCount +
                                                                  count;

                                                          // Also update musaData's contributor count so it's consistent
                                                          if (musaData
                                                                  .contributorCount !=
                                                              null) {
                                                            musaData.contributorCount =
                                                                contributorCount;
                                                          }
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                );

                                                // Request updated contributor count from API if needed
                                                if (result == true) {
                                                  // Optional: You could add an API call here to refresh the data
                                                  // For now, we'll rely on the contributorAddCount callback
                                                }

                                                // Refresh UI when returning from AddContributor screen
                                                setState(() {});
                                              },
                                              // add border around this button
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6, vertical: 4),
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFE5F6F4),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.sp),
                                                    border: Border.all(
                                                        width: 1.sp,
                                                        color: AppColor
                                                            .greenDark)),
                                                child: Center(
                                                    child: SvgPicture.asset(
                                                  'assets/svgs/add_icon.svg',
                                                  width: 14.sp,
                                                  height: 14.sp,
                                                )),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  widget.isHomeMUSA == true
                                      ? Container()
                                      : !widget.isMyMUSA
                                          ? Container()
                                          : !widget.isContributed
                                              ?
                                              //  Theme(
                                              //     data: Theme.of(context)
                                              //         .copyWith(
                                              //       popupMenuTheme:
                                              //           PopupMenuThemeData(
                                              //         color: AppColor.white,
                                              //         shape:
                                              //             RoundedRectangleBorder(
                                              //           borderRadius:
                                              //               BorderRadius.all(
                                              //                   Radius.circular(
                                              //                       10)),
                                              //           side: BorderSide(
                                              //             color: AppColor
                                              //                 .grey, // Border color
                                              //             width:
                                              //                 1, // Border width
                                              //           ),
                                              //         ),
                                              //       ),
                                              //     ),
                                              //     child:
                                              //         PopupMenuButton<String>(
                                              //       icon: Icon(
                                              //         Icons.more_vert,
                                              //         color: AppColor.black,
                                              //       ),
                                              //       onSelected: (value) {
                                              //         switch (value) {
                                              //           case 'Display Mode':
                                              //             Utilities
                                              //                 .navigateToLandscapeScreen(
                                              //               context,
                                              //               displayViewItems:
                                              //                   musaData,
                                              //             );
                                              //             break;
                                              //           case 'Add Contributor':
                                              //             Navigator.push(
                                              //               context,
                                              //               MaterialPageRoute(
                                              //                 builder: (context) =>
                                              //                     AddContributor(
                                              //                   musaId: musaData
                                              //                           .id ??
                                              //                       '',
                                              //                   initialSelectedContributors: [],
                                              //                   isComeFromProfile:
                                              //                       true,
                                              //                   contributorAddCount:
                                              //                       (count) {
                                              //                     setState(() {
                                              //                       contributorCount =
                                              //                           contributorCount +
                                              //                               count;
                                              //                     });
                                              //                   },
                                              //                 ), // Replace with your new screen
                                              //               ),
                                              //             );
                                              //             break;
                                              //           case 'Delete':
                                              //             // Handle Delete action
                                              //             if (musaData
                                              //                 .id!.isNotEmpty) {
                                              //               print(
                                              //                   "RUNNING DELETE");

                                              //               widget.deleteBtn!();
                                              //             }
                                              //             break;
                                              //         }
                                              //       },
                                              //       itemBuilder: (context) => [
                                              //         // PopupMenuItem(
                                              //         //   value: 'Display Mode',
                                              //         //   child: Text(
                                              //         //     'Display Mode',
                                              //         //     style: AppTextStyle
                                              //         //         .normalTextStyle1,
                                              //         //   ),
                                              //         // ),
                                              //         // PopupMenuDivider(
                                              //         //   height: 0.4,
                                              //         // ),
                                              //         PopupMenuItem(
                                              //           value:
                                              //               'Add Contributor',
                                              //           child: Text(
                                              //             'Add Contributor',
                                              //             style: AppTextStyle
                                              //                 .normalTextStyle1,
                                              //           ),
                                              //         ),
                                              //         PopupMenuDivider(
                                              //           height: 0.4,
                                              //         ),
                                              //         PopupMenuItem(
                                              //           value: 'Delete',
                                              //           child: Text(
                                              //             'Delete',
                                              //             style: AppTextStyle
                                              //                 .normalTextStyle1,
                                              //           ),
                                              //         ),
                                              //       ],
                                              //     ),
                                              //   )
                                              Text("")
                                              : Container(),
                                ],
                              )
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MusaPostDetailView(
                                        musaData: musaData,
                                        flowType: '',
                                        isMyMusa: widget.isMyMUSA,
                                        likeUpdateCallBack:
                                            (likeByMe, likeCount) {
                                          setState(() {
                                            musaData.isLikeByMe = likeByMe;
                                            musaData.likeCount = likeCount;
                                          });
                                        },
                                        deleteBtn: widget.deleteBtn,
                                      )));
                          audioPlayer.stop();
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height,
                          child: MusaImageVideoContainer(
                              fileList: musaData.file ?? []),
                        )),
                    SizedBox(height: 10),
                    if ((widget.musaData.audioComments?.isNotEmpty ?? false) &&
                        widget.musaData.audioComments!.first != '') ...[
                      AudioPlayerPopup(
                        filePath: widget.musaData.audioComments!.first,
                      ),
                    ],
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 12), // Add left padding as needed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            musaData.title ?? '',
                            style: AppTextStyle.normalBoldTextStyle.copyWith(
                                color: AppColor.primaryColor, fontSize: 14),
                          ),
                          Text(
                            musaData.description ?? '',
                            style: AppTextStyle.normalBoldTextStyle
                                .copyWith(color: AppColor.black, fontSize: 14),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (albumName.isNotEmpty)
                                Text(
                                  albumName,
                                  style: AppTextStyle.appBarTitleStyleBlack
                                      .copyWith(
                                          color: AppColor.grey, fontSize: 12),
                                ),
                              if (albumName.isNotEmpty &&
                                  subAlbumName.isNotEmpty)
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 2.sp, left: 1.sp, right: 1.sp),
                                  child: Text(
                                    '/',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColor.grey,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              if (subAlbumName.isNotEmpty)
                                Text(
                                  subAlbumName,
                                  style: AppTextStyle.normalTextStyle1.copyWith(
                                      color: AppColor.grey, fontSize: 12),
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //Divider(),
              SizedBox(height: 8.sp),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      // Favorite Icon
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
                          // Check is Album Id or id only
                          repository.likeMusa(musaId: musaData.id ?? "");
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
                        width: 5,
                      ),
                      Text(
                        musaData.likeCount.toString(),
                        style: AppTextStyle.normalTextStyle1
                            .copyWith(fontSize: 12),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: widget.commentBtn,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Image.asset(
                            //   Assets.commentIcon,
                            //   color: Colors.black,
                            //   height: 18,
                            //   width: 18,
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
                              width: 5,
                            ),
                            Text(
                              (musaData.textCommentCount ?? 0).toString(),
                              style: AppTextStyle.normalTextStyle1
                                  .copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: widget.commentBtn,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Image.asset(
                            //   Assets.commentIcon,
                            //   color: Colors.black,
                            //   height: 18,
                            //   width: 18,
                            // ),
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
                              width: 5,
                            ),
                            Text(
                              (musaData.audioCommentCount ?? 0).toString(),
                              style: AppTextStyle.normalTextStyle1
                                  .copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  Spacer(),
                  // SizedBox(
                  //   width: 30.sp,
                  // ),
                  DisplayCastModeWidget(
                    padding: EdgeInsets.only(right: 10.sp),
                    fileList: musaData.file ?? [],
                    musaData: musaData,
                    onPressed: () async {
                      // Your onPressed logic here
                    },
                    height: 26.sp,
                    fontSize: 12.sp,
                  ),
                  // widget.isContributed == true
                  //     ? Text(
                  //         "Contributed  ",
                  //         style: AppTextStyle.normalTextStyle1
                  //             .copyWith(color: AppColor.grey),
                  //       )
                  //     : widget.isMyMUSA == true
                  //         ? SizedBox(
                  //             height: 24.sp,
                  //             child: Row(
                  //               mainAxisSize: MainAxisSize.min,
                  //               children: [
                  //                 MusaWidgets.borderTextButton(
                  //                   minWidth: 10.sp,
                  //                   title: StringConst.displayText,
                  //                   onPressed: () async {
                  //                     debugPrint(
                  //                         "musa id for display request == ${musaData.id}");
                  //                     Utilities.navigateToLandscapeScreen(
                  //                       context,
                  //                       displayViewItems: musaData,
                  //                     );
                  //                   },
                  //                   borderColor: AppColor.primaryColor,
                  //                   borderWidth: 1.sp,
                  //                   borderRadius: 5.sp,
                  //                   fontWeight: FontWeight.w400,
                  //                   fontSize: 12,
                  //                   textcolor: AppColor.primaryColor,
                  //                 ),
                  //               ],
                  //             ),
                  //           )
                  //         : imageVideoFileList.isNotEmpty
                  //             ? SizedBox(
                  //                 height: 24.sp,
                  //                 child: Row(
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   children: [
                  //                     (musaData.isDisplayLoading != null &&
                  //                             musaData.isDisplayLoading!)
                  //                         ? SizedBox(
                  //                             height: 15,
                  //                             width: 15,
                  //                             child: CircularProgressIndicator(
                  //                               color: AppColor.primaryColor,
                  //                             ),
                  //                           )
                  //                         : MusaWidgets.borderTextButton(
                  //                             minWidth: 10.sp,
                  //                             title: musaData.displayStatus !=
                  //                                     null
                  //                                 ? musaData.displayStatus
                  //                                             ?.status ==
                  //                                         "NotInitiated"
                  //                                     ? StringConst.requested
                  //                                     : musaData.displayStatus
                  //                                                 ?.status ==
                  //                                             "Accept"
                  //                                         ? StringConst
                  //                                             .displayText
                  //                                         : StringConst
                  //                                             .buttonDisplay
                  //                                 : StringConst.buttonDisplay,
                  //                             onPressed: () async {
                  //                               debugPrint(
                  //                                   "musa id for display request == ${musaData.id}");
                  //                               if (musaData.displayStatus
                  //                                       ?.status ==
                  //                                   "Accept") {
                  //                                 Utilities
                  //                                     .navigateToLandscapeScreen(
                  //                                   context,
                  //                                   displayViewItems: musaData,
                  //                                 );
                  //                               } else if (musaData
                  //                                           .displayStatus ==
                  //                                       null ||
                  //                                   musaData.displayStatus
                  //                                           ?.status ==
                  //                                       "Reject") {
                  //                                 setState(() {
                  //                                   musaData.isDisplayLoading =
                  //                                       true;
                  //                                 });
                  //                                 await HomeCubit()
                  //                                     .displayRequest(
                  //                                         musaId:
                  //                                             musaData.id ?? '',
                  //                                         context: context)
                  //                                     .then((value) {
                  //                                   musaData.isDisplayLoading =
                  //                                       false;
                  //                                   setState(() {
                  //                                     musaData.displayStatus =
                  //                                         DisplayStatus(
                  //                                             status:
                  //                                                 "NotInitiated",
                  //                                             id: musaData.id);
                  //                                   });
                  //                                 });
                  //                               }
                  //                             },
                  //                             borderColor:
                  //                                 AppColor.primaryColor,
                  //                             borderWidth: 1.sp,
                  //                             borderRadius: 5.sp,
                  //                             fontWeight: FontWeight.w400,
                  //                             fontSize: 12,
                  //                             textcolor: AppColor.primaryColor,
                  //                           ),
                  //                   ],
                  //                 ),
                  //               )
                  //             : Container(),
                  // SizedBox(
                  //   width: 4,
                  // ),
                ],
              ),

              // PostCommentBottomRow(
              //   likeCount: musaData.likeCount,
              //   shareCount: '0',
              //   commentCount: musaData.commentCount.toString(),
              //   isContributed: widget.isContributed,
              //   isMyMUSA: widget.isMyMUSA,
              //   musaId: musaData.id ?? '',
              //   isLiked: musaData.isLikeByMe ?? true,
              //   commentBtn: widget.commentBtn,
              //   // MusaWidgets.openBottomSheet(context: context, requireWidget: CommentView(musaId: widget.musaId,keyboardType: true));
              // ),
              SizedBox(height: 10.sp),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll('/', ''); // Remove existing slashes
    if (text.length > 8) {
      text = text.substring(0, 8); // Limit the length to ddMMyyyy
    }

    // Add slashes at the appropriate positions for dd/MM/yyyy
    String formatted = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 2 || i == 4) {
        formatted += '/';
      }
      formatted += text[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
