import 'package:firebase_memo_app/Enum/edit_memo_type.dart';
import 'package:firebase_memo_app/repository/memo.dart';
import 'package:firebase_memo_app/view_model/edit_memo_bloc.dart';
import 'package:firebase_memo_app/view_model/users_bloc.dart';
import 'package:flutter/material.dart';

class EditMemo extends StatelessWidget {
  EditMemo({Key? key, required this.memoType, Memo? memo}) : super(key: key) {
    _controller.text = memo?.text ?? '';
    // TODO: 로직 ViewModel로 이동
    if (memo != null) {
      editMemoBloc.setMemo(memo);
      editMemoBloc.enterMemo(memoType);
    }
  }

  final EditMemoType memoType;
  final TextEditingController _controller = TextEditingController(text: '');
  final editMemoBloc = EditMemoBloc();
  final usersBloc = UsersBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(memoType.getTitle()),
        elevation: 0.0,
        actions: [
          Visibility(
            visible: memoType == EditMemoType.edit,
            // TODO: 별도 함수로 분리하기
            child: TextButton(
              onPressed: () {
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
                                onTap: () {
                                  editMemoBloc.shareMemoUser(row.uid);
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
              },
              child: const Text(
                '공유하기',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
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
}
