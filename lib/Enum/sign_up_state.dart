enum SignUpState { success, alreadyRegister, weakPassword, invalidInputType, otherError }

extension SignUpStateToString on SignUpState {
  String getString() {
    switch (this) {
      case SignUpState.success:
        return '회원가입에 성공했습니다.';
      case SignUpState.alreadyRegister:
        return '이미 회원가입을 수행했습니다.';
      case SignUpState.weakPassword:
        return '비밀번호 보안정도가 약합니다.';
      case SignUpState.invalidInputType:
        return '입력값이 잘못되었습니다.';
      case SignUpState.otherError:
        return '알수없는 오류가 발생했습니다.';
    }
  }
}