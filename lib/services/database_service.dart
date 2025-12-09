// import 'dart:developer';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/services.dart';
// import 'package:lami_tag/res/lami_images.dart';
// import 'package:sqflite/sqflite.dart';
//
// class DatabaseService {
//   static final DatabaseService _singleton = DatabaseService._internal();
//
//   factory DatabaseService() {
//     return _singleton;
//   }
//
//   DatabaseService._internal() {
//     // uploadDatabaseToFireStore();
//   }
//
//
//
//   // String _assetsPath = "assets/lami_database.db";
//   String _sizesCollection = "sizes";
//   String _breedsCollectionPrefix = "breeds_";
//
//   Future<Database> _openDatabase() async {
//     final databasePath = await getDatabasesPath();
//     final dbPath = "$databasePath/lami_database.db";
//
//     // Copy database from assets if it doesn't exist
//     final byteData = await rootBundle.load(LamiFiles.lamiDatabase);
//     await File(dbPath).writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
//
//     return await openDatabase(dbPath);
//   }
//
//   Future<void> _uploadSizesData(Database database, FirebaseFirestore firestore) async {
//     final results = await database.query("sizes");
//     final collection = firestore.collection(_sizesCollection);
//
//     for (final row in results) {
//       await collection.add(row);
//     }
//   }
//
//   Future<void> _uploadBreedsData(Database database, FirebaseFirestore firestore) async {
//     log('Running the loop ==> 1');
//     List<Map<String, dynamic>> breedsTable = await database.query("breeds");
//     List<String> horse = [];
//     List<String> pony = [];
//     List<String> donkey = [];
//     for (var element in breedsTable) {
//       if(element["horse"] != null) {
//         horse.add(element["horse"]);
//       }
//       if(element["pony"] != null) {
//         pony.add(element["pony"]);
//       }
//       if(element["donkey"] != null) {
//         donkey.add(element["donkey"]);
//       }
//     }
//     await firestore.collection('horse').add({"horse": horse});
//     await firestore.collection('pony').add({"pony": pony});
//     await firestore.collection('donkey').add({"donkey": donkey});
//
//     log('Running the loop ==> 5');
//   }
//
//   Future<void> uploadDatabaseToFireStore() async {
//     final database = await _openDatabase();
//     final firestore = FirebaseFirestore.instance;
//
//     // await _uploadSizesData(database, firestore);
//     await _uploadBreedsData(database, firestore);
//
//     await database.close();
//     print("Database upload complete!");
//   }
// }
