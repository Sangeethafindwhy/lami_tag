import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lami_tag/app_base_states/app_base_states.dart';
import 'package:lami_tag/model/equine.dart';
import 'package:lami_tag/model/record.dart';
import 'package:lami_tag/res/lami_colors.dart';
import 'package:lami_tag/services/blue_service.dart';
import 'package:lami_tag/services/converter_service.dart';
import 'package:lami_tag/services/equine_record_service.dart';
import 'package:lami_tag/services/storage_service.dart';

class EquineReadingCubit extends Cubit<AppBaseState> {
  final BuildContext context;
  final Equine equine;

  EquineReadingCubit({required this.context, required this.equine})
      : super(AppBaseState.idle()) {
    findAdjustmentFactor();
    blueService.$reading.listen((value) async {
      if (heartbeatRecords.length < 60) {
        heartbeatRecords.add(value);
      } else {
        await saveAverageHeartRate();
        heartbeatRecords.clear();
      }
    });
  }

  final StorageService storageService = StorageService();
  final blueService = BlueService();
  final converterService = ConverterService();
  final equineRecordService = EquineRecordService();

  List<int> heartbeatRecords = [];

  Future<void> saveAverageHeartRate() async {
    double average =
        heartbeatRecords.reduce((a, b) => a + b) / heartbeatRecords.length;
    DocumentReference documentReference =
        await storageService.addNewReading(equine.id, average.toInt());

    DocumentSnapshot snapshot = await documentReference.get();

    EquineRecord equineRecord = EquineRecord.fromJson(
        snapshot.data() as Map<String, dynamic>, snapshot.id);

    updateReading(equineRecord);
  }

  updateReading(EquineRecord equineRecord) async {
    List<EquineRecord> equineRecords =
        equineRecordService.$equineRecords.value;

    equineRecords.add(equineRecord);

    equineRecordService.$equineRecords.add(equineRecords);

  }

  Future<void> findAdjustmentFactor() async {
    double value = converterService.getAdjustedValue(
        double.parse(equine.height), equine.unit, storageService.lamiData!);

    blueService.updateAdjustmentFactor(value);
  }

  Color decideColor(int rate) {
    switch (equine.type.toLowerCase()) {
      case 'pony':
        if (rate <= 45) {
          return LamiColors.green;
        } else if (rate <= 49) {
          return LamiColors.orange;
        } else {
          return LamiColors.red;
        }
      case 'horse':
        if (rate <= 40) {
          return LamiColors.green;
        } else if (rate <= 45) {
          return LamiColors.orange;
        } else {
          return LamiColors.red;
        }
      case 'donkey':
        if (rate <= 68) {
          return LamiColors.green;
        } else if (rate <= 74) {
          return LamiColors.orange;
        } else {
          return LamiColors.red;
        }
      default:
        return LamiColors.green;
    }
  }
}
