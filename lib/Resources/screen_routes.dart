import 'package:musa_app/Repository/AppResponse/chat_modals/chat_list_response.dart';
import 'package:musa_app/Screens/auth/social_login.dart';
import 'package:musa_app/Screens/dashboard/chat/chat_group_view.dart';
import 'package:musa_app/Screens/dashboard/home/home_search_view.dart';
import 'package:musa_app/Screens/dashboard/my_section/my_musa_collection.dart';
import 'package:musa_app/Screens/profile/edit_profile.dart';
import 'package:musa_app/Screens/profile/my_profile.dart';
import 'package:musa_app/Utility/packages.dart';
import 'package:musa_app/Resources/CommonWidgets/bottom_nav_bar.dart'; 

import '../Screens/notification_view/notification_view.dart';
import '../Screens/profile/settings_view/choose_plan_view.dart';
import '../Screens/profile/settings_view/contact_us_view.dart';
import '../Screens/profile/settings_view/settings_view.dart';
import '../Screens/profile/settings_view/terms_n_privacy_view.dart';
import '../Screens/profile/my_musa_contributors.dart';
import 'package:musa_app/Screens/display_musa/display_musa.dart';

import 'package:musa_app/Screens/dashboard/home/home.dart';


final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: RouteTo.setup,
      builder: (BuildContext context, GoRouterState state) {
        return const SetupScreen();
      },
    ),
    GoRoute(
        path: RouteTo.getStart,
        builder: (BuildContext context, GoRouterState state) {
          return GetStartScreen();
        }),
    GoRoute(
        path: RouteTo.getStartSignUp,
        builder: (BuildContext context, GoRouterState state) {
          return GetStartSignUp();
        }),
    GoRoute(
      path: RouteTo.login,
      builder: (BuildContext context, GoRouterState state) {
        return const Login();
      },
    ),
    GoRoute(
      path: RouteTo.forgotPassword,
      builder: (BuildContext context, GoRouterState state) {
        return const ForgotPassword();
      },
    ),
    GoRoute(
      path: RouteTo.otp,
      builder: (BuildContext context, GoRouterState state) {
        final Map<String, String> data = state.extra as Map<String, String>;
        final String email = data['email'] as String;
        final String comingFrom = data['comingFrom'] as String;
        return Otp(
          email: email,
          comingFrom: comingFrom,
        );
      },
    ),
    GoRoute(
      path: RouteTo.changePassword,
      builder: (BuildContext context, GoRouterState state) {
        return ChangePassword();
      },
    ),
    GoRoute(
      path: RouteTo.signup,
      builder: (BuildContext context, GoRouterState state) {
        return Signup();
      },
    ),
    GoRoute(
      path: RouteTo.signupEmail,
      builder: (BuildContext context, GoRouterState state) {
        return SignupEmail();
      },
    ),
    GoRoute(
      path: RouteTo.aboutYourself,
      builder: (BuildContext context, GoRouterState state) {
        return AboutYourself();
      },
    ),
    // GoRoute(
    //   path: RouteTo.addContributor,
    //   builder: (BuildContext context, GoRouterState state) {
    //     List<String> contributorList = state.
    //     return const AddContributor(initialSelectedContributors: st,);
    //   },
    // ),
    GoRoute(
      path: RouteTo.createMusa,
      builder: (BuildContext context, GoRouterState state) {
        return const CreateMusa();
      },
    ),
    GoRoute(
      path: RouteTo.bottomNavBar,
      builder: (BuildContext context, GoRouterState state) {
        return BottomNavBar(key: bottomNavBarKey);
      },
    ),
    GoRoute(
      path: RouteTo.myProfile,
      builder: (BuildContext context, GoRouterState state) {
        return MyProfile();
      },
    ),
    GoRoute(
      path: RouteTo.notificationView,
      builder: (BuildContext context, GoRouterState state) {
        return NotificationView();
      },
    ),
    GoRoute(
      path: RouteTo.editProfile,
      builder: (BuildContext context, GoRouterState state) {
        return EditProfile();
      },
    ),
    GoRoute(
      path: RouteTo.displayMusa,
      builder: (BuildContext context, GoRouterState state) {
        return DisplayMusa();
      },
    ),
    GoRoute(
        path: RouteTo.chatView,
        builder: (BuildContext context, GoRouterState state) {
          return ChatView(chatListData: state.extra as ChatListData);
        }),
    GoRoute(
        path: RouteTo.chatView,
        builder: (BuildContext context, GoRouterState state) {
          return ChatView(chatListData: state.extra as ChatListData);
        }),
    GoRoute(
      path: RouteTo.contactUs,
      builder: (BuildContext context, GoRouterState state) {
        return ContactUsView();
      },
    ),
    GoRoute(
      path: RouteTo.choosePlan,
      builder: (BuildContext context, GoRouterState state) {
        return ChoosePlanScreen();
      },
    ),
    GoRoute(
      path: RouteTo.termsAndPrivacy,
      builder: (BuildContext context, GoRouterState state) {
        final String? flowType = state.pathParameters['flowType'];
        return TermsAndPrivacyView(
          flowType: flowType,
        );
      },
    ),
    GoRoute(
      path: RouteTo.settings,
      builder: (BuildContext context, GoRouterState state) {
        return SettingsScreen();
      },
    ),
    GoRoute(
      path: RouteTo.socialLogin,
      builder: (BuildContext context, GoRouterState state) {
        return SocialLogin();
      },
    ),
    GoRoute(
      path: RouteTo.dashboardSearch,
      builder: (BuildContext context, GoRouterState state) {
        return DashboardSearch();
      },
    ),
    GoRoute(
      path: RouteTo.myMusaContributorList,
      builder: (BuildContext context, GoRouterState state) {
        return MyMusaContributors();
      },
    ),
    GoRoute(
      path: RouteTo.myMusaCollection,
      builder: (BuildContext context, GoRouterState state) {
        return MyMusaCollection();
      },
    ),
    GoRoute(
      path: RouteTo.dashboardHome,
      builder: (BuildContext context, GoRouterState state) {
        return BottomNavBar(passIndex: 0); // Show BottomNavBar with Home tab
      },
    ),
    // GoRoute(
    //   path: RouteTo.bottomNavBar,
    //   builder: (BuildContext context, GoRouterState state) {
    //     return BottomNavBar(
    //       key: bottomNavBarKey,
    //     );
    //   },
    // ),
  ],
);

