enum SignInState {
  success,
  userNotFound,
  wrongPassword,
  invalidInputType,
  otherError
}

extension SignInStateToString on SignInState {
  String getString() {
    switch (this) {
      case SignInState.success:
        return '로그인에 성공했습니다.';
      case SignInState.userNotFound:
        return '사용자를 찾을 수 없습니다.';
      case SignInState.wrongPassword:
        return '잘못된 비밀번호입니다.';
      case SignInState.invalidInputType:
        return '입력값이 잘못되었습니다.';
      case SignInState.otherError:
        return '알수 없는 오류가 발생했습니다.';
    }
  }
}
