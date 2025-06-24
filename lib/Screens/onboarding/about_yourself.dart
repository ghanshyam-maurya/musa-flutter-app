import 'package:audioplayers/audioplayers.dart';
import 'package:musa_app/Cubit/auth/aboutYourSelfCubit/about_yourself_cubit.dart';
import 'package:musa_app/Cubit/auth/aboutYourSelfCubit/about_yourself_state.dart';
import 'package:musa_app/Resources/CommonWidgets/audio_recoder.dart';
import 'package:musa_app/Utility/packages.dart';

import '../../Utility/musa_widgets.dart';

class AboutYourself extends StatefulWidget {
  const AboutYourself({super.key});

  @override
  State<AboutYourself> createState() => _AboutYourselfState();
}

class _AboutYourselfState extends State<AboutYourself> {
  AboutyourselfCubit aboutyourselfCubit = AboutyourselfCubit();

  @override
  void dispose() {
    aboutyourselfCubit.audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AboutyourselfCubit, AboutyourselfState>(
        bloc: aboutyourselfCubit,
        listener: (context, state) {
          if (state is AboutyourselfSuccess) {
            context.go(RouteTo.bottomNavBar);
            // Navigator.pushReplacement(
            //     context, MaterialPageRoute(builder: (_) => BottomNavBar(key: bottomNavBarKey,)));
          }
          if (state is AboutyourselfFailure) {
            MusaPopup.popUpDialouge(
                context: context,
                onPressed: () => context.pop(true),
                buttonText: 'Okay',
                title: 'Error',
                description: state.errorMessage);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              buildUserAbout(context),
              state is AboutyourselfLoading
                  ? MusaWidgets.loader(context: context)
                  : Container()
            ],
          );
        },
      ),
    );
  }

  buildUserAbout(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.backgound),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringConst.aboutYourSelf,
                  style: AppTextStyle.normalTextStyleNew(
                    size: 24,
                    color: AppColor.black,
                    fontweight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  StringConst.inMusaYourVoiceAddsLife,
                  style: AppTextStyle.normalTextStyleNew(
                    size: 14,
                    color: AppColor.greyNew,
                    fontweight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CommonTextField(
                      controller: aboutyourselfCubit.bioController,
                      hintText: StringConst.bioOptional,
                      maxLines: 6,
                    ),
                    Positioned(
                      top: -25,
                      left: (MediaQuery.of(context).size.width - 30) / 2.5,
                      child: GestureDetector(
                        onTap: onRecordButtonPressed,
                        behavior: HitTestBehavior.translucent,
                        child: SizedBox(
                          width: 70,
                          height: 70,
                          child: Center(
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColor.primaryColor,
                                  width: 3,
                                ),
                              ),
                              child: Icon(Icons.mic_none_outlined),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                if (aboutyourselfCubit.audioFilePath != null)
                  audioPlayerWidget(),
                SizedBox(height: 30),
                CommonButton(
                  title: StringConst.addBio,
                  onTap: () {
                    aboutyourselfCubit.updateBio();
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    context.go(RouteTo.bottomNavBar);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        StringConst.skip,
                        style: AppTextStyle.semiTextStyle(
                            color: AppColor.primaryColor, size: 15),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: AppColor.primaryColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 200),
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(Assets.aboutYourselfTheme),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                      child: Text(
                        StringConst.musaBringsYourStory,
                        style: AppTextStyle.semiMediumTextStyle(
                            color: AppColor.white, size: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
                onRecordingComplete: (selectedRecordPath) {
                  setState(() {
                    aboutyourselfCubit.audioFilePath = selectedRecordPath;
                  });
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

  // Widget for Play/Pause Button
  Widget audioPlayerWidget() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor.primaryColor, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  aboutyourselfCubit.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  color: AppColor.primaryColor,
                  size: 36,
                ),
                onPressed: togglePlayPause,
              ),
              Expanded(
                child: Text(
                  "Audio Recorded",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.normalTextStyle(
                    color: AppColor.black,
                    size: 16,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red, size: 28),
                onPressed: () {
                  setState(() {
                    aboutyourselfCubit.audioFilePath = null;
                    aboutyourselfCubit.audioPlayer.stop();
                    aboutyourselfCubit.isPlaying = false;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Play/Pause Functionality
  void togglePlayPause() async {
    if (aboutyourselfCubit.audioFilePath == null) return;

    if (aboutyourselfCubit.isPlaying) {
      await aboutyourselfCubit.audioPlayer.pause();
    } else {
      await aboutyourselfCubit.audioPlayer
          .play(DeviceFileSource(aboutyourselfCubit.audioFilePath!));
    }

    setState(() {
      aboutyourselfCubit.isPlaying = !aboutyourselfCubit.isPlaying;
    });
  }
}
