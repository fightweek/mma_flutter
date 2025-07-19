class DataUtils{
  static DateTime stringToDateTime(String value){
    return DateTime.parse(value);
  }

  static String formatDurationToHHMM(Duration duration){
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours.toString().padLeft(2,'0')}:${minutes.toString().padLeft(2,'0')}';
  }

  static String formatDateTime(DateTime datetime){
    return '${datetime.year}.${datetime.month}.${datetime.day}';
  }
}