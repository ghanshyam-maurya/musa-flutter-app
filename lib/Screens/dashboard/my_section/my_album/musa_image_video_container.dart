import 'package:musa_app/Utility/musa_widgets.dart';

import '../../../../Repository/AppResponse/social_musa_list_response.dart';
import '../../../../Utility/packages.dart';

class MusaImageVideoContainer extends StatefulWidget {
  final List<FileElement> fileList;

  const MusaImageVideoContainer({super.key, required this.fileList});

  @override
  _CollageContainerState createState() => _CollageContainerState(fileList);
}

class _CollageContainerState extends State<MusaImageVideoContainer> {
  List<FileElement> fileList = [];

  _CollageContainerState(List<FileElement> fileList) {
    this.fileList = fileList
        .where((file) => !Utilities.isAudioUrl(file.fileLink.toString()))
        .toList();
  }

  String getBestLink(FileElement file) => file.previewLink?.isNotEmpty == true
      ? file.previewLink!
      : file.fileLink ?? '';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double halfWidth = (maxWidth - 5) / 2; // accounts for 5-px spacer

        Widget imageView(String imageUrl,
            {required double imageHeight,
            required double imageWidth,
            FileElement? file}) {
          if (file != null &&
              file.previewLink?.isNotEmpty == true &&
              Utilities.isVideoUrl(file.previewLink!)) {
            return SizedBox(
              width: imageWidth,
              height: imageHeight,
              child: MusaWidgets.autoPlayVideoView(file.previewLink!),
            );
          }
          return SizedBox(
            width: imageWidth,
            height: imageHeight,
            child: MusaWidgets.getPhotoView(imageUrl),
          );
        }

        Widget getImage() {
          if (fileList.isEmpty) return const SizedBox();

          if (fileList.length == 1) {
            return imageView(getBestLink(fileList[0]),
                imageHeight: screenHeight * 0.25,
                imageWidth: maxWidth,
                file: fileList[0]);
          } else if (fileList.length == 2) {
            return Row(
              children: [
                Expanded(
                  child: imageView(getBestLink(fileList[0]),
                      imageHeight: screenHeight * 0.25,
                      imageWidth: double.infinity,
                      file: fileList[0]),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: imageView(getBestLink(fileList[1]),
                      imageHeight: screenHeight * 0.25,
                      imageWidth: double.infinity,
                      file: fileList[1]),
                ),
              ],
            );
          } else if (fileList.length == 3) {
            return Row(
              children: [
                Expanded(
                  child: imageView(getBestLink(fileList[0]),
                      imageHeight: screenHeight * 0.25,
                      imageWidth: double.infinity,
                      file: fileList[0]),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: imageView(getBestLink(fileList[1]),
                            imageHeight: double.infinity,
                            imageWidth: double.infinity,
                            file: fileList[1]),
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: imageView(getBestLink(fileList[2]),
                            imageHeight: double.infinity,
                            imageWidth: double.infinity,
                            file: fileList[2]),
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            // 4 or more
            return Row(
              children: [
                imageView(getBestLink(fileList[0]),
                    imageHeight: screenHeight * 0.25,
                    imageWidth: halfWidth,
                    file: fileList[0]),
                const SizedBox(width: 5),
                Column(
                  children: [
                    imageView(getBestLink(fileList[1]),
                        imageHeight: screenHeight * 0.125,
                        imageWidth: halfWidth,
                        file: fileList[1]),
                    const SizedBox(height: 5),
                    Stack(
                      children: [
                        imageView(getBestLink(fileList[2]),
                            imageHeight: screenHeight * 0.125,
                            imageWidth: halfWidth,
                            file: fileList[2]),
                        Container(
                          height: screenHeight * 0.125,
                          width: halfWidth,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(15.sp),
                          ),
                          child: Center(
                            child: Text(
                              "+${fileList.length - 3}",
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            );
          }
        }

        return Container(
          width: maxWidth,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: getImage(),
        );
      },
    );
  }
}
