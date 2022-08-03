import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_memo_app/enum/edit_memo_type.dart';
import 'package:firebase_memo_app/repository/memo.dart';
import 'package:firebase_memo_app/enum/share_state.dart';
import 'package:firebase_memo_app/database/database_manager.dart';
import 'package:rxdart/rxdart.dart';

part 'edit_memo_state.dart';
part 'edit_memo_event.dart';

class EditMemoBloc extends Bloc<EditMemoEvent, EditMemoState> {
  EditMemoBloc() : super(EditMemoState()) {
    on<InitEditMemo>((event, emit) {
      emit(EditMemoState(memo: event.memo));
      if (event.memo != null) {
        state.enterMemo(event.memoType);
      }
    });
    on<TextFieldChange>((event, emit) {
      state.memoText.sink.add(event.text);
    });
  }

  @override
  Stream<EditMemoState> mapEventToState(
    EditMemoEvent event,
  ) async* {
    if (event is InitEditMemo) {
      emit(EditMemoState(memo: event.memo));
      if (event.memo != null) {
        state.enterMemo(event.memoType);
      }
    }
  }
}
