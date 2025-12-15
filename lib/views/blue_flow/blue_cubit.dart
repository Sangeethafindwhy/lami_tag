import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lami_tag/app_base_states/app_base_states.dart';
import 'package:lami_tag/services/blue_service.dart';
import 'package:lami_tag/services/storage_service.dart';

class BlueCubit extends Cubit<AppBaseState> {
  final BuildContext context;

  BlueCubit({required this.context}) : super(AppBaseState.idle()) {
    //
  }

  final blueService = BlueService.instance;
  final storageService = StorageService();

  Future<void> connectWithDevice(BluetoothDevice bluetoothDevice) async {
    // The new BlueService automatically handles service discovery,
    // characteristic subscription, and data parsing
    final connected = await blueService.connectWithDevice(bluetoothDevice);
    
    if (!connected) {
      log('Failed to connect');
    }
  }
}
