import 'package:musa_app/Utility/packages.dart';

class CommonDottedDivider extends StatelessWidget {
  final double height;
  final Color color;

  const CommonDottedDivider({
    this.height = 1,
    this.color = Colors.black,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        const dashSpacing = 4.0;
        final dashCount = (boxWidth / (dashWidth + dashSpacing)).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return Container(
              width: dashWidth,
              height: height,
              color: color,
            );
          }),
        );
      },
    );
  }
}
