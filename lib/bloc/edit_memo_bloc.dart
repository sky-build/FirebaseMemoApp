import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum BlocState { add, edit, share }

class BlocClass {
  String text;

  BlocClass(this.text);

  void pp() {
    print('hihihi');
  }
}

class BlocEditMemo extends Bloc<BlocState, BlocClass> {
  BlocEditMemo() : super(BlocClass('')) {
    on<BlocState>((event, emit) {
      switch (event) {
        case BlocState.add:
          // TODO: Handle this case.
          emit(BlocClass('add'));
          break;
        case BlocState.edit:
          // TODO: Handle this case.
          emit(BlocClass('edit'));
          break;
        case BlocState.share:
          // TODO: Handle this case.
          emit(BlocClass('share'));
          break;
      }
    });
  }

  // 이벤트 변경되었을 때 처리
  @override
  void onEvent(BlocState event) {
    super.onEvent(event);

    // TODO: implement onEvent
    print(event.toString());
  }

  @override
  void emit(BlocClass state) {
    // TODO: implement emit
    super.emit(state);
  }
}
