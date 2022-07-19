import 'package:firebase_memo_app/Model/memo.dart';
import 'package:firebase_memo_app/View/edit_memo/edit_memo.dart';
import 'package:firebase_memo_app/ViewModel/view_model.dart';
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
                MaterialPageRoute(builder: (context) => EditMemo()),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<Memo>>(
            stream: viewModel.memoList,
            builder: (context, snapshot) {
              return ListView.builder(
                  itemCount: viewModel.memoList.value.length,
                  itemBuilder: (BuildContext buildContext, int index) {
                    final row = viewModel.memoList.value[index];
                    return MemoTableViewCell(
                        memoTitle: row.text, generateDate: '오늘');
                  });
            }),
      ),
    );
  }
}

class MemoTableViewCell extends StatelessWidget {
  const MemoTableViewCell({
    Key? key,
    required this.memoTitle,
    required this.generateDate,
  }) : super(key: key);

  final String memoTitle;
  final String generateDate;

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
