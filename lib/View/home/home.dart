import 'package:firebase_memo_app/View/edit_memo/edit_memo.dart';
import 'package:flutter/material.dart';

class MemoHome extends StatelessWidget {
  const MemoHome({Key? key}) : super(key: key);

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
                MaterialPageRoute(builder: (context) => EditMemo()),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: const [
            MemoTableViewCell(),
            MemoTableViewCell(),
            MemoTableViewCell(),
            MemoTableViewCell(),
            MemoTableViewCell(),
            MemoTableViewCell(),
          ],
        ),
      ),
    );
  }
}

class MemoTableViewCell extends StatelessWidget {
  const MemoTableViewCell({Key? key}) : super(key: key);

  final String memoTitle = '메모 데이터';
  final String generateDate = '생성일자';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              children: [
                Text(
                  memoTitle,
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  generateDate,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const Icon(Icons.star_border),
        ],
      ),
    );
  }
}
