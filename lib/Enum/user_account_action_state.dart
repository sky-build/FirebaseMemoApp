enum UserAccountActionState {
  signUp,
  signIn,
  signOut
}

extension TextEnumState on UserAccountActionState {
  String getTitle() {
    switch (this) {
      case UserAccountActionState.signUp:
        return '회원가입';
      case UserAccountActionState.signIn:
        return '로그인';
      case UserAccountActionState.signOut:
        return '로그아웃';
    }
  }
}