final List<String> weekdays = ['일','월', '화', '수', '목', '금', '토'];

String convertDateString (DateTime time, bool isLinearString) {
  int month = time.month;
  int day = time.day;
  String weekDay = weekdays[time.weekday];
  String amPm = time.hour / 12 < 1 ? "오전" : "오후";
  int hour = time.hour % 12;
  int minute = time.minute;

  String hourStr = hour < 10 ? '0$hour' : hour.toString();
  String minuteStr = minute < 10 ? '0$minute' : minute.toString();


  return "$month월 $day일 ($weekDay)${!isLinearString ? '\n' : ' '}$amPm ${(amPm == '오후' && hour == 0) ? 12 : hourStr}:$minuteStr";
}