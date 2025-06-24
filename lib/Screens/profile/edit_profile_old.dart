import 'dart:io';

import 'package:intl/intl.dart';
import 'package:musa_app/Cubit/profile/edit_profile/edit_profile_cubit.dart';
import 'package:musa_app/Cubit/profile/edit_profile/edit_profile_state.dart';
import 'package:musa_app/Resources/component/custom_date_picker.dart';
import 'package:musa_app/Utility/app_validations.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import 'package:musa_app/Utility/packages.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  EditProfileCubit editProfileCubit = EditProfileCubit();

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
                    onTap: () {
                      editProfileCubit.updateUser();
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 20),
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
                                validator: MusaValidator.validatorName(),
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
                        SizedBox(
                          height: 30,
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CommonTextField(
                              controller: editProfileCubit.bioController,
                              hintText: StringConst.bioOptional,
                              maxLines: 6,
                            ),
                            // Positioned(
                            //   top: -25,
                            //   left: (MediaQuery.of(context).size.width - 30) /
                            //       2.5,
                            //   child: GestureDetector(
                            //     onTap: () {},
                            //     child: Container(
                            //       width: 52,
                            //       height: 52,
                            //       decoration: BoxDecoration(
                            //           color: AppColor.white,
                            //           shape: BoxShape.circle,
                            //           border: Border.all(
                            //             color: AppColor.primaryColor,
                            //             width: 3,
                            //           )),
                            //       child: Icon(Icons.mic_none_outlined),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
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

  // buildProfilePictureUpload(BuildContext context) {
  //   return Row(
  //     children: [
  //       Container(
  //         decoration: BoxDecoration(
  //           shape: BoxShape.circle,
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.25),
  //               spreadRadius: 1,
  //               blurRadius: 5,
  //               offset: Offset(0, 3),
  //             ),
  //           ],
  //         ),
  //         child: MusaWidgets.userProfileAvatarEdit(
  //           imageUrl: editProfileCubit.userImage,
  //           localImageFile: editProfileCubit.selectedImageFile,
  //           radius: 38.sp,
  //           borderWidth: 2.sp,
  //         ),
  //       ),
  //       SizedBox(width: 26.sp),
  //       Positioned(
  //         bottom: 0,
  //         right: 0,
  //         child: GestureDetector(
  //           onTap: () {
  //             showImagePickerOptions(context);
  //           },
  //           child: Container(
  //             padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
  //             decoration: BoxDecoration(
  //               // shape: BoxShape.circle,
  //               color: Color(0xFFE6F6EE),
  //               borderRadius: BorderRadius.circular(10),
  //               border: Border.all(
  //                 color: AppColor.white,
  //               ),
  //             ),
  //             child: Text(
  //               'Change',
  //               style: TextStyle(
  //                 color: Color(0xFF00674E), // or AppColor.greenDark
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //       SizedBox(width: 12.sp),
  //       Positioned(
  //         bottom: 0,
  //         right: 0,
  //         child: GestureDetector(
  //           onTap: () {
  //             // showImagePickerOptions(context);
  //           },
  //           child: Container(
  //             padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
  //             decoration: BoxDecoration(
  //               // shape: BoxShape.circle,
  //               color: AppColor.white,
  //               borderRadius: BorderRadius.circular(10),
  //               border: Border.all(color: Color(0xFFE6F6EE)),
  //             ),
  //             child: Text(
  //               'Remove',
  //               style: TextStyle(
  //                 color: Color(0xFF7B7B7B), // or AppColor.greenDark
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  buildProfilePictureUpload(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
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
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            // SizedBox(height: 12.sp),
            // GestureDetector(
            //   onTap: () {
            //     // showImagePickerOptions(context);
            //   },
            //   child: Container(
            //     padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            //     decoration: BoxDecoration(
            //       color: AppColor.white,
            //       borderRadius: BorderRadius.circular(10),
            //       border: Border.all(color: Color(0xFFE6F6EE)),
            //     ),
            //     child: Text(
            //       'Remove',
            //       style: TextStyle(
            //         color: Color(0xFF7B7B7B),
            //         fontSize: 14,
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ),
            // ),
          ],
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
                      print("jahdkda");
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
        DateTime today = DateTime.now();
        DateTime years = DateTime.now().subtract(Duration(days: 16 * 365));
        // DateTime sixteenYearsAgo =
        //     DateTime(today.year - 16, today.month, today.day);

        DateTime? selectedDate = await showCustomDatePicker(
          context: context,
          initialDate: years,
          firstDate: DateTime(1000),
          lastDate: years,
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: AppColor.greenDark,
                colorScheme: ColorScheme.light(primary: AppColor.greenDark),
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: child!,
            );
          },
        );
        if (selectedDate != null) {
          // if (selectedDate.isAfter(sixteenYearsAgo)) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('Age below 16 is not allowed.')),
          //   );
          //   return;
          // }

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
}
