// import 'package:musa_app/Cubit/dashboard/home_dashboard_cubit/home_state.dart';
// import 'package:musa_app/Resources/CommonWidgets/comment_view.dart';
// import 'package:musa_app/Utility/musa_widgets.dart';
// import '../../../Cubit/dashboard/home_dashboard_cubit/home_cubit.dart';
// import '../../../Utility/packages.dart';
// import 'display_feed_widgets.dart';
//
// class HomeSocialMusaList extends StatefulWidget {
//   final ScrollController scrollController;
//   final ValueNotifier<bool> isMainScrolling;
//
//   const HomeSocialMusaList({
//     super.key,
//     required this.scrollController,
//     required this.isMainScrolling,
//   });
//
//   @override
//   State<HomeSocialMusaList> createState() => _HomeSocialMusaListState();
// }
//
// class _HomeSocialMusaListState extends State<HomeSocialMusaList> {
//   late HomeCubit homeCubit;
//   late ScrollController _innerScrollController;
//   bool _isLoadingMore = false;
//
//   @override
//   void initState() {
//     super.initState();
//     homeCubit = HomeCubit();
//     homeCubit.homePageNumber = 1;
//     homeCubit.getSocialFeeds(page: homeCubit.homePageNumber);
//
//     _innerScrollController = ScrollController();
//     _innerScrollController.addListener(_innerScrollListener);
//   }
//
//   @override
//   void dispose() {
//     _innerScrollController.dispose();
//     super.dispose();
//   }
//
//   void _innerScrollListener() {
//     if (_innerScrollController.position.pixels == 0) {
//       widget.isMainScrolling.value = true; // Main scroll resumes
//     }
//
//     if (_innerScrollController.position.pixels >= _innerScrollController.position.maxScrollExtent &&
//         !_isLoadingMore &&
//         !homeCubit.noDataNextPage) {
//       _loadMoreItems();
//     }
//   }
//
//   Future<void> _loadMoreItems() async {
//     setState(() => _isLoadingMore = true);
//     await homeCubit.getSocialFeeds(page: homeCubit.homePageNumber);
//     setState(() => _isLoadingMore = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<bool>(
//       valueListenable: widget.isMainScrolling,
//       builder: (context, isMainScrollActive, child) {
//         return BlocConsumer<HomeCubit, HomeSocialState>(
//           bloc: homeCubit,
//           listener: (context, state) {},
//           builder: (context, state) {
//             return ListView.builder(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               // physics: isMainScrollActive
//               //     ? NeverScrollableScrollPhysics()
//               //     : ClampingScrollPhysics(), // Prevent bounce effect
//               controller: isMainScrollActive ? null : _innerScrollController,
//               itemCount: homeCubit.socialMusaList.length + 1,
//               itemBuilder: (context, index) {
//                 if (index == homeCubit.socialMusaList.length) {
//                   if (_isLoadingMore) {
//                     return Center(
//                       child: Padding(
//                         padding: EdgeInsets.all(10),
//                         child: CircularProgressIndicator(color: AppColor.primaryColor),
//                       ),
//                     );
//                   } else if (homeCubit.noDataNextPage) {
//                     return Center(child: Padding(padding: EdgeInsets.all(8), child: Text("No more data")));
//                   }
//                   return Container();
//                 }
//
//                 return CommonSubWidgets(
//                   isMyMUSA: false,
//                   isContributed: false,
//                   isHomeMUSA: true,
//                   musaData: homeCubit.socialMusaList[index],
//                   commentBtn: () {},
//                   deleteBtn: () {}, commentCount: 1,
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }
