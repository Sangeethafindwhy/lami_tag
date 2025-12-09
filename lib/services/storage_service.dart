import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lami_tag/model/data.dart';
import 'package:lami_tag/model/user.dart';
import 'package:rxdart/rxdart.dart';

class StorageService {
  static final StorageService _singleton = StorageService._internal();

  factory StorageService() {
    return _singleton;
  }

  StorageService._internal() {
    loadLamiData();
  }

  final FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  BehaviorSubject<UserProfile> $userProfile = BehaviorSubject<UserProfile>();
  BehaviorSubject<List<String>?> $availableBreeds = BehaviorSubject<List<String>>();

  List<LamiData>? lamiData;


  Future<void> addUserData(String id, String email) async {
    firebaseFireStore.collection('users').doc(id).set({
      'uid': id,
      'email': email,
      'created_on': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> createUserProfile(String id, String name, String role) async {
    await firebaseFireStore.collection('users').doc(id).update({
      'name': name,
      'role': role,
    });
  }

  Future<void> updateUserProfileImage(String id, String imageURL) async {
    firebaseFireStore.collection('users').doc(id).update({
      'imageURL': imageURL,
    });
  }

  Future<void> updateEquineProfileImage(String id, String imageURL) async {
    firebaseFireStore.collection('equines').doc(id).update({
      'imageURL': imageURL,
    });
  }

  Future<void> deleteData() async {}

  Future<String> uploadImage(String imagePath, String uid,
      {String imageType = 'profile'}) async {
    try {
      String fileName =
          '${imageType}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      // Upload image to Firebase Storage
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child('$imageType/$fileName')
          .putFile(File(imagePath));

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<DocumentReference> createEquineProfile(String userId, String name,
      String type, String height, String unit, String breed) async {
    try {
      return firebaseFireStore.collection('equines').add({
        'creator_id': userId,
        'equine_name': name,
        'type': type,
        'height': height,
        'unit': unit,
        'breed': breed,
        'created_on': DateTime.now().millisecondsSinceEpoch,
      });
    } on FirebaseException catch (e) {
      throw e.code;
    } catch (e) {
      throw "Failed to add equine";
    }
  }

  Future<DocumentSnapshot> updateEquineProfile(String equineId, String name,
      String type, String height, String unit, String breed) async {
    try {
      await firebaseFireStore.collection('equines').doc(equineId).update({
        'equine_name': name,
        'type': type,
        'height': height,
        'unit': unit,
        'breed': breed,
      });
      DocumentSnapshot updatedDocument = await firebaseFireStore.collection('equines').doc(equineId).get();
      return updatedDocument;
    } on FirebaseException catch (e) {
      throw e.code;
    } catch (e) {
      throw "Failed to add equine";
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getMyEquines(
      String userId) async {
    return await firebaseFireStore
        .collection('equines')
        .where('creator_id', isEqualTo: userId)
        .get();
  }

  Future<void> getCurrentUser(String userId) async {
    DocumentSnapshot snapshot =
        await firebaseFireStore.collection('users').doc(userId).get();

    try{
      UserProfile userProfile = UserProfile.fromJson(
          snapshot.data() as Map<String, dynamic>, snapshot.id);

      $userProfile.add(userProfile);
    }catch(e){
      rethrow;
    }
  }

  Future<DocumentReference> addNewReading(String equineId, int reading) async {
    try {
      return firebaseFireStore.collection('records').add({
        'equine_id': equineId,
        'reading': reading,
        'created_on': DateTime.now().millisecondsSinceEpoch,
      });
    } on FirebaseException catch (e) {
      throw e.code;
    } catch (e) {
      throw "Failed to add equine";
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getReadings(
      String equineId, DateTime startTime) async {
    try {
      return await firebaseFireStore
          .collection('records')
          .where('equine_id', isEqualTo: equineId)
          .where('created_on',
              isGreaterThanOrEqualTo: startTime.millisecondsSinceEpoch)
          .get();
    } on FirebaseException catch (e) {
      throw "FirebaseException: ${e.code} - ${e.message}";
    } catch (e) {
      throw "Failed to retrieve equine readings: $e";
    }
  }

  Future<void> loadLamiData() async {
    try {
      QuerySnapshot snapshot =
          await firebaseFireStore.collection('sizes').get();
      lamiData = snapshot.docs.map((doc) {
        return LamiData.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      lamiData!.sort((a,b) => a.hands.compareTo(b.hands));
    } on FirebaseException catch (e) {
      throw "FirebaseException: ${e.code} - ${e.message}";
    } catch (e) {
      throw "Failed to retrieve equine sizes: $e";
    }
  }

  Future<void> loadBreedTypes(String breedType) async {
    try {
      log('This is $breedType');
      QuerySnapshot snapshot = await firebaseFireStore.collection(breedType).get();
      //
      for (var element in snapshot.docs) {
        List<String> updatedBreeds = [];
        element.get(breedType).toString().replaceAll('[', '').replaceAll(']', '').split(',').forEach((element){
          updatedBreeds.add(element);
        });
        $availableBreeds.add(updatedBreeds);
      }
      //
    } on FirebaseException catch (e) {
      throw "FirebaseException: ${e.code} - ${e.message}";
    } catch (e) {
      throw "Failed to retrieve equine sizes: $e";
    }
  }

}
