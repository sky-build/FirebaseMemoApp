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
  String? friendUid;
  String text;
  Timestamp generateDate;
  Timestamp myUpdateDate;
  Timestamp? friendUpdateDate;
  ShareState shareState;
  UpdateConfirmState updateConfirm;
  String uuid;

  Memo(this.id, this.friendUid, this.text, this.generateDate, this.myUpdateDate,
      this.friendUpdateDate, this.shareState, this.updateConfirm, this.uuid);

  Memo.fromJson(Map<String, dynamic> json, this.id)
      : friendUid = json['friendUid'],
        text = json['text'],
        generateDate = json['generateDate'],
        myUpdateDate = json['myUpdateDate'],
        friendUpdateDate = json['friendUpdateDate'],
        shareState = json['shareState'].toString().changeToShareState(),
        updateConfirm =
            json['updateConfirm'].toString().changeToUpdateConfirmState(),
        uuid = const Uuid().v4();
}
