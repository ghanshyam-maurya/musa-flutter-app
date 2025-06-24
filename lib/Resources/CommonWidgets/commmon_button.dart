import 'package:musa_app/Utility/packages.dart';

class CommonButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool hasBorder;
  final Color? color;

  const CommonButton({
    super.key,
    required this.title,
    required this.onTap,
    this.hasBorder = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          // gradient: hasBorder ? null : AppColor.buttonGradient(),
          gradient:
              color == null && !hasBorder ? AppColor.buttonGradient() : null,

          border:
              hasBorder ? Border.all(color: AppColor.white, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Center(
            child: Text(
              title,
              style: AppTextStyle.semiTextStyle(
                color: AppColor.white,
                size: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
