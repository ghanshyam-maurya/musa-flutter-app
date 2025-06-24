// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musa_app/Utility/packages.dart';
import 'package:musa_app/pushNotification/push_notification_service.dart';

// Initialize go_router
final goRouter = router;
final messagingService = PushNotificationService(goRouter);

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   messagingService.notificationService();
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (Platform.isIOS) {
  //   await Firebase.initializeApp();
  // } else {
  //   await Firebase.initializeApp(
  //       name: "MUSA",
  //       options: FirebaseOptions(
  //           apiKey: "AIzaSyA15jM8jylo889nM_foLE9WdSyaYbxHpAw",
  //           // apiKey: "AIzaSyAavVAx3vQno3U6EC0ZlluJYUM3B4VBPMo",           // New created app apikey com.musaartapp
  //           // appId: "1:154296186840:ios:68177fb8f73e86fe3764ad",          // AppId iOS com.musaartapp Newly created app
  //           //appId: "1:154296186840:ios:b6793aa4c128d1433764ad",           // AppId ios Previous app com.musaapp.musaApp
  //           appId:
  //               "1:154296186840:android:03dd45015bb7e5373764ad", // AppId Android
  //           messagingSenderId: "154296186840",
  //           projectId: "musa-app-7987b"));
  // }
  // // Enable Crashlytics
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // // FirebasePerformance.instance.setPerformanceCollectionEnabled(false);
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // // Initialize MessagingService
  // messagingService.notificationService();

  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  Prefs.init();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
  await Hive.initFlutter();
  await Hive.openBox('postsBox'); // Open Hive storage
  // runApp(const MyApp());
}

// Future<void> getFcmToken() async {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   if (Platform.isIOS) {
//     await messaging.requestPermission(alert: true, badge: true, sound: true);
//     String? apnsToken = await messaging.getAPNSToken();
//     print("APNS Token: $apnsToken");
//     if(apnsToken == null){
//       return;
//     }

//   }
//   String? token = await messaging.getToken();
//   Prefs.setString(PrefKeys.fcmToken, token.toString());
//   print("FCM Token: $token");
// }

// Future<void> getDeviceInfo() async {
//   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//   String deviceId = "";
//   String deviceType = "";

//   if (Platform.isAndroid) {
//     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//     deviceId = androidInfo.id;
//     deviceType = "Android";
//   } else if (Platform.isIOS) {
//     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//     deviceId = iosInfo.identifierForVendor ?? "";
//     deviceType = "iOS";
//   }
//   Prefs.setString(PrefKeys.deviceId, deviceId);
//   Prefs.setString(PrefKeys.deviceType, deviceType);
//   print("Device ID: $deviceId");
//   print("Device Type: $deviceType");
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MultiBlocProvider(
          providers: providers,
          child: ScreenUtilInit(
            designSize: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'MUSA\nMy Usefull Social Art',
                theme: ThemeData(
                  primaryColor: Colors.green.shade800,
                  appBarTheme: AppBarTheme(
                    color: AppColor.white,
                    elevation: 0,
                    iconTheme: IconThemeData(color: AppColor.black),
                  ),
                ),
                routerConfig: router,
              );
            },
          )),
    );
  }
}
