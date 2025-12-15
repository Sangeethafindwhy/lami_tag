import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lami_tag/app_base_states/app_base_states.dart';
import 'package:lami_tag/model/equine.dart';
import 'package:lami_tag/services/auth_service.dart';
import 'package:lami_tag/services/blue_service.dart';
import 'package:lami_tag/services/storage_service.dart';
import 'package:rxdart/rxdart.dart';

class EquinesHomeCubit extends Cubit<AppBaseState> {
  final BuildContext context;

  EquinesHomeCubit({required this.context}) : super(AppBaseState.idle()) {
    getAllEquines();
  }

  final authService = AuthService();
  final storageService = StorageService();
  final blueService = BlueService.instance;

  BehaviorSubject<List<Equine>> $equines = BehaviorSubject<List<Equine>>();

  getAllEquines() async {
    emit(AppBaseState.busy());
    storageService.getCurrentUser(authService.firebaseAuth.currentUser!.uid);
    QuerySnapshot snapshot = await storageService
        .getMyEquines(authService.firebaseAuth.currentUser!.uid);
    List<Equine?> equines = snapshot.docs.map((doc) {
      return Equine.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
    updateEquinesList(equines);
    emit(AppBaseState.idle());
  }

  updateEquinesList(List<Equine?> comingEquines, {bool update = false}) async {
    List<Equine> tempEquines = [];
    if (update) {
      tempEquines = $equines.value;
    }
    for (var element in comingEquines) {
      tempEquines.add(element!);
    }
    $equines.add(tempEquines);
  }
}
