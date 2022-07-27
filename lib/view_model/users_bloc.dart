import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_memo_app/database/database_manager.dart';
import 'package:firebase_memo_app/repository/user_data.dart';
import 'package:rxdart/rxdart.dart';

class UsersBloc {
  static final _instance = UsersBloc._internal();
  UsersBloc._internal() {
    FirebaseFirestore.instance.collection('user').snapshots().listen((event) {
      updateFriendList();
    });
  }
    final _database = DatabaseManager();

  factory UsersBloc() => _instance;
  
  BehaviorSubject<List<UserData>> friendList = BehaviorSubject<List<UserData>>.seeded([]);

  void updateFriendList() async {
    List<UserData> userList = await _database.getFriendUsers();
    friendList.sink.add(userList);
  }

  Stream<List<UserData>> getFriendList() {
    return friendList.stream;
  }

  int getFriendCount() {
    return friendList.value.length;
  }

  UserData getFriendByIndex(int index) {
    return friendList.value[index];
  }
}

