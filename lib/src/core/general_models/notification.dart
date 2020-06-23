class Notification {
  String title;
  String body;
  bool isOpened = false;
  DateTime sentAt;
  String id;
  Map<String, dynamic> data;

  Notification({
    this.title,
    this.body,
    this.sentAt,
    this.id,
    this.data
  });

 Map<String,dynamic> asHashMap() => {
   'id':this.id,
   'title':this.title,
   'body':this.body,
   'isOpened':this.isOpened,
   'sentAt':this.sentAt.toString(),
   'data':this.data
 };
}
