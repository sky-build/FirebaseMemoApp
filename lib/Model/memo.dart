import 'package:cloud_firestore/cloud_firestore.dart';

class Memo {
  String id;
  String text;
  Timestamp generateDate;
  bool buttonState;

  Memo(this.id, this.text, this.generateDate, this.buttonState);

  Memo.fromJson(Map<String, dynamic> json, this.id)
      : text = json['text'],
        generateDate = json['generateDate'],
        buttonState = json['buttonState'] ?? false;
}
