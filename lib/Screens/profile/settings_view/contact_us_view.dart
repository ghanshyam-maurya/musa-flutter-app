import '../../../Utility/packages.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({
    super.key,
  });

  @override
  ContactUsViewState createState() => ContactUsViewState();
}

class ContactUsViewState extends State<ContactUsView> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final Repository _repository = Repository();
  bool _isLoading = false;
  String? _subjectError;
  String? _messageError;

  void _validateAndSubmit() {
    setState(() {
      _subjectError = null;
      _messageError = null;
    });

    bool isValid = true;

    if (_subjectController.text.trim().isEmpty) {
      setState(() {
        _subjectError = 'Please enter a subject';
      });
      isValid = false;
    }

    if (_messageController.text.trim().isEmpty) {
      setState(() {
        _messageError = 'Please enter your message';
      });
      isValid = false;
    }

    if (isValid) {
      _submitContactForm();
    } else {
      // Force rebuild to show validation errors
      setState(() {});
    }
  }

  void _submitContactForm() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _repository.sendContactMessage(
          subject: _subjectController.text.trim(),
          message: _messageController.text.trim());

      setState(() {
        _isLoading = false;
      });

      response.fold(
        (success) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Your message has been sent successfully'),
              backgroundColor: Color(0xFF00674E),
            ),
          );

          // Clear the form
          _subjectController.clear();
          _messageController.clear();

          // Navigate back or to previous screen
          context.pop();
        },
        (failure) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message ?? 'An error occurred'),
              backgroundColor:
                  Colors.red[400] ?? Colors.red, // Use a fallback color if null
            ),
          );
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(StringConst.somethingWentWrong),
          backgroundColor: Colors.red[400] ?? Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Padding(
        padding: MusaPadding.horizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40.sp,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: Icon(Icons.close),
                ),
                SizedBox(width: 26.sp), // Added spacing of 10 logical pixels
                Text(
                  StringConst.contactUs,
                  style: AppTextStyle.semiMediumTextStyleNew(
                      color: Color(0xFF222222), size: 19.sp),
                ),
              ],
            ),
            SizedBox(height: 20.sp),
            // MusaWidgets.commonTextField(
            //   bgColor: Colors.transparent,
            //   onTap: () => {},
            //   onChanged: (value) => {},
            //   inputMaxLine: 1,
            //   prefixIcon: Padding(
            //     padding: MusaPadding.iconPadding,
            //     child: SvgPicture.asset(
            //       Assets.userIcon,
            //       fit: BoxFit.fill,
            //     ),
            //   ),
            //   inputHintText: 'Subject',
            //   inputController: _firstNameController,
            // ),
            CommonTextField(
              controller: _subjectController,
              hintText: 'Subject',
              prefixIconPath: 'assets/svgs/subject_icon.svg',
              validator: (value) =>
                  _subjectError != null ? _subjectError : null,
              autovalidateMode: AutovalidateMode.always,
            ),
            // MusaWidgets.commonTextField(
            //   bgColor: Colors.transparent,
            //   onTap: () => {},
            //   onChanged: (value) => {},
            //   inputMaxLine: 1,
            //   prefixIcon: Padding(
            //     padding: MusaPadding.iconPadding,
            //     child: SvgPicture.asset(
            //       Assets.email,
            //       fit: BoxFit.fill,
            //     ),
            //   ),
            //   inputHintText: 'Email Id',
            //   inputController: _emailController,
            // ),
            SizedBox(
              height: 15.sp,
            ),
            Container(
              height: 150.sp,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.sp),
                  color: Color(0xFFF8FDFA),
                  border: Border.all(
                    color:
                        _messageError != null ? Colors.red : Color(0xFFB4C7B9),
                    width: 1.sp,
                  )),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 5.sp,
                        ),
                        Text(
                          "Your Message",
                          style: AppTextStyle.normalBoldTextStyle.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(96, 34, 34, 34)),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        maxLines: 10,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8.sp,
                            horizontal: 10.sp,
                          ),
                          errorText: _messageError,
                          errorStyle: TextStyle(
                            color: Colors.red,
                            fontSize: 12.sp,
                          ),
                        ),
                        style: AppTextStyle.normalTextStyle1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.sp),
            // MusaWidgets.primaryTextButton(
            //   title: StringConst.submitText,
            //   onPressed: () {},
            //   bgcolor: Color(0xFF00674E),
            // ),
            GestureDetector(
              onTap: () {
                _validateAndSubmit();
              },
              child: Container(
                width: double.infinity, // This makes it take full width
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xFF00674E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      )
                    : Text(
                        StringConst.submitText,
                        style: AppTextStyle.semiTextStyle(
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
