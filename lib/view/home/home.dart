import 'package:firebase_memo_app/Enum/edit_memo_type.dart';
import 'package:firebase_memo_app/repository/memo.dart';
import 'package:firebase_memo_app/View/edit_memo/edit_memo.dart';
import 'package:firebase_memo_app/view_model/memo_data_bloc.dart';
import 'package:flutter/material.dart';

class MemoHome extends StatelessWidget {
  MemoHome({Key? key}) : super(key: key);
  final memoDataBloc = MemoDataBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
        elevation: 0.0,
        actions: [
          Visibility(
            visible: memoDataBloc.userData.value != null,
            child: IconButton(
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
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<Memo>>(
            stream: memoDataBloc.myMemoList,
            builder: (context, snapshot) {
              // if (snapshot.data != null && snapshot.data!.isEmpty) {
              //   return const Center(
              //     child: Text(
              //       '로그인을 먼저 해주세요.',
              //       style: TextStyle(
              //         fontSize: 20.0,
              //       ),
              //     ),
              //   );
              // }
              return ListView.builder(
                  itemCount: memoDataBloc.myMemoList.value.length,
                  itemBuilder: (BuildContext buildContext, int index) {
                    final row = memoDataBloc.myMemoList.value[index];
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
              visible: temp,
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
