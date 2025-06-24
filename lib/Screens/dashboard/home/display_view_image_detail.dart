import '../../../Repository/AppResponse/social_musa_list_response.dart';
import '../../../Resources/component/vidio_play_detail.dart';
import '../../../Utility/musa_widgets.dart';
import '../../../Utility/packages.dart';

abstract class DisplayViewImageDetail {
  static void showDetailDialog(
    BuildContext context, {
    required MusaData musaData,
    required musaImage,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        print(musaImage.toString());
        print(musaData.albumId.toString());

        return Dialog(
          backgroundColor: AppColor.bgGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Utilities.isVideoUrl(musaImage)
                    ? Container(
                        height: MediaQuery.of(context).size.height - 50,
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          color: AppColor.grey,
                        ),
                        child: VideoPlayDetailView(
                          url: musaImage,
                        ))
                    : Container(
                        height: MediaQuery.of(context).size.height - 50,
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          color: AppColor.bgGrey,
                          image: DecorationImage(
                            image: NetworkImage(musaImage),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                // Flexible(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Padding(
                //         padding: EdgeInsets.all(10.0),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Row(
                //               children: [
                //                 MusaWidgets.userProfileAvatar(
                //                   imageUrl: musaData.musaDetail.userDetail.photo
                //                           .toString() ??
                //                       "",
                //                   //Assets.dummyUserProfile1,
                //                   radius: 20.0,
                //                   borderWidth: 3.sp,
                //                 ),
                //                 Text(
                //                   musaData.musaDetail.userDetail.firstName
                //                           .toString() ??
                //                       "",
                //                   style: AppTextStyle.appBarTitleStyleBlack
                //                       .copyWith(fontSize: 12),
                //                 ),
                //               ],
                //             ),
                //             Text(
                //               musaData.title.toString() ?? "",
                //               style: AppTextStyle.normalBoldTextStyle,
                //             ),
                //             Row(
                //               crossAxisAlignment: CrossAxisAlignment.center,
                //               children: [
                //                 Text(
                //                   musaData.musaDetail.title.toString() ?? "",
                //                   style: AppTextStyle.appBarTitleStyleBlack
                //                       .copyWith(
                //                           color: AppColor.primaryColor,
                //                           fontSize: 13),
                //                 ),
                //                 Container(
                //                   margin: EdgeInsets.only(top: 5.sp),
                //                   child: Icon(Icons.circle,
                //                       color: AppColor.primaryColor,
                //                       size: 8.sp),
                //                 ),
                //                 // Text(
                //                 //   " Daughter Birthday",
                //                 //   style: AppTextStyle.normalTextStyle.copyWith(
                //                 //       color: AppColor.primaryColor,
                //                 //       fontSize: 12),
                //                 // ),
                //               ],
                //             ),
                //             Text(
                //               musaData.musaDetail.description.toString() ?? "",
                //               style: AppTextStyle.normalTextStyle
                //                   .copyWith(fontSize: 12),
                //             ),
                //           ],
                //         ),
                //       ),
                //       Flexible(
                //           child: CommentView(
                //             commentCountBtn: (valu){},
                //         musaId: musaData.musaDetail.albumId.toString(),
                //         keyboardType: false,
                //       )),
                //     ],
                //   ),
                // ),

                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  MusaWidgets.userProfileAvatar(
                                    imageUrl: musaData.userDetail?[0].photo
                                            .toString() ??
                                        "",
                                    radius: 20.0,
                                    borderWidth: 3.sp,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    '${musaData.userDetail?[0].firstName} ${musaData.userDetail?[0].lastName}'
                                            .toString() ??
                                        "",
                                    style: AppTextStyle.appBarTitleStyleBlack
                                        .copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                              // Text(
                              //   musaData.title.toString() ?? "",
                              //   style: AppTextStyle.normalBoldTextStyle,
                              // ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    musaData.albumDetail?[0].title ?? "",
                                    style: AppTextStyle.appBarTitleStyleBlack
                                        .copyWith(
                                      color: AppColor.primaryColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 5.sp, left: 5.sp, right: 5.sp),
                                    child: Icon(
                                      Icons.circle,
                                      color: AppColor.primaryColor,
                                      size: 8.sp,
                                    ),
                                  ),
                                  Text(musaData.subAlbumDetail![0].title ?? "",
                                      style: GoogleFonts.dmSans(
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                      )),
                                ],
                              ),
                              Text(
                                musaData.description ?? "",
                                style: AppTextStyle.normalTextStyle1
                                    .copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   height:300,
                        //   color: Colors.red,
                        //   child: CommentView(
                        //     musaData:musaData,
                        //     commentCountBtn: (valu) {},
                        //     musaId: musaData.id.toString(),
                        //     //keyboardType: false,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.cancel_outlined,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
