import 'package:intl/intl.dart';

class TimeService{



  String convertEpochToHumanReadable(int epochTime, {String desiredFormat = 'MMMM-yyyy'}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epochTime);
    DateFormat dateFormat = DateFormat(desiredFormat);
    String humanReadableDate = dateFormat.format(dateTime);
    return humanReadableDate;
  }
}