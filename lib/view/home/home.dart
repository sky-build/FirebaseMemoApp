import 'package:firebase_memo_app/Enum/edit_memo_type.dart';
import 'package:firebase_memo_app/repository/memo.dart';
import 'package:firebase_memo_app/View/edit_memo/edit_memo.dart';
import 'package:firebase_memo_app/view_model/view_model.dart';
import 'package:flutter/material.dart';

class MemoHome extends StatelessWidget {
  MemoHome({Key? key}) : super(key: key);
  final viewModel = ViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditMemo(
                          memoType: EditMemoType.add,
                        )),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<Memo>>(
            stream: viewModel.myMemoList,
            builder: (context, snapshot) {
              return ListView.builder(
                  itemCount: viewModel.myMemoList.value.length,
                  itemBuilder: (BuildContext buildContext, int index) {
                    final row = viewModel.myMemoList.value[index];
                    // TODO: MemoTableViewCell 클래스로 로직 이동하거나, ViewModel로 이동
                    bool updateData;
                    if (row.updateConfirm == UpdateConfirmState.me) {
                      updateData = true;
                    } else {
                      updateData = false;
                    }
                    return MemoTableViewCell(
                      memo: row,
                      temp: updateData,
                    );
                  });
            }),
      ),
    );
  }
}

class MemoTableViewCell extends StatelessWidget {
  MemoTableViewCell({Key? key, required this.memo, required this.temp})
      : super(key: key);

  final Memo memo;
  final viewModel = ViewModel();
  final bool temp;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 터치했을 떄
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditMemo(
              memoType: EditMemoType.edit,
              memo: memo,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memo.text,
                    style: const TextStyle(fontSize: 20),
                    maxLines: 1,
                  ),
                  Text(
                    memo.myUpdateDate.toDate().toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: memo.updateConfirm == UpdateConfirmState.me,
              child: const Icon(
                IconData(0xe087, fontFamily: 'MaterialIcons'),
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}