import 'package:firebase_memo_app/View/Setting/sign_in_view.dart';
import 'package:flutter/material.dart';

class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: const [
            UserView(),
            SettingTableViewCell(textValue: '회원가입'),
            SettingTableViewCell(textValue: '개인정보 수정'),
            SettingTableViewCell(textValue: '회원탈퇴'),
          ],
        ),
      ),
    );
  }
}

class UserView extends StatelessWidget {
  const UserView({Key? key}) : super(key: key);

  final String userName = '이름';
  final String userID = 'userID';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const SizedBox(
            width: 100.0,
            height: 100.0,
            child: CircleAvatar(
              radius: 110,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('asset/images/flutter.png'),
            ),
          ),
          const SizedBox(width: 15.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(fontSize: 20.0),
              ),
              Text(
                userID,
                style: const TextStyle(fontSize: 15.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingTableViewCell extends StatelessWidget {
  const SettingTableViewCell({Key? key, required this.textValue}) : super(key: key);

  final String textValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: GestureDetector(
        onTap: () {
          print('터치터치');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SignInView()
            ),
          );
        },
        child: Row(
          children: [
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Text(
                textValue,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
