import 'dart:io';
import 'package:intl/intl.dart';
import 'package:musa_app/Cubit/auth/Login/login_cubit.dart';
import 'package:musa_app/Cubit/auth/Login/login_state.dart';
import 'package:musa_app/Resources/component/custom_date_picker.dart';
import 'package:musa_app/Utility/app_validations.dart';
import 'package:musa_app/Utility/packages.dart';
import 'package:file_picker/file_picker.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import 'package:musa_app/Resources/CommonWidgets/audio_recoder.dart';
import 'package:musa_app/Resources/CommonWidgets/audio_player.dart';
import 'package:musa_app/Resources/CommonWidgets/speech_to_text.dart';
import 'package:record/record.dart';

class SocialLogin extends StatefulWidget {
  const SocialLogin({super.key});

  @override
  State<SocialLogin> createState() => _SocialLoginState();
}

class _SocialLoginState extends State<SocialLogin> {
  LoginCubit loginCubit = LoginCubit();
  final record = AudioRecorder();
  String? audioFilePath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _speech = stt.SpeechToText();
    loginCubit.setPrefilledValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: BlocConsumer<LoginCubit, LoginState>(
        bloc: loginCubit,
        listener: (context, state) {
          if (state is UserInfoUpdate) {
            context.go(RouteTo.bottomNavBar);
          }
          if (state is LoginFailureState) {
            MusaPopup.popUpDialouge(
                context: context,
                onPressed: () => context.pop(true),
                buttonText: 'Okay',
                title: 'Error',
                description: state.errorMessage);
          }
          if (state is SpeechToTextSuccess) {}
          if (state is SpeechToTextFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              buildSocialLoginForm(context),
              state is LoggedInLoadingState
                  ? MusaWidgets.loader(context: context, isForFullHeight: true)
                  : Container()
            ],
          );
        },
      ),
    );
  }

  Container buildSocialLoginForm(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 15),
            child: Form(
              key: loginCubit.loginKey,
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
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextField(
                          controller: loginCubit.firstNameController,
                          hintText: StringConst.firstName,
                          prefixIconPath: Assets.userIcon1,
                          validator: MusaValidator.validatorName(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CommonTextField(
                          controller: loginCubit.lastNameController,
                          hintText: StringConst.lastName,
                          // prefixIconPath: Assets.userIcon,
                          validator: MusaValidator.validatorLName(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildDatePicker(),
                  SizedBox(height: 10),
                  CommonTextField(
                    controller: loginCubit.mobileController,
                    hintText: StringConst.mobileNumber,
                    prefixIconPath: Assets.phone1,
                  ),
                  SizedBox(height: 20),
                  CommonTextField(
                    controller: loginCubit.zipController,
                    hintText: StringConst.zipCode,
                    prefixIconPath: Assets.zipcode1,
                    // validator: MusaValidator.validatorZipCode,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'MUSA uses your zip code to offer you local gifts from sponsors',
                    style: AppTextStyle.normalTextStyleNew(
                      size: 13,
                      color: AppColor.greyNew,
                      fontweight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 20),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
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
                                      height: 20,
                                      width: 20,
                                      color:
                                          Color(0xFF1B5E20), // dark green icon
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
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: () {
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
                              loginCubit.audioFilePath = null;
                              loginCubit.bioController.text = '';
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
                  SizedBox(height: 12),
                  CommonTextField(
                    controller: loginCubit.bioController,
                    hintText: StringConst.bio,
                    maxLength: 500,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 30),
                  CommonButton(
                    title: StringConst.saveFinish,
                    onTap: () {
                      loginCubit.completeUserInfo();
                    },
                    color: AppColor.greenDark,
                  ),
                  SizedBox(height: 20),
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
          // if (selectedDate.isAfter(sixteenYearsAgo)) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('Age below 16 is not allowed.')),
          //   );
          //   return;
          // }
          final formattedDate = DateFormat('MMMM yyyy').format(selectedDate);

          loginCubit.dOBController.text = formattedDate;
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AbsorbPointer(
            child: CommonTextField(
              controller: loginCubit.dOBController,
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
                    loginCubit.audioFilePath = selectedRecordPath;
                  });
                  await loginCubit.speechToText();
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
                  audioFilePath = selectedRecordPath;
                  // await loginCubit.speechToText([File(selectedRecordPath)]);
                  // Navigator.pop(context);
                },
                recordUploadBtn: () {
                  Navigator.pop(context);
                },
                onSpeechTextUpdate: (text) {
                  setState(() {
                    loginCubit.bioController.text =
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
        allowMultiple: false,
      );
      if (result != null && result.files.single.path != null) {
        File audio = File(result.files.single.path!);
        setState(() {
          loginCubit.audioFilePath = audioFilePath = audio.path;
        });
        await loginCubit.speechToText();
      }
    } catch (e) {
      debugPrint('Error picking audio: $e');
    }
  }
}
