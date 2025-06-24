import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:musa_app/Cubit/dashboard/CreateMusa/create_musa_cubit.dart';
import 'package:musa_app/Cubit/dashboard/CreateMusa/create_musa_state.dart';
import 'package:musa_app/Resources/CommonWidgets/audio_preview_screen.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import 'package:musa_app/Utility/packages.dart';

class CreateMusa extends StatefulWidget {
  const CreateMusa({super.key});

  @override
  State<CreateMusa> createState() => _CreateMusaState();
}

class _CreateMusaState extends State<CreateMusa> {
  CreateMusaCubit cubit = CreateMusaCubit();
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int? currentPlayingIndex;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        cubit.getAlbumListApi(context: context);
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => MediaPickerBottomSheet(cubit: cubit),
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
        body: BlocConsumer<CreateMusaCubit, CreateMusaState>(
          bloc: cubit,
          listener: (context, state) {
            if (state is CreateMusaLoaded) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => BottomNavBar(passIndex: 0)));
            }
            if (state is CreateMusaError) {
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
                state is CreateMusaLoading
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
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.photo, size: 20),
                      SizedBox(width: 5),
                      Text(
                        "Upload Media",
                        style: AppTextStyle.normalTextStyle(
                            color: AppColor.primaryTextColor, size: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  cubit.selectedAssets.value.isNotEmpty
                      ? buildSelectedMediaBox()
                      : buildUploadSection(),
                  SizedBox(height: 15),
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
                  SizedBox(height: 10),
                  MusaWidgets.commonTextField(
                    bgColor: Colors.transparent,
                    inputController: cubit.titleController,
                    onTap: () {},
                    onChanged: (value) {},
                    inputMaxLine: 1,
                    prefixIcon: Padding(
                      padding: MusaPadding.iconPadding,
                      child: Text(
                        "T",
                        style: AppTextStyle.boldTextStyle(
                            color: AppColor.grey, size: 17),
                      ),
                    ),
                    inputHintText: StringConst.titleText,
                  ),
                  buildDropdownAlbum(),
                  buildDropdownSubAlbum(),
                  const SizedBox(height: 10),
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
                  SizedBox(height: 10),
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
                  Text(StringConst.musaType,
                      style: AppTextStyle.normalTextStyle(
                          color: AppColor.primaryTextColor, size: 16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                  ),
                  SizedBox(height: 10),
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

  buildDropdownAlbum() {
    return BlocBuilder<CreateMusaCubit, CreateMusaState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is CreateMusaAlbumLoading) {
          return CommonDropdownWidgets.commonDropdownField(
            hint: 'Select Album',
            isLoading: true,
            items: ['Loading Album...'],
            selectedValue: null,
            onChanged: null,
          );
        }

        if (state is CreateMusaAlbumLoaded) {
          return CommonDropdownWidgets.commonDropdownField(
            hint: 'Select Album',
            isLoading: false,
            items: [
              ...cubit.musaAlbumList.map((item) => item.title ?? ""),
              'Create New Album'
            ],
            selectedValue: cubit.selectedAlbum?.title,
            onChanged: (value) {
              if (value == "Create New Album") {
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
          );
        }

        return CommonDropdownWidgets.commonDropdownField(
          hint: 'Select Album',
          isLoading: false,
          items: [
            ...cubit.musaAlbumList.map((item) => item.title ?? ""),
            'Create New Album'
          ],
          selectedValue: cubit.selectedAlbum?.title,
          onChanged: (value) {
            if (value == "Create New Album") {
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
        );
      },
    );
  }

  buildDropdownSubAlbum() {
    return BlocBuilder<CreateMusaCubit, CreateMusaState>(
      bloc: cubit,
      builder: (context, state) {
        if (cubit.selectedAlbum == null) {
          return CommonDropdownWidgets.commonDropdownField(
            hint: 'Select Sub-Album',
            items: ['Loading Sub-Album...'],
            selectedValue: null,
            onChanged: null,
          );
        }

        if (state is CreateMusaSubAlbumLoading) {
          return CommonDropdownWidgets.commonDropdownField(
            hint: 'Select Sub-Album',
            isLoading: true,
            items: ['Loading Sub-Album...'],
            selectedValue: null,
            onChanged: null,
          );
        }

        if (state is CreateMusaSubAlbumLoaded &&
            cubit.musaSubAlbumList.isNotEmpty) {
          return CommonDropdownWidgets.commonDropdownField(
            hint: 'Select Sub-Album',
            items: [
              ...cubit.musaSubAlbumList.map((item) => item.title ?? ""),
              'Create New Sub-Album'
            ],
            selectedValue: cubit.selectedSubAlbum?.title,
            onChanged: (value) {
              if (value == "Create New Sub-Album") {
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
          );
        }

        return CommonDropdownWidgets.commonDropdownField(
          hint: 'Select Sub-Album',
          items: [
            ...cubit.musaSubAlbumList.map((item) => item.title ?? ""),
            'Create New Sub-Album'
          ],
          selectedValue: cubit.selectedSubAlbum?.title,
          onChanged: (value) {
            if (value == "Create New Sub-Album") {
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
        );
      },
    );
  }

  buildAppBar() {
    return AppBarMusa1(
      title: "New MUSA",
      appBarBtn: () {
        if (cubit.titleController.text.isNotEmpty) {
          if (cubit.selectedAlbum != null) {
            if (cubit.selectedSubAlbum != null) {
              if (cubit.selectedAssets.value.isNotEmpty ||
                  cubit.selectedAudio.value.isNotEmpty) {
                cubit.createMusa(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Please select a image/video/audio")),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please select a sub album")),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please select an album")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter title")),
          );
        }
      },
      appBarBtnText: 'Create',
    );
  }

  /// Upload Media Section
  buildUploadSection() {
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
                  Text("Upload Media",
                      style: AppTextStyle.semiMediumTextStyle(
                          color: AppColor.grey, size: 14)),
                ],
              ),
            ),
          ),
        ],
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
