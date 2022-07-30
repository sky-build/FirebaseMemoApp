enum UpdateConfirmState { none, me, friend }

extension UpdateConfirmStateToString on UpdateConfirmState {
  String getString() {
    switch (this) {
      case UpdateConfirmState.none:
        return 'none';
      case UpdateConfirmState.me:
        return 'me';
      case UpdateConfirmState.friend:
        return 'friend';
    }
  }
}