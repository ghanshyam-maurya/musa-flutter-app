import 'package:musa_app/Cubit/display_musa/display_cubit.dart';
import 'package:musa_app/Screens/display_musa/horizontal_calender.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import 'package:musa_app/Utility/packages.dart';
import 'package:intl/intl.dart';
import 'display_musa_list.dart';

class DisplayMusa extends StatefulWidget {
  const DisplayMusa({super.key});

  @override
  State<DisplayMusa> createState() => _DisplayMusaState();
}

class _DisplayMusaState extends State<DisplayMusa> {
  DisplayCubit myCubit = DisplayCubit();
  DateTime? _initialSelectedDate;
  late ScrollController _mainScrollController;
  ValueNotifier<bool> isMainScrolling =
      ValueNotifier(true); // Control scrolling

  @override
  void initState() {
    super.initState();
    // Set initial selected date to today
    _initialSelectedDate = DateTime.now();
    myCubit.selectedDate = _initialSelectedDate;
    myCubit.selectedDateString = _initialSelectedDate != null
        ? DateFormat('yyyy-MM-dd').format(_initialSelectedDate!)
        : null;
    myCubit.setUserData();
    _mainScrollController = ScrollController();
    _mainScrollController.addListener(_scrollListener);

    // Only one API call: after user data and date are set
    Future.delayed(Duration.zero, () {
      final userId = myCubit.myUserId;
      if (userId != null &&
          userId.isNotEmpty &&
          myCubit.selectedDateString != null) {
        myCubit.getMyFeeds(
            page: 1, userId: userId, filterDate: myCubit.selectedDateString);
      }
    });
  }

  // Removed didUpdateWidget to prevent extra API call and resetting selectedDate

  void _scrollListener() {
    if (_mainScrollController.position.pixels <= 0) {
      isMainScrolling.value = true; // Main scroll is at the top
    } else if (_mainScrollController.position.pixels >=
        _mainScrollController.position.maxScrollExtent) {
      isMainScrolling.value = false;
    }
  }

  // Removed _loadDataAndRefresh to prevent duplicate API calls

  Future<void> onRefresh() async {
    final userId = myCubit.myUserId;
    myCubit.homePageNumber = 1;
    if (userId != null && userId.isNotEmpty) {
      // Always use the selected date filter if set
      myCubit.getMyFeeds(
        page: 1,
        userId: userId,
        filterDate: myCubit.selectedDateString,
      );
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
                        Icon(Icons.close, color: AppColor.black, size: 24.sp)),
                SizedBox(width: 18.sp),
                Text(
                  'Display MUSAs',
                  style: AppTextStyle.mediumTextStyle(
                      color: AppColor.black, size: 18.sp),
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
                          size: 15.sp,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        HorizontalCalendar(
          selectedDate: myCubit.selectedDate,
          onDateSelected: (DateTime selectedDate) {
            if (myCubit.selectedDate != null &&
                DateUtils.isSameDay(myCubit.selectedDate, selectedDate)) {
              // myCubit.clearDateFilter();
              // myCubit.selectedDate = null; // Ensure highlight is cleared
              // setState(() {});
            } else {
              myCubit.filterByDate(selectedDate);
              setState(() {});
            }
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
