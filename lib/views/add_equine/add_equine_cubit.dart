import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lami_tag/app_base_states/app_base_states.dart';
import 'package:lami_tag/model/equine.dart';
import 'package:lami_tag/res/lami_strings.dart';
import 'package:lami_tag/services/auth_service.dart';
import 'package:lami_tag/services/converter_service.dart';
import 'package:lami_tag/services/image_service.dart';
import 'package:lami_tag/services/snack_service.dart';
import 'package:lami_tag/services/storage_service.dart';
import 'package:lami_tag/services/validation_services.dart';
import 'package:lami_tag/views/common/dialogs/select_option.dart';
import 'package:rxdart/rxdart.dart';

class AddEquineCubit extends Cubit<AppBaseState> {
  final BuildContext context;
  final Equine? equine;
  AddEquineCubit({required this.context, this.equine}) : super(AppBaseState.idle()) {
    //
    if(equine != null){
      fetchEquineDetails();
    }
    //
  }

  fetchEquineDetails(){
    equineName.text = equine!.equineName;
    height.text = equine!.height;

    updateEquineType(equine!.type);
    updateEquineBreed(equine!.breed);
    updateEquineImage(equine!.imageURL);
    updateHeightUnit(equine!.unit);

  }

  final validationServices = ValidationServices();
  final addEquineKey = GlobalKey<FormState>();
  final storageService = StorageService();
  final imageService = ImageService();
  final authService = AuthService();
  final converterService = ConverterService();
  // final databaseService = DatabaseService();
  final snackService = SnackService();


  final equineName = TextEditingController();
  final height = TextEditingController();

  BehaviorSubject<String> $selectedEquineType = BehaviorSubject<String>();
  BehaviorSubject<String?> $selectedEquineBreed = BehaviorSubject<String?>();
  BehaviorSubject<String> $selectedHeightUnit = BehaviorSubject<String>();
  BehaviorSubject<String> $equineImage = BehaviorSubject<String>.seeded('');

  updateEquineType(value) {
    $selectedEquineType.add(value);
    updateEquineBreed(null);
    storageService.loadBreedTypes(value.toString().toLowerCase());

  }

  updateEquineBreed(value){
    $selectedEquineBreed.add(value);
  }

  updateHeightUnit(value) {
    $selectedHeightUnit.add(value);
  }

  updateEquineImage(String value) {
    $equineImage.add(value);
  }

  Future<void> addEquine() async {
    emit(AppBaseState.busy());
    try {
      DocumentReference documentReference =
      await storageService.createEquineProfile(
          authService.firebaseAuth.currentUser!.uid,
          equineName.text,
          $selectedEquineType.value,
          height.text,
          $selectedHeightUnit.value,
          $selectedEquineBreed.value!
      );

      await uploadEquineProfileImage(documentReference.id);

      DocumentSnapshot snapshot = await documentReference.get();

      Equine equine = Equine.fromJson(snapshot.data() as Map<String, dynamic>, snapshot.id);

      if(context.mounted){
        Navigator.pop(context, equine);
      }

    } catch (e) {
      log('This is error: ${e.toString()}');
    }

    emit(AppBaseState.idle());
  }

  Future<void> updateEquine() async {
    emit(AppBaseState.busy());
    try {
      await uploadEquineProfileImage(equine!.id);

      DocumentSnapshot snapshot = await storageService.updateEquineProfile(
          equine!.id,
          equineName.text,
          $selectedEquineType.value,
          height.text,
          $selectedHeightUnit.value,
          $selectedEquineBreed.value!
      );

      Equine updatedEquine = Equine.fromJson(snapshot.data() as Map<String, dynamic>, snapshot.id);

      if(context.mounted){
        Navigator.pop(context, updatedEquine);
      }
    } catch (e) {
      log('This is error: ${e.toString()}');
    }

    emit(AppBaseState.idle());
  }


  Future<void> saveEquineData() async {
    bool heightIsValid = converterService.validateHeight(
        double.parse(height.text), $selectedHeightUnit.value, storageService.lamiData!);
    if (!heightIsValid) {
      emit(AppBaseState.idle());
      return snackService.showSnackBar(
          context: context, message: 'Invalid height ${height.text}');
    }
    else{
      if(equine != null){
        await updateEquine();
      }else{
        await addEquine();
      }
    }
  }

  Future<void> uploadEquineProfileImage(String equineId) async {
    if ($equineImage.value.isNotEmpty && !$equineImage.value.contains('http')) {
      try {
        String downloadURL = await storageService.uploadImage(
            $equineImage.value, equineId,
            imageType: 'equine_profile');

        storageService.updateEquineProfileImage(equineId, downloadURL);
      } catch (e) {
        log('Error uploading image: $e');
      }
    }
  }

  selectProfileImage(BuildContext dropDownContext) async {
    int? value = await showSelectionSheet(dropDownContext,
        LamiString.imageSourceOptions, [Icons.camera_alt, Icons.photo_library]);

    if (value != null) {
      File? imageFile = await imageService.pickImage(
          imageSource: value == 0 ? ImageSource.camera : ImageSource.gallery);
      if (imageFile != null) {
        updateEquineImage(imageFile.path);
      }
    }
  }
}
