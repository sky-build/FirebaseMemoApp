import 'package:firebase_memo_app/Model/memo.dart';
import 'package:firebase_memo_app/database/database_manager.dart';
import 'package:rxdart/rxdart.dart';

class ViewModel {

  static final _instance = ViewModel._internal();

  ViewModel._internal() {
    updateDatabase();
    memoList.listen((value) {
      print('값 변경');
    });
  }

  factory ViewModel() => _instance;

  final _database = DatabaseManager();

  BehaviorSubject<List<Memo>> memoList = BehaviorSubject<List<Memo>>.seeded([]);


  Future<void> addDatabase(String text) async {
    await _database.addData(text);
    await updateDatabase();
  }

  Future<void> updateDatabase() async {
    List<Memo> memo = await _database.getMemoData();
    memoList.add(memo);
  }
}