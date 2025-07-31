import 'package:musa_app/Screens/profile/settings_view/privacy_content_html_widget.dart';

import '../../../Utility/packages.dart';
import 'terms_content_widget.dart';
import 'privacy_content_widget.dart';

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
                    child: TermsPrivacyHeader(flowType: widget.flowType),
                  ),
                ],
              ),
              SizedBox(height: 20.sp),
              Expanded(
                child: TermsPrivacyContent(flowType: widget.flowType),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget for the header/title
class TermsPrivacyHeader extends StatelessWidget {
  final String? flowType;
  const TermsPrivacyHeader({Key? key, this.flowType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      (flowType.toString() == "Terms")
          ? StringConst.termsText
          : (flowType.toString() == "Privacy")
              ? "Privacy & Policy"
              : StringConst.aboutText,
      style: AppTextStyle.semiMediumTextStyleNew(
        color: Color(0xFF222222),
        size: 19.sp,
      ),
    );
  }
}

// Widget for the content/body
class TermsPrivacyContent extends StatelessWidget {
  final String? flowType;
  const TermsPrivacyContent({Key? key, this.flowType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // You can add logic here to show different content for terms/privacy/about if needed
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: MusaPadding.horizontalPadding,
        child: (flowType.toString() == "Terms")
            ? const TermsContentWidget()
            : (flowType.toString() == "Privacy")
                ? const PrivacyContentHTMLWidget()
                : Text(
                    StringConst.dummyTermsText,
                    style: AppTextStyle.normalTextStyle1,
                  ),
      ),
    );
  }
}
