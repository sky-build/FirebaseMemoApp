import 'package:firebase_memo_app/Enum/edit_memo_type.dart';
import 'package:firebase_memo_app/Model/memo.dart';
import 'package:firebase_memo_app/ViewModel/view_model.dart';
import 'package:flutter/material.dart';

class EditMemo extends StatelessWidget {
  EditMemo({Key? key, required this.memoType, this.memo}) : super(key: key) {
    _controller.text = memo?.text ?? '';
  }

  final EditMemoType memoType;
  Memo? memo;
  final TextEditingController _controller = TextEditingController(text: '');
  final viewModel = ViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(memoType.getTitle()),
        elevation: 0.0,
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (memoType == EditMemoType.add) {
                await viewModel.addDatabase(_controller.text);
              } else {
                memo?.text = _controller.text;
                await viewModel.updateMemoData(memo!);
              }
              Navigator.of(context).pop();
            },
            child: Text(memoType.getButtonText()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          autofocus: true,
          controller: _controller,
          decoration: const InputDecoration(
            labelText: '메모를 입력하세요',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
