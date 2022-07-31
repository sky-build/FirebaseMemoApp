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

    _database.userValue.listen((value) {
      userData.sink.add(value);
      _updateDatabase();
    });

    FirebaseFirestore.instance.collection('memo').snapshots().listen((event) async {
      _updateDatabase();
    });
  }

  factory MemoDataBloc() => _instance;

  final _database = DatabaseManager();
  final myMemoList = BehaviorSubject<List<Memo>>.seeded([]);
  final friendsMemoList = BehaviorSubject<List<Memo>>.seeded([]);
  final requestMemoList = BehaviorSubject<List<Memo>>.seeded([]);
  final userData = BehaviorSubject<User?>.seeded(null);
}

extension MemoActions on MemoDataBloc {
  Future<void> _updateDatabase() async {
    List<Memo> memo = await _database.getMyMemoData();
    myMemoList.sink.add(memo);
    memo = await _database.getFriendsMemoData();
    friendsMemoList.sink.add(memo);
    memo = await _database.getRequestMemoData();
    requestMemoList.sink.add(memo);
  }
}

extension ShareMemoActions on MemoDataBloc {
  Future<void> requestMemoData(Memo memo, String uid) async {
    await _database.requestMemo(memo, uid);
  }

  Future<bool> responseMemoData(Memo memo, bool isAccept) async {
    return await _database.responseMemo(memo, isAccept);
  }
}