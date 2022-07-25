import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_memo_app/Model/user_data.dart';
import 'package:rxdart/rxdart.dart';

import 'package:firebase_memo_app/Enum/sign_in_state.dart';
import 'package:firebase_memo_app/Enum/sign_up_state.dart';
import 'package:firebase_memo_app/Model/memo.dart';
import 'package:uuid/uuid.dart';

class DatabaseManager {
  static final _instance = DatabaseManager._internal();
  final _db = FirebaseFirestore.instance;
  final _firebaseAuthInstance = FirebaseAuth.instance;
  BehaviorSubject<User?> userValue = BehaviorSubject<User?>.seeded(null);

  DatabaseManager._internal() {
    _firebaseAuthInstance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
      userValue.value = user;
    });
  }

  factory DatabaseManager() => _instance;
}

// 메모 추가 삭제 수정기능
extension MemoDataProcessExtension on DatabaseManager {
  Future<void> addData(String text) async {
    final memo = <String, dynamic>{
      "id": userValue.value?.uid,
      "friendUid": null,
      "text": text,
      "generateDate": Timestamp.now(),
      "myUpdateDate": Timestamp.now(),
      "friendUpdateDate": null,
      "shareState": "none",
      "updateConfirm": "none",
      "buttonState": false,
      "uuid": const Uuid().v4()
    };

    _db.collection("memo").add(memo);

    getMemoData();
  }

  Future<List<Memo>> getMemoData() async {
    List<Memo> memoList = [];
    if (userValue.value == null) {
      return memoList;
    }
    await _db
        .collection("memo")
        .where('id', isEqualTo: userValue.value!.uid) // 내 UID와 동일한 메모만 볼 수 있게
        .orderBy('buttonState',
            descending: true) // 다중 정렬을 수행하려면 파이어베이스에서 인덱스 설정을 해야한다.
        .orderBy('myUpdateDate', descending: true) // 시간 역순으로 정렬
        .get()
        .then((event) {
      for (var doc in event.docs) {
        final data = Memo.fromJson(doc.data(), doc.id);
        memoList.add(data);
      }
    });
    return memoList;
  }

  Future<List<Memo>> getFriendsMemoData() async {
    List<Memo> memoList = [];
    if (userValue.value == null) {
      return memoList;
    }
    await _db
        .collection("memo")
        .where('friendUid', isEqualTo: userValue.value!.uid)
        .orderBy('buttonState',
            descending: true) // 다중 정렬을 수행하려면 파이어베이스에서 인덱스 설정을 해야한다.
        .orderBy('friendUpdateDate', descending: true) // 시간 역순으로 정렬
        .get()
        .then((event) {
      for (var doc in event.docs) {
        final data = Memo.fromJson(doc.data(), doc.id);
        // 사용자 데이터가 존재하고
        if (userValue.value != null) {
          final userId = userValue.value!.uid;
          // 친구 ID와 같은 경우
          if (data.friendUid != null && data.friendUid == userId) {
            memoList.add(data);
          }
        }
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

    await data.update({
      "text": memo.text,
      "myUpdateDate": Timestamp.now(),
      "updateConfirm": 'friend'
    }).then((value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }

  Future<void> updateFriendMemoData(Memo memo) async {
    final data = _db.collection("memo").doc(memo.id);
    // 수정될 데이터 검색

    await data.update({
      "text": memo.text,
      "friendUpdateDate": Timestamp.now(),
      "updateConfirm": 'me'
    }).then((value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }

  Future<void> shareMemo(Memo memo, String uid) async {
    final data = _db.collection("memo").doc(memo.id);

    await data.update({"friendUid": uid}).then(
        (value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }

  Future<void> enterMemo(Memo memo) async {
    final data = _db.collection("memo").doc(memo.id);

    await data.update({"updateConfirm": 'none'}).then(
            (value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }
}

// 회원가입, 로그인
extension FirebaseAuthExtension on DatabaseManager {
  /// Firebase 회원가입
  Future<SignUpState> signUp(String emailAddress, String password) async {
    try {
      final credintial =
          await _firebaseAuthInstance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      // TODO: 여기서 사용자 데이터베이스에 추가
      addUser(credintial.user);
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

  Future<SignInState> signIn(String emailAddress, String password) async {
    try {
      final user = _firebaseAuthInstance.currentUser;
      print(user?.email!);

      await _firebaseAuthInstance.signInWithEmailAndPassword(
          email: emailAddress, password: password);

      return SignInState.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return SignInState.userNotFound;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return SignInState.wrongPassword;
      }
      return SignInState.otherError;
    }
  }

  Future<void> logOut() async {
    await _firebaseAuthInstance.signOut();
  }
}

extension UserActionsExtension on DatabaseManager {
  Future<void> addUser(User? user) async {
    if (user == null) {
      return;
    }

    final userValue = <String, dynamic>{"email": user.email!, "uid": user.uid};

    await _db.collection("user").add(userValue);
  }

  Future<List<UserData>> getFriendUsers() async {
    List<UserData> userList = [];
    if (userValue.value == null) {
      return userList;
    }
    await _db
        .collection("user")
        .where('uid', isNotEqualTo: userValue.value!.uid)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        final data = UserData.fromJson(doc.data());
        userList.add(data);
      }
    });

    return userList;
  }
}
