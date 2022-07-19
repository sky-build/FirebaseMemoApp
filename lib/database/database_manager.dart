import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_memo_app/Model/memo.dart';

class DatabaseManager {
  static final _instance = DatabaseManager._internal();
  final _db = FirebaseFirestore.instance;

  factory DatabaseManager() => _instance;

  DatabaseManager._internal();

  Future<void> addData(String text) async {
    final memo = <String, dynamic> {
      "id": text,
      "text": text
    };

    // Add a new document with a generated ID
    _db.collection("memo").add(memo).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));

    getMemoData();
  }

  Future<List<Memo>> getMemoData() async {
    List<Memo> memoList = [];
    await _db.collection("memo").get().then((event) {
      for (var doc in event.docs) {
        final data = Memo.fromJson(doc.data());
        memoList.add(data);
      }
    });
    return memoList;
  }
}
