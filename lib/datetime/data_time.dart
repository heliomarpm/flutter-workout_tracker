DateTime strToDateTime(String yyyymmdd) {
  int year = int.parse(yyyymmdd.substring(0, 4));
  int month = int.parse(yyyymmdd.substring(4, 6));
  int day = int.parse(yyyymmdd.substring(6, 8));

  return DateTime(year, month, day);
}

String dateTimeToStr(DateTime? dateTime) {
 var dateTimeObject = dateTime?? DateTime.now();

  var year = dateTimeObject.year.toString();
  var month = dateTimeObject.month.toString();
  var day = dateTimeObject.day.toString();

  if (month.length == 1) {
    month = '0$month';
  }

  if (day.length == 1) {
    day = '0$day';
  }

  var yyyymmdd = year + month + day;

  return yyyymmdd;
}
