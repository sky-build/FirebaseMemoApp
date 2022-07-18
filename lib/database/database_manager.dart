import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseManager {

  static final instance = DatabaseManager._internal();

  DatabaseManager._internal() {
    // FirebaseApp secondaryApp = Firebase.app('SecondaryApp');
    // FirebaseDatabase database = FirebaseDatabase.instanceFor(app: secondaryApp);
  }

  void addData() async {
    // 데이터를 읽기, 쓰기할 때 이 인스턴스가 필요하다.
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    await ref.set({
      "name": "John",
      "age": 18,
      "address": {
        "line1": "100 Mountain View"
      }
    });
  }
  // static final shared =
}