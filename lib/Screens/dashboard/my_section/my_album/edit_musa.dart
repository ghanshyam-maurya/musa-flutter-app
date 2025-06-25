import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:musa_app/Cubit/dashboard/CreateMusa/edit_musa_cubit.dart';
import 'package:musa_app/Cubit/dashboard/CreateMusa/edit_musa_state.dart';
import 'package:musa_app/Repository/AppResponse/social_musa_list_response.dart';
// import 'package:musa_app/Repository/AppResponse/my_section_album_list.dart';
// import 'package:musa_app/Repository/AppResponse/my_section_sub_album_list.dart';
import 'package:musa_app/Resources/CommonWidgets/audio_preview_screen.dart';
import 'package:musa_app/Resources/CommonWidgets/audio_recoder.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import 'package:musa_app/Utility/packages.dart';
import 'package:intl/intl.dart';
import 'package:musa_app/Resources/CommonWidgets/audio_player.dart';
import 'dart:io';

class EditMusa extends StatefulWidget {
  final MusaData musaData;
  // final MySectionAlbumData? albumName;
  // final MySectionSubAlbumData? subAlbumName;
  const EditMusa({
    super.key,
    // this.albumName,
    // this.subAlbumName,
    required this.musaData,
  });

  @override
  State<EditMusa> createState() => _EditMusaState();
}

