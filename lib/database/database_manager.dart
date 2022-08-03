import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_memo_app/enum/edit_memo_type.dart';
import 'package:firebase_memo_app/enum/share_state.dart';
import 'package:firebase_memo_app/enum/update_confirm_state.dart';
import 'package:firebase_memo_app/repository/user_data.dart';
import 'package:rxdart/rxdart.dart';

import 'package:firebase_memo_app/Enum/sign_in_state.dart';
import 'package:firebase_memo_app/Enum/sign_up_state.dart';
import 'package:firebase_memo_app/repository/memo.dart';

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
      userValue.sink.add(user);
    });
  }

  factory DatabaseManager() => _instance;
}

// 메모 추가 삭제 수정기능
extension MemoDataProcessExtension on DatabaseManager {
  // 메모 추가
  Future<void> addData(String text) async {
    if (userValue.value == null) {
      return;
    }

    final memo = <String, dynamic>{
      "id": userValue.value?.uid,
      "friendUid": null,
      "text": text,
      "generateDate": Timestamp.now(),
      "myUpdateDate": Timestamp.now(),
      "friendUpdateDate": null,
      "shareState": "none",
      "updateConfirm": "none",
    };

    _db.collection("memo").add(memo);

    getMyMemoData();
  }

  // 내 메모 가져오기
  Future<List<Memo>> getMyMemoData() async {
    List<Memo> memoList = [];
    if (userValue.value == null) {
      return memoList;
    }

    await _db
        .collection("memo")
        .where('id', isEqualTo: userValue.value!.uid) // 내 UID와 동일한 메모만 볼 수 있게
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

  // 친구가 공유한 메모정보 가져오기
  Future<List<Memo>> getFriendsMemoData() async {
    List<Memo> memoList = [];
    if (userValue.value == null) {
      return memoList;
    }
    await _db
        .collection("memo")
        .where('friendUid', isEqualTo: userValue.value!.uid)
        .where('shareState', isEqualTo: ShareState.accept.getString())
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

  // 나에게 요청한 메모데이터 가져오기
  Future<List<Memo>> getRequestMemoData() async {
    List<Memo> memoList = [];
    if (userValue.value == null) {
      return memoList;
    }

    await _db
        .collection("memo")
        .where('friendUid', isEqualTo: userValue.value!.uid)
        .where('shareState', isEqualTo: ShareState.request.getString())
        .orderBy('friendUpdateDate', descending: true)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        final data = Memo.fromJson(doc.data(), doc.id);
        final userId = userValue.value!.uid;
        memoList.add(data);
      }
    });

    return memoList;
  }

  // 메모데이터 수정
  Future<void> updateMemoData(Memo memo) async {
    final data = _db.collection("memo").doc(memo.id);

    await data.update({
      "text": memo.text,
      "myUpdateDate": Timestamp.now(),
      "updateConfirm": 'friend'
    }).then((value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }

  // 친구가 수정
  Future<void> updateFriendMemoData(Memo memo) async {
    final data = _db.collection("memo").doc(memo.id);

    await data.update({
      "text": memo.text,
      "friendUpdateDate": Timestamp.now(),
      "updateConfirm": 'me'
    }).then((value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }

  // 메모에 진입했을때 읽었다는 확인
  Future<void> enterMemo(Memo memo, EditMemoType memoType) async {
    final data = _db.collection("memo").doc(memo.id);
    bool check = true;
    await data.get().then((value) {
      final memoData = Memo.fromJson(value.data()!, value.id);
      // 내가 최근에 수정했고, 내가 다시 보는 경우 or 친구가 수정했고, 친구가 다시 보는 경우
      if (memoData.updateConfirm == UpdateConfirmState.friend &&
              memoType == EditMemoType.edit ||
          memoData.updateConfirm == UpdateConfirmState.me &&
              memoType == EditMemoType.shareData) {
        check = false;
      }
    });

    if (check == true) {
      await data.update({"updateConfirm": 'none'}).then(
          (value) => print("DocumentSnapshot successfully updated!"),
          onError: (e) => print("Error updating document $e"));
    }
  }
}

// 회원가입, 로그인
extension FirebaseAuthExtension on DatabaseManager {
  /// Firebase 회원가입
  Future<SignUpState> signUp(String emailAddress, String password) async {
    try {
      final credential =
          await _firebaseAuthInstance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      addUser(credential.user);
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

  // UID로 사용자 이메일 가져오기
  Future<String> getUserEmail(String uid) async {
    String userEmail = '';

    await _db
        .collection("user")
        .where('uid', isEqualTo: uid)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        final data = UserData.fromJson(doc.data());
        if (data.uid == uid) {
          userEmail = data.email;
        }
      }
    });

    return userEmail;
  }
}

extension UserActionsExtension on DatabaseManager {
  // 사용자 DB에 추가(회원가입할 때 수행)
  Future<void> addUser(User? user) async {
    if (user == null) {
      return;
    }

    final userValue = <String, dynamic>{"email": user.email!, "uid": user.uid};

    await _db.collection("user").add(userValue);
  }

  // 친구정보 가져오기
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

extension FriendRelatedActions on DatabaseManager {
  // 메모공유 요청
  Future<bool> requestMemo(Memo memo, String uid) async {
    final data = _db.collection("memo").doc(memo.id);
    bool check = false;
    await data.get().then((value) {
      final memoData = Memo.fromJson(value.data()!, value.id);
      // 메모를 공유하고 있지 않다면 요청 가능
      if (memoData.shareState == ShareState.none) {
        check = true;
      }
    });

    if (check) {
      await data.update({
        "friendUid": uid,
        "shareState": ShareState.request.getString(),
      }).then((value) => print("DocumentSnapshot successfully updated!"),
          onError: (e) => check = false);
    }

    return check;
  }

  // 메모공유 응답(accept, reject)
  Future<bool> responseMemo(Memo memo, bool isAccept) async {
    bool result = false;
    final data = _db.collection("memo").doc(memo.id);
    final responseData = isAccept
        ? ShareState.accept.getString()
        : ShareState.reject.getString();
    final updateConfirmString = isAccept
        ? UpdateConfirmState.friend.getString()
        : UpdateConfirmState.none.getString();

    await data.update({
      "shareState": responseData,
      "updateConfirm": updateConfirmString,
    }).then((value) => result = true, onError: (e) => result = false);

    return result;
  }

  // 메모공유 초기화
  Future<bool> initRequestMemo(Memo memo) async {
    bool result = false;
    final data = _db.collection("memo").doc(memo.id);

    await data.update({
      "friendUid": null,
      "friendUpdateDate": null,
      "shareState": "none",
      "updateConfirm": UpdateConfirmState.none.getString(),
    }).then((value) => result = true, onError: (e) => result = false);

    return result;
  }
}
