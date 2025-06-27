import 'package:audioplayers/audioplayers.dart';
import 'package:musa_app/Cubit/display_musa/display_cubit.dart';
// import '../../../Cubit/dashboard/home_dashboard_cubit/home_cubit.dart';
import '../../../Repository/AppResponse/social_musa_list_response.dart';
import '../../../Resources/component/musa_image_video_container.dart';
import '../../../Utility/musa_widgets.dart';
import '../../../Utility/packages.dart';
import 'package:timeago/timeago.dart' as timeago;
// import '../profile/my_profile.dart';
import 'package:musa_app/Screens/dashboard/my_section/my_album/musa_post_detail_view.dart';

class CommonSubWidgets extends StatefulWidget {
  final MusaData musaData;
  final DisplayCubit displayCubit;
  const CommonSubWidgets({
    super.key,
    required this.musaData,
    required this.displayCubit,
  });

  @override
  _CommonSubWidgetsState createState() => _CommonSubWidgetsState();
}

class _CommonSubWidgetsState extends State<CommonSubWidgets> {
  late DisplayCubit displayCubit;
  late MusaData musaData;
  int commentCount = 0;
  String userName = "", userProfileImage = "";
  String timeStatus = "", albumName = "", subAlbumName = "";
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String? audioFileUrl;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  int contributorCount = 0;
  bool _isDisposed = false;
  bool isHideDisplay = false;
  List<FileElement> imageVideoFileList = [];

  UserDetail userData = UserDetail();
  final Repository repository = Repository();
  @override
  void initState() {
    musaData = widget.musaData;
    if (musaData.userDetail != null && musaData.userDetail!.isNotEmpty) {
      userName =
          '${musaData.userDetail![0].firstName} ${musaData.userDetail![0].lastName}';
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
    musaData.musaType == 'public'
        ? isHideDisplay = false
        : isHideDisplay = true;
    super.initState();
    displayCubit = widget.displayCubit;
  }

  @override
  void didUpdateWidget(covariant CommonSubWidgets oldWidget) {
    // musaData.commentCount = widget.commentCount;
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
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              // if (musaData.userId != null &&
                              //     musaData.userId
                              //         .toString()
                              //         .trim()
                              //         .isNotEmpty) {
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => MyProfile(
                              //         userId: musaData.userId,
                              //       ),
                              //     ),
                              //   );
                              // }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    MusaWidgets.userProfileAvatar(
                                      imageUrl: userProfileImage,
                                      radius: 23.0,
                                      borderWidth: 3.sp,
                                    ),
                                    const SizedBox(width: 4),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userName ?? "Dummy User",
                                          // style: AppTextStyle.appBarTitleStyleBlack.copyWith(fontSize: 12),
                                        ),
                                        Text(
                                          timeStatus ?? '',
                                          style: AppTextStyle.normalTextStyle1
                                              .copyWith(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Hide Display',
                                      style: AppTextStyle.mediumTextStyle(
                                        color: isHideDisplay
                                            ? AppColor.primaryTextColor
                                            : Color(0xFFABABAB),
                                        size: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () async {
                                        // Show confirmation dialog
                                        bool? shouldProceed =
                                            await showDialog<bool>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                'Confirm',
                                              ),
                                              content: Text(
                                                  'Are you sure you want to change the visibility of this MUSA?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      color:
                                                          AppColor.primaryColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                ),
                                                TextButton(
                                                  child: Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        // Only proceed if user confirmed
                                        if (shouldProceed == true) {
                                          setState(() {
                                            isHideDisplay = !isHideDisplay;
                                          });
                                          await displayCubit.updateMusa(
                                            isHideDisplay: isHideDisplay,
                                            musaId: musaData.id.toString(),
                                          );
                                        }
                                      },
                                      child: SvgPicture.asset(
                                        isHideDisplay
                                            ? 'assets/svgs/switch-on.svg'
                                            : 'assets/svgs/switch-off.svg',
                                        width: 60,
                                        height: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
                                      )));
                          audioPlayer.stop();
                        },
                        child: MusaImageVideoContainer(
                            fileList: musaData.file ?? [])),
                    SizedBox(height: 10),
                    if (audioFileUrl != null)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColor.primaryColor),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.mic, color: Colors.black),
                            SizedBox(width: 5),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: LinearProgressIndicator(
                                  borderRadius: BorderRadius.circular(10),
                                  minHeight: 10,
                                  value: duration.inSeconds > 0
                                      ? position.inSeconds / duration.inSeconds
                                      : 0,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColor.primaryColor),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                                isPlaying
                                    ? "-${formatDuration(remainingTime)}"
                                    : formatDuration(duration),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.green),
                              onPressed: playPauseAudio,
                            ),
                          ],
                        ),
                      ),
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
              SizedBox(height: 5.sp),
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
