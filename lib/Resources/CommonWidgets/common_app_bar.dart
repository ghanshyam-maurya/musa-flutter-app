import 'package:musa_app/Utility/packages.dart';

class AppBarMusa1 extends StatelessWidget {
  final String title;
  final Function() appBarBtn;
  final String appBarBtnText;
  const AppBarMusa1(
      {super.key,
      required this.title,
      required this.appBarBtn,
      required this.appBarBtnText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
        gradient: AppColor.appBarGradientBlank(),
      ),
      padding: const EdgeInsets.only(top: 50, bottom: 10, left: 20, right: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.close),
          ),
          SizedBox(width: 10),
          Text(
            title,
            style: AppTextStyle.semiMediumTextStyle(
                color: AppColor.primaryTextColor, size: 18),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: appBarBtn,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00674E), // Green background
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size(0, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              appBarBtnText,
              style: const TextStyle(
                color: Colors.white, // White text
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppBarMusa2 extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? end;

  const AppBarMusa2({
    super.key,
    required this.leading,
    required this.title,
    this.end,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        gradient: AppColor.appBarGradient(),
      ),
      padding: const EdgeInsets.only(top: 0, bottom: 10, left: 20, right: 20),
      child: Row(
        children: [
          leading,
          SizedBox(width: 10),
          Expanded(child: title),
          if (end != null) ...[
            SizedBox(width: 10),
            end!,
          ],
        ],
      ),
    );
  }
}

class AppBarMusa3 extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? end;

  const AppBarMusa3({
    super.key,
    required this.leading,
    required this.title,
    this.end,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        gradient: AppColor.appBarGradient(),
      ),
      padding: const EdgeInsets.only(top: 0, bottom: 55, left: 20, right: 20),
      child: Row(
        children: [
          leading,
          SizedBox(width: 10),
          Expanded(child: title),
          if (end != null) ...[
            SizedBox(width: 10),
            end!,
          ],
        ],
      ),
    );
  }
}

class AppBarDashboard extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? end;

  const AppBarDashboard({
    super.key,
    required this.leading,
    required this.title,
    this.end,
  });

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Container(
      height: 99,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        gradient: AppColor.appBarGradientDashboard(),
      ),
      padding: EdgeInsets.fromLTRB(20, topPadding, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          leading,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: title,
              ),
            ),
          ),
          if (end != null)
            Container(
              //color: Colors.red.withOpacity(0.2), // Visual debug
              child: end!,
            ),
        ],
      ),
    );
  }
}
