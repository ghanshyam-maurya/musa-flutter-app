import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../Resources/app_style.dart';
import '../../../../Resources/colors.dart';
import '../../../../Utility/musa_widgets.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String imageUrl;

  const ImagePreviewScreen({super.key, required this.imageUrl});

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgGrey,
      body: Column(
        children: [
          MusaWidgets.commonAppBar(
            height: 110.0,
            row: Padding(
              padding: MusaPadding.appBarPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: Icon(Icons.arrow_back_ios,
                        color: AppColor.black, size: 22),
                  ),
                  // Text(
                  //   Utilities.capitalizeFirstLetter('Upload Media'),
                  //   style: AppTextStyle.appBarTitleStyle,
                  // ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: Center(
              child: PhotoView(
                imageProvider:
                    NetworkImage(widget.imageUrl), // Load image from network
                backgroundDecoration: BoxDecoration(color: AppColor.bgGrey),
                minScale: PhotoViewComputedScale.contained, // Minimum zoom
                maxScale: PhotoViewComputedScale.covered * 2.0, // Maximum zoom
              ),
            ),
          )
        ],
      ),
    );
  }
}
