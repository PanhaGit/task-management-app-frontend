class NotificationModel {
   String title;
   String body;
   String userId;
   Map<String, dynamic> data;
   bool isRead;

   NotificationModel({
      required this.title,
      required this.body,
      required this.userId,
      required this.data,
      this.isRead = false,
   });


   factory NotificationModel.fromJson(Map<String, dynamic> json) {
      return NotificationModel(
         title: json['title'] ?? '',
         body: json['body'] ?? '',
         userId: json['userId'] ?? '',
         data: json['data'] ?? {},
         isRead: json['isRead'] ?? false,
      );
   }


   Map<String, dynamic> toJson() {
      return {
         'title': title,
         'body': body,
         'userId': userId,
         'data': data,
         'isRead': isRead,
      };
   }
}
