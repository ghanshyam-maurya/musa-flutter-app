import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:musa_app/Utility/packages.dart';

class MusaPopup {
  static Future<void> popUpDialouge(
      {required BuildContext context,
      String? title,
      String? description,
      String? buttonText,
      required Function onPressed}) {
    // HapticFeedback.vibrate();
    return Dialogs.materialDialog(
        color: Colors.white,
        msg: description,
        title: title,
        titleStyle: AppTextStyle.normalTextStyleNew(
          size: 13,
          color: AppColor.black,
          fontweight: FontWeight.w400,
        ),
        msgStyle: AppTextStyle.normalTextStyleNew(
          size: 13,
          color: AppColor.txtColor,
          fontweight: FontWeight.w400,
        ),
        titleAlign: TextAlign.center,
        msgAlign: TextAlign.center,
        //customView: MySuperWidget(),
        customViewPosition: CustomViewPosition.BEFORE_ACTION,
        context: context,
        actions: [
          IconsButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.sp)),
            onPressed: onPressed,
            text: '$buttonText',
            iconData: Icons.done,
            color: AppColor.greenDark,
            textStyle: AppTextStyle.normalTextStyleNew(
              size: 13,
              color: AppColor.white,
              fontweight: FontWeight.w400,
            ),
            iconColor: Colors.white,
          ),
        ]);
  }
}
