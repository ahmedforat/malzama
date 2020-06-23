// this class is to format the date to handle the representation of posted at
// for different usecases
// such as notifications,posts,messages et cetera

class CustomDate{
  int year,month,day,hour,minute,second;
  CustomDate({
    this.year,this.month,this.day,this.hour,this.minute,this.second
  });

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
    customDate.hour = now.hour - date.hour;
    customDate.minute = now.minute - date.minute;
    customDate.second = now.second - date.second;

    return customDate;
  }

  // this method get the best representation of the posted at
  String getPostedAt(DateTime date){
    CustomDate myDate = _getDateDifference(date);
    if(myDate.year != 0)
      return '${myDate.year} ' + (myDate.year > 1 ? 'years':'year') + ' ago';
    else if (myDate.month != 0)
      return '${myDate.month} ' + (myDate.month > 1 ? 'months':'month') + ' ago';
    else if(myDate.day != 0)
      return '${myDate.day} ' + (myDate.day > 1 ? 'days':'day') + ' ago';
    else if (myDate.hour != 0)
      return '${myDate.hour} ' + (myDate.hour > 1 ? 'hours':'hour') + ' ago';
    else if (myDate.minute != 0)
      return '${myDate.minute} ' + (myDate.minute > 1 ? 'minutes':'minute') + ' ago';
    else return 'now';
  }
}