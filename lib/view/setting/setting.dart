import 'package:firebase_memo_app/bloc/memo_data/memo_data_bloc.dart';
import 'package:firebase_memo_app/bloc/memo_data/memo_data_state.dart';
import 'package:firebase_memo_app/bloc/user/user_bloc.dart';
import 'package:firebase_memo_app/bloc/user/user_state.dart';
import 'package:firebase_memo_app/view/setting/user_sign_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_memo_app/Enum/user_account_action_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingView extends StatelessWidget {
  SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final memoDataBloc = context.read<MemoDataBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<UserLoginState>(
            stream: memoDataBloc.state.userState,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              }
              switch (snapshot.data!) {
                case UserLoginState.none:
                  return const Center(child: CircularProgressIndicator());
                case UserLoginState.login:
                  return ListView(
                    children: [
                      UserView(),
                      SettingTableViewCell(
                          state: UserAccountActionState.signOut),
                    ],
                  );
                case UserLoginState.logout:
                  return ListView(
                    children: [
                      UserView(),
                      SettingTableViewCell(
                          state: UserAccountActionState.signUp),
                      SettingTableViewCell(
                          state: UserAccountActionState.signIn),
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

  @override
  Widget build(BuildContext context) {
    final memoDataBloc = context.read<MemoDataBloc>();
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
              stream: memoDataBloc.state.userData.stream,
              builder: (context, snapshot) {
                final emailText = getUserString(memoDataBloc.state.userState.value, '이메일');
                final uidText = getUserString(memoDataBloc.state.userState.value, 'uid');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.data?.email ?? emailText,
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      snapshot.data?.uid ?? uidText,
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }

  String getUserString(UserLoginState state, String str) {
    if (state == UserLoginState.login) {
      return '';
    }
    return '$str 없음';
  }
}

class SettingTableViewCell extends StatelessWidget {
  SettingTableViewCell({Key? key, required this.state}) : super(key: key);

  final UserAccountActionState state;

  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: GestureDetector(
        onTap: () {
          if (state == UserAccountActionState.signOut) {
            userBloc.state.logOut(context);
          } else {
            userBloc.state.initTextField();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UserSignView(state: state)),
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
