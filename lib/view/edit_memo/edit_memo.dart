import 'package:firebase_memo_app/bloc/edit_memo/edit_memo_bloc.dart';
import 'package:firebase_memo_app/bloc/friends/friends_bloc.dart';
import 'package:firebase_memo_app/bloc/friends/friends_state.dart';
import 'package:firebase_memo_app/enum/edit_memo_type.dart';
import 'package:firebase_memo_app/enum/share_state.dart';
import 'package:firebase_memo_app/repository/memo.dart';
import 'package:firebase_memo_app/repository/user_data.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditMemo extends StatelessWidget {
  const EditMemo({Key? key, required this.memoType}) : super(key: key);

  final EditMemoType memoType;

  @override
  Widget build(BuildContext context) {
    final editMemoBloc = context.read<EditMemoBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text(memoType.getTitle()),
        elevation: 0.0,
        actions: [
          Visibility(
              visible: memoType == EditMemoType.edit,
              child: getActionButton(context)),
          Visibility(
              visible: memoType == EditMemoType.shareData,
              child: getShareButton(context)),
          TextButton(
            onPressed: () async {
              await editMemoBloc.state.editMemoButtonClicked(memoType);
              // await editMemoBloc.editMemoButtonClicked(memoType);
              Navigator.of(context).pop();
            },
            child: Text(
              memoType.getButtonText(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocBuilder<EditMemoBloc, EditMemoState>(
          builder: (context, state) {
            return TextFormField(
              initialValue: state.memoText.value,
              onChanged: (text) {
                editMemoBloc.add(TextFieldChange(text));
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: '메모를 입력하세요',
                border: InputBorder.none,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget getShareButton(BuildContext context) {
    final editMemoBloc = context.read<EditMemoBloc>();
    return StreamBuilder<Memo?>(
        stream: editMemoBloc.state.memo,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const CircularProgressIndicator();
          }
          return TextButton(
              onPressed: () async {
                final result = await editMemoBloc.state.initRequestMemo();
                if (result) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('공유를 취소했습니다.')));
                }
                Navigator.pop(context);
              },
              child: const Text(
                '공유취소',
                style: TextStyle(color: Colors.white),
              ));
        });
  }

  Widget getActionButton(BuildContext context) {
    final editMemoBloc = context.read<EditMemoBloc>();
    return StreamBuilder<Memo?>(
      stream: editMemoBloc.state.memo,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const CircularProgressIndicator();
        }
        final shareState = snapshot.data!.shareState;
        return TextButton(
            onPressed: () async {
              switch (shareState) {
                case ShareState.none:
                  _showFriendEMailList(context);
                  break;
                case ShareState.request:
                case ShareState.accept:
                case ShareState.reject:
                  final result = await editMemoBloc.state.initRequestMemo();
                  if (result) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(shareState.getSnackBarText())));
                  }
                  break;
              }
            },
            child: Text(
              shareState.getActionButtonTitle(),
              style: const TextStyle(color: Colors.white),
            ));
      },
    );
  }

  void _showFriendEMailList(BuildContext context) {
    final editMemoBloc = context.read<EditMemoBloc>();
    final userBloc = context.read<FriendsBloc>();
    showDialog(
        context: context,
        builder: (BuildContext btx) {
          return AlertDialog(
            title: const Text('공유하고싶은 사용자를 선택하세요.'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: SizedBox(
              height: 300.0,
              width: 300.0,
              child: StreamBuilder<List<UserData>>(
                  stream: userBloc.state.friendList,
                  builder: (context, snapshot) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        final row = userBloc.state.getFriendByIndex(index);
                        return GestureDetector(
                          onTap: () async {
                            final result = await editMemoBloc.state
                                .requestMemoData(row.uid);
                            if (result) {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          '${row.email} 님에게 요청을 수행했습니다.')));
                            }
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(row.email),
                          ),
                        );
                      },
                    );
                  }),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                  ),
                  child: const Text("취소")),
            ],
          );
        });
  }
}
