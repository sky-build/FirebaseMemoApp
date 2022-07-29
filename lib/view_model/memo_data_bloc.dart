import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_memo_app/repository/memo.dart';
import 'package:firebase_memo_app/database/database_manager.dart';

class MemoDataBloc {

  static final _instance = MemoDataBloc._internal();
  MemoDataBloc._internal() {
    _updateDatabase();
    myMemoList.listen((value) {
      print('값 변경');
    });

    _database.userDataChanged().listen((event) {
      userData.sink.add(event);
      _updateDatabase();
    });

    FirebaseFirestore.instance.collection('memo').snapshots().listen((event) async {
      _updateDatabase();
    });
  }

  factory MemoDataBloc() => _instance;

  final _database = DatabaseManager();
  BehaviorSubject<List<Memo>> myMemoList = BehaviorSubject<List<Memo>>.seeded([]);
  BehaviorSubject<List<Memo>> friendsMemoList = BehaviorSubject<List<Memo>>.seeded([]);
  BehaviorSubject<User?> userData = BehaviorSubject<User?>.seeded(null);
}

extension MemoActions on MemoDataBloc {
  Future<void> _updateDatabase() async {
    List<Memo> memo = await _database.getMemoData();
    myMemoList.add(memo);
    memo = await _database.getFriendsMemoData();
    friendsMemoList.add(memo);
  }
}