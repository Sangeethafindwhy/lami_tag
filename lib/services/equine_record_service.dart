import 'package:fl_chart/fl_chart.dart';
import 'package:lami_tag/model/record.dart';
import 'package:lami_tag/services/time_service.dart';
import 'package:rxdart/rxdart.dart';

class EquineRecordService {
  static final EquineRecordService _singleton = EquineRecordService._internal();

  factory EquineRecordService() {
    return _singleton;
  }

  EquineRecordService._internal() {
    $equineRecords.listen((value) {
      updateSpots();
    });
  }

  BehaviorSubject<List<EquineRecord>> $equineRecords =
      BehaviorSubject<List<EquineRecord>>();
  List<String> readings = [];
  BehaviorSubject<List<FlSpot>> $spots = BehaviorSubject<List<FlSpot>>();
  BehaviorSubject<List<String>> $times = BehaviorSubject<List<String>>();
  final timeService = TimeService();

  void updateSpots() {
    List<FlSpot> newSpots = [];
    List<String> newTimes = [];
    readings.clear();
    for (int i = 0; i < $equineRecords.value.length; i++) {
      addNewReadingFromPastData($equineRecords.value[i].createdOn, $equineRecords.value[i].reading);
      newSpots.add(FlSpot((i).toDouble(), $equineRecords.value[i].reading.toDouble()));
      newTimes.add(getTimesForGraph($equineRecords.value[i].createdOn));
    }
    $spots.add(newSpots);
    $times.add(newTimes);
  }

  addNewReadingFromPastData(int time, int reading){
    readings.add('\nTime: ${timeService.convertEpochToHumanReadable(time,desiredFormat: 'dd/MM/yy hh:mm')}-Reading $reading');
  }

  String getTimesForGraph(int time){
    return timeService.convertEpochToHumanReadable(time,desiredFormat: "MMM d'th' yyy\nh: mm a");
  }
}
