import 'package:firebase_memo_app/Enum/edit_memo_type.dart';
import 'package:firebase_memo_app/enum/share_state.dart';
import 'package:firebase_memo_app/repository/memo.dart';
import 'package:firebase_memo_app/view_model/edit_memo_bloc.dart';
import 'package:firebase_memo_app/view_model/friends_bloc.dart';
import 'package:flutter/material.dart';

class EditMemo extends StatelessWidget {
  EditMemo({Key? key, required this.memoType, Memo? memo}) : super(key: key) {
    _controller.text = memo?.text ?? '';
    if (memo != null) {
      editMemoBloc.setMemo(memo);
      editMemoBloc.enterMemo(memoType);
    }
  }

  final EditMemoType memoType;
  final TextEditingController _controller = TextEditingController(text: '');
  final editMemoBloc = EditMemoBloc();
  final usersBloc = FriendsBloc();

  @override
  Widget build(BuildContext context) {
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
              await editMemoBloc.editMemoButtonClicked(memoType);
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
        child: TextField(
          onChanged: (text) {
            editMemoBloc.updateText(text);
          },
          controller: _controller,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: '메모를 입력하세요',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget getShareButton(BuildContext context) {
    return StreamBuilder<Memo?>(
        stream: editMemoBloc.memo,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const CircularProgressIndicator();
          }
          return TextButton(
              onPressed: () async {
                final result = await editMemoBloc.initRequestMemo();
                if (result) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('공유를 취소했습니다.')));
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
    return StreamBuilder<Memo?>(
        stream: editMemoBloc.memo,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const CircularProgressIndicator();
          }
          final shareState =
              snapshot.data!.shareState; // editMemoBloc.memo.value!.shareState;
          return TextButton(
              onPressed: () async {
                switch (shareState) {
                  case ShareState.none:
                    _showFriendEMailList(context);
                    break;
                  case ShareState.request:
                  case ShareState.accept:
                  case ShareState.reject:
                    final result = await editMemoBloc.initRequestMemo();
                    if (result) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(shareState.getSnackBarText())));
                    }
                    break;
                }
              },
              child: Text(
                shareState.getActionButtonTitle(),
                style: const TextStyle(color: Colors.white),
              ));
        });
  }

  void _showFriendEMailList(BuildContext context) {
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
              child: ListView.builder(
                itemCount: usersBloc.getFriendCount(),
                itemBuilder: (BuildContext context, int index) {
                  final row = usersBloc.getFriendByIndex(index);
                  return GestureDetector(
                    onTap: () async {
                      final result =
                          await editMemoBloc.requestMemoData(row.uid);
                      if (result) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${row.email} 님에게 요청을 수행했습니다.')));
                      }
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(row.email),
                    ),
                  );
                },
              ),
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
