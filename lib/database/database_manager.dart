import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_memo_app/Model/memo.dart';

class DatabaseManager {
  static final _instance = DatabaseManager._internal();
  final _db = FirebaseFirestore.instance;

  factory DatabaseManager() => _instance;

  DatabaseManager._internal();

  Future<void> addData(String text) async {
    final memo = <String, dynamic>{
      "id": text,
      "text": text,
      "generateDate": Timestamp.now(),
      "buttonState": false
    };

    // Add a new document with a generated ID
    _db.collection("memo").add(memo);

    getMemoData();
  }

  Future<List<Memo>> getMemoData() async {
    List<Memo> memoList = [];
    await _db
        .collection("memo")
        .orderBy('buttonState', descending: true)
        .orderBy('generateDate', descending: true) // 시간 역순으로 정렬
        .get()
        .then((event) {
      for (var doc in event.docs) {
        final data = Memo.fromJson(doc.data(), doc.id);
        memoList.add(data);
      }
    });
    return memoList;
  }

  Future<void> updateMemoState(String id) async {
    final data = _db.collection("memo").doc(id);
    // 수정될 데이터 검색
    bool state = false;
    await data.get().then((value) {
      final temp = Memo.fromJson(value.data()!, value.id);
      state = temp.buttonState == false ? true : false;
    });

    await data.update({"buttonState": state}).then(
        (value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }

  Future<void> updateMemoData(Memo memo) async {
    final data = _db.collection("memo").doc(memo.id);
    // 수정될 데이터 검색

    await data.update({"text": memo.text, "generateDate": Timestamp.now()}).then(
            (value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }
}
