import 'package:musa_app/Utility/packages.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  SetupCubit setupCubit = SetupCubit();

  @override
  void initState() {
    super.initState();
    setupCubit.init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFFF1CF7C),
      ),
    );
    return Scaffold(
      body: BlocConsumer<SetupCubit, SetupState>(
        bloc: setupCubit,
        listener: (context, state) {
          if (state is SetupFetched) {
            context.go(RouteTo.bottomNavBar);
            // Navigator.pushReplacement(
            //     context, MaterialPageRoute(builder: (_) => BottomNavBar(key: bottomNavBarKey,)));
          } else if (state is SetupInitial) {
            context.pushReplacement(RouteTo.getStart);
          }
          if (state is SetupError) {
            MusaPopup.popUpDialouge(
                context: context,
                onPressed: () => context.pop(true),
                buttonText: 'Okay',
                title: 'Error',
                description: state.errorMessage);
          }
        },
        builder: (context, state) {
          return Container(
              decoration: BoxDecoration(gradient: AppColor.gradientVertical()),
              // color:  MusaColoStyles.splashColor,
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        Assets.splashLogo,
                        width: 60,
                        height: 30,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'My Useful Social Art',
                        style: AppTextStyle.normalTextStyleNew(
                          size: 29,
                          color: AppColor.white,
                          fontweight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
