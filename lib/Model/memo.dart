import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_memo_app/Extensions/extension_string.dart';
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

  ShareState getEnum(String value) {
    if (value == 'none') {
      return ShareState.none;
    } else if (value == 'request') {
      return ShareState.request;
    } else if (value == 'accept') {
      return ShareState.accept;
    } else {
      return ShareState.reject;
    }
  }
}

enum UpdateConfirmState { none, me, friend }

extension UpdateConfirmStateToString on UpdateConfirmState {
  UpdateConfirmState getEnum(String value) {
    if (value == 'none') {
      return UpdateConfirmState.none;
    } else if (value == 'me') {
      return UpdateConfirmState.me;
    } else {
      return UpdateConfirmState.friend;
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
  bool buttonState;
  String uuid;

  Memo(this.id, this.friendUid, this.text, this.generateDate, this.myUpdateDate,
      this.friendUpdateDate, this.shareState, this.updateConfirm,
      this.buttonState, this.uuid);

  Memo.fromJson(Map<String, dynamic> json, this.id)
      : friendUid = json['friendUid'],
        text = json['text'],
        generateDate = json['generateDate'],
        myUpdateDate = json['myUpdateDate'],
        friendUpdateDate = json['friendUpdateDate'],
        shareState = json['shareState'].toString().changeToShareState(),
        updateConfirm = json['updateConfirm'].toString().changeToUpdateConfirmState(),
        buttonState = json['buttonState'] ?? false,
        uuid = const Uuid().v4();
}
