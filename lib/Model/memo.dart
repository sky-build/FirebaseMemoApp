class Memo {
  String id;
  String text;

  Memo(this.id, this.text);

  Memo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        text = json['text'];
}