// import 'package:musa_app/Screens/dashboard/chat/chat_list_view.dart';
import 'package:musa_app/Screens/dashboard/home/home.dart';
import 'package:musa_app/Screens/art/art.dart';
import 'package:musa_app/Screens/social/social.dart';
import 'package:musa_app/Utility/packages.dart';
import '../../Screens/dashboard/home/media_upload_page.dart';
import '../../Screens/dashboard/my_section/my_section.dart';

final GlobalKey<_BottomNavBarState> bottomNavBarKey =
    GlobalKey<_BottomNavBarState>();

class BottomNavBar extends StatefulWidget {
  final int? passIndex;
  final Widget? customPage;
  const BottomNavBar({super.key, this.passIndex, this.customPage});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int? _selectedIndex = 0;
  int? pageIndex = 0;
  bool tap = false;
  DateTime? lastPressed;
  bool showCustomPage = true;

  @override
  void initState() {
    if (widget.passIndex != 4) {
      _selectedIndex = widget.passIndex;
    }
    super.initState();
  }

  // Ensure this function is accessible globally
  void onItemTapped(int index) {
    setState(() {
      tap = true;
      showCustomPage = false;
      _selectedIndex = index;
    });
  }

  static final List<Widget> _widgetOptions = [
    Home(),
    MyScreen(),
    Social(),
    Art(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (lastPressed == null ||
            DateTime.now().difference(lastPressed!) > Duration(seconds: 2)) {
          lastPressed = DateTime.now();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Press again to exit"),
              duration: Duration(seconds: 2),
            ),
          );
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        body: Center(
          child: (widget.customPage != null && showCustomPage)
              ? widget.customPage!
              : (widget.passIndex == null || tap
                  ? _widgetOptions[_selectedIndex ?? 0]
                  : _widgetOptions[widget.passIndex ?? 0]),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     //context.push(RouteTo.createMusa);
        //     uploadPopUp(context);
        //   },
        //   backgroundColor: AppColor.greenDark,
        //   shape: CircleBorder(),
        //   elevation: 0,
        //   child: Icon(Icons.add, color: AppColor.white),
        // ),
        floatingActionButton: Container(
          width: 60, // you can adjust size as needed
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3), // white border
          ),
          child: FloatingActionButton(
            onPressed: () {
              uploadPopUp(context);
            },
            backgroundColor: AppColor.greenDark,
            shape: CircleBorder(),
            elevation: 0,
            child: Icon(Icons.add, color: AppColor.white),
          ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex ?? 0,
          onTap: onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                Assets.inActiveHome_1,
                color: AppColor.primaryColor,
              ),
              activeIcon: SvgPicture.asset(Assets.activeHome_1),
              label: StringConst.homeText,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(Assets.myMusaInactive),
              activeIcon: SvgPicture.asset(Assets.myMusaActive),
              label: StringConst.myText,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(Assets.inActiveSocial_1),
              activeIcon: SvgPicture.asset(Assets.activeSocial_1),
              label: StringConst.socialText,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(Assets.artInactive),
              activeIcon: SvgPicture.asset(Assets.artActive),
              label: StringConst.artText,
            ),
          ],
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColor.white,
          unselectedItemColor: AppColor.textInactive,
          backgroundColor: AppColor.greenDark,
        ),
      ),
    );
  }
}

uploadPopUp(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Quick Actions",
                      style: AppTextStyle.mediumTextStyle(
                        color: AppColor.black,
                        size: 18,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: AppColor.black, size: 24),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _QuickActionButton(
                text: "Create MUSA",
                onTap: () {
                  Navigator.pop(context);
                  context.push(RouteTo.createMusa);
                },
              ),
              SizedBox(height: 12),
              _QuickActionButton(
                text: "Upload Media",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MediaUploadPage()),
                  );
                },
              ),
              SizedBox(height: 12),
              _QuickActionButton(
                text: "Add Contributor",
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement Add Contributor action
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _QuickActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _QuickActionButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: Material(
        color: const Color(0xFFF1FBF7),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Center(
            child: Text(
              text,
              style: AppTextStyle.mediumTextStyle(
                color: AppColor.primaryColor,
                size: 15,
              ).copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
