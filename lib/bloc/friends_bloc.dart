import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_memo_app/database/database_manager.dart';
import 'package:firebase_memo_app/repository/user_data.dart';
import 'package:rxdart/rxdart.dart';

class FriendsBloc {
  static final _instance = FriendsBloc._internal();
  FriendsBloc._internal() {
    // 사용자가 변경되면 friendList업데이트
    FirebaseFirestore.instance.collection('user').snapshots().listen((event) {
      updateFriendList();
    });

    // 인증상태(로그인)가 변경되면 업데이트
    _database.userValue.listen((value) {
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

  Future<String> getFriendEmail(String uid) async {
    return await _database.getUserEmail(uid);
  }
}