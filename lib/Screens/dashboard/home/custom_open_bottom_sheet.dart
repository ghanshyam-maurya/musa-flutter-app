import 'package:flutter/material.dart';

class BottomSheetContainer extends StatefulWidget {
  final Widget requiredWidget;

  const BottomSheetContainer({super.key, required this.requiredWidget});

  @override
  _BottomSheetContainerState createState() => _BottomSheetContainerState();

  /// Instead of a static method, this widget now exposes a method to open the bottom sheet.
  static void openBottomSheet({
    required BuildContext context,
    required Widget requireWidget,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => BottomSheetContainer(requiredWidget: requireWidget),
    );
  }
}

class _BottomSheetContainerState extends State<BottomSheetContainer> {
  @override
  void didUpdateWidget(covariant BottomSheetContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger a rebuild if the `requiredWidget` changes
    if (widget.requiredWidget != oldWidget.requiredWidget) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 60,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16, top: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75, // Fixed height
            child: widget.requiredWidget,
          ),
        ],
      ),
    );
  }
}
