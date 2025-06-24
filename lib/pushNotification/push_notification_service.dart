// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';

class PushNotificationService {
  final GoRouter _router;

  PushNotificationService(this._router);

  void notificationService() async {
    // Request for Notification Permission
    // NotificationSettings settings = await requestNotificationPermission();
    return null;
    // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //   // Receive Notifications when app is in foreground
    //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //     print("message : $message");
    //     // Prefs.setBool(PrefKeys.notificationDot, true);
    //   });

    //   // Actions on tap of notification
    //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //     PushNotificationData notificationData =
    //         PushNotificationData.fromJson((message.data));
    //     print("notificationData : $notificationData");
    //     // navigateOnNotification(notificationData);
    //   });

    //   // Receive Notifications when app is terminated
    //   FirebaseMessaging.instance.getInitialMessage().then((message) {
    //     if (message != null) {
    //       PushNotificationData notificationData =
    //           PushNotificationData.fromJson((message.data));
    //       print("notificationData in getInitialMessage : $notificationData");
    //       Future.delayed(const Duration(seconds: 1)).then((value) {
    //         // navigateOnNotification(notificationData);
    //       });
    //     }
    //   });
    // } else {
    //   print('User declined or has not accepted permission');
    // }
  }

  // Future<NotificationSettings> requestNotificationPermission() async {
  //   NotificationSettings settings =
  //       await FirebaseMessaging.instance.requestPermission(
  //     alert: true,
  //     badge: true,
  //     provisional: false,
  //     sound: true,
  //     announcement: true,
  //     carPlay: true,
  //     criticalAlert: true,
  //   );
  //   return settings;
  // }

  // void navigateOnNotification(PushNotificationData? notificationData){

  //   if(notificationData != null){
  //     String routeScreen = getNotificationRoute(notificationData.notificationScreen);
  //     if(routeScreen == RouteTo.chatScreen){
  //       if(notificationData.chatType == 'contextual_chat'){
  //         _router.push(
  //           routeScreen,
  //           extra:ChatListData(
  //             id:notificationData.id != null ? int.parse(notificationData.id.toString()) : null,
  //                         isRefer: 1,
  //                         userDetail: UserDetail(
  //                           id:int.parse(notificationData.senderId.toString()),
  //                           firstName: notificationData.commonName,
  //                           lastName:''
  //                         ),
  //                         listeningId:notificationData.contextualId != null ? int.parse(notificationData.contextualId.toString()) : null,
  //                         listeningType: notificationData.listeningType,
  //                         chatType: 'contextual_chat',
  //                         listeningData: ListeningData(
  //                           id: notificationData.contextualId != null ? int.parse(notificationData.contextualId.toString()) : null,
  //                           name: notificationData.contextualName,
  //                           bmgPoints: notificationData.contextualPrice,
  //                           photo: [notificationData.contextualImage.toString()]
  //                         )
  //                       )
  //         );
  //       }else{
  //         _router.push(
  //           routeScreen,
  //           extra:ChatListData(
  //             id: notificationData.id != null ? int.parse(notificationData.id.toString()) : null,
  //             isRefer: 0,
  //                         userDetail: UserDetail(
  //                           id:int.parse(notificationData.senderId.toString()),
  //                           firstName: notificationData.commonName,
  //                           lastName: '',
  //                         ),
  //                         chatType: 'one_to_one_chat',
  //           )
  //         );
  //       }

  //     } else if(routeScreen == RouteTo.myHostingOfferReceived){
  //       _router.push(routeScreen,extra:{
  //                 'hostingName': '${notificationData.commonName}',
  //                 'hostingId': '${notificationData.id}'
  //               });
  //     } else if(routeScreen == RouteTo.myOfferingOfferReceived){
  //       _router.push(routeScreen,extra:{
  //                 'offeringName': '${notificationData.commonName}',
  //                 'offeringId': '${notificationData.id}'
  //               });
  //     } else if(routeScreen == RouteTo.myServiceOfferReceived){
  //       _router.push(routeScreen,extra:{
  //                 'serviceTitle': '${notificationData.commonName}',
  //                 'serviceId': '${notificationData.id}'
  //               });
  //     } else if(routeScreen == RouteTo.myUnlistedOffers){
  //       MyUnlistedList myUnlistedList = MyUnlistedList();
  //       myUnlistedList.id = int.parse(notificationData.id.toString());
  //       myUnlistedList.type = notificationData.myUnlistedType;
  //       if(myUnlistedList.type != null){
  //         _router.push(routeScreen,extra:myUnlistedList);
  //       }
  //     } else if(routeScreen == RouteTo.myRequestsActivities){
  //       int tabNumber = 0;
  //       if(notificationData.notificationScreen == 'my_request_accept'){
  //         tabNumber = 1;
  //       }else if(notificationData.notificationScreen == 'my_request_cancel'){
  //         tabNumber = 2;
  //       }
  //       _router.push(routeScreen,extra:tabNumber);
  //     } else if(routeScreen == RouteTo.myHosting || routeScreen == RouteTo.myOffering || routeScreen == RouteTo.myService){
  //       _router.push(routeScreen,extra:1);
  //     } else if(notificationData.notificationScreen == 'my_profile'){
  //       _router.push(routeScreen,extra:4);
  //     } else if(notificationData.notificationScreen == 'friend_request_received'){
  //       print("Inside the friend_request_received Screen >>>>>>>>>>>");
  //       _router.push(routeScreen);
  //     } else{
  //       print("Dashboard Routing >>>>>>>");
  //       _router.push(routeScreen,extra: notificationData.notificationScreen == 'other_user_profile' ? int.parse(notificationData.id.toString()) : notificationData.id);
  //     }
  //   }
  // }

  // getNotificationRoute(String? notificationScreen){
  //   print("notificationScreen : $notificationScreen");
  //   switch (notificationScreen) {
  //     case 'my_hosting_offer' :
  //       return RouteTo.myHostingOfferReceived;
  //     case 'my_offering_offer' :
  //       return RouteTo.myOfferingOfferReceived;
  //     case 'my_service_offer' :
  //       return RouteTo.myServiceOfferReceived;
  //     case 'my_unlisted_offer' :
  //       return RouteTo.myUnlistedOffers;
  //     case 'my_request_accept' :
  //       return RouteTo.myRequestsActivities;
  //     case 'my_request_cancel' :
  //       return RouteTo.myRequestsActivities;
  //     case 'friend_request_received' :
  //       return RouteTo.requestFriendReceive;
  //     case 'other_user_profile' :
  //       return RouteTo.friendsProfile;
  //     case 'chat_screen' :
  //       return RouteTo.chatScreen;
  //     case 'my_hosting_accepted' :
  //       return RouteTo.myHosting;
  //     case 'my_offering_accepted' :
  //       return RouteTo.myOffering;
  //     case 'my_services_accepted' :
  //       return RouteTo.myService;
  //     case 'my_profile' :
  //       return RouteTo.dashboard;
  //     default:
  //       return RouteTo.dashboard;
  //   }
  // }
}
