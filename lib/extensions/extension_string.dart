import 'package:firebase_memo_app/repository/memo.dart';

extension InputValidate on String {
  //이메일 포맷 검증
  bool isValidEmailFormat() {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }
}

extension ChangeStringToEnum on String {
  ShareState changeToShareState() {
    if (this == 'none') {
      return ShareState.none;
    } else if (this == 'request') {
      return ShareState.request;
    } else if (this == 'accept') {
      return ShareState.accept;
    } else {
      return ShareState.reject;
    }
  }

  UpdateConfirmState changeToUpdateConfirmState() {
    if (this == 'none') {
      return UpdateConfirmState.none;
    } else if (this == 'me') {
      return UpdateConfirmState.me;
    } else {
      return UpdateConfirmState.friend;
    }
  }
}