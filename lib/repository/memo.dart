import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_memo_app/enum/share_state.dart';
import 'package:firebase_memo_app/enum/update_confirm_state.dart';
import 'package:firebase_memo_app/extensions/extension_string.dart';
import 'package:uuid/uuid.dart';

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