// declare route name here

abstract class RouteTo {
  static const String setup = '/';
  static const String getStart = '/getStart';
  static const String getStartSignUp = '/getStartSignUp';
  static const String login = '/login';
  static const String forgotPassword = '/forgotPassword';
  static const String otp = '/otp';
  static const String changePassword = '/changePassword';
  static const String signupEmail = '/signupEmail';
  static const String signup = '/signup';
  static const String aboutYourself = '/aboutYourself';
  static const String bottomNavBar = '/bottomNavBar';
  static const String createMusa = '/create_musa';
  static const String addContributor = '/add_contributor';
  static const String myProfile = '/myProfile';
  static const String editProfile = '/editProfile';
  static const String notificationView = '/notification_view';
  static const String chatView = '/chat_view';
  static const String settings = '/settings';
  static const String contactUs = '/contact_us';
  static const String choosePlan = '/choose_plan';
  static const String termsAndPrivacy = '/terms_and_privacy/:flowType';
  static const String socialLogin = 'social_login';
  static const String dashboardSearch = '/dashboard_search';
  static const String myMusaContributorList = '/my_musa_contributor_list';
  static const String myMusaCollection = '/myMusaCollection';
  static const String displayMusa = '/displayMusa';
  static const String dashboardHome = '/dashboardHome';
}
