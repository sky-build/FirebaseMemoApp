import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_memo_app/bloc/user_bloc.dart';
import 'package:firebase_memo_app/Enum/user_account_action_state.dart';
import 'package:firebase_memo_app/View/Setting/sign_in_view.dart';
import 'package:firebase_memo_app/bloc/memo_data_bloc.dart';

class SettingView extends StatelessWidget {
  SettingView({Key? key}) : super(key: key);

  final memoDataBloc = MemoDataBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<User?>(
            stream: memoDataBloc.userData,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return ListView(
                  children: [
                    UserView(),
                    SettingTableViewCell(
                        state: UserAccountActionState.signUp),
                    SettingTableViewCell(
                        state: UserAccountActionState.signIn),
                  ],
                );
              } else {
                return ListView(
                  children: [
                    UserView(),
                    SettingTableViewCell(
                        state: UserAccountActionState.signOut),
                  ],
                );
              }
            }),
      ),
    );
  }
}

class UserView extends StatelessWidget {
  UserView({Key? key}) : super(key: key);

  final memoDataBloc = MemoDataBloc();

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
              stream: memoDataBloc.userData.stream,
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
  SettingTableViewCell({Key? key, required this.state}) : super(key: key);

  final UserAccountActionState state;
  final userBloc = UserBloc();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: GestureDetector(
        onTap: () {
          if (state == UserAccountActionState.signOut) {
            userBloc.logOut(context);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SignInView(state: state)),
            );
          }
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
