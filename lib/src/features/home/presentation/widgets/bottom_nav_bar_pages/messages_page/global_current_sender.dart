
class CurrentSender{
   String id;
   String oneSignalID;

   CurrentSender({this.id,this.oneSignalID});
  bool check(String testID) {
    if(id == null){
      return false;
    }
    return id.compareTo(testID) == 0;
  }
}