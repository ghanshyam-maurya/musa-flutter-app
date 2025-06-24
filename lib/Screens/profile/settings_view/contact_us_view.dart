import '../../../Utility/musa_widgets.dart';
import '../../../Utility/packages.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({
    super.key,
  });

  @override
  ContactUsViewState createState() => ContactUsViewState();
}

class ContactUsViewState extends State<ContactUsView> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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
              controller: _emailController,
              hintText: 'Subject',
              prefixIconPath: 'assets/svgs/subject_icon.svg',

              // obscureText: changePwCubit.obsecureText1,
              // onToggleObscure: () {
              //   changePwCubit.showPassword1();
              // },
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
                    color: Color(0xFFB4C7B9),
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
                        // Icon(
                        //   Icons.edit,
                        //   color: Colors.grey,
                        //   size: 18.sp,
                        // ),
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
                        maxLines: 10,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8.sp,
                            horizontal: 10.sp,
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
              onTap: () {},
              child: Container(
                width: double.infinity, // This makes it take full width
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xFF00674E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
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
