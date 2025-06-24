import 'package:musa_app/Utility/musa_widgets.dart';

import '../../Repository/AppResponse/social_musa_list_response.dart';
import '../../Utility/packages.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    //Get image view
    Widget imageView(imageUrl, {imageHeight, imageWidth, FileElement? file}) {
      print("inside video view");
      print("previewLink22: ${file?.previewLink}");
      if (file != null &&
          file.previewLink?.isNotEmpty == true &&
          Utilities.isVideoUrl(file.previewLink!)) {
        print("inside video view22");
        return SizedBox(
          width: imageWidth,
          height: imageHeight,
          child: MusaWidgets.autoPlayVideoView(file.previewLink!),
        );
      }
      return SizedBox(
          width: imageWidth,
          height: imageHeight,
          // child: Utilities.isVideoUrl(imageUrl)
          //     ? MusaWidgets.thumbnailView(imageUrl)
          //     : MusaWidgets.getPhotoView(imageUrl));
          child: MusaWidgets.getPhotoView(imageUrl));
    }

    //Get image view as per length of images
    Widget getImage() {
      print("fileLink: ${fileList[0].fileLink}");
      print("previewLink: ${fileList[0].previewLink}");
      if (fileList.length == 1) {
        return imageView(
          getBestLink(fileList[0]),
          imageHeight: screenHeight * 0.25,
          //imageWidth: screenHeight * 0.5 - 100,
          imageWidth: screenHeight * 0.5 - 85,
          file: fileList[0],
        );
      } else if (fileList.length == 2) {
        return Row(
          children: [
            imageView(getBestLink(fileList[0]),
                imageHeight: screenHeight * 0.25,
                //imageWidth: screenWidth * 0.5 - 55),
                imageWidth: screenWidth * 0.5 - 25,
                file: fileList[0]),
            SizedBox(
              width: 5,
            ),
            imageView(getBestLink(fileList[1]),
                imageHeight: screenHeight * 0.25,
                //imageWidth: screenWidth * 0.5 - 55),
                imageWidth: screenWidth * 0.5 - 25,
                file: fileList[1]),
          ],
        );
      } else if (fileList.length == 3) {
        return Row(
          children: [
            imageView(getBestLink(fileList[0]),
                imageHeight: screenHeight * 0.25,
                //imageWidth: screenWidth * 0.5 - 55),
                imageWidth: screenWidth * 0.5 - 25,
                file: fileList[0]),
            SizedBox(
              width: 5,
            ),
            Column(
              children: [
                imageView(getBestLink(fileList[1]),
                    imageHeight: screenHeight * 0.125,
                    //imageWidth: screenWidth * 0.5 - 55),
                    imageWidth: screenWidth * 0.5 - 25,
                    file: fileList[1]),
                SizedBox(
                  height: 5,
                ),
                imageView(getBestLink(fileList[2]),
                    imageHeight: screenHeight * 0.125,
                    //imageWidth: screenWidth * 0.5 - 55),
                    imageWidth: screenWidth * 0.5 - 25,
                    file: fileList[2]),
              ],
            )
          ],
        );
      } else if (fileList.length > 3) {
        return Row(
          children: [
            imageView(getBestLink(fileList[0]),
                imageHeight: screenHeight * 0.25,
                //imageWidth: screenWidth * 0.5 - 55),
                imageWidth: screenWidth * 0.5 - 25,
                file: fileList[0]),
            SizedBox(
              width: 5,
            ),
            Column(
              children: [
                imageView(getBestLink(fileList[1]),
                    imageHeight: screenHeight * 0.125,
                    //imageWidth: screenWidth * 0.5 - 55),
                    imageWidth: screenWidth * 0.5 - 25,
                    file: fileList[1]),
                SizedBox(
                  height: 5,
                ),
                Stack(
                  children: [
                    imageView(getBestLink(fileList[2]),
                        imageHeight: screenHeight * 0.125,
                        //imageWidth: screenWidth * 0.5 - 55),
                        imageWidth: screenWidth * 0.5 - 25,
                        file: fileList[2]),
                    Container(
                      height: screenHeight * 0.125,
                      //width: screenWidth * 0.5 - 55,
                      width: screenWidth * 0.5 - 25,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15.sp),
                      ),
                      child: Center(
                        child: Text(
                          "+${fileList.length - 3}",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        );
      } else {
        return Container();
      }
    }

    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.symmetric(horizontal: 5, vertical: 8), // 5px left/right
      child: getImage(),
    );
  }
}
