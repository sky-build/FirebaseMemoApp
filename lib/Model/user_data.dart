class UserData {
  String email;
  String uid;

  UserData(this.email, this.uid);

  UserData.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        uid = json['uid'];
}