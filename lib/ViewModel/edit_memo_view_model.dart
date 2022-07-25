import 'package:firebase_memo_app/Enum/edit_memo_type.dart';
import 'package:firebase_memo_app/Model/memo.dart';
import 'package:firebase_memo_app/database/database_manager.dart';
import 'package:rxdart/rxdart.dart';

class EditMemoViewModel {

  static final _instance = EditMemoViewModel._internal();
  EditMemoViewModel._internal();

  factory EditMemoViewModel() => _instance;

  final _database = DatabaseManager();
  BehaviorSubject<String> memoText = BehaviorSubject<String>.seeded('');
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

  Future<void> memoEditButtonClicked(EditMemoType memoType) async {
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
    await _database.addData(memoText.value);
  }

  Future<void> updateMemoData() async {
    if (memo.value == null) {
      return;
    }
    final changeMemo = memo.value!;
    changeMemo.text = memoText.value;

    await _database.updateMemoData(changeMemo);
  }

  Future<void> updateFriendMemoData() async {
    if (memo.value == null) {
      return;
    }
    await _database.updateFriendMemoData(memo.value!);
  }

  Future<void> enterMemo(EditMemoType memoType) async {
    if (memo.value == null) {
      return;
    }
    await _database.enterMemo(memo.value!, memoType);
  }

  Future<void> shareMemoUser(String uid) async {
    if (memo.value == null) {
      return;
    }
    await _database.shareMemo(memo.value!, uid);
  }
}