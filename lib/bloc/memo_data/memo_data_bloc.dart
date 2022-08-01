import 'dart:async';

import 'package:bloc/bloc.dart';
import 'memo_data_state.dart';
import 'package:meta/meta.dart';

part 'memo_data_event.dart';

class MemoDataBloc extends Bloc<MemoDataEvent, MemoDataState> {
  MemoDataBloc() : super(MemoDataState());

  @override
  Stream<MemoDataState> mapEventToState(
    MemoDataEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
