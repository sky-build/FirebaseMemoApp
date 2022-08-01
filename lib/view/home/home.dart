import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_memo_app/bloc/edit_memo/edit_memo_bloc.dart';
import 'package:firebase_memo_app/bloc/memo_data/memo_data_bloc.dart';
import 'package:firebase_memo_app/enum/edit_memo_type.dart';
import 'package:firebase_memo_app/enum/update_confirm_state.dart';
import 'package:firebase_memo_app/repository/memo.dart';
import 'package:firebase_memo_app/View/edit_memo/edit_memo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemoHome extends StatelessWidget {
  MemoHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final memoDataBloc = context.read<MemoDataBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
        elevation: 0.0,
        actions: [
          StreamBuilder<User?>(
              stream: memoDataBloc.state.userData,
              builder: (context, snapshot) {
                return Visibility(
                  visible: snapshot.data != null,
                  child: IconButton(
                    onPressed: () {
                      final editMemoBloc = context.read<EditMemoBloc>();
                      editMemoBloc
                          .add(InitEditMemo(memoType: EditMemoType.add));

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
                );
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<Memo>>(
            stream: memoDataBloc.state.myMemoList,
            builder: (context, snapshot) {
              return ListView.builder(
                  itemCount: memoDataBloc.state.myMemoList.value.length,
                  itemBuilder: (BuildContext buildContext, int index) {
                    final row = memoDataBloc.state.myMemoList.value[index];
                    bool updateData;
                    if (row.updateConfirm == UpdateConfirmState.me) {
                      updateData = true;
                    } else {
                      updateData = false;
                    }
                    return MemoTableViewCell(memo: row);
                  });
            }),
      ),
    );
  }
}

class MemoTableViewCell extends StatelessWidget {
  MemoTableViewCell({Key? key, required this.memo}) : super(key: key);

  final Memo memo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final editMemoBloc = context.read<EditMemoBloc>();
        editMemoBloc.add(InitEditMemo(memo: memo, memoType: EditMemoType.edit));
        // 터치했을 떄
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditMemo(
              memoType: EditMemoType.edit,
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
