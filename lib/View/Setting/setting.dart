import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_memo_app/Enum/user_account_action_state.dart';
import 'package:firebase_memo_app/View/Setting/sign_in_view.dart';
import 'package:firebase_memo_app/ViewModel/view_model.dart';
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
          children: [
            UserView(),
            const SettingTableViewCell(state: UserAccountActionState.signUp),
            const SettingTableViewCell(state: UserAccountActionState.signIn),
            const SettingTableViewCell(state: UserAccountActionState.signOut),
          ],
        ),
      ),
    );
  }
}

class UserView extends StatelessWidget {
  UserView({Key? key}) : super(key: key);

  final viewModel = ViewModel();

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
          StreamBuilder<User?>(
              stream: viewModel.userData.stream,
              builder: (context, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.data?.email ?? '이름 없음',
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      snapshot.data?.uid ?? 'UID 없음',
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}

class SettingTableViewCell extends StatelessWidget {
  const SettingTableViewCell(
      {Key? key, required this.state})
      : super(key: key);

  final UserAccountActionState state;

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
                builder: (_) =>
                    SignInView(state: state)),
          );
        },
        child: Row(
          children: [
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Text(
                state.getTitle(),
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
