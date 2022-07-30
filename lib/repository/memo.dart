import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_memo_app/extensions/extension_string.dart';
import 'package:uuid/uuid.dart';

enum ShareState { none, request, accept, reject }

extension ShareStateToString on ShareState {
  String getString() {
    switch (this) {
      case ShareState.none:
        return 'none';
      case ShareState.request:
        return 'request';
      case ShareState.accept:
        return 'accept';
      case ShareState.reject:
        return 'reject';
    }
  }

  String getActionButtonTitle() {
    switch (this) {
      case ShareState.none:
        return '공유하기';
      case ShareState.request:
        return '요청취소';
      case ShareState.accept:
        return '공유 취소하기';
      case ShareState.reject:
        return '상대가 요청 취소';
    }
  }

  String getSnackBarText() {
    switch (this) {
      case ShareState.none:
        return '공유하기';
      case ShareState.request:
        return '요청이 취소되었습니다.';
      case ShareState.accept:
        return '메모공유가 취소되었습니다.';
      case ShareState.reject:
        return '상태를 초기화했습니다.';
    }
  }
}

enum UpdateConfirmState { none, me, friend }

extension UpdateConfirmStateToString on UpdateConfirmState {
  String getString() {
    switch (this) {
      case UpdateConfirmState.none:
        return 'none';
      case UpdateConfirmState.me:
        return 'me';
      case UpdateConfirmState.friend:
        return 'friend';
    }
  }
}

class Memo {
  String id;
  String userId;
  String? friendUid;
  String text;
  Timestamp generateDate;
  Timestamp myUpdateDate;
  Timestamp? friendUpdateDate;
  ShareState shareState;
  UpdateConfirmState updateConfirm;
  String uuid;

  Memo(this.id, this.userId, this.friendUid, this.text, this.generateDate, this.myUpdateDate,
      this.friendUpdateDate, this.shareState, this.updateConfirm, this.uuid);

  Memo.fromJson(Map<String, dynamic> json, this.id)
      : userId = json['id'],
        friendUid = json['friendUid'],
        text = json['text'],
        generateDate = json['generateDate'],
        myUpdateDate = json['myUpdateDate'],
        friendUpdateDate = json['friendUpdateDate'],
        shareState = json['shareState'].toString().changeToShareState(),
        updateConfirm =
            json['updateConfirm'].toString().changeToUpdateConfirmState(),
        uuid = const Uuid().v4();
}
