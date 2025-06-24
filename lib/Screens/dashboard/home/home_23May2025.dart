import 'dart:io';
import 'package:musa_app/Cubit/dashboard/home_dashboard_cubit/home_cubit.dart';
import 'package:musa_app/Utility/packages.dart';
import '../../../Utility/musa_widgets.dart';
import '../../profile/my_profile.dart';
import 'home_myfeed_carousel.dart';
import 'home_socia_musa_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeCubit homeCubit = HomeCubit();
  late ScrollController _mainScrollController;
  ValueNotifier<bool> isMainScrolling =
      ValueNotifier(true); // Control scrolling

  @override
  void initState() {
    super.initState();
    homeCubit.setUserData();
    homeCubit.getMyFeeds(userId: homeCubit.myUserId.toString(), page: 1);
    // homeCubit.getSocialFeeds(page: 1);
    _mainScrollController = ScrollController();
    _mainScrollController.addListener(_scrollListener);
  }

  @override
  void didUpdateWidget(covariant Home oldWidget) {
    // TODO: implement didUpdateWidget
    homeCubit.setUserData();
    super.didUpdateWidget(oldWidget);
  }

  void _scrollListener() {
    if (_mainScrollController.position.pixels <= 0) {
      isMainScrolling.value = true; // Main scroll is at the top
    } else if (_mainScrollController.position.pixels >=
        _mainScrollController.position.maxScrollExtent) {
      isMainScrolling.value = false;
    }
  }

  Future<void> onRefresh() async {
    homeCubit.homePageNumber = 1;
    homeCubit.getMyFeeds(userId: homeCubit.myUserId.toString(), page: 1);
    homeCubit.getSocialFeeds(page: 1);
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: NestedScrollView(
          controller: _mainScrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: Platform.isIOS
                  ? MediaQuery.of(context).size.height * 0.43
                  : MediaQuery.of(context).size.height * 0.45,
              pinned: true, // Keeps bottom part visible on collapse
              backgroundColor: Colors.white,
              collapsedHeight: kToolbarHeight,
              centerTitle: true,

              title: ValueListenableBuilder<bool>(
                valueListenable: isMainScrolling,
                builder: (context, isScrolling, child) {
                  return AnimatedOpacity(
                    opacity: isScrolling ? 0.0 : 1.0,
                    duration: Duration(milliseconds: 300),
                    child: Text(
                      homeCubit.userName ?? '',
                      style: AppTextStyle.normalTextStyle(
                          color: AppColor.black, size: 14),
                    ),
                  );
                },
              ),

              leading: ValueListenableBuilder<bool>(
                valueListenable: isMainScrolling,
                builder: (context, isScrolling, child) {
                  return AnimatedOpacity(
                    opacity: isScrolling ? 0.0 : 1.0,
                    duration: Duration(milliseconds: 300),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyProfile(
                              userId: homeCubit.myUserId,
                            ),
                          ),
                        ).then((snj) {
                          homeCubit.setUserData();
                          setState(() {});
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 10, bottom: 10),
                        child: MusaWidgets.userProfileAvatar(
                          imageUrl: homeCubit.userProfilePicture,
                          radius: 15,
                          borderWidth: 2,
                        ),
                      ),
                    ),
                  );
                },
              ),

              actions: [
                ValueListenableBuilder<bool>(
                  valueListenable: isMainScrolling,
                  builder: (context, isScrolling, child) {
                    return AnimatedOpacity(
                      opacity: isScrolling ? 0.0 : 1.0,
                      duration: Duration(milliseconds: 300),
                      child: Row(
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(Assets.searchIcon),
                            onPressed: () {
                              context.push(RouteTo.dashboardSearch,
                                  extra: homeCubit.myFeedsList);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.notifications, size: 30),
                            onPressed: () {
                              context.push(RouteTo.notificationView);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],

              flexibleSpace: ValueListenableBuilder<bool>(
                valueListenable: isMainScrolling,
                builder: (context, isScrolling, child) {
                  return isMainScrolling.value
                      ? FlexibleSpaceBar(
                          background: _headerWidget(),
                        )
                      : Container(
                          //height: kToolbarHeight,
                          decoration: BoxDecoration(
                          gradient: AppColor.appBarGradientDashboard(),
                        ));
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    // InkWell(
                    //   onTap: (){
                    //     FirebaseCrashlytics.instance.crash();
                    //   },
                    //   child: Text(
                    //     'hit crash',
                    //     style: AppTextStyle.mediumTextStyle(
                    //         color: AppColor.black, size: 18),
                    //   ),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          StringConst.socialText,
                          style: AppTextStyle.mediumTextStyle(
                              color: AppColor.black, size: 18),
                        ),
                        InkWell(
                          onTap: () {
                            if (bottomNavBarKey.currentState != null) {
                              bottomNavBarKey.currentState!.onItemTapped(2);
                            }
                          },
                          child: Text(
                            StringConst.viewAll,
                            style: AppTextStyle.normalTextStyle(
                              color: AppColor.primaryColor,
                              size: 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: HomeSocialMusaList(
            scrollController: _mainScrollController,
            isMainScrolling: isMainScrolling,
            homeCubit: homeCubit,
          ),
        ),
      ),
    );
  }

  Widget _headerWidget() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          child: AppBarDashboard(
            leading: const SizedBox.shrink(),
            // leading: GestureDetector(
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => MyProfile(userId: homeCubit.myUserId),
            //       ),
            //     ).then((snj) {
            //       homeCubit.setUserData();
            //       setState(() {});
            //     });
            //   },
            //   child: MusaWidgets.userProfileAvatar(
            //     imageUrl: homeCubit.userProfilePicture,
            //     radius: 30.sp,
            //     borderWidth: 3.sp,
            //   ),
            // ),
            // title: Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       'MUSA',
            //       style: AppTextStyle.mediumTextStyle(
            //           color: AppColor.black, size: 18),
            //     ),
            //     Text(
            //       homeCubit.userName ?? '',
            //       style: AppTextStyle.normalTextStyle(
            //           color: AppColor.black, size: 14),
            //     ),
            //   ],
            // ),
            title: Text(
              'MUSA',
              style: const TextStyle(
                color: Color(0xFF222222),
                fontFamily: 'Manrope',
                fontSize: 24,
                fontWeight: FontWeight.w800,
                height: 42 / 24,
                letterSpacing: -0.5,
              ),
            ),
            // end: Row(
            //   children: [
            //     GestureDetector(
            //       onTap: () {
            //         context.push(RouteTo.dashboardSearch);
            //       },
            //       child: SvgPicture.asset(Assets.searchIcon),
            //     ),
            //     SizedBox(width: 10),
            //     GestureDetector(
            //       onTap: () {
            //         context.push(RouteTo.notificationView);
            //       },
            //       child: Icon(Icons.notifications, size: 30),
            //     ),
            //   ],
            // ),
            end: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.all(8), // Ensures a decent hit area
                  iconSize: 24,
                  icon: SvgPicture.asset(
                    Assets.searchIcon_1,
                    width: 24,
                    height: 24,
                  ),
                  onPressed: () {
                    context.push(RouteTo.dashboardSearch);
                  },
                ),
                IconButton(
                  padding: EdgeInsets.all(8), // Ensures a decent hit area
                  iconSize: 24,
                  icon: SvgPicture.asset(
                    Assets.settings,
                    width: 24,
                    height: 24,
                  ),
                  onPressed: () {
                    context.push(RouteTo.settings);
                  },
                ),
                IconButton(
                  padding: EdgeInsets.all(8), // Ensures a decent hit area
                  iconSize: 24,
                  icon: SvgPicture.asset(
                    Assets.notification,
                    width: 24,
                    height: 24,
                  ),
                  onPressed: () {
                    context.push(RouteTo.notificationView);
                  },
                ),
              ],
            ),
          ),
        ),
        HomeMyFeedCarousel(homeCubit: homeCubit),
        // IgnorePointer(
        //   ignoring: true, // or conditional
        //   child: HomeMyFeedCarousel(homeCubit: homeCubit),
        // ),
      ],
    );
  }
}
