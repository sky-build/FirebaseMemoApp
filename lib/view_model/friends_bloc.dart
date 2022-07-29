import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_memo_app/database/database_manager.dart';
import 'package:firebase_memo_app/repository/user_data.dart';
import 'package:rxdart/rxdart.dart';

class FriendsBloc {
  static final _instance = FriendsBloc._internal();
  FriendsBloc._internal() {
    FirebaseFirestore.instance.collection('user').snapshots().listen((event) {
      updateFriendList();
    });
  }
    final _database = DatabaseManager();

  factory FriendsBloc() => _instance;
  
  BehaviorSubject<List<UserData>> friendList = BehaviorSubject<List<UserData>>.seeded([]);
}

extension FriendUserExtension on FriendsBloc {
  void updateFriendList() async {
    final userList = await _database.getFriendUsers();
    friendList.sink.add(userList);
  }

  int getFriendCount() {
    return friendList.value.length;
  }

  UserData getFriendByIndex(int index) {
    return friendList.value[index];
  }
}