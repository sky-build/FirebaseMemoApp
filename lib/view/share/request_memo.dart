import 'package:firebase_memo_app/repository/memo.dart';
import 'package:firebase_memo_app/view_model/friends_bloc.dart';
import 'package:firebase_memo_app/view_model/memo_data_bloc.dart';
import 'package:flutter/material.dart';

class RequestMemo extends StatelessWidget {
  RequestMemo({Key? key}) : super(key: key);

  final memoBloc = MemoDataBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('요청된 메모'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<Memo>>(
            stream: memoBloc.requestMemoList,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const CircularProgressIndicator();
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  final row = snapshot.data![index];
                  return RequestMemoTableViewCell(memo: row);
                },
              );
            }),
      ),
    );
  }
}

class RequestMemoTableViewCell extends StatelessWidget {
  RequestMemoTableViewCell({Key? key, required this.memo}) : super(key: key);

  final Memo memo;
  String email = '';
  final userBloc = FriendsBloc();
  final memoBloc = MemoDataBloc();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  memo.text,
                  style: const TextStyle(fontSize: 20),
                  maxLines: 1,
                ),
                StreamBuilder<String>(
                    stream: userBloc.getFriendEmail(memo.userId).asStream(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return const CircularProgressIndicator();
                      }
                      return Text(
                        snapshot.data ?? '',
                        style: const TextStyle(fontSize: 16),
                      );
                    }),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await memoBloc.responseMemoData(memo, true);
              if (result) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('요청을 받았습니다.')));
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 0.0,
            ),
            child: const Text('추가'),
          ),
          const SizedBox(width: 5.0),
          ElevatedButton(
            onPressed: () async {
              final result = await memoBloc.responseMemoData(memo, false);
              if (result) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('요청을 거절했습니다.')));
              }
            },
            style: ElevatedButton.styleFrom(
                elevation: 0.0, primary: Colors.redAccent),
            child: const Text('거절'),
          ),
        ],
      ),
    );
  }
}
