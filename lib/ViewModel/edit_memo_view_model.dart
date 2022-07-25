import 'package:firebase_memo_app/Enum/edit_memo_type.dart';
import 'package:firebase_memo_app/Model/memo.dart';
import 'package:firebase_memo_app/database/database_manager.dart';
import 'package:rxdart/rxdart.dart';

class EditMemoViewModel {

  static final _instance = EditMemoViewModel._internal();
  EditMemoViewModel._internal();

  factory EditMemoViewModel() => _instance;

  final _database = DatabaseManager();
  BehaviorSubject<String> memoData = BehaviorSubject<String>.seeded('');
  BehaviorSubject<Memo?> memo = BehaviorSubject<Memo?>.seeded(null);
}

extension EditMemoActions on EditMemoViewModel {
  Future<void> editMemoButtonClicked(EditMemoType memoType) async {
    switch (memoType) {
      case EditMemoType.add:
        return await addDatabase();
      case EditMemoType.edit:
        return await updateMemoData();
      case EditMemoType.shareData:
        return await updateFriendMemoData();
    }
  }

  Future<void> addDatabase() async {
    await _database.addData(memoData.value);
    await _updateDatabase();
  }

  Future<void> updateMemoData() async {
    if (memo.value == null) {
      return;
    }
    await _database.updateMemoData(memo.value!);
    await _updateDatabase();
  }

  Future<void> updateFriendMemoData() async {
    if (memo.value == null) {
      return;
    }
    await _database.updateFriendMemoData(memo.value!);
    await _updateDatabase();
  }

  Future<void> enterMemo() async {
    if (memo.value == null) {
      return;
    }
    await _database.enterMemo(memo.value!);
    await _updateDatabase();
  }

  Future<void> _updateDatabase() async {
    // List<Memo> memo = await _database.getMemoData();
    // myMemoList.add(memo);
    // memo = await _database.getFriendsMemoData();
    // friendsMemoList.add(memo);
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