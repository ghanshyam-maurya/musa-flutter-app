import 'package:musa_app/Cubit/social/social_cubit.dart';
import 'package:musa_app/Screens/components/notification_icon_button.dart';
import 'package:musa_app/Utility/packages.dart';
import 'socia_musa_list.dart';

class Social extends StatefulWidget {
  const Social({super.key});

  @override
  State<Social> createState() => _SocialState();
}

class _SocialState extends State<Social> {
  SocialCubit socialCubit = SocialCubit();
  late ScrollController _mainScrollController;
  ValueNotifier<bool> isMainScrolling =
      ValueNotifier(true); // Control scrolling

  @override
  void initState() {
    super.initState();
    socialCubit.setUserData();
    // Load cached posts first
    socialCubit.loadCachedPosts();

    // Ensure myUserId is available before calling getMyFeeds
    Future.delayed(Duration.zero, () {
      final userId = socialCubit.myUserId;
      if (userId != null && userId.isNotEmpty) {
        // socialCubit.getMyFeeds(userId: userId, page: 1);
      }
      socialCubit.getSocialFeeds(page: 1);
    });
    _mainScrollController = ScrollController();
    _mainScrollController.addListener(_scrollListener);

    _loadDataAndRefresh();
  }

  @override
  void didUpdateWidget(covariant Social oldWidget) {
    // TODO: implement didUpdateWidget
    socialCubit.setUserData();
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
    await socialCubit.setUserData(); // Make sure user data is fully loaded

    final userId = socialCubit.myUserId;

    if (userId != null && userId.isNotEmpty) {
      await socialCubit.getMyFeeds(userId: userId, page: 1);
    }

    await socialCubit.getSocialFeeds(page: 1);

    setState(() {}); // Triggers rebuild once data is loaded
  }

  Future<void> onRefresh() async {
    socialCubit.homePageNumber = 1;
    socialCubit.getMyFeeds(userId: socialCubit.myUserId.toString(), page: 1);
    socialCubit.getSocialFeeds(page: 1);
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
          body: SocialMusaList(
            scrollController: _mainScrollController,
            isMainScrolling: isMainScrolling,
            socialCubit: socialCubit,
          ),
        ),
      ),
    );
  }

  Widget _headerWidget() {
    print('hasFeeds: ${socialCubit.hasFeeds}');
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBarDashboard(
          leading: const SizedBox.shrink(),
          title: Text(
            'Social',
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
                  context.push(RouteTo.dashboardSearch);
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
              // IconButton(
              //   padding: EdgeInsets.all(8),
              //   iconSize: 24,
              //   icon: SvgPicture.asset(
              //     Assets.notification,
              //     width: 24,
              //     height: 24,
              //   ),
              //   onPressed: () {
              //     context.push(RouteTo.notificationView);
              //   },
              // ),
              NotificationIconButton(
                iconSize: 24,
                onPressed: () {
                  context.push(RouteTo.notificationView);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
