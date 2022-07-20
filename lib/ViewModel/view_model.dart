import 'package:firebase_memo_app/Model/memo.dart';
import 'package:firebase_memo_app/database/database_manager.dart';
import 'package:rxdart/rxdart.dart';

class ViewModel {

  static final _instance = ViewModel._internal();

  ViewModel._internal() {
    _updateDatabase();
    memoList.listen((value) {
      print('값 변경');
    });
  }

  factory ViewModel() => _instance;

  final _database = DatabaseManager();

  BehaviorSubject<List<Memo>> memoList = BehaviorSubject<List<Memo>>.seeded([]);

  Future<void> addDatabase(String text) async {
    await _database.addData(text);
    await _updateDatabase();
  }

  Future<void> updateMemoData(Memo memo) async {
    await _database.updateMemoData(memo);
    await _updateDatabase();
  }

  Future<void> _updateDatabase() async {
    List<Memo> memo = await _database.getMemoData();
    memoList.add(memo);
  }

  Future<void> updateMemoState(String id) async {
    await _database.updateMemoState(id);
    await _updateDatabase();
  }
}