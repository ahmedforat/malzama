// this class is to format the date to handle the representation of posted at
// for different usecases
// such as notifications,posts,messages et cetera

class CustomDate{
  int year,month,day,hour,minute,second;
  CustomDate({
    this.year,this.month,this.day,this.hour,this.minute,this.second
  });

  Map<String,dynamic> toJson() => {
    'year':year,
    'month':month,
    'day':day,
    'hour':hour,
    'minute':minute
  };
  CustomDate.fromDateTime(DateTime date):
        this.year = date.year,
        this.month = date.month,
        this.day = date.day,
        this.hour = date.hour,
        this.minute = date.minute,
        this.second = date.second;

    // this method get the difference between the current date and the passed date
   CustomDate  _getDateDifference(DateTime date){
     DateTime now = DateTime.now();
    CustomDate customDate = new CustomDate();
    customDate.year = now.year - date.year;
    customDate.month = now.month - date.month;
    customDate.day = now.day - date.day;
    customDate.hour = now.hour - date.hour -3;
    customDate.minute = now.minute - date.minute;
    customDate.second = now.second - date.second;

    return customDate;
  }

  // this method get the best representation of the posted at
  String getPostedAt(DateTime date){
    CustomDate myDate = _getDateDifference(date);
    print('=============================================');
    print(myDate.toJson());
    print('================================================');
    if(myDate.year >= 1)
      return '${myDate.year} ' + (myDate.year > 1 ? 'years':'year') + ' ago';
    else if (myDate.month >= 1)
      return '${myDate.month} ' + (myDate.month > 1 ? 'months':'month') + ' ago';
    else if(myDate.day >= 1)
      return '${myDate.day} ' + (myDate.day > 1 ? 'days':'day') + ' ago';
    else if (myDate.hour >= 1)
      return '${myDate.hour} ' + (myDate.hour > 1 ? 'hours':'hour') + ' ago';
    else if (myDate.minute >= 1)
      return '${myDate.minute} ' + (myDate.minute > 1 ? 'minutes':'minute') + ' ago';
    else return 'now';
  }
}