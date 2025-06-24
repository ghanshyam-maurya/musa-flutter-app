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
    return SizedBox(
      height: 250, // or whatever height fits your design
      child: Stack(
        children: [
          BlocConsumer<HomeCubit, HomeSocialState>(
            bloc: homeCubit,
            listener: (context, state) {},
            builder: (context, state) {
              if (state is MyFeedsListSuccess) {
                homeCubit.myFeedsLoaded = true;
                return getWidget();
              } else if (state is MyFeedsListLoading) {
                return MusaWidgets
                    .shimmerAnimationLoadingForHomeScreenMyFeeds();
              } else if (state is MyFeedsListFailure) {
                return Center(
                  child: Container(
                    margin:
                        EdgeInsets.only(top: 150.sp, left: 25.sp, right: 25.sp),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Text('Failed to load feeds!'),
                  ),
                );
              } else {
                if (homeCubit.myFeedsLoaded) {
                  return getWidget();
                }
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget getWidget() {
    final filteredList = homeCubit.myFeedsList
        .where((musa) => musa.file != null && musa.file!.isNotEmpty)
        .toList();

    return filteredList.isNotEmpty
        ? CarouselSliderWidget(musaList: filteredList)
        : SizedBox.shrink();
  }
}
