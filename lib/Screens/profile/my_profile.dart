import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:musa_app/Repository/AppResponse/chat_modals/chat_list_response.dart'
    as chat;
import 'package:musa_app/Repository/AppResponse/chat_modals/chat_list_response.dart';
import 'package:musa_app/Resources/CommonWidgets/comment_view.dart';
import 'package:musa_app/Resources/CommonWidgets/common_tab_button.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import 'package:musa_app/Utility/packages.dart';

import '../../Cubit/profile/profile_cubit/profile_cubit.dart';
import '../../Cubit/profile/profile_cubit/profile_state.dart';
import '../dashboard/home/display_feed_widgets.dart';

class MyProfile extends StatefulWidget {
  final String? userId;
  const MyProfile({super.key, this.userId});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  ProfileCubit profileCubit = ProfileCubit();
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    profileCubit.checkIsMyProfile(userId: widget.userId ?? '');
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: (Platform.isIOS)
                ? MediaQuery.of(context).size.height * 0.40
                : MediaQuery.of(context).size.height * 0.42,
            child: Stack(
              children: [
                MusaWidgets.commonAppBar(
                  height: 200.sp,
                  row: Padding(
                    padding: EdgeInsets.only(top: 0.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  GoRouter.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: AppColor.black,
                                    size: 20,
                                  ),
                                )),
                            Text(
                              StringConst.profileValue.toString() == "HomeUser"
                                  ? StringConst.profileTitleText
                                  : "",
                              style: AppTextStyle.appBarTitleStyle,
                            ),
                          ],
                        ),
                        profileCubit.isMyProfile
                            ? Row(
                                children: [
                                  SizedBox(width: 10.sp),
                                  InkWell(
                                    onTap: () {
                                      context
                                          .push(RouteTo.editProfile)
                                          .then((val) {
                                        if (val != null && val == true) {
                                          profileCubit.getOtherUserProfile(
                                              userId:
                                                  profileCubit.myUserId ?? '');
                                        }
                                      });
                                    },
                                    child: SvgPicture.asset(
                                      "assets/svgs/edit_profile_icon.svg",
                                      width: 25.sp,
                                      height: 25.sp,
                                    ),
                                  ),
                                  SizedBox(width: 5.sp),
                                  InkWell(
                                    onTap: () {
                                      context.push(RouteTo.settings);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Icon(Icons.settings,
                                          color: AppColor.black, size: 25.sp),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      var myId = Prefs.getString(PrefKeys.uId);
                                      context.push(RouteTo.chatView,
                                          extra: ChatListData(
                                              senderId: widget.userId,
                                              receiverId: profileCubit.myUserId,
                                              userDetail: chat.UserDetail(
                                                  id: myId,
                                                  firstName: profileCubit
                                                      .userName
                                                      .toString()
                                                      .split(' ')[0],
                                                  lastName: profileCubit
                                                      .userName
                                                      .toString()
                                                      .split(' ')[1],
                                                  photo: profileCubit
                                                      .userProfilePicture)));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: SvgPicture.asset(
                                        "assets/svgs/inactive_chat.svg",
                                        width: 25.sp,
                                        height: 25.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 140.sp,
                  left: 20.sp,
                  right: 20.sp,
                  child: card(),
                ),
              ],
            ),
          ),
          // Tab buttons
          BlocBuilder<ProfileCubit, ProfileState>(
              bloc: profileCubit, // Ensure this is your ProfileCubit instance
              builder: (context, state) {
                return TabSelector(
                  firstTitle: 'My MUSA\'s (${profileCubit.musaCount})',
                  secondTitle: 'Contributed (${profileCubit.contributedCount})',
                  tabChangeCallback: (index) {
                    profileCubit.onTabChange(index, widget.userId);
                  },
                );
              }),
          Expanded(
            child: BlocBuilder<ProfileCubit, ProfileState>(
              bloc: profileCubit, // Ensure this is your ProfileCubit instance
              builder: (context, state) {
                return Stack(
                  children: [
                    profileCubit.selectedTabIndex == 0
                        ? myFeedsListView()
                        : contributedFeedsListView(),
                    profileCubit.myFeedsLoading &&
                            profileCubit.selectedTabIndex == 0
                        ? MusaWidgets.loader(context: context)
                        : Container(),
                    profileCubit.contributedFeedsLoading &&
                            profileCubit.selectedTabIndex == 1
                        ? MusaWidgets.loader(context: context)
                        : Container()
                  ],
                );
              },
            ),
          ),

          // Expanded(child: profileCubit.selectedTabIndex == 0? myFeedsListView():contributedFeedsListView(),)
        ],
      ),
    );
  }

  Future<void> _togglePlayPause() async {
    if (isPlaying) {
      audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      try {
        if (audioPlayer.processingState == ProcessingState.idle) {
          await audioPlayer.setUrl(profileCubit.userVoiceAudio ?? '');
        }
        audioPlayer.play(); // Play the audio
        setState(() {
          isPlaying = true;
        });
        if (audioPlayer.processingState == ProcessingState.completed) {
          setState(() {
            isPlaying = false;
          });
        }
      } catch (e) {
        print('Error playing audio: $e');
      }
    }
  }

  Widget card() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: profileCubit, // Ensure profileCubit is defined in your state
      builder: (context, state) {
        return Card(
          elevation: 2.0,
          color: AppColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.all(16.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 40.sp),
                    Center(
                      child: Text(
                        profileCubit.userName ?? '',
                        style: AppTextStyle.appBarTitleStyle,
                      ),
                    ),
                    Center(
                      child: Text(
                        profileCubit.userEmail ?? '',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.normalTextStyle1
                            .copyWith(fontSize: 14),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        profileCubit.userBio ?? '',
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.normalTextStyle1
                            .copyWith(fontSize: 12),
                      ),
                    ),
                    SizedBox(height: 10),
                    profileCubit.userVoiceAudio != null &&
                            profileCubit.userVoiceAudio!.isNotEmpty
                        ? InkWell(
                            onTap: _togglePlayPause,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.sp),
                                color: Color(0XFFC8E4D6),
                                border: Border.all(
                                  color: AppColor.primaryColor,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isPlaying
                                        ? Icons.pause
                                        : Icons
                                            .play_arrow, // Change icon dynamically
                                    size: 15,
                                  ),
                                  Text(
                                    isPlaying ? "Pause" : "Play my Bio",
                                    style: AppTextStyle.normalTextStyle1
                                        .copyWith(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
              Positioned(
                top: -50.h,
                left: 5.w,
                right: 5.w,
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Circle Avatar
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: ClipRect(
                                child: MusaWidgets.getPhotoView(
                                    profileCubit.userProfilePicture,
                                    radius: 50.0),
                              ),
                            ),
                          ),
                        ),
                        StringConst.profileValue.toString() == "HomeUser"
                            ? Positioned(
                                left: 85.w,
                                right: 5.w,
                                top: 65.h,
                                child: Icon(
                                  Icons.add_circle,
                                  size: 30.sp,
                                  color: AppColor
                                      .primaryColor, // Icon color, change it as needed
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget myFeedsListView() {
    return BlocConsumer<ProfileCubit, ProfileState>(
      bloc: profileCubit,
      buildWhen: (previous, current) {
        return current is ProfileMyFeedsListLoading ||
            current is ProfileMyFeedsListSuccess ||
            current is ProfileMyFeedsListFailure;
      },
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ProfileMyFeedsListLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColor.primaryColor,
            ),
          );
        } else if (state is ProfileMyFeedsListSuccess) {
          return profileCubit.myFeedsList.isNotEmpty
              ? profileMyFeedsList()
              : Center(child: Text("No MUSA's Available"));
        } else if (state is ProfileMyFeedsListFailure) {
          return Center(
            child: Text("Failed to load MUSA's List"),
          );
        } else {
          if (profileCubit.myFeedsLoaded) {
            return profileCubit.myFeedsList.isNotEmpty
                ? profileMyFeedsList()
                : Center(child: Text("No MUSA's Available"));
          }
          return profileCubit.myFeedsLoadedFailed
              ? Center(child: Text("Failed to load MUSA's List"))
              : Container();
        }
      },
    );
  }

  Widget contributedFeedsListView() {
    return BlocConsumer<ProfileCubit, ProfileState>(
      bloc: profileCubit,
      listener: (context, state) {},
      buildWhen: (previous, current) {
        return current is ProfileContributedFeedsListSuccess ||
            current is ProfileContributedFeedsListLoading ||
            current is ProfileContributedFeedsListFailure;
      },
      builder: (context, state) {
        if (state is ProfileContributedFeedsListLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColor.primaryColor,
            ),
          );
        } else if (state is ProfileContributedFeedsListSuccess) {
          return profileCubit.contributedFeedsList.isNotEmpty
              ? profileContributedFeedsList()
              : Center(child: Text("No MUSA's Available"));
        } else if (state is ProfileContributedFeedsListFailure) {
          return Center(
            child: Text("Failed to load MUSA's List"),
          );
        } else {
          if (profileCubit.contributedFeedsLoaded) {
            return profileCubit.contributedFeedsList.isNotEmpty
                ? profileContributedFeedsList()
                : Center(child: Text("No MUSA's Available"));
          }
          return profileCubit.contributedFeedsLoadedFailed
              ? Center(child: Text("Failed to load MUSA's List"))
              : Container();
          // return Container();
        }
      },
    );
  }

  Future<void> onRefreshMyFeeds() async {
    profileCubit.getMyFeeds(userId: profileCubit.myUserId.toString(), page: 1);
  }

  Future<void> onRefreshMyContributedFeeds() async {
    profileCubit.getContributedFeeds(
        userId: profileCubit.myUserId.toString(), page: 1);
  }

  profileMyFeedsList() {
    return RefreshIndicator(
      onRefresh: onRefreshMyFeeds,
      child: ListView.builder(
          shrinkWrap: true,
          //controller: profileCubit.scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: profileCubit.myFeedsList.length,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemBuilder: (context, index) {
            return CommonSubWidgets(
              isMyMUSA: profileCubit.isMyProfile,
              isContributed: false,
              isHomeMUSA: false,
              musaData: profileCubit.myFeedsList[index],
              //cubit: profileCubit,
              commentCount: profileCubit.myFeedsList[index].commentCount ?? 0,
              commentBtn: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
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
                            musaId:
                                profileCubit.myFeedsList[index].id.toString(),
                            commentCountBtn: (int count) {
                              setState(() {
                                print("count=============");
                                print(count);
                                profileCubit.myFeedsList[index].commentCount =
                                    count;
                              });
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
              deleteBtn: () {
                setState(() {
                  profileCubit.deleteMusa(profileCubit.myFeedsList[index]);
                });
              },
            );
          }),
    );
  }

  profileContributedFeedsList() {
    return RefreshIndicator(
      onRefresh: onRefreshMyContributedFeeds,
      child: ListView.builder(
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: profileCubit.contributedFeedsList.length,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemBuilder: (context, index) {
            return CommonSubWidgets(
              isMyMUSA: profileCubit.isMyProfile,
              isContributed: true,
              isHomeMUSA: false,
              musaData: profileCubit.contributedFeedsList[index],
              // cubit: profileCubit,
              commentCount:
                  profileCubit.contributedFeedsList[index].commentCount ?? 0,
              commentBtn: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
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
                            musaId: profileCubit.contributedFeedsList[index].id
                                .toString(),
                            commentCountBtn: (int count) {
                              setState(() {
                                profileCubit.contributedFeedsList[index]
                                    .commentCount = count;
                              });
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
              deleteBtn: () {},
            );
          }),
    );
  }
}
