import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lami_tag/services/snack_service.dart';
import 'package:rxdart/subjects.dart';

class BlueService {
  static final BlueService _singleton = BlueService._internal();

  factory BlueService() {
    return _singleton;
  }

  BlueService._internal() {
    initializeBlueService();
  }

  BehaviorSubject<BluetoothAdapterState> $blueToothState =
  BehaviorSubject<BluetoothAdapterState>();

  final SnackService snackService = SnackService();

  BehaviorSubject<bool> $isConnected = BehaviorSubject<bool>.seeded(false);


  BehaviorSubject<double> $factor =
  BehaviorSubject<double>.seeded(0.0);

  BehaviorSubject<int> $reading = BehaviorSubject<int>();


  BehaviorSubject<List<BluetoothDevice>> $bluetoothDevices =
  BehaviorSubject<List<BluetoothDevice>>();

  BehaviorSubject<List<ScanResult>> $bluetoothScannedDevices =
  BehaviorSubject<List<ScanResult>>();

  Future<void> initializeBlueService() async {
    FlutterBluePlus.adapterState.listen((event) {
      log('This is previously bluetooth status of phone: $event');
      $blueToothState.add(event);

      if($blueToothState.value == BluetoothAdapterState.on){
        scanAvailableDevices();
      }
    });

    FlutterBluePlus.scanResults.listen((event) {
      $bluetoothScannedDevices.add(event);
    });
  }

  Future<void> updateBluetoothAdapterStatus(BuildContext context) async {
    if ($blueToothState.value == BluetoothAdapterState.turningOn ||
        $blueToothState.value == BluetoothAdapterState.on) {
      //library does not support this feature
      if (Platform.isAndroid) {
        await FlutterBluePlus.turnOff();
        $bluetoothScannedDevices.add([]);
        $isConnected.add(false);
      } else {
        snackService.showSnackBar(
            context: context, message: 'Manually turn OFF Bluetooth');
      }
    } else {
      if (Platform.isAndroid) {
        await FlutterBluePlus.turnOn();
        // await scanAvailableDevices();
      } else {
        snackService.showSnackBar(
            context: context, message: 'Manually turn ON Bluetooth');
      }
    }
  }

  Future<void> scanAvailableDevices() async {
    try {
      List<BluetoothDevice> devices = await FlutterBluePlus.systemDevices([]);
      $bluetoothDevices.add(devices);
    } catch (e) {
      log("System Devices Error: $e");
    }
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      log("Start Scan Error: $e");
    }
  }

  BluetoothDevice? connectedDevice;

  Future<bool> connectWithDevice(BluetoothDevice bluetoothDevice) async {
    connectedDevice = bluetoothDevice;
    await bluetoothDevice.connect();
    if (bluetoothDevice.isConnected) {
      for (var element in bluetoothDevice.servicesList) {
        log('These are service characteristics: ${element.characteristics}');
      }
      return true;
    } else {
      return false;
    }
  }

  void updateReading(int value) async {
    double newValue = value * $factor.value;
    $reading.add(newValue.toInt());
  }

  void updateAdjustmentFactor(double value) async {
    $factor.add(value);
  }

  void disConnectWithDevice() async {
    try {
      await connectedDevice!.disconnect();
      connectedDevice = null;
      $isConnected.add(false);
    } catch (e) {
      log('Not connected with any device');
    }
  }

}
