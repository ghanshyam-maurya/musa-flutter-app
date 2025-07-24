import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:musa_app/Cubit/profile/edit_profile/edit_profile_cubit.dart';
import 'package:musa_app/Cubit/profile/edit_profile/edit_profile_state.dart';
import 'package:musa_app/Resources/CommonWidgets/audio_recoder.dart';
import 'package:musa_app/Resources/component/month_year_picker.dart';
import 'package:musa_app/Utility/app_validations.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import 'package:musa_app/Utility/packages.dart';
import 'package:record/record.dart';
import 'package:musa_app/Resources/CommonWidgets/audio_player.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  EditProfileCubit editProfileCubit = EditProfileCubit();
  final record = AudioRecorder();
  String? audioFilePath;
  @override
  void initState() {
    super.initState();
    editProfileCubit.init();
    editProfileCubit.phoneFocusNode.addListener(() {
      if (editProfileCubit.phoneFocusNode.hasFocus) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<EditProfileCubit, EditProfileState>(
        bloc: editProfileCubit,
        listener: (context, state) {
          if (state is editProfileSuccess) {
            context.pop(true);
          } else if (state is ProfilePicUpdateSuccess) {
            // Add success toast
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColor.greenDark,
              ),
            );
          } else if (state is EditProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              buildUserEditProfile(context),
              state is EditProfileLoading
                  ? MusaWidgets.loader(context: context, isForFullHeight: true)
                  : Container()
            ],
          );
        },
      ),
    );
  }

  buildUserEditProfile(BuildContext context) {
    return Column(
      children: [
        MusaWidgets.commonAppBar(
          height: MediaQuery.of(context).size.height / 8,
          backgroundColor: AppColor.white,
          row: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: Icon(Icons.close)),
                SizedBox(width: 26.sp),
                Text(
                  'Edit Profile',
                  style: AppTextStyle.mediumTextStyle(
                      color: AppColor.black, size: 18),
                ),
                Spacer(),
                // SizedBox(
                //   height: 36.sp,
                //   width: 70.sp,
                //   child: CommonButton(
                //       title: 'Save',
                //       color: AppColor.greenDark,
                //       onTap: () {
                //         editProfileCubit.updateUser();
                //       }),
                // )
                SizedBox(
                  height: 34.sp,
                  width: 64.sp,
                  child: GestureDetector(
                    onTap: () async {
                      // var userId = Prefs.getString(PrefKeys.uId);
                      await editProfileCubit.updateUser();
                      // await editProfileCubit.getUserDetails(userId: userId);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColor.greenDark,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        'Save',
                        style: AppTextStyle.semiTextStyle(
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              color: AppColor.white,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 25.0,
                      right: 25.0,
                      top: 20.0,
                      bottom: MediaQuery.of(context).padding.bottom +
                          20.0, // Add bottom padding
                    ),
                    child: Column(
                      children: [
                        buildProfilePictureUpload(context),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CommonTextField(
                                controller:
                                    editProfileCubit.firstNameController,
                                hintText: StringConst.firstName,
                                prefixIconPath: Assets.userIcon1,
                                validator: MusaValidator.validatorName(),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: CommonTextField(
                                controller: editProfileCubit.lastNameController,
                                hintText: StringConst.lastName,
                                // prefixIconPath: Assets.userIcon1,
                                validator: MusaValidator.validatorLName(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AbsorbPointer(
                          child: CommonTextField(
                              controller: editProfileCubit.emailController,
                              hintText: StringConst.emailId,
                              prefixIconPath:
                                  'assets/svgs/email_light_icon.svg',
                              validator: MusaValidator.validatorEmail,
                              textStyle: TextStyle(color: Colors.grey[500])),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _buildDatePicker(),
                        SizedBox(
                          height: 20,
                        ),
                        CommonTextField(
                          controller: editProfileCubit.phoneController,
                          hintText: StringConst.mobileNumber,
                          prefixIconPath: Assets.phone1,
                          // validator: MusaValidator.validatorPhone,
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        CommonTextField(
                          controller: editProfileCubit.zipController,
                          hintText: StringConst.zipCode,
                          prefixIconPath: Assets.zipcode1,
                          //validator: MusaValidator.validatorZipCode,
                        ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        if (editProfileCubit.uploadedAudioFilePath != null &&
                            editProfileCubit
                                .uploadedAudioFilePath!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          AudioPlayerPopup(
                            filePath: editProfileCubit.uploadedAudioFilePath!,
                            onRemove: () {
                              showRemoveConfirmationDialogForVoiceFile();
                            },
                          ),
                        ],
                        const SizedBox(height: 12),
                        Text(
                          "You can record your bio in audio format, or simply upload your pre-recorded file (optional)",
                          style: AppTextStyle.normalTextStyleNew(
                            size: 14,
                            color: AppColor.black,
                            fontweight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        onRecordButtonPressed();
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: AppColor
                                              .textInactive, // light green background
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(
                                              Assets
                                                  .recordAudioSvg, // Replace with your actual path
                                              height: 16,
                                              width: 16,
                                              color: Color(
                                                  0xFF1B5E20), // dark green icon
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Record Audio',
                                              style: AppTextStyle
                                                  .normalTextStyleNew(
                                                size: 12,
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: AppColor
                                              .textInactive, // light green background
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(
                                              Assets
                                                  .uploadAudioSvg, // Replace with your actual path
                                              height: 16,
                                              width: 16,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Upload Audio',
                                              style: AppTextStyle
                                                  .normalTextStyleNew(
                                                size: 12,
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
                              ),
                            ),
                            if (audioFilePath != null) ...[
                              const SizedBox(height: 12),
                              AudioPlayerPopup(
                                filePath: audioFilePath!,
                                onRemove: () {
                                  setState(() {
                                    audioFilePath = null;
                                    editProfileCubit.audioFilePath = null;
                                    editProfileCubit.bioController.text =
                                        editProfileCubit.intialBioText ?? '';
                                  });
                                },
                              ),
                            ],
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Add your bio in text format (optional)",
                            textAlign: TextAlign.justify,
                            style: AppTextStyle.normalTextStyleNew(
                              size: 14,
                              color: AppColor.black,
                              fontweight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        CommonTextField(
                          controller: editProfileCubit.bioController,
                          hintText: StringConst.bioOptional,
                          maxLines: 6,
                        ),
                        // Stack(
                        //   clipBehavior: Clip.none,
                        //   children: [
                        //     CommonTextField(
                        //       controller: editProfileCubit.bioController,
                        //       hintText: StringConst.bioOptional,
                        //       maxLines: 6,
                        //     ),
                        //     Positioned(
                        //       top: -25,
                        //       left: (MediaQuery.of(context).size.width - 30) /
                        //           2.5,
                        //       child: GestureDetector(
                        //         onTap: () {},
                        //         child: Container(
                        //           width: 52,
                        //           height: 52,
                        //           decoration: BoxDecoration(
                        //               color: AppColor.white,
                        //               shape: BoxShape.circle,
                        //               border: Border.all(
                        //                 color: AppColor.primaryColor,
                        //                 width: 3,
                        //               )),
                        //           child: Icon(Icons.mic_none_outlined),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildProfilePictureUpload(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: MusaWidgets.userProfileAvatarEdit(
            imageUrl: editProfileCubit.userImage,
            localImageFile: editProfileCubit.selectedImageFile,
            radius: 38.sp,
            borderWidth: 2.sp,
          ),
        ),
        SizedBox(width: 26.sp),
        // Removed Positioned widget
        GestureDetector(
          onTap: () {
            showImagePickerOptions(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFFE6F6EE),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColor.white,
              ),
            ),
            child: Text(
              'Change',
              style: TextStyle(
                color: Color(0xFF00674E),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.sp),
        // Removed Positioned widget
        GestureDetector(
          onTap: () {
            if (editProfileCubit.userImage != '') {
              showDialog(
                context: context,
                builder: (BuildContext context) {
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
                    content: Text(
                      'Are you sure you want to delete your profile picture?',
                      style: AppTextStyle.normalTextStyle(
                        color: AppColor.black,
                        size: 14,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
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
                          var userId = Prefs.getString(PrefKeys.uId);
                          setState(() {
                            // editProfileCubit.selectedImageFile = null;
                            // editProfileCubit.userImage = null;
                            editProfileCubit.removeProfilePic = 'remove';
                          });
                          await editProfileCubit.removePrfilePicBio();
                          await editProfileCubit.getUserDetails(userId: userId);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Yes',
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
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xFFE6F6EE)),
            ),
            child: Text(
              'Remove',
              style: TextStyle(
                color: Color(0xFF7B7B7B),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> showImagePickerOptions(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Pick from Gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedFile =
                        await editProfileCubit.imagePicker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      print(pickedFile.path);
                      setState(() {
                        editProfileCubit.selectedImageFile =
                            File(pickedFile.path);
                      });
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Take a Picture'),
                  onTap: () async {
                    Navigator.pop(context); // Close the bottom sheet
                    final pickedFile =
                        await editProfileCubit.imagePicker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        editProfileCubit.selectedImageFile =
                            File(pickedFile.path);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        DateTime years = DateTime.now().subtract(Duration(days: 16 * 365));

        // Check if there's already a date in the controller
        DateTime? initialDate;
        if (editProfileCubit.dOBController.text.isNotEmpty) {
          try {
            // Parse the existing date (format: "MMMM yyyy" like "May 1999")
            final parsedDate = DateFormat('MMMM yyyy')
                .parse(editProfileCubit.dOBController.text);
            initialDate = parsedDate;
          } catch (e) {
            // If parsing fails, use the default
            initialDate = years;
          }
        } else {
          initialDate = years;
        }

        DateTime? selectedDate = await showMonthYearPicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(1000),
          lastDate: years,
          helpText: 'Select birth month and year',
          cancelText: 'Cancel',
          confirmText: 'OK',
          primaryColor: AppColor.greenDark,
        );

        if (selectedDate != null) {
          final formattedDate = DateFormat('MMMM yyyy').format(selectedDate);
          editProfileCubit.dOBController.text = formattedDate;
        }
      },
      child: AbsorbPointer(
        child: CommonTextField(
          controller: editProfileCubit.dOBController,
          hintText: StringConst.dateOfBirth,
          prefixIconPath: Assets.dob1,
          validator: MusaValidator.validatorDOB,
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
                onRecordingComplete: (selectedRecordPath) async {
                  setState(() {
                    audioFilePath = selectedRecordPath;
                    editProfileCubit.audioFilePath = selectedRecordPath;
                  });
                  await editProfileCubit.speechToText();
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

  Future<void> _pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );
      if (result != null && result.files.single.path != null) {
        File audio = File(result.files.single.path!);
        setState(() {
          editProfileCubit.audioFilePath = audioFilePath = audio.path;
        });
        await editProfileCubit.speechToText();
      }
    } catch (e) {
      debugPrint('Error picking audio: $e');
    }
  }

  void showRemoveConfirmationDialogForVoiceFile() {
    bool removeText = false; // State variable for checkbox

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
                    'Are you sure you want to delete your bio voice file?',
                    style: AppTextStyle.normalTextStyle(
                      color: AppColor.black,
                      size: 14,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: removeText,
                        activeColor: Color(0xFF00674E),
                        onChanged: (value) {
                          setState(() {
                            removeText = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Also remove bio text',
                          style: AppTextStyle.normalTextStyle(
                            color: AppColor.black,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                    var userId = Prefs.getString(PrefKeys.uId);

                    // Set states based on selection
                    editProfileCubit.removeBioFile = 'remove';
                    if (removeText) {
                      editProfileCubit.removeBioText = 'remove';
                    }

                    // Make API calls
                    await editProfileCubit.removePrfilePicBio();
                    await editProfileCubit.getUserDetails(userId: userId);

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
