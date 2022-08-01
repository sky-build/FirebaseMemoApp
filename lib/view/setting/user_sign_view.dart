import 'package:firebase_memo_app/bloc/user/user_bloc.dart';
import 'package:firebase_memo_app/bloc/user/user_state.dart';
import 'package:flutter/material.dart';

import 'package:firebase_memo_app/Enum/user_account_action_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserSignView extends StatefulWidget {
  UserSignView({Key? key, required this.state}) : super(key: key);
  UserAccountActionState state;

  @override
  State<UserSignView> createState() => _UserSignViewState();
}

class _UserSignViewState extends State<UserSignView> {
  bool passwordVisibleState = false;

  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.state.getTitle()),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: '',
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                userBloc.state.updateID(value);
              },
            ),
            TextFormField(
              initialValue: '',
              obscureText: !passwordVisibleState,
              obscuringCharacter: "*",
              onChanged: (value) {
                userBloc.state.updatePW(value);
              },
            ),
            Row(
              children: [
                Checkbox(
                    value: passwordVisibleState,
                    activeColor: Colors.black,
                    checkColor: Colors.white,
                    onChanged: (value) {
                      setState(() {
                        if (passwordVisibleState == false) {
                          passwordVisibleState = true;
                        } else {
                          passwordVisibleState = false;
                        }
                      });
                    }),
                const Text('비밀번호 보이게'),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await userBloc.state.userAccountButtonClicked(
                    context, widget.state);
                if (result) {
                  Navigator.pop(context);
                }
              },
              child: Text(widget.state.getTitle()),
            ),
          ],
        ),
      ),
    );
  }
}
