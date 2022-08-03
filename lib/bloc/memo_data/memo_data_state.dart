import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_memo_app/repository/memo.dart';
import 'package:firebase_memo_app/database/database_manager.dart';

enum UserLoginState { none, login, logout }

class MemoDataState {
  MemoDataState() {
    _updateDatabase();

    _database.userValue.listen((value) {
      userData.sink.add(value);
      _updateDatabase();
      if (value != null) {
        userState.sink.add(UserLoginState.login);
      } else {
        userState.sink.add(UserLoginState.logout);
      }
    });

    FirebaseFirestore.instance.collection('memo').snapshots().listen((event) async {
      _updateDatabase();
    });
  }

  final _database = DatabaseManager();
  final myMemoList = BehaviorSubject<List<Memo>>.seeded([]);
  final friendsMemoList = BehaviorSubject<List<Memo>>.seeded([]);
  final requestMemoList = BehaviorSubject<List<Memo>>.seeded([]);
  final userData = BehaviorSubject<User?>.seeded(null);
  final userState = BehaviorSubject<UserLoginState>.seeded(UserLoginState.none);
}

extension MemoActions on MemoDataState {
  Future<void> _updateDatabase() async {
    List<Memo> memo = await _database.getMyMemoData();
    myMemoList.sink.add(memo);
    memo = await _database.getFriendsMemoData();
    friendsMemoList.sink.add(memo);
    memo = await _database.getRequestMemoData();
    requestMemoList.sink.add(memo);
  }
}

extension ShareMemoActions on MemoDataState {
  Future<void> requestMemoData(Memo memo, String uid) async {
    await _database.requestMemo(memo, uid);
  }

  Future<bool> responseMemoData(Memo memo, bool isAccept) async {
    return await _database.responseMemo(memo, isAccept);
  }
}