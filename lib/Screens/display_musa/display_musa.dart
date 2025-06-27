import 'package:musa_app/Cubit/display_musa/display_cubit.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import 'package:musa_app/Utility/packages.dart';
import 'display_musa_list.dart';

class DisplayMusa extends StatefulWidget {
  const DisplayMusa({super.key});

  @override
  State<DisplayMusa> createState() => _DisplayMusaState();
}

class _DisplayMusaState extends State<DisplayMusa> {
  DisplayCubit myCubit = DisplayCubit();
  late ScrollController _mainScrollController;
  ValueNotifier<bool> isMainScrolling =
      ValueNotifier(true); // Control scrolling

  @override
  void initState() {
    super.initState();
    myCubit.setUserData();
    // Load cached posts first
    myCubit.loadCachedPosts();

    // Ensure myUserId is available before calling getMyFeeds
    Future.delayed(Duration.zero, () {
      final userId = myCubit.myUserId;
      if (userId != null && userId.isNotEmpty) {
        myCubit.getMyFeeds(page: 1, userId: userId);
      }
    });
    _mainScrollController = ScrollController();
    _mainScrollController.addListener(_scrollListener);

    _loadDataAndRefresh();
  }

  @override
  void didUpdateWidget(covariant DisplayMusa oldWidget) {
    myCubit.setUserData();
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

  Future<void> _loadDataAndRefresh() async {
    await myCubit.setUserData(); // Make sure user data is fully loaded

    final userId = myCubit.myUserId;

    if (userId != null && userId.isNotEmpty) {
      await myCubit.getMyFeeds(page: 1, userId: userId);
    }
    setState(() {}); // Triggers rebuild once data is loaded
  }

  Future<void> onRefresh() async {
    final userId = myCubit.myUserId;
    myCubit.homePageNumber = 1;
    if (userId != null && userId.isNotEmpty) {
      myCubit.getMyFeeds(page: 1, userId: userId);
    }
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: NestedScrollView(
          controller: _mainScrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _headerWidget(),
                ],
              ),
            ),
          ],
          body: DisplayMusaList(
            scrollController: _mainScrollController,
            isMainScrolling: isMainScrolling,
            displayCubit: myCubit,
          ),
        ),
      ),
    );
  }

  Widget _headerWidget() {
    // print('hasFeeds: ${myCubit.hasFeeds}');
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MusaWidgets.commonAppBar(
          height: MediaQuery.of(context).size.height / 8,
          backgroundColor: AppColor.white,
          row: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child:
                        Icon(Icons.close, color: AppColor.black, size: 28.sp)),
                SizedBox(width: 18.sp),
                Text(
                  'Display MUSAs',
                  style: AppTextStyle.mediumTextStyle(
                      color: AppColor.black, size: 20),
                ),
                Spacer(),
                SizedBox(
                  height: 32.sp,
                  width: 124.sp,
                  child: GestureDetector(
                    onTap: () async {
                      // var userId = Prefs.getString(PrefKeys.uId);
                      // await editProfileCubit.updateUser();
                      // await editProfileCubit.getUserDetails(userId: userId);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColor.greenDark,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        'Display Mode',
                        style: AppTextStyle.semiTextStyle(
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
