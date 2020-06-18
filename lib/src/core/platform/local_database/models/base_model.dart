abstract class BaseUploadingModel{
  String key;
  BaseUploadingModel.fromJSON(Map map);
  Map<String,dynamic> toJSON();
}