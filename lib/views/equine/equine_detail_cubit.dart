import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lami_tag/app_base_states/app_base_states.dart';
import 'package:lami_tag/model/equine.dart';
import 'package:lami_tag/model/record.dart';
import 'package:lami_tag/services/blue_service.dart';
import 'package:lami_tag/services/email_service.dart';
import 'package:lami_tag/services/equine_record_service.dart';
import 'package:lami_tag/services/storage_service.dart';
import 'package:lami_tag/services/time_service.dart';
import 'package:lami_tag/services/validation_services.dart';
import 'package:rxdart/rxdart.dart';

class EquinesDetailCubit extends Cubit<AppBaseState> {
  final BuildContext context;
  final Equine equine;

  EquinesDetailCubit({required this.context, required this.equine})
      : super(AppBaseState.idle()) {
    updateGraphType(10);
    //
  }

  final StorageService storageService = StorageService();
  final blueService = BlueService.instance;
  final emailService = EmailService();
  final validationServices = ValidationServices();
  final timeService = TimeService();
  final equineRecordService = EquineRecordService();

  final shareFormKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  BehaviorSubject<int> $selectedGraphType = BehaviorSubject<int>();









  void updateGraphType(int type) async {
    $selectedGraphType.add(type);
    DateTime startTime = DateTime.now();
    switch (type) {
      case 0:
        startTime = startTime.subtract(const Duration(days: 1));
        break;
      case 1:
        startTime = startTime.subtract(const Duration(days: 7));
        break;
      case 2:
        startTime =
            DateTime(startTime.year, startTime.month - 1, startTime.day);
        break;
      case 3:
        startTime =
            DateTime(startTime.year - 1, startTime.month, startTime.day);
        break;
      default:
        startTime = DateTime(2023);
        break;
    }

    QuerySnapshot snapshot =
        await storageService.getReadings(equine.id, startTime);
    List<EquineRecord> newRecords = snapshot.docs.map((doc) {
      return EquineRecord.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
    equineRecordService.$equineRecords.add(newRecords);
  }

}
