import 'package:rxdart/rxdart.dart';

class SessionManagementService {
  static final SessionManagementService _singleton =
      SessionManagementService._internal();

  factory SessionManagementService() {
    return _singleton;
  }

  SessionManagementService._internal() {
    // checkNotifications();
  }



  BehaviorSubject<bool> $hasNotifications = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<String> $profileImagePath =
      BehaviorSubject<String>.seeded('');


  String userIdValue = '';
  String emailValue = '';


  final String userId = 'userId';
  final String email = 'email';


  final String totalDoneTaskCount = 'totalDoneTaskCount';
  final String totalDoneTaskMinutes = 'totalDoneTaskMinutes';



}
