import 'package:musa_app/Utility/packages.dart';

class AppTextStyle {
  static TextStyle normalTextStyle(
          {required Color color,
          required double size,
          TextDecoration? decoration}) =>
      GoogleFonts.dmSans(
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: color,
        decoration: decoration,
      );
  static TextStyle semiTextStyle({
    required Color color,
    required double size,
  }) =>
      GoogleFonts.dmSans(
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: color,
      );
  static TextStyle semiMediumTextStyle(
      {required Color color,
      required double size,
      TextDecoration? decoration}) {
    return GoogleFonts.dmSans(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color,
        decoration: decoration);
  }

  static TextStyle semiMediumTextStyleNew({
    required Color color,
    required double size,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.manrope(
      // switched to Manrope
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: color, // Replaces withOpacity(0.4)
      decoration: decoration,
      height: 1.3125, // line-height = 21 / 16 = 1.3125
      fontStyle: FontStyle.normal,
    );
  }

  static TextStyle mediumTextStyle(
          {required Color color,
          required double size,
          TextDecoration? decoration}) =>
      GoogleFonts.dmSans(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color,
        decoration: decoration,
      );
  static TextStyle boldTextStyle(
          {required Color color, required double size}) =>
      GoogleFonts.dmSans(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: color,
      );
  static TextStyle boldTextStyleNew(
          {required Color color, required double size}) =>
      GoogleFonts.manrope(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color,
      );
  static TextStyle normalTextStyleNew(
          {required Color color,
          required double size,
          required fontweight,
          TextDecoration? decoration}) =>
      GoogleFonts.manrope(
        fontSize: size,
        fontWeight: fontweight,
        color: color,
        decoration: decoration,
      );
  static TextStyle normalBoldTextStyle = GoogleFonts.dmSans(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColor.primaryTextColor);

  static TextStyle appBarTitleStyle = GoogleFonts.dmSans(
      fontSize: 17.sp,
      color: AppColor.primaryTextColor,
      fontWeight: FontWeight.w700);

  static TextStyle normalTextStyle1 = GoogleFonts.dmSans(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.primaryTextColor);

  static TextStyle buttonTextStyle = GoogleFonts.dmSans(
      fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.black);

  static TextStyle titleStyle = GoogleFonts.dmSans(
      fontSize: 24.sp,
      fontWeight: FontWeight.w700,
      color: AppColor.primaryTextColor);

  static TextStyle appBarTitleStyleBlack =
      GoogleFonts.dmSans(color: AppColor.black, fontWeight: FontWeight.w700);
}

abstract class MusaPadding {
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
  static EdgeInsets iconPadding = EdgeInsets.all(15.sp);
  static EdgeInsets appBarPadding = EdgeInsets.only(top: 27.sp);

  static const EdgeInsets horizontalPadding =
      EdgeInsets.symmetric(horizontal: 20.0);

  static const EdgeInsets verticalPadding =
      EdgeInsets.symmetric(vertical: 16.0);

  static const EdgeInsets topPadding = EdgeInsets.only(top: 10.0);

  static const EdgeInsets bottomPadding = EdgeInsets.only(bottom: 16.0);

  static const EdgeInsets leftPadding = EdgeInsets.only(left: 16.0);

  static const EdgeInsets rightPadding = EdgeInsets.only(right: 16.0);

  static const EdgeInsets smallPadding = EdgeInsets.all(8.0);

  static const EdgeInsets largePadding = EdgeInsets.all(24.0);

  static const EdgeInsets cardPadding = EdgeInsets.all(20.0);
  static const EdgeInsets horizontalPadding2 =
      EdgeInsets.symmetric(horizontal: 10.0);

  static EdgeInsets customPadding(
      double top, double left, double bottom, double right) {
    return EdgeInsets.fromLTRB(left, top, right, bottom);
  }
}
