import 'package:musa_app/Cubit/dashboard/home_dashboard_cubit/home_state.dart';
import 'package:musa_app/Utility/musa_widgets.dart';

import '../../../Cubit/dashboard/home_dashboard_cubit/home_cubit.dart';
import '../../../Resources/component/carousel_widget.dart';
import '../../../Utility/packages.dart';

class HomeMyFeedCarousel extends StatefulWidget {
  final HomeCubit homeCubit;
  const HomeMyFeedCarousel({super.key, required this.homeCubit});

  @override
  State<HomeMyFeedCarousel> createState() => _HomeMyFeedCarouselState();
}

class _HomeMyFeedCarouselState extends State<HomeMyFeedCarousel> {
  late HomeCubit homeCubit;

  @override
  void initState() {
    // TODO: implement initState
    homeCubit = widget.homeCubit;
    homeCubit.getMyFeeds(page: 1, userId: homeCubit.myUserId ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeSocialState>(
      bloc: homeCubit,
      listener: (context, state) {},
      builder: (context, state) {
        // Positioned Content Section
        if (state is MyFeedsListSuccess) {
          homeCubit.myFeedsLoaded = true;
          // return getWidget();
          final widget = getWidget();
          return widget;
          return const SizedBox.shrink();
        } else if (state is MyFeedsListLoading) {
          return MusaWidgets.shimmerAnimationLoadingForHomeScreenMyFeeds();
        } else if (state is MyFeedsListFailure) {
          return Positioned(
            top: 150.sp,
            left: 25.sp,
            right: 25.sp,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text('Failed to load feeds!'),
            ),
          );
        } else {
          // This is the case when other states of HomeStates can be get
          //So, if the my feed list loaded then show the get widget
          if (homeCubit.myFeedsLoaded) {
            return getWidget();
          }
          return Container();
        }
      },
    );
  }

  Widget createMusaCard() {
    return Positioned(
      top: 130,
      left: 24,
      right: 24,
      child: Container(
        padding: EdgeInsets.only(left: 50, right: 50, bottom: 20, top: 20),
        decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Shadow color
                spreadRadius: 1, // How much the shadow spreads
                blurRadius: 5, // How much the shadow blurs
                offset: Offset(0, 3), // Shadow position (x, y)
              ),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100, child: Image.asset(Assets.homeGroupPic)),
            Text(
              StringConst.createFirstMUSA,
              style:
                  AppTextStyle.mediumTextStyle(color: AppColor.black, size: 18),
              textAlign: TextAlign.center,
            ),
            Text(
              StringConst.myUsefulSocialArt,
              style:
                  AppTextStyle.mediumTextStyle(color: AppColor.black, size: 10),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: CommonButton(
                  title: 'Create MUSA',
                  onTap: () {
                    context.push(RouteTo.createMusa);
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget getWidget() {
    if (homeCubit.myFeedsList.isNotEmpty) {
      return Positioned(
        top: 140.sp,
        left: 25.sp,
        right: 25.sp,
        child: CarouselSliderWidget(
            musaList: homeCubit.myFeedsList), // Show the Carousel
      );
    } else {
      return createMusaCard();
      // return const SizedBox.shrink();
    }
  }
}
