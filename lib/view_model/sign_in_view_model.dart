import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:firebase_memo_app/database/database_manager.dart';
import 'package:firebase_memo_app/Enum/sign_in_state.dart';
import 'package:firebase_memo_app/Enum/sign_up_state.dart';
import 'package:firebase_memo_app/Extensions/extension_string.dart';
import 'package:firebase_memo_app/Enum/user_account_action_state.dart';

class SignInViewModel {
  static final _instance = SignInViewModel._internal();

  SignInViewModel._internal();

  factory SignInViewModel() => _instance;

  final _database = DatabaseManager();

  final _userID = BehaviorSubject<String>.seeded('');
  final _userPW = BehaviorSubject<String>.seeded('');

  get userIDObservable => _userID.stream;
  get userPWObservable => _userID.stream;
}

extension UpdateInputValue on SignInViewModel {
  void initTextField() {
    _userID.value = '';
    _userPW.value = '';
  }

  void updateID(String id) {
    _userID.value = id;
  }

  void updatePW(String pw) {
    _userPW.value = pw;
  }
}

extension CheckInputFormat on SignInViewModel {
  String get id => _userID.value.toString();
  String get pw => _userPW.value.toString();

  bool checkInputFormat() {
    if (id.isValidEmailFormat() && pw.toString().length >= 4) {
      return true;
    }
    return false;
  }
}

extension UserAccountActions on SignInViewModel {
  String get id => _userID.value.toString();
  String get pw => _userPW.value.toString();

  Future<bool> userAccountButtonClicked(
      BuildContext context, UserAccountActionState actions) async {
    String snackBarText;
    switch (actions) {
      case UserAccountActionState.signUp:
        final result = await signUpEmail();
        snackBarText = result.getString();
        _showSnackBar(context, snackBarText);
        return result == SignUpState.success ? true : false;
      case UserAccountActionState.signIn:
        final result = await signInEmail();
        snackBarText = result.getString();
        _showSnackBar(context, snackBarText);
        return result == SignInState.success ? true : false;
    }
    return false;
  }

  Future<SignUpState> signUpEmail() async {
    if (checkInputFormat()) {
      return await _database.signUp(id, pw);
    }
    return SignUpState.invalidInputType;
  }

  Future<SignInState> signInEmail() async {
    if (checkInputFormat()) {
      return await _database.signIn(id, pw);
    }
    return SignInState.invalidInputType;
  }

  Future<void> logOut(BuildContext context) async {
    await _database.logOut();
    _showSnackBar(context, '로그아웃 되었습니다.');
  }

  void _showSnackBar(BuildContext context, String snackBarText) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(snackBarText)));
  }
}
