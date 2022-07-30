enum ShareState { none, request, accept, reject }

extension ShareStateToString on ShareState {
  String getString() {
    switch (this) {
      case ShareState.none:
        return 'none';
      case ShareState.request:
        return 'request';
      case ShareState.accept:
        return 'accept';
      case ShareState.reject:
        return 'reject';
    }
  }

  String getActionButtonTitle() {
    switch (this) {
      case ShareState.none:
        return '공유하기';
      case ShareState.request:
        return '요청취소';
      case ShareState.accept:
        return '공유 취소하기';
      case ShareState.reject:
        return '상대가 요청 취소';
    }
  }

  String getSnackBarText() {
    switch (this) {
      case ShareState.none:
        return '공유하기';
      case ShareState.request:
        return '요청이 취소되었습니다.';
      case ShareState.accept:
        return '메모공유가 취소되었습니다.';
      case ShareState.reject:
        return '상태를 초기화했습니다.';
    }
  }
}
