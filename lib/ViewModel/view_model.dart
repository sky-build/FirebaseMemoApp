import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_memo_app/Model/user_data.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_memo_app/Model/memo.dart';
import 'package:firebase_memo_app/database/database_manager.dart';

class ViewModel {

  static final _instance = ViewModel._internal();
  ViewModel._internal() {
    _updateDatabase();
    myMemoList.listen((value) {
      print('값 변경');
    });

    _database.userValue.listen((value) {
      print('사용자 데이터가 변경되었다');
      userData.value = value;
      _updateDatabase();
    });

    FirebaseFirestore.instance.collection('memo').snapshots().listen((event) async {
      _updateDatabase();
    });
  }

  factory ViewModel() => _instance;

  final _database = DatabaseManager();
  BehaviorSubject<List<Memo>> myMemoList = BehaviorSubject<List<Memo>>.seeded([]);
  BehaviorSubject<List<Memo>> friendsMemoList = BehaviorSubject<List<Memo>>.seeded([]);
  BehaviorSubject<User?> userData = BehaviorSubject<User?>.seeded(null);
  BehaviorSubject<List<UserData>> friendList = BehaviorSubject<List<UserData>>.seeded([]);
}

extension MemoActions on ViewModel {
  Future<void> _updateDatabase() async {
    List<Memo> memo = await _database.getMemoData();
    myMemoList.add(memo);
    memo = await _database.getFriendsMemoData();
    friendsMemoList.add(memo);
    List<UserData> userList = await _database.getFriendUsers();
    friendList.add(userList);
  }
}