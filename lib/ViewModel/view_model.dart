import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_memo_app/Enum/edit_memo_type.dart';
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
      List<UserData> userList = await _database.getFriendUsers();
      friendList.add(userList);
    });
  }

  factory ViewModel() => _instance;

  final _database = DatabaseManager();
  BehaviorSubject<List<Memo>> myMemoList = BehaviorSubject<List<Memo>>.seeded([]);
  BehaviorSubject<List<Memo>> friendsMemoList = BehaviorSubject<List<Memo>>.seeded([]);
  BehaviorSubject<User?> userData = BehaviorSubject<User?>.seeded(null);
  BehaviorSubject<List<UserData>> friendList = BehaviorSubject<List<UserData>>.seeded([]);

  BehaviorSubject<String> memoText = BehaviorSubject<String>.seeded('');
  BehaviorSubject<Memo?> memo = BehaviorSubject<Memo?>.seeded(null);
}

extension MemoActions on ViewModel {
  // Future<void> memoEditButtonClicked(EditMemoType memoType) async {
  //   switch (memoType) {
  //     case EditMemoType.add:
  //       return await addDatabase();
  //     case EditMemoType.edit:
  //       return await updateMemoData();
  //     case EditMemoType.shareData:
  //       return await updateFriendMemoData();
  //   }
  // }

  // Future<void> addDatabase() async {
  //   await _database.addData(memoText.value);
  //   await _updateDatabase();
  // }
  //
  // Future<void> updateMemoData() async {
  //   if (memo.value == null) {
  //     return;
  //   }
  //   await _database.updateMemoData(memo.value!);
  //   await _updateDatabase();
  // }
  //
  // Future<void> updateFriendMemoData() async {
  //   if (memo.value == null) {
  //     return;
  //   }
  //   await _database.updateFriendMemoData(memo.value!);
  //   await _updateDatabase();
  // }
  //
  // Future<void> enterMemo() async {
  //   if (memo.value == null) {
  //     return;
  //   }
  //   await _database.enterMemo(memo.value!);
  //   await _updateDatabase();
  // }

  Future<void> addDatabase(String text) async {
    await _database.addData(text);
    await _updateDatabase();
  }

  Future<void> updateMemoData(Memo memo) async {
    await _database.updateMemoData(memo);
    await _updateDatabase();
  }

  Future<void> updateFriendMemoData(Memo memo) async {
    await _database.updateFriendMemoData(memo);
    await _updateDatabase();
  }

  Future<void> enterMemo(Memo memo) async {
    await _database.enterMemo(memo);
    await _updateDatabase();
  }

  Future<void> _updateDatabase() async {
    List<Memo> memo = await _database.getMemoData();
    myMemoList.add(memo);
    memo = await _database.getFriendsMemoData();
    friendsMemoList.add(memo);
  }

  Future<void> updateMemoState(String id) async {
    await _database.updateMemoState(id);
    await _updateDatabase();
  }

  Future<void> shareMemoUser(Memo memo, String uid) async {
    await _database.shareMemo(memo, uid);
    await _updateDatabase();
  }
}