import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationModel {
   String id;
   String title;
   String body;
   Map<String, dynamic> userId;
   String type;
   String? image;
   Map<String, dynamic> data;
   bool isRead;
   bool isDelivered;
   DateTime? deliveredAt;
   DateTime? sentTime;

   NotificationModel({
      required this.id,
      required this.title,
      required this.body,
      required this.userId,
      required this.type,
      this.image,
      required this.data,
      this.isRead = false,
      this.isDelivered = false,
      this.deliveredAt,
      this.sentTime,
   });

   factory NotificationModel.fromJson(Map<String, dynamic> json) {
      return NotificationModel(
         id: json['_id'] ?? '',
         title: json['title'] ?? '',
         body: json['body'] ?? '',
         userId: json['userId'] is Map<String, dynamic> ? json['userId'] : {},
         type: json['type'] ?? '',
         image: json['image'],
         data: json['data'] is Map<String, dynamic> ? json['data'] : {},
         isRead: json['isRead'] ?? false,
         isDelivered: json['isDelivered'] ?? false,
         deliveredAt: json['deliveredAt'] != null
             ? DateTime.tryParse(json['deliveredAt'])
             : null,
         sentTime: json['createdAt'] != null
             ? DateTime.tryParse(json['createdAt'])
             : null,
      );
   }

   Map<String, dynamic> toJson() {
      return {
         '_id': id,
         'title': title,
         'body': body,
         'userId': userId,
         'type': type,
         'image': image,
         'data': data,
         'isRead': isRead,
         'isDelivered': isDelivered,
         'deliveredAt': deliveredAt?.toIso8601String(),
         'createdAt': sentTime?.toIso8601String(),
      };
   }

   factory NotificationModel.fromRemoteMessage(RemoteMessage message) {
      return NotificationModel(
         id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
         title: message.notification?.title ?? '',
         body: message.notification?.body ?? '',
         userId: message.data['userId'] is Map<String, dynamic>
             ? message.data['userId']
             : {},
         type: message.data['type'] ?? 'alert',
         image: message.data['image'],
         data: message.data,
         isRead: false,
         isDelivered: true,
         deliveredAt: DateTime.now(),
         sentTime: message.sentTime ?? DateTime.now(),
      );
   }
}