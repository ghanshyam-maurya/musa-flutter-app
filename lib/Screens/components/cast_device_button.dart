import 'package:flutter/material.dart';

import 'cast_utils.dart';

class CastDeviceButton extends StatelessWidget {
  final List<dynamic> fileList;
  final double iconSize;
  final Color? color;

  const CastDeviceButton({
    Key? key,
    required this.fileList,
    this.iconSize = 28.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.cast, size: iconSize, color: color ?? Colors.blue),
      onPressed: () {
        CastUtils.showCastDialog(context, fileList);
      },
      tooltip: 'Cast to device',
    );
  }
}
