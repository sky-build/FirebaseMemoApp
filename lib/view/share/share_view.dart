import 'package:firebase_memo_app/Enum/edit_memo_type.dart';
import 'package:firebase_memo_app/repository/memo.dart';
import 'package:firebase_memo_app/View/edit_memo/edit_memo.dart';
import 'package:firebase_memo_app/view_model/memo_data_bloc.dart';
import 'package:flutter/material.dart';

class ShareMemoView extends StatelessWidget {
  ShareMemoView({Key? key}) : super(key: key);

  final memoDataBloc = MemoDataBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공유된 메모'),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<Memo>>(
            stream: memoDataBloc.friendsMemoList,
            builder: (context, snapshot) {
              return ListView.builder(
                  itemCount: memoDataBloc.friendsMemoList.value.length,
                  itemBuilder: (BuildContext buildContext, int index) {
                    final row = memoDataBloc.friendsMemoList.value[index];
                    bool updateData;
                    if (row.updateConfirm == UpdateConfirmState.friend) {
                      updateData = true;
                    } else {
                      updateData = false;
                    }
                    return ShareMemoTableViewCell(
                      memo: row,
                      temp: updateData,
                    );
                  });
            }),
      ),
    );
  }
}

class ShareMemoTableViewCell extends StatelessWidget {
  ShareMemoTableViewCell({Key? key, required this.memo, required this.temp})
      : super(key: key);

  final Memo memo;
  final memoDataBloc = MemoDataBloc();
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
              visible: memo.updateConfirm == UpdateConfirmState.friend,
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
