import 'package:flutter/cupertino.dart';

abstract class BaseUploadingModel{
  String key;
  BaseUploadingModel.fromJSON(Map map);
  Map<String,dynamic> toJSON();
  Map<String,dynamic> getCommentRelatedData();

  List<String> get comments;
  String get comments_collection;
  String get material_collection;
  String get material_type;
  String get material_id;
  Map<String,dynamic> get author;

}


abstract class BaseStateProvider with ChangeNotifier{
  List<BaseUploadingModel> get materialItems;
  void setState();
}

