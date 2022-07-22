import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Memo {
  String uuid;
  String id;
  String? friendUid;
  String text;
  Timestamp generateDate;
  Timestamp modifyDate;
  bool buttonState;
  bool shareState;

  Memo(this.uuid, this.id, this.friendUid, this.text, this.generateDate,
      this.modifyDate, this.buttonState, this.shareState);

  Memo.fromJson(Map<String, dynamic> json, this.id)
      : friendUid = json['friendUid'],
        // TODO: 이거는 나중에 수정하기
        text = json['text'],
        generateDate = json['generateDate'],
        modifyDate = json['modifyDate'],
        buttonState = json['buttonState'] ?? false,
        shareState = json['shareState'] ?? false,
        uuid = const Uuid().v4();
}
