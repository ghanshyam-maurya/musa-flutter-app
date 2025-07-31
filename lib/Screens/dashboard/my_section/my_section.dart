import 'package:musa_app/Cubit/dashboard/my_section_cubit/my_section_state.dart';
import 'package:musa_app/Screens/components/notification_icon_button.dart';
import 'package:musa_app/Screens/dashboard/home/home_search_view.dart';
import 'package:musa_app/Screens/dashboard/my_section/my_library/my_media_list_view.dart';
import 'package:musa_app/Cubit/dashboard/my_section_cubit/my_section_cubit.dart';
import 'package:musa_app/Cubit/auth/Login/login_cubit.dart';
import 'package:musa_app/Screens/dashboard/my_section/my_library/media_library_detail_view.dart';
import 'package:musa_app/Utility/packages.dart';

class MyScreen extends StatefulWidget {
  final int? pageIndex;
  final bool? musa;
  const MyScreen({super.key, this.pageIndex, this.musa});

  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  MySectionCubit mySectionCubit = MySectionCubit();
  LoginCubit loginCubit = LoginCubit();
  bool isSearching = false;
  bool isUploading = false;
  bool _isSearchActive = false;
  late final List<Map<String, dynamic>> buttons;

  @override
  void initState() {
    // buttons = [
    //   {
    //     'label': StringConst.mediaText,
    //     'icon': Assets.media,
    //     'onTap': () => Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => MediaLibraryDetailView(
    //                 mySectionCubit: mySectionCubit, musa: isUploading),
    //           ),
    //         ),
    //     // 'onTap': () => MyAlbums(mySectionCubit: mySectionCubit),
    //   },
    //   {
    //     'label': StringConst.toggleMusa,
    //     'icon': Assets.myMusa,
    //     'onTap': () => mySectionCubit.changeTab(1),
    //   },
    //   {
    //     'label': StringConst.displayMusa,
    //     'icon': Assets.displayMusa,
    //     'onTap': () => print("Videos tapped"),
    //   },
    //   {
    //     'label': StringConst.contributors,
    //     'icon': Assets.contributors,
    //     'onTap': () => print("Videos tapped"),
    //   },
    //   {
    //     'label': StringConst.profileTitleText,
    //     'icon': Assets.profile,
    //     'onTap': () => print("Videos tapped"),
    //   },
    //   {
    //     'label': StringConst.settingsText,
    //     'icon': Assets.settingsGreen,
    //     'onTap': () => context.push(RouteTo.settings),
    //   },
    // ];
    mySectionCubit.getAlbumList();
    if ((bottomNavBarKey.currentState != null && bottomNavBarKey.currentState!.pageIndex == 1) 
        || widget.pageIndex == 1) {
      mySectionCubit.changeTab(1);
    }
    if (widget.musa == true) {
      isUploading = true;
    }
    super.initState();
  }

