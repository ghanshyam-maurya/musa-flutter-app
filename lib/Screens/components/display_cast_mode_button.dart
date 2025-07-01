import '../../../Utility/musa_widgets.dart';
import '../../../Utility/packages.dart';

class DisplayCastModeWidget extends StatefulWidget {
  final EdgeInsetsGeometry padding;
  final List<dynamic> fileList; // Use the correct type for your file list
  final VoidCallback? onPressed;
  double? height = 20.sp;
  double? fontSize = 10.sp;

  DisplayCastModeWidget({
    Key? key,
    required this.padding,
    required this.fileList,
    this.onPressed,
    this.height = 20,
    this.fontSize = 10,
  }) : super(key: key);

  @override
  State<DisplayCastModeWidget> createState() => _DisplayCastModeWidgetState();
}

class _DisplayCastModeWidgetState extends State<DisplayCastModeWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: SizedBox(
        height: widget.height,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MusaWidgets.borderTextButton(
              minWidth: 10.sp,
              title: StringConst.displayText,
              onPressed: widget.onPressed ?? () {},
              borderColor: AppColor.primaryColor,
              borderWidth: 1.sp,
              borderRadius: 5.sp,
              fontWeight: FontWeight.w500,
              fontSize: widget.fontSize!,
              textcolor: AppColor.primaryColor,
            ),
            // You can add the MusaImageVideoContainer here if needed
            // MusaImageVideoContainer(fileList: widget.fileList),
          ],
        ),
      ),
    );
  }
}
