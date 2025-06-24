import '../../../Utility/packages.dart';

class TermsAndPrivacyView extends StatefulWidget {
  final String? flowType;

  const TermsAndPrivacyView({super.key, this.flowType});

  @override
  TermsAndPrivacyViewState createState() => TermsAndPrivacyViewState();
}

class TermsAndPrivacyViewState extends State<TermsAndPrivacyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 25.sp),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(Icons.close),
                  ),
                  SizedBox(width: 26.sp),
                  Expanded(
                    child: Text(
                      (widget.flowType.toString() == "Terms")
                          ? StringConst.termsText
                          : (widget.flowType.toString() == "Privacy")
                              ? "Privacy & Policy"
                              : StringConst.aboutText,
                      style: AppTextStyle.semiMediumTextStyleNew(
                          color: Color(0xFF222222), size: 19.sp),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.sp),
              Expanded(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: MusaPadding.horizontalPadding,
                    child: Text(
                      StringConst.dummyTermsText,
                      style: AppTextStyle.normalTextStyle1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
