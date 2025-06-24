// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:musa/imports/resources_import.dart';
// import 'package:musa/resources/musa_widgets.dart';
//
// import '../../cubit/dashboard_cubit/carousel_cubit.dart';
// import '../../repository/response_modals/musa_detail_model.dart';
// import '../../repository/response_modals/musa_list_modal.dart';
// import '../../resources/routes.dart';
// import '../../resources/style_sheets.dart';
//
// class CarouselSliderWidget extends StatefulWidget {
//   final List<MusaData>? musaList;
//
//   const CarouselSliderWidget({super.key, this.musaList});
//   @override
//   State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();
// }
//
// class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
//   List<MusaData>? musaList;
//   List<MusaData>? tempMusaList = [];
//
//   @override
//   void initState() {
//     musaList = widget.musaList;
//     addMusaInTemp();
//     super.initState();
//   }
//
//   addMusaInTemp() {
//    for(int index = 0; index<musaList!.length; index++){
//      if (musaList![index].file != null && musaList![index].file!.isNotEmpty) {
//        tempMusaList?.add(musaList![index]);
//      }
//    }
// }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => CarouselCubit(),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           tempMusaList!.isNotEmpty?BlocBuilder<CarouselCubit, List<String>>(
//             builder: (context, imageList) {
//               return CarouselSlider.builder(
//                 itemCount: tempMusaList!.length,
//                 itemBuilder: (context, index, realIndex) {
//                   if(tempMusaList!= null && tempMusaList!.length>0 && tempMusaList![index].file!= null && tempMusaList![index].file!.isNotEmpty){
//                     return InkWell(
//                       onTap: (){
//                         // MusaDetailModel musaDetail = MusaWidgets.getMusaDetailObject(
//                         //     musaData: tempMusaList![index], isFavorite: true);
//                         // context.push(
//                         //     RouteTo.musaPostDetail
//                         //         .replaceFirst(':flowType', "HOME"),
//                         //     extra: musaDetail);
//
//                         context.push(RouteTo.musaPostDetail.replaceFirst(':flowType', "HOME"), extra: tempMusaList![index] );
//                       },
//                       child: Container(
//                         margin: EdgeInsets.symmetric(horizontal: 10.w),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(
//                             color: Colors.white,
//                             width: 2,
//                           ),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: Stack(
//                             children: [
//                               Positioned.fill(
//                                 child: MusaFunctions.isVideoUrl(tempMusaList![index].file![0].fileLink??'')?
//                                MusaWidgets.thumbnailView(tempMusaList![index].file![0].fileLink):Image.network(
//                                   tempMusaList![index].file![0].fileLink??'',
//                                   fit: BoxFit.cover,
//                                   loadingBuilder: (context, child, loadingProgress) {
//                                     if (loadingProgress == null) {
//                                       return child;
//                                     } else {
//                                       return Center(
//                                         child: CircularProgressIndicator(
//                                           value:
//                                           loadingProgress.expectedTotalBytes !=
//                                               null
//                                               ? loadingProgress
//                                               .cumulativeBytesLoaded /
//                                               (loadingProgress
//                                                   .expectedTotalBytes ??
//                                                   1)
//                                               : null,
//                                         ),
//                                       );
//                                     }
//                                   },
//                                 ),
//                               ),
//                               Align(
//                                 alignment: Alignment.bottomCenter,
//                                 child: Container(
//
//                                   height: 70.h,
//                                   width: 250.w,
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.bottomCenter,
//                                       colors: [
//                                         Colors.black.withOpacity(0.2),
//                                         Colors.black.withOpacity(0.9),
//                                       ],
//                                     ),
//                                     // Optional: Rounded corners
//                                   ),
//                                   child: Padding(
//                                     padding: EdgeInsets.only(left: 5.sp, bottom: 5),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           tempMusaList![index].title??'',
//                                           style: MusaTextStyle.normalBoldTextStyle
//                                               .copyWith(
//                                             color: MusaColoStyles.white,
//                                             fontSize: 10.sp,
//                                           ),
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         Row(
//                                           children: [
//                                             (tempMusaList![index].albumDetail!= null && tempMusaList![index].albumDetail!.isNotEmpty )?
//
//                                             SizedBox(
//                                               width: 50.w,
//                                               child: Text(
//                                                 tempMusaList![index].albumDetail?[0]!.title ?? '',
//                                                 style: MusaTextStyle.normalTextStyle
//                                                     .copyWith(
//                                                     color: MusaColoStyles.white,
//                                                     fontSize: 10),
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                             ):Container(),
//                                             Container(
//                                               margin: EdgeInsets.only(top: 3.sp),
//                                               child: Icon(Icons.circle,
//                                                   color: MusaColoStyles.white,
//                                                   size: 10.sp),
//                                             ),
//                                             (tempMusaList![index].subAlbumDetail != null && tempMusaList![index].subAlbumDetail!.isNotEmpty )?
//                                             SizedBox(
//                                               width: 60.w,
//                                               child: Text(
//                                                 tempMusaList![index].subAlbumDetail?[0]!.title ?? '',
//                                                 style: MusaTextStyle.normalTextStyle
//                                                     .copyWith(
//                                                     color: MusaColoStyles.white,
//                                                     fontSize: 10),
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                             ):Container(),
//                                           ],
//                                         ),
//                                         SizedBox(height: 5.h),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   }
//                   return Container();
//                 },
//                 options: CarouselOptions(
//                   height: 210.sp,
//                   initialPage: 0,
//                   onPageChanged: (index, reason) {},
//                   enableInfiniteScroll: true,
//                   enlargeCenterPage: true,
//                   viewportFraction: 0.6,
//                   autoPlay: true,
//                 ),
//               );
//             },
//           ):Container(),
//         ],
//       ),
//     );
//   }
// }
