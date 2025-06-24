import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musa_app/Utility/packages.dart';

import '../../Cubit/dashboard/carousel_cubit.dart';
import '../../Repository/AppResponse/social_musa_list_response.dart';
import '../../Screens/dashboard/home/musa_post_detail_view.dart';
import '../../Utility/musa_widgets.dart';

class CarouselSliderWidget extends StatefulWidget {
  final List<MusaData>? musaList;

  const CarouselSliderWidget({super.key, this.musaList});
  @override
  State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  List<MusaData>? musaList;
  List<MusaData>? tempMusaList = [];

  @override
  // void initState() {
  //   musaList = widget.musaList;
  //   addMusaInTemp();
  //   super.initState();
  // }

  // void addMusaInTemp() {
  //   for (int index = 0; index < musaList!.length; index++) {
  //     if (musaList![index].file != null && musaList![index].file!.isNotEmpty) {
  //       tempMusaList?.add(musaList![index]);
  //     }
  //   }
  // }

  void initState() {
    super.initState();
    musaList = widget.musaList;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      addMusaInTemp();
      setState(() {}); // Trigger rebuild only after build completes
    });
  }

  void addMusaInTemp() {
    tempMusaList = musaList
        ?.where((item) => item.file != null && item.file!.isNotEmpty)
        .toList();
  }

  String getBestLink(FileElement file) => file.previewLink?.isNotEmpty == true
      ? file.previewLink!
      : file.fileLink ?? '';

  @override
  Widget build(BuildContext context) {
    if (tempMusaList == null || tempMusaList!.isEmpty) {
      return const SizedBox.shrink(); // No widget, no space
    }
    return BlocProvider(
      create: (_) => CarouselCubit(),
      child: SizedBox(
        height: 250.sp,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (tempMusaList!.isNotEmpty)
              BlocBuilder<CarouselCubit, List<String>>(
                builder: (context, imageList) {
                  final uniqueMusaList = tempMusaList!
                      .where(
                          (item) => item.file != null && item.file!.isNotEmpty)
                      .toSet()
                      .toList();
                  return CarouselSlider.builder(
                    itemCount: uniqueMusaList.length,
                    itemBuilder: (context, index, realIndex) {
                      final item = uniqueMusaList[index];

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MusaPostDetailView(
                                musaData: item,
                                flowType: '',
                                isMyMusa: true,
                                likeUpdateCallBack: (likeByMe, likeCount) {},
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: 164.w,
                          height: 185.h,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Utilities.isVideoUrl(item.file![0]
                                                    .previewLink?.isNotEmpty ==
                                                true
                                            ? item.file![0].previewLink!
                                            : item.file![0].fileLink ?? '')
                                        ? MusaWidgets.autoPlayVideoView(
                                            item.file![0].previewLink
                                                        ?.isNotEmpty ==
                                                    true
                                                ? item.file![0].previewLink!
                                                : item.file![0].fileLink ?? '',
                                            width: double.infinity,
                                            height: double.infinity,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl:
                                                item.file![0].fileLink ?? '',
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Center(
                                              child: CircularProgressIndicator(
                                                  color: Colors.white),
                                            ),
                                            errorWidget:
                                                (context, url, error) => Center(
                                              child: Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.grey,
                                                  size: 50),
                                            ),
                                          ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 50.h,
                                      width: 250.w,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.2),
                                            Colors.black.withOpacity(0.9),
                                          ],
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 5.sp, bottom: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.title ?? '',
                                              style: AppTextStyle
                                                  .normalBoldTextStyle
                                                  .copyWith(
                                                color: AppColor.white,
                                                fontSize: 10.sp,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // (item.albumDetail != null &&
                                                //         item.albumDetail!
                                                //             .isNotEmpty)
                                                //     ? SizedBox(
                                                //         //width: 50.w,
                                                //         child: Text(
                                                //           item.albumDetail?[0]
                                                //                   .title ??
                                                //               '',
                                                //           style: AppTextStyle
                                                //               .normalTextStyle1
                                                //               .copyWith(
                                                //             color:
                                                //                 AppColor.white,
                                                //             fontSize: 10,
                                                //           ),
                                                //           maxLines: 1,
                                                //           overflow: TextOverflow
                                                //               .ellipsis,
                                                //         ),
                                                //       )
                                                //     : SizedBox.shrink(),

                                                if (item.albumDetail != null &&
                                                    item.albumDetail!
                                                        .isNotEmpty)
                                                  Flexible(
                                                    child: Text(
                                                      item.albumDetail?[0]
                                                              .title ??
                                                          '',
                                                      style: AppTextStyle
                                                          .normalTextStyle1
                                                          .copyWith(
                                                        color: AppColor.white,
                                                        fontSize: 10,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),

                                                // Container(
                                                //   margin: EdgeInsets.only(
                                                //       top: 3.sp),
                                                //   child: Icon(Icons.circle,
                                                //       color: AppColor.white,
                                                //       size: 10.sp),
                                                // ),
                                                (item.subAlbumDetail != null &&
                                                        item.subAlbumDetail!
                                                            .isNotEmpty)
                                                    ? Container(
                                                        margin: EdgeInsets.only(
                                                            top: 2.sp,
                                                            left: 1.sp,
                                                            right: 1.sp),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              '/',
                                                              style: TextStyle(
                                                                fontSize: 12.sp,
                                                                color: AppColor
                                                                    .grey,
                                                                height: 1.2,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                width: 2.w),
                                                            Text(
                                                              item.subAlbumDetail?[0]
                                                                      .title ??
                                                                  '',
                                                              style: AppTextStyle
                                                                  .normalTextStyle1
                                                                  .copyWith(
                                                                color: AppColor
                                                                    .white,
                                                                fontSize: 10,
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : SizedBox.shrink(),
                                              ],
                                            ),
                                            SizedBox(height: 5.h),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 210.sp,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: false,
                      viewportFraction: tempMusaList!.length <= 2 ? 0.8 : 0.45,
                      padEnds: false,
                      autoPlay: false,
                      onPageChanged: (index, reason) {},
                    ),
                  );
                },
              )
            else
              SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
