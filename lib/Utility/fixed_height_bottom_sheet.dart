import 'package:flutter/cupertino.dart';

class FixedHeightBottomSheet extends StatefulWidget {
  final Widget requiredWidget;
  const FixedHeightBottomSheet({super.key, required this.requiredWidget});

  @override
  State<FixedHeightBottomSheet> createState() => _FixedHeightBottomSheetState();
}

class _FixedHeightBottomSheetState extends State<FixedHeightBottomSheet> {
  @override
  void didUpdateWidget(covariant FixedHeightBottomSheet oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.75, // Fixed height
        child: widget.requiredWidget);
  }
}
