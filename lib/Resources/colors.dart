import '../Utility/packages.dart';

class AppColor {
  static const splashColor = Color(0xFF008C45);
  static const primaryTextColor = Color(0xFF222222);
  static const secondaryTextColor = Color(0xFF555555);
  static const hintTextColor = Color(0xFFA1ABB8);
  static const greyLine = Color(0xFFBDBDBD);
  static const greyChatBG = Color(0xFFE7E6EB);
  static Color secondaryColor = const Color.fromARGB(255, 245, 190, 51);
  static Color primaryColor = const Color(0xFF008C45);
  static Color primaryDarkColor = const Color(0xff263580);
  static Color selectedItem = const Color(0xff00A4B5);
  static Color selectedNavigation = const Color(0xff12ADC1);
  static Color bgGrey = const Color(0xffF2F2F2);
  static Color bgAlbum = const Color(0xffB0E6CB);
  static const bgAlbum2 = Color(0xFF66BAB4);
  static const txtColor = Color(0xFF575655);
  static Color green = Colors.green;
  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color red = Colors.red;
  static Color grey = Colors.grey.shade400;
  static Color lightestGreen = Color.fromARGB(255, 237, 248, 243);
  static Color bgAudio = const Color(0XFFC2D6D6);
  static Color greenLight = Color(0xFF66BB6A);
  static Color greenDarkest = Color.fromARGB(255, 5, 87, 12);
  static const Color lightGreen = Color(0xFFE0CC03);
  static const Color greenDark = Color(0xFF00674E);
  static const Color greyNew = Color(0xFF7B7B7B);
  static const Color greenTextbd = Color(0xFFB4C7B9);
  static const Color greenTextbg = Color(0xFFF8FDFA);
  static Color lightGreenNew = Color(0xFFC8E4D6);
  static Color textBg = const Color(0xFFF8FDFA);
  static Color textBorder = const Color(0xFFB4C7B9);
  static Color switchActive = const Color(0xFF00674E);
  static Color switchInactive = const Color(0xFFD9F0E5);
  static Color textInactive = const Color(0xFFE6F6EE);
  static Color greenBorder = const Color(0xFF9E510D);
  static Color greenText = const Color(0xFF019E51);
  static Color greyDividerColor = const Color(0xFFE9E9E9);
  // added by Sailee Agni
  static const LinearGradient primaryGreenGradient = LinearGradient(
    colors: [lightGreen, greenDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient gradient() => const LinearGradient(
        begin: Alignment.topCenter, // Start at the top
        end: Alignment.bottomCenter, // End at the bottom
        colors: [
          Color(0xFFF7EF81), // #15B563
          Color(0xFF008C45), // #008C45
        ],
        stops: [0.3177, 0.9896], // 31.77% and 98.96%
      );

  static LinearGradient gradientVertical() => const LinearGradient(
        begin: Alignment.topRight, // Start at the top
        end: Alignment.bottomLeft, // End at the bottom
        colors: [
          Color(0xFFF7EF81), // #15B563
          Color(0xFF008C45), // #008C45
        ],
        stops: [0.3177, 0.9896], // 31.77% and 98.96%
      );

  static LinearGradient buttonGradient() => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF02A959), // #02A959
          Color(0xFF008E46), // #008E46
        ],
      );

  static LinearGradient appBarGradient() => const LinearGradient(
        begin: Alignment.centerRight, // Start at the left
        end: Alignment.centerLeft, // End at the right
        colors: [
          Color(0xFFF7EF81), // #15B563// Color(0xFFF7EF81),
          Color(0xFFF6C472), // #008C45// Color(0xFFFEC062),
        ],
        stops: [0.3177, 0.9896], // 31.77% and 98.96%
      );

  static LinearGradient appBarGradientBlank() => const LinearGradient(
        begin: Alignment.centerLeft, // Start at the left
        end: Alignment.centerRight, // End at the right
        colors: [
          Color(0xFFFFFFFF), // #15B563// Color(0xFFF7EF81),
          Color(0xFFFFFFFF), // #008C45// Color(0xFFFEC062),
        ],
        stops: [0.3177, 0.9896], // 31.77% and 98.96%
      );
  static LinearGradient appBarGradientDashboard() => const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFFF5C674), // Left side
          Color(0xFFF9EE82), // Right side
        ],
      );

  static LinearGradient toggleGradient() => const LinearGradient(
        begin: Alignment.centerLeft, // Start at the left
        end: Alignment.centerRight, // End at the right
        colors: [
          Color(0xFF9ED899), // #15B563
          Color(0xFF66BAB4), // #008C45
        ],
        stops: [0.3177, 0.9896], // 31.77% and 98.96%
      );

  static LinearGradient opacityrGadient() => const LinearGradient(
        begin: Alignment.centerLeft, // Start at the left
        end: Alignment.centerRight, // End at the right
        colors: [
          Color(0xFF302D2D), // #15B563
          Color(0xFF121918), // #008C45
        ],
        stops: [0.3177, 0.9896], // 31.77% and 98.96%
      );
}
