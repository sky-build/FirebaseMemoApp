import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_memo_app/Enum/edit_memo_type.dart';
import 'package:firebase_memo_app/Model/memo.dart';
import 'package:firebase_memo_app/ViewModel/edit_memo_view_model.dart';
import 'package:firebase_memo_app/ViewModel/view_model.dart';
import 'package:flutter/material.dart';

class EditMemo extends StatelessWidget {
  EditMemo({Key? key, required this.memoType, this.memo}) : super(key: key) {
    _controller.text = memo?.text ?? '';
    // TODO: 나중에 BloC 패턴쓰면 Bloc 클래스에서 ViewModel로 직접 값 넘겨주는것도 가능할것 같다.
    if (memo != null) {
      editMemoViewModel.memoText.add(memo?.text ?? '');
      editMemoViewModel.memo.add(memo!);
      editMemoViewModel.enterMemo();
    }
  }

  final EditMemoType memoType;
  Memo? memo;
  final TextEditingController _controller = TextEditingController(text: '');
  final viewModel = ViewModel();
  final editMemoViewModel = EditMemoViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(memoType.getTitle()),
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext btx) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      content: SizedBox(
                        height: 300.0,
                        width: 300.0,
                        child: ListView.builder(
                          itemCount: viewModel.friendList.value.length,
                          itemBuilder: (BuildContext context, int index) {
                            final row = viewModel.friendList.value[index];
                            return GestureDetector(
                              onTap: () {
                                if (memo != null) {
                                  editMemoViewModel.shareMemoUser(row.uid);
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
            },
            child: const Text(
              '이걸 클릭하세요.',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () async {
              editMemoViewModel.memoEditButtonClicked(memoType);
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
          onChanged: (value) {
            editMemoViewModel.memoText.add(value);
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
