import 'package:firebase_memo_app/Extensions/extension_string.dart';
import 'package:firebase_memo_app/ViewModel/view_model.dart';
import 'package:firebase_memo_app/database/database_manager.dart';
import 'package:flutter/material.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final userIDData = TextEditingController();
  final userPWData = TextEditingController();
  bool passwordVisibleState = false;
  final viewModel = ViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입 or 로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(controller: userIDData),
            TextField(
              controller: userPWData,
              obscureText: !passwordVisibleState,
              obscuringCharacter: "*",
            ),
            Row(
              children: [
                Checkbox(
                    value: passwordVisibleState,
                    activeColor: Colors.black,
                    checkColor: Colors.white,
                    onChanged: (value) {
                      if (passwordVisibleState == false) {
                        passwordVisibleState = true;
                      } else {
                        passwordVisibleState = false;
                      }
                      setState(() {});
                    }),
                const Text('비밀번호 보이게'),
              ],
            ),
            ElevatedButton(onPressed: () {}, child: const Text('로그인')),
            ElevatedButton(
                onPressed: () async {
                  // TODO: 로직 ViewModel or Bloc로 이동
                  SignUpState result;
                  if (userIDData.text.isValidEmailFormat() && userPWData.text.length >= 4) {
                    result = await viewModel.signUpEmail(
                        userIDData.text, userPWData.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result.getString())));
                    if (result == SignUpState.success) {
                      Navigator.pop(context);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('입력양식이 올바르지 않습니다. 확인해주세요.')));
                  }
                },
                child: const Text('회원가입')),
          ],
        ),
      ),
    );
  }
}
