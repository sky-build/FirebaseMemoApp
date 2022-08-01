// import 'package:firebase_memo_app/enum/edit_memo_type.dart';
// import 'package:firebase_memo_app/repository/memo.dart';

part of 'edit_memo_bloc.dart';

abstract class EditMemoEvent {}

class InitEditMemo extends EditMemoEvent {
  Memo? memo;
  EditMemoType memoType;

  InitEditMemo({this.memo, required this.memoType});
}

class TextFieldChange extends EditMemoEvent {
  String text;

  TextFieldChange(this.text);
}