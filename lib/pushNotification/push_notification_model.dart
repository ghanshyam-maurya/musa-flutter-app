// To parse this JSON data, do
//
//     final notificationData = notificationDataFromJson(jsonString);

import 'dart:convert';

PushNotificationData notificationDataFromJson(String str) => PushNotificationData.fromJson(json.decode(str));

String notificationDataToJson(PushNotificationData data) => json.encode(data.toJson());

class PushNotificationData {
    String? id;
    String? notificationScreen;
    String? commonName;
    String? myUnlistedType;
    String? chatType;
    String? contextualId;
    String? contextualName;
    String? contextualImage;
    String? contextualPrice;
    String? listeningType;
    String? senderId;
    String? receiverId;
    

    PushNotificationData({
        this.id,
        this.notificationScreen,
        this.commonName,
        this.myUnlistedType,
        this.chatType,
        this.contextualId,
        this.contextualName,
        this.contextualImage,
        this.contextualPrice,
        this.listeningType,
        this.senderId,
        this.receiverId
    });

    PushNotificationData copyWith({
        String? id,
        String? notificationScreen,
        String? commonName,
        String? myUnlistedType,
        String? chatType,
        String? contextualId,
        String? contextualName,
        String? contextualImage,
        String? contextualPrice,
        String? listeningType,
        String? senderId,
        String? receiverId
    }) => 
        PushNotificationData(
            id: id ?? this.id,
            notificationScreen: notificationScreen ?? this.notificationScreen,
            commonName: commonName ?? this.commonName,
            myUnlistedType: myUnlistedType ?? this.myUnlistedType,
            chatType: chatType ?? this.chatType,
            contextualId: contextualId ?? this.contextualId,
            contextualName: contextualName ?? this.contextualName,
            contextualImage: contextualImage ?? this.contextualImage,
            contextualPrice: contextualPrice ?? this.contextualPrice,
            listeningType: listeningType ?? this.listeningType,
            senderId: senderId ?? this.senderId,
            receiverId: receiverId ?? this.receiverId
        );

    factory PushNotificationData.fromJson(Map<String, dynamic> json) => PushNotificationData(
        id: json["id"],
        notificationScreen: json["notification_screen_redirection"],
        commonName: json["name"],
        myUnlistedType: json["my_unlisted_type"],
        chatType: json["chat_type"],
        contextualId: json["contextual_id"],
        contextualName: json["contextual_name"],
        contextualImage: json["contextual_image"],
        contextualPrice: json["contextual_price"],
        listeningType: json["listening_type"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "module_type": notificationScreen,
        "name": commonName,
        "my_unlisted_type": myUnlistedType,
        "chat_type": chatType,
        "contextual_id": contextualId,
        "contextual_name": contextualName,
        "contextual_image": contextualImage,
        "contextual_price": contextualPrice,
        "listening_type": listeningType
    };
}