class _EditMusaState extends State<EditMusa> {
  late final EditMusaCubit cubit;
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int? currentPlayingIndex;
  String? audioFilePath;
  @override
  void initState() {
    cubit = EditMusaCubit(
      musaId: widget.musaData.id!, // or int.parse(...) if you want int
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        print("musa data--------------------->: ${widget.musaData.toJson()}");
        // 1. Set text controllers and simple fields
        cubit.titleController.text = widget.musaData.title ?? '';
        cubit.descriptionController.text = widget.musaData.description ?? '';
        cubit.isPublic = widget.musaData.musaType ?? 'only_me';
        cubit.isRecurringDisplay = widget.musaData.recurringDisplay ?? false;
        // cubit.recurringDateController.text = widget.musaData.recurringDate ?? '';
        cubit.selectedRecurringInterval =
            widget.musaData.recurringInterval != null &&
                    widget.musaData.recurringInterval!.isNotEmpty
                ? widget.musaData.recurringInterval![0].toUpperCase() +
                    widget.musaData.recurringInterval!.substring(1)
                : '';

        // Setting initially recurring Date
        if (widget.musaData.recurringDate != null) {
          try {
            DateTime parsedDate;
            if (widget.musaData.recurringDate is DateTime) {
              parsedDate = widget.musaData.recurringDate as DateTime;
            } else if (widget.musaData.recurringDate is String) {
              parsedDate =
                  DateTime.parse(widget.musaData.recurringDate as String);
            } else {
              throw Exception("Invalid date type");
            }
            cubit.recurringDateController.text =
                DateFormat('MM-dd-yyyy').format(parsedDate);
          } catch (e) {
            cubit.recurringDateController.text = '';
          }
        } else {
          cubit.recurringDateController.text = '';
        }
        await cubit.getAlbumListApi(context: context);
        // Auto-select album and sub-album based on the ids that come with this Musa
        try {
          // 1️⃣  Set album
          if (widget.musaData.albumId != null &&
              widget.musaData.albumId!.isNotEmpty) {
            final album = cubit.musaAlbumList.firstWhere(
              (a) => a.id.toString() == widget.musaData.albumId.toString(),
            );
            setState(() {
              cubit.selectedAlbum = album;
            });

            // 2️⃣  Fetch sub-albums for this album and set sub-album
            await cubit.getSubAlbumListApi(
                albumId: album.id.toString(), context: context);

            if (widget.musaData.subAlbumId != null &&
                widget.musaData.subAlbumId!.isNotEmpty) {
              try {
                final subAlbum = cubit.musaSubAlbumList.firstWhere(
                  (s) =>
                      s.id.toString() == widget.musaData.subAlbumId.toString(),
                );
                setState(() {
                  cubit.selectedSubAlbum = subAlbum;
                });
              } catch (_) {
                // sub-album id not present in list – ignore
              }
            }
          }
        } catch (_) {
          // album id not found – ignore and leave selections empty
        }
      }
    });

    //  listener to detect when a new album is created
    cubit.stream.listen((state) {
      if (state is EditMusaAlbumLoaded && cubit.shouldAutoSelectNewAlbum) {
        // Auto-select the last album (newly created one)
        if (cubit.musaAlbumList.isNotEmpty) {
          final newAlbum = cubit.musaAlbumList.first;
          setState(() {
            cubit.selectedAlbum = newAlbum;
            cubit.selectedSubAlbum = null;
            cubit.musaSubAlbumList = [];
            cubit.shouldAutoSelectNewAlbum = false; // Reset flag
          });

          // Load sub-albums for the new album
          cubit.getSubAlbumListApi(
              albumId: newAlbum.id.toString(), context: context);
        }
      }

      // new condition for sub-album auto-selection
      if (state is EditMusaSubAlbumLoaded &&
          cubit.shouldAutoSelectNewSubAlbum) {
        // Auto-select the last sub-album (newly created one)
        if (cubit.musaSubAlbumList.isNotEmpty) {
          final newSubAlbum = cubit.musaSubAlbumList.first;

          // Find the album that this sub-album belongs to
          final parentAlbum = cubit.musaAlbumList.firstWhere(
            (album) => album.id.toString() == newSubAlbum.albumId?.toString(),
            orElse: () => cubit.selectedAlbum ?? cubit.musaAlbumList.first,
          );

          setState(() {
            cubit.selectedAlbum = parentAlbum; // Update the selected album
            cubit.selectedSubAlbum = newSubAlbum;
            cubit.shouldAutoSelectNewSubAlbum = false; // Reset flag
          });
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    cubit.selectedAssets.dispose();
    super.dispose();
  }

  pickMedia() async {
    final selectedAssets = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true, //  to respect safe areas
      enableDrag: false, // Disable dragging
      isDismissible: false, // Prevent dismissing by tapping outside
      backgroundColor: Colors.white,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height, // Full screen height
        minHeight: MediaQuery.of(context).size.height,
      ),
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 200), // Faster animation
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      //builder: (context) => MediaPickerBottomSheet(cubit: cubit),
      builder: (context) => Container(
        height: MediaQuery.of(context)
            .size
            .height, // Set container height to full screen
        child: MediaPickerBottomSheet(cubit: cubit),
      ),
    );

    if (selectedAssets != null && selectedAssets.isNotEmpty) {
      if (!mounted) return;
      List<AssetEntity> assetEntities =
          await convertIdsToAssetEntities(selectedAssets);

      cubit.selectedAssets.value = assetEntities;
      setState(() {}); // Ensure UI updates
    }
  }

  Future<List<AssetEntity>> convertIdsToAssetEntities(List<String> ids) async {
    List<AssetEntity> assetEntities = [];
    for (var id in ids) {
      AssetEntity? assetEntity = await fetchAssetById(id);
      if (assetEntity != null) {
        assetEntities.add(assetEntity);
      }
    }
    return assetEntities;
  }

  Future<AssetEntity?> fetchAssetById(String id) async {
    try {
      return AssetEntity(id: id, typeInt: 1, height: 100, width: 100);
    } catch (e) {
      print("Error fetching asset by ID: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(cubit.isNewMusaCreated);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<EditMusaCubit, EditMusaState>(
          bloc: cubit,
          listener: (context, state) {
            if (state is EditMusaLoaded) {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => BottomNavBar(passIndex: 0)));
              // Pop the current EditMusa screen and the screen before it
              // so the user returns to the page they were on before opening the editor.
              Navigator.of(context).pop(); // pop EditMusa
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }
            if (state is EditMusaError) {
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
                buildCreateMusaSection(context),
                state is EditMusaLoading
                    ? ValueListenableBuilder<double>(
                        valueListenable: cubit
                            .loadingTime, // The ValueNotifier being observed
                        builder: (context, value, child) {
                          return UploadProgressIndicator(
                            value: value,
                          );
                        },
                      )
                    : Container(),
              ],
            );
          },
        ),
      ),
    );
  }

  buildCreateMusaSection(BuildContext context) {
    return Column(
      children: [
        buildAppBar(),
        const SizedBox(height: 10),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Removed Text("Upload Media")
                    ],
                  ),
                  // cubit.selectedAssets.value.isNotEmpty
                  //     ? buildSelectedMediaBox()
                  //     : buildUploadSection(),
                  buildSelectedMediaBoxWithPreview(), // Show selected media with preview
                  SizedBox(height: 10),
                  ValueListenableBuilder<List<String>>(
                    valueListenable: cubit.selectedAudio,
                    builder: (context, selectedAudio, child) {
                      if (selectedAudio.isEmpty) return SizedBox();
                      return GestureDetector(
                        onTap: () async {
                          final bool? updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AudioPreviewScreen(cubit: cubit),
                            ),
                          );
                          if (updated == true) {
                            setState(() {});
                          }
                        },
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          color: Colors.grey,
                          dashPattern: const <double>[5, 8],
                          radius: const Radius.circular(15),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            width: double.infinity,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.music_note,
                                    color: AppColor.primaryColor),
                                SizedBox(width: 10),
                                SizedBox(
                                  width: 270,
                                  child: Text(
                                    selectedAudio.last,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      color: AppColor.primaryTextColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  MusaWidgets.commonTextField(
                    bgColor: AppColor.textBg,
                    inputController: cubit.titleController,
                    onTap: () {},
                    onChanged: (value) {},
                    inputMaxLine: 1,
                    prefixIcon: Padding(
                      padding: MusaPadding.iconPadding,
                      child: SvgPicture.asset(
                        'assets/svgs/H.svg',
                        width: 20,
                        height: 20,
                      ),
                    ),
                    inputHintText: StringConst.titleText,
                  ),
                  const SizedBox(height: 10),
                  buildAudioComment(),
                  const SizedBox(height: 10),
                  buildDropdownAlbum(),
                  buildDropdownSubAlbum(),

                  const SizedBox(height: 10),
                  // Recurring Display Switch
                  /*
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Switch(
                          value: cubit.isRecurringDisplay,
                          onChanged: (value) {
                            setState(() {
                              cubit.isRecurringDisplay = value;
                            });
                          },
                          activeColor: AppColor.switchActive,
                          inactiveThumbColor: AppColor.white,
                          inactiveTrackColor: AppColor.switchInactive,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Recurring Display',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  */

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            cubit.isRecurringDisplay =
                                !cubit.isRecurringDisplay;
                          });
                        },
                        child: SvgPicture.asset(
                          cubit.isRecurringDisplay
                              ? 'assets/svgs/switch-on.svg'
                              : 'assets/svgs/switch-off.svg',
                          width: 60,
                          height: 40,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Recurring Display',
                        style: AppTextStyle.mediumTextStyle(
                          color: cubit.isRecurringDisplay
                              ? AppColor.primaryTextColor
                              : AppColor.secondaryTextColor,
                          size: 14,
                        ),
                      ),
                    ],
                  ),

                  // Conditionally show Recurring Date & Interval Dropdown
                  if (cubit.isRecurringDisplay) ...[
                    // Recurring Date Field
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextFormField(
                          controller: cubit.recurringDateController,
                          readOnly: true,
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: AppColor
                                          .greenDark, // header background and selected date color
                                      onPrimary: Colors
                                          .white, // header text and selected date text color
                                      onSurface:
                                          Colors.black, // calendar text color
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColor
                                            .greenDark, // button text color
                                      ),
                                    ),
                                    dialogBackgroundColor: Colors
                                        .white, // calendar background color
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedDate != null) {
                              cubit.recurringDateController.text =
                                  DateFormat('MM-dd-yyyy').format(pickedDate);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Recurring Date',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppColor.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(width: 2, color: AppColor.green),
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(
                                  12.0), // adjust for alignment
                              child: SvgPicture.asset(
                                'assets/svgs/date.svg',
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                              ),
                            ),
                          )),
                    ),

                    // Recurring Interval Dropdown
                    CommonDropdownWidgets.commonDropdownField<String>(
                        hint: 'Recurring Interval',
                        items: ['Daily', 'Weekly', 'Monthly'],
                        selectedValue: cubit.selectedRecurringInterval,
                        onChanged: (value) {
                          setState(() {
                            cubit.selectedRecurringInterval = value;
                          });
                        },
                        displayItem: (value) =>
                            value[0].toUpperCase() + value.substring(1),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(
                              12.0), // adjust padding for alignment
                          child: SvgPicture.asset(
                            'assets/svgs/sub-album.svg',
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                          ),
                        )),
                  ],

                  const SizedBox(height: 10),
                  /*
                  Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: Colors.grey,
                        size: 18.sp,
                      ),
                      SizedBox(width: 5.sp),
                      Text(
                        StringConst.description,
                        style: AppTextStyle.semiMediumTextStyle(
                          color: AppColor.grey,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                  */

                  buildDescriptionBox(),

                  SizedBox(height: 10),
                  /*
                  TextFormField(
                    maxLines: 5,
                    focusNode: cubit.descriptionFocusNode,
                    controller: cubit.descriptionController,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      contentPadding: EdgeInsets.only(
                          left: 8,
                          top: 10,
                          right: 8,
                          bottom: 0), // Adjusted padding
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColor.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            width: 2, color: AppColor.primaryTextColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColor.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  */
                  /*
                  MusaTextButton.borderTextButton(
                    minHeight: 25,
                    title: StringConst.addContributorText,
                    onPressed: () {
                      cubit.openContributorScreen(context: context);
                      cubit.descriptionFocusNode.unfocus();
                    },
                    borderColor: AppColor.primaryColor,
                    borderWidth: 1,
                    fontSize: 15,
                    textcolor: AppColor.primaryColor,
                  ),
                  SizedBox(height: 10),
                  */
                  /*
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 8,
                      children: cubit.selectedContributors.entries.map((entry) {
                        String contributorId = entry.key;
                        String contributorName = entry.value;

                        return Chip(
                          backgroundColor: AppColor.black,
                          label: Text(contributorName), // ✅ Show Name
                          labelStyle: AppTextStyle.normalTextStyle(
                              color: AppColor.white, size: 14),
                          onDeleted: () {
                            setState(() {
                              cubit.selectedContributors.remove(contributorId);
                            });
                          },
                          deleteIcon: const Icon(Icons.close_sharp),
                          deleteIconColor: AppColor.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  */

                  Text(
                    'Contributors',
                    style: AppTextStyle.mediumTextStyle(
                      color: AppColor.black,
                      size: 14,
                    ),
                  ),
                  const SizedBox(height: 10),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Contributors Chips
                        ...cubit.selectedContributors.entries.map((entry) {
                          String contributorId = entry.key;
                          String contributorName = entry.value;

                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Chip(
                              backgroundColor: const Color(0xFFF8F8F8),
                              label: Text(
                                contributorName,
                                style: AppTextStyle.normalTextStyle(
                                  color: AppColor.black,
                                  size: 14,
                                ),
                              ),
                              onDeleted: () {
                                setState(() {
                                  cubit.selectedContributors
                                      .remove(contributorId);
                                });
                              },
                              deleteIcon: const Icon(Icons.close, size: 16),
                              deleteIconColor: AppColor.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side:
                                    BorderSide(color: const Color(0xFFE0E0E0)),
                              ),
                            ),
                          );
                        }),

                        ///Add Button
                        GestureDetector(
                          onTap: () {
                            cubit.openContributorScreen(context: context);
                            cubit.descriptionFocusNode.unfocus();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F3EA),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svgs/add.svg',
                                  width: 16,
                                  height: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Add',
                                  style: AppTextStyle.normalTextStyle(
                                    color: const Color(0xFF0C7A3E),
                                    size: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    StringConst.musaType,
                    style: AppTextStyle.mediumTextStyle(
                      color: AppColor.black,
                      size: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    /*
                    children: [
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            cubit.isPublic = "only_me";
                          });
                        },
                        child: Row(
                          children: [
                            Radio<String>(
                              activeColor: AppColor.primaryColor,
                              value: "only_me",
                              groupValue: cubit.isPublic,
                              onChanged: (value) {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  cubit.isPublic = value.toString();
                                });
                              },
                            ),
                            Text(
                              "Private",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.sp),
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            cubit.isPublic = "public";
                          });
                        },
                        child: Row(
                          children: [
                            Radio<String>(
                              activeColor: AppColor.primaryColor,
                              value: "public",
                              groupValue: cubit.isPublic,
                              onChanged: (value) {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  cubit.isPublic = value.toString();
                                });
                              },
                            ),
                            Text(
                              "Public",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                    */
                    children: [
                      //Private Switch with label
                      /*
                      Row(
                        children: [
                          Switch(
                            value: cubit.isPublic == "only_me",
                            activeColor: AppColor.primaryColor,
                            onChanged: (value) {
                              if (value) {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  cubit.isPublic = "only_me";
                                });
                              }
                            },
                          ),
                          Text(
                            "Private",
                            style: AppTextStyle.normalTextStyle(
                              color: AppColor.primaryTextColor,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      //Public Switch with label
                      Row(
                        children: [
                          Switch(
                            value: cubit.isPublic == "public",
                            activeColor: AppColor.primaryColor,
                            onChanged: (value) {
                              if (value) {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  cubit.isPublic = "public";
                                });
                              }
                            },
                          ),
                          Text(
                            "Public",
                            style: AppTextStyle.normalTextStyle(
                              color: AppColor.primaryTextColor,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      */

                      // Private Switch
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            cubit.isPublic = "only_me";
                          });
                        },
                        child: SvgPicture.asset(
                          cubit.isPublic == "only_me"
                              ? 'assets/svgs/switch-on.svg'
                              : 'assets/svgs/switch-off.svg',
                          width: 60,
                          height: 40,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Private",
                        style: AppTextStyle.mediumTextStyle(
                          color: cubit.isPublic == "only_me"
                              ? AppColor.primaryTextColor
                              : AppColor.secondaryTextColor,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 20),

                      // Public Switch
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            cubit.isPublic = "public";
                          });
                        },
                        child: SvgPicture.asset(
                          cubit.isPublic == "public"
                              ? 'assets/svgs/switch-on.svg'
                              : 'assets/svgs/switch-off.svg',
                          width: 60,
                          height: 40,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Public",
                        style: AppTextStyle.mediumTextStyle(
                          color: cubit.isPublic == "public"
                              ? AppColor.primaryTextColor
                              : AppColor.secondaryTextColor,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  buildAudioPreviewList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: cubit.selectedAudio.value.length,
      itemBuilder: (context, index) {
        String audioPath = cubit.selectedAudio.value[index];
        return ListTile(
          leading: Icon(Icons.music_note, color: AppColor.primaryColor),
          title: Text(
            "Audio ${index + 1}",
            style: TextStyle(color: AppColor.primaryTextColor),
          ),
          subtitle: Text(audioPath.split('/').last), // Show file name
          trailing: IconButton(
            icon: Icon(
              isPlaying && currentPlayingIndex == index
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_fill,
              color: AppColor.primaryColor,
              size: 30,
            ),
            onPressed: () => playPauseAudio(index, audioPath),
          ),
        );
      },
    );
  }

  void playPauseAudio(int index, String path) async {
    if (currentPlayingIndex == index && isPlaying) {
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      await audioPlayer.stop();
      await audioPlayer.play(DeviceFileSource(path));
      setState(() {
        isPlaying = true;
        currentPlayingIndex = index;
      });

      audioPlayer.onPlayerComplete.listen((_) {
        setState(() {
          isPlaying = false;
          currentPlayingIndex = null;
        });
      });
    }
  }

  buildAudioComment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.musaData.audioComments?[0] != null) ...[
          const SizedBox(height: 12),
          AudioPlayerPopup(
            filePath: widget.musaData.audioComments?[0] ?? '',
            onRemove: () {
              // setState(() {
              //   audioFilePath = null;
              //   cubit.audioFilePath = null;
              // });
              showRemoveConfirmationDialogForVoiceFile();
            },
          ),
        ],
        const SizedBox(height: 12),
        const Text(
          "Audio Comment",
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.31, // 21px / 16px
            color: Color(0xFF222222),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Why is this Collection of Art Meaningful, tell us in your words! Use your Voice!!!!!",
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.4,
            color: Color(0xFF222222),
            // Apply opacity using RGBA or withAlpha if needed
          ),
        ),
        const SizedBox(height: 12),
        // Row(
        //   children: [
        //     Expanded(
        //       child: ElevatedButton.icon(
        //         onPressed: () {
        //           // Handle record audio
        //         },
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: const Color(0xFFEAF6F0),
        //           foregroundColor: const Color(0xFF00684A),
        //           padding: const EdgeInsets.symmetric(vertical: 12),
        //           shape: RoundedRectangleBorder(
        //             borderRadius:
        //                 BorderRadius.circular(7), // border-radius: 7px
        //             side: const BorderSide(
        //               color: Color.fromRGBO(1, 158, 81, 0.05), // border color
        //               width: 1,
        //             ),
        //           ),
        //         ),
        //         icon: SvgPicture.asset(
        //           'assets/svgs/recording.svg',
        //           width: 20,
        //           height: 20,
        //         ),
        //         label: const Text("Record Audio"),
        //       ),
        //     ),
        //     const SizedBox(width: 12),
        //     Expanded(
        //       child: ElevatedButton.icon(
        //         onPressed: () {
        //           // Handle upload audio
        //         },
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: const Color(0xFFEAF6F0),
        //           foregroundColor: const Color(0xFF00684A),
        //           padding: const EdgeInsets.symmetric(vertical: 12),
        //           shape: RoundedRectangleBorder(
        //             borderRadius:
        //                 BorderRadius.circular(7), // border-radius: 7px
        //             side: const BorderSide(
        //               color: Color.fromRGBO(1, 158, 81, 0.05), // border color
        //               width: 1,
        //             ),
        //           ),
        //         ),
        //         icon: SvgPicture.asset(
        //           'assets/svgs/upload-recording.svg',
        //           width: 20,
        //           height: 20,
        //         ),
        //         label: const Text("Upload Audio"),
        //       ),
        //     ),
        //   ],
        // ),

        Row(
          children: [
            InkWell(
              onTap: () {
                onRecordButtonPressed();
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColor.textInactive, // light green background
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      Assets.recordAudioSvg, // Replace with your actual path
                      height: 20,
                      width: 20, // dark green icon
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Record Audio',
                      style: AppTextStyle.normalTextStyleNew(
                        size: 14,
                        color: AppColor.greenDark,
                        fontweight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () {
                // onRecordButtonPressed();
                _pickAudioFile();
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColor.textInactive, // light green background
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      Assets.uploadAudioSvg, // Replace with your actual path
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Upload Audio',
                      style: AppTextStyle.normalTextStyleNew(
                        size: 14,
                        color: AppColor.greenDark,
                        fontweight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        if (audioFilePath != null) ...[
          const SizedBox(height: 12),
          AudioPlayerPopup(
            filePath: audioFilePath!,
            onRemove: () {
              setState(() {
                audioFilePath = null;
                cubit.audioFilePath = null;
              });
            },
          ),
        ],
      ],
    );
  }

  buildDropdownAlbum() {
    return BlocBuilder<EditMusaCubit, EditMusaState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is EditMusaAlbumLoading) {
          return CommonDropdownWidgets.commonDropdownField(
            hint: 'Album',
            isLoading: true,
            items: ['Loading Album...'],
            selectedValue: null,
            onChanged: null,
            prefixIcon: Padding(
              padding:
                  const EdgeInsets.all(12.0), // adjust padding for alignment
              child: SvgPicture.asset(
                'assets/svgs/album.svg',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
            ),
          );
        }

        if (state is EditMusaAlbumLoaded) {
          return CommonDropdownWidgets.commonDropdownField(
            hint: 'Album',
            isLoading: false,
            items: [
              ...cubit.musaAlbumList.map((item) => item.title ?? ""),
              'Create New Album'
            ],
            selectedValue: cubit.selectedAlbum?.title,
            onChanged: (value) {
              if (value == "Create New Album") {
                cubit.shouldAutoSelectNewAlbum =
                    true; // Set flag before opening dialog
                MusaLoader.showCreateAlbumDialog(context, cubit);
                return;
              }

              var selectedAlbum = cubit.musaAlbumList.firstWhere(
                (album) => album.title == value,
                orElse: () => cubit.musaAlbumList.first,
              );

              setState(() {
                cubit.selectedAlbum = selectedAlbum;
                cubit.selectedSubAlbum = null; // Reset Sub-Album
                cubit.musaSubAlbumList = []; // Clear old Sub-Album data
              });

              cubit.getSubAlbumListApi(
                  albumId: selectedAlbum.id.toString(), context: context);
            },
            prefixIcon: Padding(
              padding:
                  const EdgeInsets.all(12.0), // adjust padding for alignment
              child: SvgPicture.asset(
                'assets/svgs/album.svg',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
            ),
          );
        }

        return CommonDropdownWidgets.commonDropdownField(
          hint: 'Album',
          isLoading: false,
          items: [
            ...cubit.musaAlbumList.map((item) => item.title ?? ""),
            'Create New Album'
          ],
          selectedValue: cubit.selectedAlbum?.title,
          onChanged: (value) {
            if (value == "Create New Album") {
              cubit.shouldAutoSelectNewAlbum =
                  true; // Set flag before opening dialog
              MusaLoader.showCreateAlbumDialog(context, cubit);
              return;
            }

            var selectedAlbum = cubit.musaAlbumList.firstWhere(
              (album) => album.title == value,
              orElse: () => cubit.musaAlbumList.first,
            );

            setState(() {
              cubit.selectedAlbum = selectedAlbum;
              cubit.selectedSubAlbum = null; // Reset Sub-Album
              cubit.musaSubAlbumList = []; // Clear old Sub-Album data
            });

            cubit.getSubAlbumListApi(
                albumId: selectedAlbum.id.toString(), context: context);
          },
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0), // adjust padding for alignment
            child: SvgPicture.asset(
              'assets/svgs/album.svg',
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

  buildDropdownSubAlbum() {
    return BlocBuilder<EditMusaCubit, EditMusaState>(
      bloc: cubit,
      builder: (context, state) {
        if (cubit.selectedAlbum == null) {
          return CommonDropdownWidgets.commonDropdownField(
            hint: 'Sub Album',
            items: ['Loading Sub Album...'],
            selectedValue: null,
            onChanged: null,
            prefixIcon: Padding(
              padding:
                  const EdgeInsets.all(12.0), // adjust padding for alignment
              child: SvgPicture.asset(
                'assets/svgs/sub-album.svg',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
            ),
          );
        }

        if (state is EditMusaSubAlbumLoading) {
          return CommonDropdownWidgets.commonDropdownField(
            hint: 'Sub Album',
            isLoading: true,
            items: ['Loading Sub Album...'],
            selectedValue: null,
            onChanged: null,
            prefixIcon: Padding(
              padding:
                  const EdgeInsets.all(12.0), // adjust padding for alignment
              child: SvgPicture.asset(
                'assets/svgs/sub-album.svg',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
            ),
          );
        }

        if (state is EditMusaSubAlbumLoaded &&
            cubit.musaSubAlbumList.isNotEmpty) {
          return CommonDropdownWidgets.commonDropdownField(
            hint: 'Sub Album',
            items: [
              ...cubit.musaSubAlbumList.map((item) => item.title ?? ""),
              'Create New Sub Album'
            ],
            selectedValue: cubit.selectedSubAlbum?.title,
            onChanged: (value) {
              if (value == "Create New Sub Album") {
                cubit.shouldAutoSelectNewSubAlbum =
                    true; // Set flag before opening dialog
                MusaLoader.showCreateAlbumDialog(context, cubit,
                    isSubAlbum: true);
                return;
              }

              var selectedSubAlbum = cubit.musaSubAlbumList.firstWhere(
                (subAlbum) => subAlbum.title == value,
                orElse: () => cubit.musaSubAlbumList.first,
              );

              setState(() {
                cubit.selectedSubAlbum = selectedSubAlbum;
              });
            },
            prefixIcon: Padding(
              padding:
                  const EdgeInsets.all(12.0), // adjust padding for alignment
              child: SvgPicture.asset(
                'assets/svgs/sub-album.svg',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
            ),
          );
        }

        return CommonDropdownWidgets.commonDropdownField(
          hint: 'Sub Album',
          items: [
            ...cubit.musaSubAlbumList.map((item) => item.title ?? ""),
            'Create New Sub Album'
          ],
          selectedValue: cubit.selectedSubAlbum?.title,
          onChanged: (value) {
            if (value == "Create New Sub Album") {
              cubit.shouldAutoSelectNewSubAlbum =
                  true; // Set flag before opening dialog
              MusaLoader.showCreateAlbumDialog(context, cubit,
                  isSubAlbum: true);
              return;
            }

            var selectedSubAlbum = cubit.musaSubAlbumList.firstWhere(
              (subAlbum) => subAlbum.title == value,
              orElse: () => cubit.musaSubAlbumList.first,
            );

            setState(() {
              cubit.selectedSubAlbum = selectedSubAlbum;
            });
          },
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0), // adjust padding for alignment
            child: SvgPicture.asset(
              'assets/svgs/sub-album.svg',
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

  buildDescriptionBox() {
    return BlocBuilder<EditMusaCubit, EditMusaState>(
      bloc: cubit,
      builder: (context, state) {
        return CommonDescriptionFieldWithCounter(
          controller: cubit.descriptionController,
        );
      },
    );
  }

  buildAppBar() {
    return AppBarMusa1(
      title: "Edit MUSA",
      appBarBtn: () {
        if (cubit.titleController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter title")),
          );
          return;
        }

        // if (cubit.selectedAssets.value.isEmpty &&
        //     cubit.selectedAudio.value.isEmpty) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text("Please select a image/video/audio")),
        //   );
        //   return;
        // }

        // Proceed with MUSA creation
        cubit.updateMusa(context);
      },
      appBarBtnText: 'Update',
    );
  }

  /// Upload Media Section
  buildUploadSection() {
    /*
    return GestureDetector(
      onTap: pickMedia,
      child: Column(
        children: [
          SizedBox(height: 10),
          DottedBorder(
            borderType: BorderType.RRect,
            color: Colors.grey,
            dashPattern: const <double>[5, 8],
            radius: const Radius.circular(15),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 50),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_card, color: Colors.grey),
                  Text("Add Media",
                      style: AppTextStyle.semiMediumTextStyle(
                          color: AppColor.grey, size: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    */

    return GestureDetector(
      onTap: pickMedia,
      child: DottedBorder(
        color: const Color(0xFFB4C7B9),
        dashPattern: const [5, 5],
        strokeWidth: 1,
        borderType: BorderType.RRect,
        radius: const Radius.circular(8),
        child: Container(
          width: 111,
          height: 90,
          // padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
          color: const Color(0xFFF8FDFA),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svgs/add-media.svg',
                width: 21,
                height: 21,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 12),
              const Text(
                "Add Media",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF00674E),
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 16 / 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Selected Media Preview Box
  buildSelectedMediaBox() {
    return ValueListenableBuilder<List<AssetEntity>>(
      valueListenable: cubit.selectedAssets,
      builder: (context, selectedAssets, child) {
        if (selectedAssets.isEmpty) {
          return buildUploadSection();
        }
        final AssetEntity lastSelected = selectedAssets.last;
        return FutureBuilder<Uint8List?>(
          future: lastSelected.thumbnailDataWithSize(
              const ThumbnailSize(200, 200)), // Generate thumbnail
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return GestureDetector(
                onTap: () async {
                  final updatedAssets = await Navigator.push<List<AssetEntity>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MediaPreviewScreen(
                        selectedAssets: selectedAssets,
                        cubit: cubit,
                      ),
                    ),
                  );
                  if (updatedAssets != null) {
                    cubit.selectedAssets.value = updatedAssets;
                    cubit.selectedAudio.notifyListeners();
                  }
                },
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                          color: Colors.grey[300]),
                      alignment: Alignment.center,
                      child: CachedNetworkImage(
                        imageUrl: lastSelected.id,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.error),
                        ),
                      ),
                    ),
                    if (lastSelected.type == AssetType.video)
                      Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                          image: DecorationImage(
                            image:
                                MemoryImage(snapshot.data!), // Video thumbnail
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${selectedAssets.length} selected",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return GestureDetector(
              onTap: () async {
                final updatedAssets = await Navigator.push<List<AssetEntity>>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MediaPreviewScreen(
                      selectedAssets: selectedAssets,
                      cubit: cubit,
                    ),
                  ),
                );
                if (updatedAssets != null) {
                  cubit.selectedAssets.value = updatedAssets;
                  cubit.selectedAudio.notifyListeners();
                }
              },
              child: Stack(
                children: [
                  if (lastSelected.type == AssetType.image)
                    Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                        image: DecorationImage(
                          image: MemoryImage(snapshot.data!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  // For videos
                  if (lastSelected.type == AssetType.video)
                    Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                        image: DecorationImage(
                          image: MemoryImage(snapshot.data!), // Video thumbnail
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  // Play icon overlay for video
                  if (lastSelected.type == AssetType.video)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black
                              .withOpacity(0.6), // Semi-transparent background
                          shape: BoxShape.circle, // Circular background
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                              8.0), // Padding to create space around the icon
                          child: Icon(
                            Icons.play_circle_fill,
                            color: Colors
                                .white, // Icon color that contrasts with the background
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  // Selected count display
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${selectedAssets.length} selected",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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
                  setState(() {
                    audioFilePath = selectedRecordPath;
                    cubit.audioFilePath = selectedRecordPath;
                    print('audiofilepath:-->  ${cubit.audioFilePath}');
                  });
                  // await signupCubit.speechToText();
                  // await signupCubit.speechToText([File(selectedRecordPath)]);
                  // Navigator.pop(context);
                },
                recordUploadBtn: () {
                  Navigator.pop(context);
                },
                // onSpeechTextUpdate: (text) {
                //   setState(() {
                //     signupCubit.bioController.text =
                //         text; // This updates the bio field
                //   });
                // },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );

      if (result != null && result.files.single.path != null) {
        File audio = File(result.files.single.path!);
        setState(() {
          audioFilePath = audio.path;
          cubit.audioFilePath = audio.path;
        });
      }
      // if (result != null) {
      //   List<File> files = result.paths.map((path) => File(path!)).toList();
      //   // await signupCubit.speechToText(files);
      // }
    } catch (e) {
      debugPrint('Error picking audio: $e');
    }
  }

  /// Selected Media Preview Box with 3-Column Grid Layout
  buildSelectedMediaBoxWithPreview() {
    return ValueListenableBuilder<List<AssetEntity>>(
      valueListenable: cubit.selectedAssets,
      builder: (context, selectedAssets, child) {
        return Column(
          children: [
            // 3-column grid for selected media + add media button
            _buildMediaGrid(selectedAssets),
          ],
        );
      },
    );
  }

  Widget _buildMediaGrid(List<AssetEntity> selectedAssets) {
    // Create a list that includes selected assets + add media button
    final totalItems = selectedAssets.length + 1; // +1 for add media button
    final rows = (totalItems / 3).ceil();

    return Container(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: List.generate(rows, (rowIndex) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: List.generate(3, (colIndex) {
                final itemIndex = rowIndex * 3 + colIndex;

                if (itemIndex < selectedAssets.length) {
                  // Show selected media item
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: colIndex < 2 ? 8 : 0,
                      ),
                      child: _buildMediaItem(
                          selectedAssets[itemIndex], itemIndex, selectedAssets),
                    ),
                  );
                } else if (itemIndex == selectedAssets.length) {
                  // Show add media button
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: colIndex < 2 ? 8 : 0,
                      ),
                      child: buildUploadSection(),
                    ),
                  );
                } else {
                  // Empty space
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: colIndex < 2 ? 8 : 0,
                      ),
                      child: Container(), // Empty container for spacing
                    ),
                  );
                }
              }),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMediaItem(
      AssetEntity asset, int index, List<AssetEntity> selectedAssets) {
    return AspectRatio(
      aspectRatio: 1.0, // Square aspect ratio
      child: FutureBuilder<Uint8List?>(
        future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
              ),
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          return Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  image: DecorationImage(
                    image: MemoryImage(snapshot.data!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Play icon for videos
              if (asset.type == AssetType.video)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.play_circle_fill,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),

              // Remove button
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAssets.removeAt(index);
                      cubit.selectedAssets.value = List.from(selectedAssets);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void showRemoveConfirmationDialogForVoiceFile() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Use StatefulBuilder to update dialog state
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(
                'Alert',
                style: AppTextStyle.mediumTextStyle(
                  color: AppColor.black,
                  size: 20,
                ),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you sure you want to delete your audio comment file?',
                    style: AppTextStyle.normalTextStyle(
                      color: AppColor.black,
                      size: 14,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Row(
                  //   children: [
                  //     Checkbox(
                  //       value: removeText,
                  //       activeColor: Color(0xFF00674E),
                  //       onChanged: (value) {
                  //         setState(() {
                  //           removeText = value ?? false;
                  //         });
                  //       },
                  //     ),
                  //     Expanded(
                  //       child: Text(
                  //         'Also remove bio text',
                  //         style: AppTextStyle.normalTextStyle(
                  //           color: AppColor.black,
                  //           size: 14,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // var userId = Prefs.getString(PrefKeys.uId);

                    // Make API calls
                    // await editProfileCubit.removePrfilePicBio();
                    // await editProfileCubit.getUserDetails(userId: userId);

                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Yes, Remove',
                    style: TextStyle(
                      color: Color(0xFF00674E),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class UploadProgressIndicator extends StatelessWidget {
  final double value;

  const UploadProgressIndicator({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Color.fromRGBO(255, 255, 255, 0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 8,
                  backgroundColor: AppColor.primaryColor.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColor.primaryColor,
                  ),
                ),
              ),
              Text(
                "${(value * 100).toStringAsFixed(2)}%",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "Uploading...",
            style: TextStyle(fontSize: 16, color: AppColor.primaryColor),
          ),
        ],
      ),
    );
  }
}
