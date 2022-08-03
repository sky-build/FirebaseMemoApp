part of 'edit_memo_bloc.dart';

class EditMemoState {
  EditMemoState({Memo? memo}) {
    if (memo != null) {
      memoText.sink.add(memo.text);
      this.memo.sink.add(memo);
    }
  }

  final _database = DatabaseManager();
  BehaviorSubject<String> memoText = BehaviorSubject<String>.seeded('');
  BehaviorSubject<Memo?> memo = BehaviorSubject<Memo?>.seeded(null);
}

extension MemoDataUpdate on EditMemoState {
  void setMemo(Memo? newMemo) {
    if (newMemo != null) {
      memo.sink.add(newMemo);
      updateText(newMemo.text);
    }
  }

  void updateText(String text) {
    memoText.sink.add(text);
  }
}

extension EditMemoActions on EditMemoState {
  Future<bool> editMemoButtonClicked(EditMemoType memoType) async {
    switch (memoType) {
      case EditMemoType.add:
        return await addDatabase();
      case EditMemoType.edit:
        return await updateMemoData();
      case EditMemoType.shareData:
        return await updateFriendMemoData();
    }
  }

  Future<bool> addDatabase() async {
    return await _database.addData(memoText.value);
  }

  Future<bool> deleteDatabase() async {
    return await _database.deleteData(memo.value!);
  }

  Future<bool> updateMemoData() async {
    if (memo.value == null) {
      return false;
    }
    final changeMemo = memo.value!;
    changeMemo.text = memoText.value;

    return await _database.updateMemoData(changeMemo);
  }

  Future<bool> updateFriendMemoData() async {
    if (memo.value == null) {
      return false;
    }
    final changeMemo = memo.value!;
    changeMemo.text = memoText.value;

    return await _database.updateFriendMemoData(changeMemo);
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
    await _database.requestMemo(memo.value!, uid);
  }

  Future<bool> requestMemoData(String uid) async {
    if (memo.value == null) {
      return false;
    }
    final result = await _database.requestMemo(memo.value!, uid);

    if (result) {
      setShareState(ShareState.request);
      return true;
    }
    return false;
  }

  Future<bool> initRequestMemo() async {
    final result = await _database.initRequestMemo(memo.value!);

    if (result) {
      setShareState(ShareState.none);
      return true;
    }
    return false;
  }

  void setShareState(ShareState state) {
    final newMemo = memo.value;
    newMemo?.shareState = state;
    memo.sink.add(newMemo);
  }
}
