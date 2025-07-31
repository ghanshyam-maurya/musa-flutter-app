import 'package:musa_app/Cubit/dashboard/my_section_cubit/my_section_state.dart';
import 'package:musa_app/Screens/dashboard/my_section/my_album/my_albums.dart';
import 'package:musa_app/Screens/dashboard/my_section/my_library/my_libraries_view.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import '../../../Cubit/dashboard/my_section_cubit/my_section_cubit.dart';
import '../../../Utility/packages.dart';

class MyMusaCollection extends StatefulWidget {
  final int? pageIndex;
  final bool? musa;
  const MyMusaCollection({super.key, this.pageIndex, this.musa});

  @override
  _MyMusaCollectionState createState() => _MyMusaCollectionState();
}

class _MyMusaCollectionState extends State<MyMusaCollection> {
  MySectionCubit mySectionCubit = MySectionCubit();
  bool isSearching = false;
  bool isUploading = false;

  @override
void initState() {
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

  Future<void> onRefresh() async {
    await mySectionCubit.getAlbumList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AppBar Section
          MusaWidgets.commonAppBar2(
            height: 110.0,
            row: Container(
              padding: MusaPadding.appBarPadding,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => context.pop(),
                    child: IconButton(
                      icon: SvgPicture.asset(Assets.backIcon),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "MUSAs",
                    style: AppTextStyle.normalTextStyleNew(
                      size: 17,
                      color: AppColor.black,
                      fontweight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            // height: 160,
            child: Stack(
              children: [
                // AppBarMusa2(
                //   leading: SizedBox(
                //     width: 55,
                //     height: 110,
                //     child: Center(
                //       child: Padding(
                //         padding: const EdgeInsets.only(top: 30.0),
                //         child: Text(
                //           "My",
                //           style: AppTextStyle.mediumTextStyle(
                //               color: AppColor.black, size: 18),
                //         ),
                //       ),
                //     ),
                //   ),
                //   end: SizedBox(),
                //   title: const SizedBox(),
                // ),
                // Positioned(
                //   bottom: 0,
                //   left: 16,
                //   right: 16,
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 16),
                //     child: Container(
                //       height: 50,
                //       decoration: BoxDecoration(
                //         color: Colors.grey[300],
                //         borderRadius: BorderRadius.circular(25),
                //       ),
                //       padding: const EdgeInsets.all(4),
                //       child: SizedBox(
                //         width: double.infinity,
                //         child: Row(
                //           children: [
                //             _buildSegment("My MUSA's", 0),
                //             _buildSegment("My Library", 1),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
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
                return Column(
                  children: [
                    mySectionCubit.selectedTab == 0
                        ? MyAlbums(mySectionCubit: mySectionCubit)
                        : MyLibrariesView(
                            mySectionCubit: mySectionCubit, musa: isUploading)
                  ],
                );
              },
            )),
          ))
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
}
