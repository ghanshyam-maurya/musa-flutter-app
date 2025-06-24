import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';
import 'package:musa_app/Cubit/dashboard/my_section_cubit/my_section_cubit.dart';
import 'package:musa_app/Cubit/dashboard/my_section_cubit/my_section_state.dart';
import 'package:musa_app/Resources/CommonWidgets/audio_recoder.dart';
import 'package:musa_app/Resources/app_style.dart';
import 'package:musa_app/Resources/assets.dart';
import 'package:musa_app/Resources/colors.dart';
import 'package:musa_app/Utility/musa_widgets.dart';

import '../../../../Repository/AppResponse/library_response.dart';

class AudioLibraryDetailView extends StatefulWidget {
  final MySectionCubit mySectionCubit;
  final bool? musa;
  const AudioLibraryDetailView(
      {super.key, required this.mySectionCubit, this.musa});

  @override
  State<AudioLibraryDetailView> createState() => _AudioLibraryDetailViewState();
}

class _AudioLibraryDetailViewState extends State<AudioLibraryDetailView> {
  final GlobalKey _addButtonKey = GlobalKey();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    if (widget.mySectionCubit.audioLibrary == null) {
      widget.mySectionCubit.getLibrary();
    }
    if (widget.musa == true) {
      isUploading = true;
    }
  }

  Future<void> _showAudioPopup(BuildContext context, LibraryFile file) async {
    String audioUrl =
        file.fileLink ?? ""; // Replace with your network audio URL

    try {
      await _audioPlayer.setUrl(audioUrl);
    } catch (e) {
      print("Error loading audio: $e");
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing on tap outside
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Now Playing",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Icon(Icons.music_note, size: 50, color: AppColor.primaryColor),
                SizedBox(height: 10),
                StreamBuilder<PlayerState>(
                  stream: _audioPlayer.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final playing = playerState?.playing ?? false;

                    return IconButton(
                      icon: Icon(
                          playing
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          size: 60,
                          color: AppColor.primaryColor),
                      onPressed: () {
                        playing ? _audioPlayer.pause() : _audioPlayer.play();
                      },
                    );
                  },
                ),
                SizedBox(height: 10),
                StreamBuilder<Duration?>(
                  stream: _audioPlayer.durationStream,
                  builder: (context, snapshot) {
                    final duration = snapshot.data ?? Duration.zero;
                    return StreamBuilder<Duration>(
                      stream: _audioPlayer.positionStream,
                      builder: (context, snapshot) {
                        final position = snapshot.data ?? Duration.zero;
                        return Column(
                          children: [
                            Slider(
                              value: position.inSeconds.toDouble(),
                              max: duration.inSeconds.toDouble(),
                              onChanged: (value) {
                                _audioPlayer
                                    .seek(Duration(seconds: value.toInt()));
                              },
                            ),
                            Text(
                              "${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')} / "
                              "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _audioPlayer.stop();
                    Navigator.pop(context);
                  },
                  child: Text("Close"),
                ),
              ],
            ),
          ),
        );
      },
    );

    _audioPlayer.play();
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        Navigator.pop(context);
      }
    });
  }

  Map<String, List<dynamic>> groupAudioByDate() {
    final Map<String, List<dynamic>> groupedAudio = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var audio in widget.mySectionCubit.audioLibrary ?? []) {
      final audioDate = DateTime.parse(audio.createdAt ?? '');
      final audioDay = DateTime(audioDate.year, audioDate.month, audioDate.day);

      String key;
      if (audioDay == today) {
        key = 'Today';
      } else if (audioDay == yesterday) {
        key = 'Yesterday';
      } else {
        key = DateFormat('MMMM d, y').format(audioDay);
      }

      if (!groupedAudio.containsKey(key)) {
        groupedAudio[key] = [];
      }
      groupedAudio[key]!.add(audio);
    }

    return groupedAudio;
  }

  Future<void> _pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );

      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        await widget.mySectionCubit.uploadLibraryFiles(files);
      }
    } catch (e) {
      debugPrint('Error picking audio: $e');
    }
  }

  void _showAddOptions() {
    final RenderBox button =
        _addButtonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + button.size.height,
        position.dx + button.size.width,
        position.dy + button.size.height + 100,
      ),
      items: [
        PopupMenuItem(
          onTap: () async {
            await Future.delayed(Duration.zero);
            _pickAudioFile();
          },
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: AppColor.grey,
                    width: 2.5,
                  ),
                ),
                child: Icon(
                  Icons.audio_file,
                  size: 30.w,
                  color: AppColor.black,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'File',
                style: AppTextStyle.normalTextStyle1,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () async {
            await Future.delayed(Duration.zero);
            onRecordButtonPressed();
          },
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: Colors.green,
                    width: 2.5,
                  ),
                ),
                child: Icon(
                  Icons.mic,
                  size: 30.w,
                  color: AppColor.black,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'Record',
                style: AppTextStyle.normalTextStyle1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void toggleSelection(String mediaId) {
    setState(() {
      if (widget.mySectionCubit.selectedMedia.contains(mediaId)) {
        widget.mySectionCubit.selectedMedia.remove(mediaId);
      } else {
        widget.mySectionCubit.selectedMedia.add(mediaId);
      }
    });
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
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Column(
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
                          Text(
                            "Audio Collection",
                            style: AppTextStyle.appBarTitleStyle,
                          ),
                          Spacer(),
                          IconButton(
                            key: _addButtonKey,
                            onPressed: _showAddOptions,
                            icon: Icon(Icons.add_circle,
                                color: AppColor.black, size: 25),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: widget.mySectionCubit.audioLibrary?.isEmpty ?? true
                        ? Center(
                            child: Text(
                              'No audio files found',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColor.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(16.w),
                            itemCount: groupAudioByDate().length,
                            itemBuilder: (context, index) {
                              final dates = groupAudioByDate().keys.toList();
                              final date = dates[index];
                              final audioList = groupAudioByDate()[date]!;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.h),
                                    child: Text(
                                      date,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF555555),
                                      ),
                                    ),
                                  ),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 8.w,
                                      mainAxisSpacing: 8.h,
                                      childAspectRatio:
                                          0.7, // Reduced from 1 to make items taller
                                    ),
                                    itemCount: audioList.length,
                                    itemBuilder: (context, audioIndex) {
                                      final audio = audioList[audioIndex];
                                      final audioId = audio.fileLink ?? '';
                                      final isSelected = widget
                                          .mySectionCubit.selectedMedia
                                          .contains(audioId);
                                      return InkWell(
                                        onTap: () {
                                          if (isUploading == true) {
                                            toggleSelection(audioId);
                                          } else {
                                            _showAudioPopup(context, audio);
                                          }
                                        },
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.green
                                                      .withOpacity(0.1),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      Assets.audioFile,
                                                      height: 50
                                                          .sp, // Increased from 40 to 50
                                                      width: 50
                                                          .sp, // Increased from 40 to 50
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 8.h),
                                              child: Text(
                                                'Audio-${(audio.id ?? '').substring((audio.id?.length ?? 5) - 5)}',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: AppColor.black,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (isSelected)
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.green,
                                                  ),
                                                  padding: EdgeInsets.all(6),
                                                  child: Icon(Icons.check,
                                                      color: Colors.white,
                                                      size: 10),
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 16.h),
                                ],
                              );
                            },
                          ),
                  ),
                ],
              ),
              if (state is MyLibraryLoading)
                Center(
                  child: MusaWidgets.loader(context: context),
                ),
              if (widget.mySectionCubit.selectedMedia.isNotEmpty)
                Positioned(
                  bottom: 16.h,
                  left: 16.w,
                  right: 16.w,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Just pop, as data is
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(
                      'Add (${widget.mySectionCubit.selectedMedia.length})',
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
                onRecordingComplete: (selectedRecordPath) async {
                  widget.mySectionCubit.audioFilePath = selectedRecordPath;
                  await widget.mySectionCubit
                      .uploadLibraryFiles([File(selectedRecordPath)]);
                  Navigator.pop(context);
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

  @override
  void dispose() {
    super.dispose();
  }
}
