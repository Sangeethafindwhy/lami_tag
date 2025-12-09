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

  final blueService = BlueService();
  final storageService = StorageService();

  Future<void> connectWithDevice(BluetoothDevice bluetoothDevice) async {
    blueService.$isConnected
        .add(await blueService.connectWithDevice(bluetoothDevice));

    if (blueService.$isConnected.value) {
      try {
        await bluetoothDevice.discoverServices();
        for (var newElement in bluetoothDevice.servicesList) {
          if (newElement.characteristics.length == 2) {
            for (var characteristic in newElement.characteristics) {
              if (characteristic.descriptors.isNotEmpty) {
                characteristic.setNotifyValue(true);
                characteristic.lastValueStream.listen((event) {
                  try {
                    blueService.updateReading(event.last);
                  } catch (e) {
                    //
                  }
                });
              } else {
                // characteristic.setNotifyValue(true);
              }
            }
            //
          } else {
            //
          }
        }
      } catch (e) {
        //
      }
    } else {
      log('Failed to connect');
    }
  }
}
