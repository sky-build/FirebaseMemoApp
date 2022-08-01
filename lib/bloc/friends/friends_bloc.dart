import 'dart:async';

import 'package:bloc/bloc.dart';
import 'friends_state.dart';
import 'package:meta/meta.dart';

part 'friends_event.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  FriendsBloc() : super(FriendsState());

  @override
  Stream<FriendsState> mapEventToState(
    FriendsEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
