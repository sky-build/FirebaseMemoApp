import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_memo_app/Model/memo.dart';

import 'package:firebase_auth/firebase_auth.dart';

enum SignUpState { success, alreadyRegister, weakPassword, otherError }

extension SignUpStateToString on SignUpState {
  String getString() {
    switch (this) {
      case SignUpState.success:
        return '회원가입에 성공했습니다.';
      case SignUpState.alreadyRegister:
        return '이미 회원가입을 수행했습니다.';
      case SignUpState.weakPassword:
        return '비밀번호 보안정도가 약합니다.';
      case SignUpState.otherError:
        return '알수없는 오류가 발생했습니다.';
    }
  }
}

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

    _db.collection("memo").add(memo);

    getMemoData();
  }

  Future<List<Memo>> getMemoData() async {
    List<Memo> memoList = [];
    await _db
        .collection("memo")
        .orderBy('buttonState',
            descending: true) // 다중 정렬을 수행하려면 파이어베이스에서 인덱스 설정을 해야한다.
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

    await data
        .update({"text": memo.text, "generateDate": Timestamp.now()}).then(
            (value) => print("DocumentSnapshot successfully updated!"),
            onError: (e) => print("Error updating document $e"));
  }

  /// Firebase 회원가입
  Future<SignUpState> signUp(String emailAddress, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return SignUpState.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return SignUpState.weakPassword;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return SignUpState.alreadyRegister;
      }
    } catch (e) {
      return SignUpState.otherError;
    }
    return SignUpState.otherError;
  }
}