  openMediaLibrary(MySectionCubit mySectionCubit) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MediaLibraryDetailView(
            mySectionCubit: mySectionCubit, musa: isUploading),
      ),
    );
    setState(() {});
  }

  Future<void> onRefresh() async {
    await mySectionCubit.getAlbumList();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        // _searchController.clear();
        // homeCubit.getSearchMusaList("", 0); // Clear search results
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AppBar Section
          SizedBox(
            height: 140,
            child: Stack(
              children: [
                AppBarDashboard(
                  leading: const SizedBox.shrink(),
                  title: Text(
                    'My',
                    style: const TextStyle(
                      color: Color(0xFF222222),
                      fontFamily: 'Manrope',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 42 / 24,
                      letterSpacing: -0.5,
                    ),
                  ),
                  end: Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.all(8),
                        iconSize: 24,
                        icon: SvgPicture.asset(
                          Assets.searchIcon_1,
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DashboardSearch(title: "My"),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        padding: EdgeInsets.all(8),
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
                      NotificationIconButton(
                        iconSize: 24,
                        onPressed: () {
                          context.push(RouteTo.notificationView);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: SingleChildScrollView(
                  child: BlocBuilder<MySectionCubit, MySectionState>(
                bloc: mySectionCubit,
                builder: (context, state) {
                  // return Column(
                  //   children: [
                  //     SizedBox(
                  //       height: 30,
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 20),
                  //       child: _buildSocialButton(
                  //         onTap: () {
                  //           MyAlbums(mySectionCubit: mySectionCubit);
                  //           // MyLibrariesView(
                  //           //     mySectionCubit: mySectionCubit,
                  //           //     musa: isUploading);
                  //         },
                  //         icon: Assets.media,
                  //         label: StringConst.mediaText,
                  //         height: 25,
                  //         width: 25,
                  //       ),
                  //     ),

                  //     // mySectionCubit.selectedTab == 0
                  //     //     ? MyAlbums(mySectionCubit: mySectionCubit)
                  //     //     : MyLibrariesView(
                  //     //         mySectionCubit: mySectionCubit, musa: isUploading)
                  //   ],
                  // );
                  return Column(
                    children: buildButtonList(),
                  );
                },
              )),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build Segmented Buttons
  Widget _buildSegment(String text, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          mySectionCubit.changeTab(index);
        },
        child: BlocBuilder<MySectionCubit, MySectionState>(
          bloc: mySectionCubit,
          builder: (context, state) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                gradient: mySectionCubit.selectedTab == index
                    ? AppColor.toggleGradient()
                    : null,
                borderRadius: mySectionCubit.selectedTab == 0
                    ? BorderRadius.only(
                        topLeft: Radius.circular(30.sp),
                        bottomLeft: Radius.circular(30.sp),
                      )
                    : BorderRadius.only(
                        topRight: Radius.circular(30.sp),
                        bottomRight: Radius.circular(30.sp),
                      ),
              ),
              child: Center(
                child: Text(
                  text,
                  style: mySectionCubit.selectedTab == index
                      ? AppTextStyle.normalBoldTextStyle.copyWith(
                          fontSize: 14.sp, fontWeight: FontWeight.w600)
                      : AppTextStyle.normalTextStyle(
                          color: AppColor.primaryTextColor, size: 14.sp),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> buildButtonList() {
    final List<Map<String, dynamic>> buttons = [
      {
        'label': StringConst.mediaText,
        'icon': Assets.media,
        'onTap': () =>
            // Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => MediaLibraryDetailView(
            //           mySectionCubit: mySectionCubit,
            //           musa: isUploading,
            //         ),
            //       ),
            //     ),
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => MyMediaListView(
            //       mySectionCubit: mySectionCubit,
            //       musa: isUploading,
            //     ),
            //   ),
            // ),
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BottomNavBar(
                  passIndex: 1, // Optional
                  customPage: MyMediaListView(
                    mySectionCubit: mySectionCubit,
                    musa: true,
                  ),
                ),
              ),
            ),
      },
      {
        'label': StringConst.toggleMusa,
        'icon': Assets.myMusa,
        'onTap': () => context.push(RouteTo.myMusaCollection),
      },
      {
        'label': StringConst.displayMusa,
        'icon': Assets.displayMusa,
        'onTap': () => context.push(RouteTo.displayMusa),
      },
      {
        'label': StringConst.contributors,
        'icon': Assets.contributors,
        'onTap': () => context.push(RouteTo.myMusaContributorList),
      },
      {
        'label': StringConst.profileTitleText,
        'icon': Assets.profile,
        'onTap': () => context.push(RouteTo.editProfile),
      },
      {
        'label': StringConst.settingsText,
        'icon': Assets.settingsGreen,
        'onTap': () => context.push(RouteTo.settings),
      },
    ];

    final List<Widget> widgets = [const SizedBox(height: 0)];
    for (var btn in buttons) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildSocialButton(
            onTap: btn['onTap'],
            icon: btn['icon'] as String,
            label: btn['label'] as String,
            height: 20,
            width: 20,
          ),
        ),
      );
      widgets.add(const SizedBox(height: 20));
    }
    return widgets;
  }

  Widget _buildSocialButton({
    required VoidCallback onTap,
    required String icon,
    required String label,
    required double height,
    required double width,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
            color: Color.fromARGB(255, 172, 166, 166)), // Plain border
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            icon,
            height: height,
            width: width,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTextStyle.normalTextStyleNew(
                size: 16,
                color: AppColor.black,
                fontweight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SvgPicture.asset(
            Assets.navigate,
            height: height,
            width: width,
          ),
        ],
      ),
    );
  }
}
