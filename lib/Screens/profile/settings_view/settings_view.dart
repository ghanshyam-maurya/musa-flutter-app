import 'dart:io';
import '../../../Cubit/profile/setting_cubit/settings_cubit.dart';
import '../../../Cubit/profile/setting_cubit/settings_state.dart';
import '../../../Utility/musa_widgets.dart';
import '../../../Utility/packages.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  SettingsCubit settingsCubit = SettingsCubit();

  @override
  void initState() {
    super.initState();
    settingsCubit.init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: BlocConsumer<SettingsCubit, SettingsState>(
        bloc: settingsCubit,
        listener: (context, state) {
          if (state is LogoOutSuccess) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('User logged out successfully!')),
            // );
            while (context.canPop()) {
              context.pop();
            }
            context.pushReplacement(RouteTo.getStart);
          } else if (state is LogoOutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: MusaWidgets.commonAppBar(
                        height: 120.sp,
                        backgroundColor: AppColor.white,
                        row: Padding(
                          padding: MusaPadding.appBarPadding,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      GoRouter.of(context).pop();
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: AppColor.black,
                                      size: 24.sp,
                                    ),
                                  ),
                                  SizedBox(
                                      width: 26
                                          .sp), // Added spacing of 10 logical pixels
                                  Text(
                                    StringConst.generalSettings,
                                    style: AppTextStyle.semiMediumTextStyleNew(
                                        color: Color(0xFF222222), size: 19.sp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: MusaPadding.horizontalPadding,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          // borderRadius: BorderRadius.circular(
                          //     12.sp), // Optional: if you want rounded corners
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 1.h),
                            // Text(
                            //   StringConst.generalSettings,
                            //   style: AppTextStyle.normalBoldTextStyle
                            //       .copyWith(color: AppColor.grey),
                            // ),
                            reusableSettingsItem(
                              context,
                              icon: SvgPicture.asset(
                                Assets.planIcon,
                                fit: BoxFit.fill,
                              ),
                              text: StringConst.planText,
                              onTap: () {
                                context.push(RouteTo.choosePlan);
                              },
                            ),
                            reusableSettingsItem(
                              context,
                              icon: SvgPicture.asset(
                                Assets.rateIcon,
                                fit: BoxFit.fill,
                              ),
                              text: StringConst.rateText,
                              onTap: () {},
                            ),
                            reusableSettingsItem(
                              context,
                              icon: SvgPicture.asset(
                                Assets.key,
                                fit: BoxFit.fill,
                              ),
                              text: StringConst.changePassword,
                              onTap: () {
                                String flowType = "ChangePassword";
                                context.push(RouteTo.changePassword
                                    .replaceFirst(':flowType', flowType));
                              },
                            ),
                            // Divider(),
                            reusableSettingsItem(
                              context,
                              icon: SvgPicture.asset(
                                Assets.contactUsIcon,
                                fit: BoxFit.fill,
                              ),
                              text: StringConst.contactUs,
                              onTap: () {
                                context.push(RouteTo.contactUs);
                                // Navigate to Plans screen
                              },
                            ),
                            // Divider(),

                            // Divider(),
                            // Text(
                            //   "Others",
                            //   style: AppTextStyle.normalBoldTextStyle
                            //       .copyWith(color: AppColor.grey),
                            // ),
                            reusableSettingsItem(
                              context,
                              icon: SvgPicture.asset(
                                Assets.termsCondition,
                                fit: BoxFit.fill,
                              ),
                              text: StringConst.termsText,
                              onTap: () {
                                String flowType = "Terms";
                                context.push(RouteTo.termsAndPrivacy
                                    .replaceFirst(':flowType', flowType));
                              },
                            ),
                            // Divider(),
                            reusableSettingsItem(
                              context,
                              icon: SvgPicture.asset(
                                Assets.privacyICon,
                                fit: BoxFit.fill,
                              ),
                              text: StringConst.privacyText,
                              onTap: () {
                                String flowType = "Privacy";
                                context.push(RouteTo.termsAndPrivacy
                                    .replaceFirst(':flowType', flowType));
                              },
                            ),
                            // Divider(),
                            reusableSettingsItem(
                              context,
                              icon: Icon(
                                Icons.info_rounded,
                                color: const Color.fromARGB(201, 93, 172, 152),
                              ),
                              text: "About",
                              onTap: () {
                                String flowType = "About";
                                context.push(RouteTo.termsAndPrivacy
                                    .replaceFirst(':flowType', flowType));
                              },
                            ),
                            // Divider(),

                            // Divider(),
                            // reusableSettingsItem(
                            //   context,
                            //   icon: SvgPicture.asset(
                            //     Assets.shareWireIcon,
                            //     fit: BoxFit.fill,
                            //   ),
                            //   text: StringConst.rateText,
                            //   onTap: () {
                            //     // Navigate to About screen
                            //   },
                            // ),
                            // if (Platform.isIOS) Divider(),
                            if (Platform.isIOS)
                              reusableSettingsItem(
                                context,
                                icon: Icon(
                                  Icons.delete,
                                  color:
                                      const Color.fromARGB(201, 93, 172, 152),
                                ),
                                text: StringConst.deleteText,
                                onTap: () {
                                  confirmDialog(context, "Delete");
                                  // Navigate to About screen
                                },
                              ),
                            // Divider(),
                            InkWell(
                              onTap: () {
                                confirmDialog(context, "Logout");
                              },
                              child: SizedBox(
                                height: 60.sp,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      Assets.logoutIcon,
                                      fit: BoxFit.fill,
                                    ),
                                    SizedBox(width: 26.sp),
                                    Text(
                                      StringConst.logOutText,
                                      style:
                                          AppTextStyle.semiMediumTextStyleNew(
                                              color: Color(0xFF222222),
                                              size: 16.sp),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (settingsCubit.state is SettingsLoading)
                Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryColor,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget reusableSettingsItem(
    BuildContext context, {
    required Widget icon,
    required String text,
    Colors? textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 60.sp,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            icon,
            SizedBox(width: 26.sp),
            Text(
              text,
              style: AppTextStyle.semiMediumTextStyleNew(
                  color: Color(0xFF222222), size: 16.sp),
            ),
          ],
        ),
      ),
    );
  }

  void confirmDialog(BuildContext parentContext, String? eventName) {
    showDialog(
      context: context,
      builder: (BuildContext parentContext) {
        return BlocProvider.value(
            value: settingsCubit,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 16,
              child: Container(
                height: 200.sp,
                decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(12.sp)),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close,
                          color: AppColor.black,
                          size: 20.sp,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          (eventName == "Logout")
                              ? "Are you sure you want to log out?"
                              : "Are you sure you want to $eventName the account permanently?",
                          style: AppTextStyle.appBarTitleStyle,
                        ),
                        SizedBox(
                          height: 30.sp,
                        ),
                        SizedBox(
                            height: 40,
                            width: 150,
                            // child: MusaWidgets.secondaryTextButton(
                            //   fontSize: 16,
                            //   bgcolor: AppColor.greenDark,
                            //   title: ' $eventName ',
                            //   onPressed: () {
                            //     Navigator.of(context).pop();
                            //     signOut(parentContext);
                            //   },
                            // ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                signOut(parentContext);
                              },
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xFF00674E),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    '$eventName',
                                    style: AppTextStyle.semiTextStyle(
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  signOut(BuildContext context) {
    try {
      settingsCubit.logOut();
    } catch (e) {
      debugPrint("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  deleteAccount(BuildContext context) {
    try {
      settingsCubit.deleteAccount();
    } catch (e) {
      debugPrint("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }
}
