import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rxdart/rxdart.dart';

/// Bluetooth service manager for LamiTag (TI CC2541 / CL858 BLE 4.0)
/// Handles scanning, connecting, notifications and value parsing.
class BlueService {
  BlueService._();
  static final BlueService instance = BlueService._();

  // ---- CONFIG ----
  static const String SERVICE_UUID = "FFF0";       // ← replace if different
  static const String CHARACTERISTIC_UUID = "FFF1"; // ← replace if different

  // ---- STATE STREAMS ----
  final $adapterState = BehaviorSubject<BluetoothAdapterState>();
  final $bluetoothDevices = BehaviorSubject<List<BluetoothDevice>>();
  final $bluetoothScannedDevices = BehaviorSubject<List<ScanResult>>();
  final $isConnected = BehaviorSubject<bool>.seeded(false);
  final $reading = BehaviorSubject<double>.seeded(0);
  final $factor = BehaviorSubject<double>.seeded(1.0);

  BluetoothDevice? _connectedDevice;
  StreamSubscription<List<int>>? _notifySub;

  // ---- INITIALISATION ----
  void init() {
    FlutterBluePlus.adapterState.listen($adapterState.add);
    if (FlutterBluePlus.adapterStateNow == BluetoothAdapterState.on) {
      scanAvailableDevices();
    }
  }

  // ---- SCANNING ----
  Future<void> scanAvailableDevices() async {
    final sysDevices = await FlutterBluePlus.systemDevices([]);
    $bluetoothDevices.add(sysDevices);
    $bluetoothScannedDevices.add([]);

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));

    FlutterBluePlus.scanResults.listen((results) {
      $bluetoothScannedDevices.add(results);
    });

    FlutterBluePlus.isScanning.listen((scanning) {
      if (!scanning) FlutterBluePlus.stopScan();
    });
  }

  // ---- CONNECT ----
  Future<bool> connectWithDevice(BluetoothDevice device) async {
    try {
      log('Connecting to ${device.remoteId}');
      await device.connect(autoConnect: false, timeout: const Duration(seconds: 10));
      _connectedDevice = device;
      $isConnected.add(true);

      // Discover services / characteristics
      List<BluetoothService> services = await device.discoverServices();
      for (final s in services) {
        if (s.uuid.toString().toUpperCase().contains(SERVICE_UUID)) {
          for (final c in s.characteristics) {
            if (c.uuid.toString().toUpperCase().contains(CHARACTERISTIC_UUID)) {
              log('Subscribed to ${c.uuid}');
              await c.setNotifyValue(true);
              _notifySub = c.onValueReceived.listen(_onData);
            }
          }
        }
      }

      // Watch for disconnects
      device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.disconnected) {
          _cleanup();
        }
      });

      return true;
    } catch (e, st) {
      log('Connection failed: $e\n$st');
      _cleanup();
      return false;
    }
  }

  // ---- DATA HANDLER ----
  void _onData(List<int> value) {
    try {
      if (value.isEmpty) return;

      final buffer = Uint8List.fromList(value).buffer;
      final byteData = buffer.asByteData();

      // Read both endian orders
      int le = byteData.getUint16(0, Endian.little);
      int be = byteData.getUint16(0, Endian.big);

      // Choose plausible one based on physiological range (20–300 bpm)
      int reading;
      if (le >= 20 && le <= 300 && (be < 20 || be > 300)) {
        reading = le;
      } else if (be >= 20 && be <= 300 && (le < 20 || le > 300)) {
        reading = be;
      } else {
        reading = le; // fallback
      }

      updateReading(reading);
    } catch (e) {
      log('Data parse error: $e');
    }
  }

  // ---- UPDATE READINGS ----
  void updateReading(int value) {
    final adjusted = value * $factor.value;
    $reading.add(adjusted);
  }

  void updateAdjustmentFactor(double factor) => $factor.add(factor);

  // ---- DISCONNECT / CLEANUP ----
  Future<void> disconnect() async {
    if (_connectedDevice != null) {
      try {
        await _connectedDevice!.disconnect();
      } catch (_) {}
    }
    _cleanup();
  }

  void _cleanup() {
    _notifySub?.cancel();
    _notifySub = null;
    _connectedDevice = null;
    $isConnected.add(false);
    log('Disconnected / cleaned up');
  }

  // ---- TEARDOWN ----
  void dispose() {
    $adapterState.close();
    $bluetoothDevices.close();
    $bluetoothScannedDevices.close();
    $isConnected.close();
    $reading.close();
    $factor.close();
  }
}
