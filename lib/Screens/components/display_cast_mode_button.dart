import '../../../Repository/AppResponse/social_musa_list_response.dart';
import '../../../Utility/musa_widgets.dart';
import '../../../Utility/packages.dart';
//import 'cast_media_dialog.dart';
import 'cast_dialog.dart';

class DisplayCastModeWidget extends StatefulWidget {
  final EdgeInsetsGeometry padding;
  final List<dynamic> fileList;
  final MusaData musaData;
  final VoidCallback? onPressed;
  final double? height;
  final double? fontSize;

  DisplayCastModeWidget({
    Key? key,
    required this.padding,
    required this.fileList,
    required this.musaData,
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
              onPressed: () {
                // showModalBottomSheet(
                //   context: context,
                //   builder: (context) {
                //     return ListView.builder(
                //       itemCount: widget.fileList.length,
                //       itemBuilder: (context, index) {
                //         final file = widget.fileList[index];
                //         final dynamic url =
                //             file is Map ? file['file_link'] : file.fileLink;
                //         final fileName =
                //             url.toString().split('/').last.toLowerCase();

                //         final isImage = fileName.endsWith('.jpg') ||
                //             fileName.endsWith('.jpeg') ||
                //             fileName.endsWith('.png') ||
                //             fileName.endsWith('.gif') ||
                //             fileName.endsWith('.webp');

                //         final isVideo = fileName.endsWith('.mp4') ||
                //             fileName.endsWith('.mov') ||
                //             fileName.endsWith('.mkv') ||
                //             fileName.endsWith('.avi');

                //         return ListTile(
                //           leading: isImage
                //               ? ClipRRect(
                //                   borderRadius: BorderRadius.circular(6),
                //                   child: Image.network(
                //                     url,
                //                     width: 60,
                //                     height: 60,
                //                     fit: BoxFit.cover,
                //                     errorBuilder:
                //                         (context, error, stackTrace) =>
                //                             Icon(Icons.broken_image, size: 40),
                //                     loadingBuilder:
                //                         (context, child, loadingProgress) {
                //                       if (loadingProgress == null) return child;
                //                       return SizedBox(
                //                         width: 60,
                //                         height: 60,
                //                         child: Center(
                //                           child: CircularProgressIndicator(
                //                               strokeWidth: 2),
                //                         ),
                //                       );
                //                     },
                //                   ),
                //                 )
                //               : Icon(
                //                   isVideo
                //                       ? Icons.ondemand_video
                //                       : Icons.insert_drive_file,
                //                   size: 40,
                //                 ),
                //           title: Text(
                //             fileName,
                //             overflow: TextOverflow.ellipsis,
                //           ),
                //           subtitle: Text(isImage
                //               ? 'Image'
                //               : isVideo
                //                   ? 'Video'
                //                   : 'Media'),
                //           onTap: () {
                //             Navigator.pop(context);
                //             showDialog(
                //               context: context,
                //               // builder: (_) => CastMediaDialog(
                //               //   url: url.toString(),
                //               //   title: 'Cast $fileName',
                //               // ),
                //               builder: (_) => CastDialog(
                //                 url: url.toString(),
                //                 title: 'Cast $fileName',
                //               ),
                //             );
                //           },
                //         );
                //       },
                //     );
                //   },
                // );
                print(
                    "Display Mode Button Pressed inside display cast mode widget");
                print("Musa Data: ${widget.musaData}");
                Utilities.navigateToLandscapeScreen(
                  context,
                  displayViewItems: widget.musaData,
                );
              },
              borderColor: AppColor.primaryColor,
              borderWidth: 1.sp,
              borderRadius: 5.sp,
              fontWeight: FontWeight.w500,
              fontSize: widget.fontSize!,
              textcolor: AppColor.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
