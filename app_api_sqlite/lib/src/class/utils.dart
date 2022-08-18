class Utils{

  static String strDateTime(){
    DateTime now = DateTime.now();
    String dateTime = "${now.year.toString()}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')} ${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}";
    return dateTime;
  }

}