import 'dart:developer';
import 'package:lami_tag/model/data.dart';

class ConverterService {
  static final ConverterService _singleton = ConverterService._internal();

  factory ConverterService() {
    return _singleton;
  }

  ConverterService._internal() {
    // loadLamiData();
  }





  double getAdjustedValue(double height, String selectedUnit, List<LamiData>? lamiData) {
    selectedUnit = selectedUnit.toLowerCase();

    log('Trying to find the adjustment factor $selectedUnit $height');

    double heightInCm;
    switch (selectedUnit) {
      case 'hands':
        heightInCm = height * 10.16; // 1 hand = 10.16 cm
        break;
      case 'inches':
        heightInCm = height * 2.54; // 1 inch = 2.54 cm
        break;
      case 'cm':
        heightInCm = height;
        break;
      default:

        throw 'Invalid unit: $selectedUnit';
    }

    // Find the closest horse data based on height
    LamiData closestData = lamiData!.first;
    double minDiff = (closestData.cm - heightInCm).abs();
    for (var data in lamiData) {
      double diff = (data.cm - heightInCm).abs();
      if (diff < minDiff) {
        closestData = data;
        minDiff = diff;
      }
    }
    return closestData.adjustment;
  }

  bool validateHeight(double height, String selectedUnit, List<LamiData>? lamiData) {

    selectedUnit = selectedUnit.toLowerCase();


    switch (selectedUnit) {

      case 'hands':
        return height >= lamiData!.first.hands &&
            height <= lamiData.last.hands;
      case 'inches':
        return height >= lamiData!.first.inches &&
            height <= lamiData.last.inches;
      case 'cm':
        return height >= lamiData!.first.cm &&
            height <= lamiData.last.cm;
      default:
        throw 'Invalid unit: $selectedUnit';
    }
  }
}
