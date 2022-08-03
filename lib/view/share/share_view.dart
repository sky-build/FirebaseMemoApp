import 'package:firebase_memo_app/bloc/edit_memo/edit_memo_bloc.dart';
import 'package:firebase_memo_app/bloc/memo_data/memo_data_bloc.dart';
import 'package:firebase_memo_app/bloc/memo_data/memo_data_state.dart';
import 'package:firebase_memo_app/enum/edit_memo_type.dart';
import 'package:firebase_memo_app/enum/update_confirm_state.dart';
import 'package:firebase_memo_app/repository/memo.dart';
import 'package:firebase_memo_app/View/edit_memo/edit_memo.dart';
import 'package:firebase_memo_app/view/share/request_memo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShareMemoView extends StatelessWidget {
  ShareMemoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final memoDataBloc = context.read<MemoDataBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('공유된 메모'),
        elevation: 0.0,
        actions: [
          StreamBuilder<UserLoginState>(
            stream: memoDataBloc.state.userState,
            builder: (context, snapshot) {
              return Visibility(
                visible: snapshot.data == UserLoginState.login,
                child: TextButton(
                  child: const Text(
                    '요청된 메모',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    // 터치했을 떄
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RequestMemo(),
                      ),
                    );
                    // Navigator.push(
                    //     context, MaterialPageRoute(builder: (_) => RequestMemo()));
                  },
                ),
              );
            }
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<UserLoginState>(
          stream: memoDataBloc.state.userState,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const CircularProgressIndicator();
            }
            switch (snapshot.data!) {
              case UserLoginState.none:
              case UserLoginState.logout:
                return const Center(
                  child: Text('로그인을 먼저 수행해주세요.'),
                );
              case UserLoginState.login:
                return StreamBuilder<List<Memo>>(
                    stream: memoDataBloc.state.friendsMemoList,
                    builder: (context, snapshot) {
                      return ListView.builder(
                          itemCount: memoDataBloc.state.friendsMemoList.value.length,
                          itemBuilder: (BuildContext buildContext, int index) {
                            final row = memoDataBloc.state.friendsMemoList.value[index];
                            return ShareMemoTableViewCell(memo: row);
                          });
                    });
            }
          },
        ),
      ),
    );
  }
}

class ShareMemoTableViewCell extends StatelessWidget {
  const ShareMemoTableViewCell({Key? key, required this.memo})
      : super(key: key);

  final Memo memo;

  @override
  Widget build(BuildContext context) {
    final editMemoBloc = context.read<EditMemoBloc>();
    return GestureDetector(
      onTap: () {
        editMemoBloc
            .add(InitEditMemo(memo: memo, memoType: EditMemoType.shareData));
        // 터치했을 떄
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditMemo(
              memoType: EditMemoType.shareData,
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
