import 'dart:io';
import 'package:intl/intl.dart';
import 'package:musa_app/Cubit/auth/Signup/signup_cubit.dart';
import 'package:musa_app/Cubit/auth/Signup/signup_state.dart';
import 'package:musa_app/Resources/component/custom_date_picker.dart';
import 'package:musa_app/Utility/app_validations.dart';
import 'package:musa_app/Utility/packages.dart';
import 'package:file_picker/file_picker.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import 'package:musa_app/Resources/CommonWidgets/audio_recoder.dart';
import 'package:musa_app/Resources/CommonWidgets/audio_player.dart';
import 'package:musa_app/Resources/CommonWidgets/speech_to_text.dart';
import 'package:musa_app/Cubit/dashboard/my_section_cubit/my_section_cubit.dart';
import 'package:record/record.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  SignupCubit signupCubit = SignupCubit();
  MySectionCubit mySectionCubit = MySectionCubit();
  final record = AudioRecorder();
  String? audioFilePath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close), // Cross icon
          onPressed: () {
            Navigator.pop(context); // <- Navigate to Get Started screen
          },
        ),
        title: Text(
          StringConst.complete,
          style: AppTextStyle.normalTextStyleNew(
            size: 18,
            color: AppColor.black,
            fontweight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<SignupCubit, SignupState>(
        bloc: signupCubit,
        listener: (context, state) {
          if (state is SignupSuccess) {
            var email = Prefs.getString(PrefKeys.email) ?? '';
            context.push(
              RouteTo.otp,
              extra: {'email': email, 'comingFrom': 'SignUp'},
            );
          }
          if (state is SignUpFailureState) {
            MusaPopup.popUpDialouge(
                context: context,
                onPressed: () => context.pop(true),
                buttonText: 'Okay',
                title: 'Error',
                description: state.errorMessage);
          }
          if (state is SpeechToTextSuccess) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('File Uploaded Successfully!!')),
            // );
          }
          if (state is SpeechToTextFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              buildMusaUserRegister(context),
              state is SignupLoading
                  ? MusaWidgets.loader(context: context, isForFullHeight: true)
                  : Container()
            ],
          );
        },
      ),
    );
  }

  Container buildMusaUserRegister(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 20),
            child: Form(
              key: signupCubit.signUpKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringConst.completeMusa,
                    style: AppTextStyle.normalTextStyleNew(
                      size: 14,
                      color: AppColor.black,
                      fontweight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextField(
                          controller: signupCubit.firstNameController,
                          hintText: StringConst.firstName,
                          prefixIconPath: Assets.userIcon1,
                          validator: MusaValidator.validatorName(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CommonTextField(
                          controller: signupCubit.lastNameController,
                          hintText: StringConst.lastName,
                          // prefixIconPath: Assets.userIcon,
                          validator: MusaValidator.validatorLName(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildDatePicker(),
                  const SizedBox(height: 10),
                  CommonTextField(
                    controller: signupCubit.mobileController,
                    hintText: StringConst.mobileNumber,
                    prefixIconPath: Assets.phone1,
                  ),
                  const SizedBox(height: 20),
                  CommonTextField(
                    controller: signupCubit.zipCodeController,
                    hintText: StringConst.zipCode,
                    prefixIconPath: Assets.zipcode1,
                    // validator: MusaValidator.validatorZipCode,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'MUSA uses your zip code to offer you rewards from sponsors',
                    style: AppTextStyle.normalTextStyleNew(
                      size: 13,
                      color: AppColor.greyNew,
                      fontweight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "You can record your bio in audio format, or simply upload your pre-recorded file (optional)",
                    style: AppTextStyle.normalTextStyleNew(
                      size: 14,
                      color: AppColor.black,
                      fontweight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 12),
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
                                    borderRadius: BorderRadius.circular(8),
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
                                        style: AppTextStyle.normalTextStyleNew(
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
                                    borderRadius: BorderRadius.circular(8),
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
                                        style: AppTextStyle.normalTextStyleNew(
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
                              signupCubit.audioFilePath = null;
                              signupCubit.bioController.text = '';
                            });
                          },
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    "You can record your bio in text (optional)",
                    style: AppTextStyle.normalTextStyleNew(
                      size: 14,
                      color: AppColor.black,
                      fontweight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CommonTextField(
                    controller: signupCubit.bioController,
                    hintText: StringConst.bio,
                    maxLength: 500,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 30),
                  CommonButton(
                    title: StringConst.saveFinish,
                    onTap: () {
                      signupCubit.registerFormValid(context: context);
                    },
                    color: AppColor.greenDark,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        DateTime today = DateTime.now();
        // DateTime years = DateTime(today.year, today.month, today.day);
        DateTime sixteenYearsAgo =
            DateTime(today.year - 16, today.month, today.day);
        DateTime years = DateTime.now().subtract(Duration(days: 16 * 365));

        DateTime? selectedDate = await showCustomDatePicker(
          context: context,
          initialDate: years,
          firstDate: DateTime(1000),
          lastDate: years,
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: Colors.green,
                colorScheme: ColorScheme.light(primary: Colors.green),
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: child!,
            );
          },
        );
        if (selectedDate != null) {
          // if (selectedDate.isBefore(sixteenYearsAgo)) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('Age below 16 is not allowed.')),
          //   );
          //   return;
          // }

          final formattedDate = DateFormat('MMMM yyyy').format(selectedDate);

          signupCubit.dobController.text = formattedDate;
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AbsorbPointer(
            child: CommonTextField(
              controller: signupCubit.dobController,
              hintText: StringConst.dateOfBirth,
              prefixIconPath: Assets.dob1,
              validator: MusaValidator.validatorDOB,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'You have to be 16 years or older to use MUSA',
            style: AppTextStyle.normalTextStyleNew(
              size: 13,
              color: AppColor.greyNew,
              fontweight: FontWeight.w400,
            ),
          ),
        ],
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
                    signupCubit.audioFilePath = selectedRecordPath;
                  });
                  await signupCubit.speechToText();
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

  void onSpeechToTextButtonPressed() {
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
              child: SpeechToText(
                onRecordingComplete: (selectedRecordPath) async {
                  setState(() {
                    audioFilePath = selectedRecordPath;
                    signupCubit.audioFilePath = selectedRecordPath;
                  });
                  // await loginCubit.speechToText([File(selectedRecordPath)]);
                  // Navigator.pop(context);
                },
                recordUploadBtn: () {
                  Navigator.pop(context);
                },
                onSpeechTextUpdate: (text) {
                  setState(() {
                    signupCubit.bioController.text =
                        text; // This updates the bio field
                  });
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
        allowMultiple: true,
      );

      if (result != null && result.files.single.path != null) {
        File audio = File(result.files.single.path!);
        setState(() {
          audioFilePath = audio.path;
          signupCubit.audioFilePath = audio.path;
        });
        await signupCubit.speechToText();

        // Call your speech-to-text or processing function here
        // await loginCubit.speechToText(audio);
      }
      // if (result != null) {
      //   List<File> files = result.paths.map((path) => File(path!)).toList();
      //   // await signupCubit.speechToText(files);
      // }
    } catch (e) {
      debugPrint('Error picking audio: $e');
    }
  }
}
