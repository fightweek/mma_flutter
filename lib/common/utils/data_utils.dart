class DataUtils {
  static DateTime stringToDateTime(String value) {
    return DateTime.parse(value);
  }

  static String formatDurationToHHMM(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  static String formatDateTime(DateTime datetime) {
    return '${datetime.year}.${datetime.month.toString().padLeft(2, '0')}.${datetime.day.toString().padLeft(2, '0')}';
  }

  static String formatDateTimeWithNWI(DateTime datetime) {
    return '${datetime.year}년 ${datetime.month.toString().padLeft(2, '0')}월 ${datetime.day.toString().padLeft(2, '0')}일';
  }

  static String extractLastName(String name) {
    if (name.contains(' ')) {
      List<String> names = name.split(' ');
      return names.sublist(1).join(' ');
    }
    return name;
  }
}
