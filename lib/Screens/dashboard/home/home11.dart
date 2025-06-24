// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:musa_app/Cubit/dashboard/home_dashboard_cubit/home_cubit.dart';
// import 'package:musa_app/Utility/packages.dart';
// import '../../../Utility/musa_widgets.dart';
// import '../../profile/my_profile.dart';
// import 'home_myfeed_carousel.dart';
// import 'home_socia_musa_list.dart';
//
// class Home extends StatefulWidget {
//   const Home({super.key});
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   HomeCubit homeCubit = HomeCubit();
//   late ScrollController _mainScrollController;
//   ValueNotifier<bool> isMainScrolling = ValueNotifier(true); // Control scrolling
//
//   @override
//   void initState() {
//     super.initState();
//     homeCubit.setUserData();
//     _mainScrollController = ScrollController();
//     _mainScrollController.addListener(_scrollListener);
//   }
//
//   void _scrollListener() {
//     if (_mainScrollController.position.pixels <= 0) {
//       isMainScrolling.value = true; // Main scroll is at the top
//     } else if (_mainScrollController.position.pixels >= _mainScrollController.position.maxScrollExtent) {
//       isMainScrolling.value = false; // Main scroll collapsed, allow inner scroll
//     }
//   }
//
//   Future<void> onRefresh() async {
//     homeCubit.homePageNumber = 1;
//     homeCubit.getMyFeeds(userId: homeCubit.myUserId.toString(), page: 1);
//     homeCubit.getSocialFeeds(page: 1);
//   }
//
//   @override
//   void dispose() {
//     _mainScrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: RefreshIndicator(
//         onRefresh: onRefresh,
//         child: NestedScrollView(
//           controller: _mainScrollController,
//           headerSliverBuilder: (context, innerBoxIsScrolled) => [
//             SliverAppBar(
//               pinned: true,
//               expandedHeight: Platform.isIOS
//                   ? MediaQuery.of(context).size.height * 0.43
//                   : MediaQuery.of(context).size.height * 0.45,
//               flexibleSpace: FlexibleSpaceBar(
//                 background: _headerWidget(),
//               ),
//               collapsedHeight: kToolbarHeight,
//             ),
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           StringConst.socialText,
//                           style: AppTextStyle.mediumTextStyle(color: AppColor.black, size: 18),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             if (bottomNavBarKey.currentState != null) {
//                               bottomNavBarKey.currentState!.onItemTapped(2);
//                             }
//                           },
//                           child: Text(
//                             StringConst.viewAll,
//                             style: AppTextStyle.normalTextStyle(
//                               color: AppColor.primaryColor,
//                               size: 12,
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//           body: HomeSocialMusaList(
//             scrollController: _mainScrollController,
//             isMainScrolling: isMainScrolling,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _headerWidget() {
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         SizedBox(
//           height: 200,
//           child: AppBarMusa2(
//             leading: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => MyProfile(userId: homeCubit.myUserId),
//                   ),
//                 );
//               },
//               child: MusaWidgets.userProfileAvatar(
//                 imageUrl: homeCubit.userProfilePicture,
//                 radius: 30.sp,
//                 borderWidth: 3.sp,
//               ),
//             ),
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   StringConst.helloText,
//                   style: AppTextStyle.mediumTextStyle(color: AppColor.black, size: 18),
//                 ),
//                 Text(
//                   homeCubit.userName ?? '',
//                   style: AppTextStyle.normalTextStyle(color: AppColor.black, size: 14),
//                 ),
//               ],
//             ),
//             end: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     context.push(RouteTo.dashboardSearch, extra: homeCubit.myFeedsList);
//                   },
//                   child: SvgPicture.asset(Assets.searchIcon),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     context.push(RouteTo.notificationView);
//                   },
//                   child: Icon(Icons.notifications, size: 30),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         HomeMyFeedCarousel(homeCubit: homeCubit),
//       ],
//     );
//   }
// }


// return Scaffold(
// body: RefreshIndicator(
// onRefresh: onRefresh,
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// _headerWidget(),
// // Social Text Section
// SizedBox(height: 20),
// Padding(
// padding: const EdgeInsets.symmetric(horizontal: 24.0),
// child: Column(
// children: [
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text(
// StringConst.socialText,
// style: AppTextStyle.mediumTextStyle(
// color: AppColor.black, size: 18),
// ),
// InkWell(
// onTap: (){
// if (bottomNavBarKey.currentState != null) {
// bottomNavBarKey.currentState!.onItemTapped(2);
// }
// },
// child: Text(
// StringConst.viewAll,
// style: AppTextStyle.normalTextStyle(
// color: AppColor.primaryColor,
// size: 12,
// decoration: TextDecoration.underline,
// ),
// ),
// ),
// ],
// ),
// ],
// ),
// ),
// Expanded(child: HomeSocialMusaList())
// ],
// ),
// ),
// );
// }
//
// Widget _headerWidget() {
// return SizedBox(
// height: (Platform.isIOS)
// ? MediaQuery.of(context).size.height * 0.43
//     : MediaQuery.of(context).size.height * 0.45,
// child: Stack(
// clipBehavior: Clip.none,
// children: [
// // AppBar Section
// SizedBox(
// height: 200,
// child: AppBarMusa2(
// leading: GestureDetector(
// onTap: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => MyProfile(
// userId: homeCubit.myUserId,
// ),
// ),
// );
// },
// child: MusaWidgets.userProfileAvatar(
// imageUrl: homeCubit.userProfilePicture,
// radius: 30.sp,
// borderWidth: 3.sp,
// ),
// ),
// title: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Text(
// StringConst.helloText,
// style: AppTextStyle.mediumTextStyle(
// color: AppColor.black, size: 18),
// ),
// Text(
// homeCubit.userName ?? '',
// style: AppTextStyle.normalTextStyle(
// color: AppColor.black, size: 14),
// ),
// ],
// ),
// end: Row(
// children: [
// GestureDetector(
// onTap: () {
// context.push(RouteTo.dashboardSearch,
// extra: homeCubit.myFeedsList);
// }, child: SvgPicture.asset(Assets.searchIcon)),
// SizedBox(width: 10),
// GestureDetector(
// onTap: () {
// context
//     .push(RouteTo.notificationView);
// }, child: Icon(Icons.notifications, size: 30)),
// ],
// ),
// ),
// ),
// HomeMyFeedCarousel(homeCubit: homeCubit),
// ],
// ),
// );