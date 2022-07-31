# firebase_memo_app
- 메모를 생성하고 공유할 수 있는 앱

## Feature
- 메모 생성
- 메모 공유
  - 메모공유 요청
  - 메모공유 승인 or 거절
- 로그인, 회원가입(공유할 때 회원가입 필요)

## 프로젝트 목표
- Firebase를 사용해 외부 사용자와 공유할 수 있도록 구현
- RxDart 라이브러리 사용
- Bloc 아키텍처 적용

## 데이터베이스 구조
<img width="652" alt="스크린샷 2022-07-31 오후 6 53 38" src="https://user-images.githubusercontent.com/26789278/182021661-f16cc2e1-aa46-40b0-ba64-cf9615ae9981.png">

## Issue
- Firebase 데이터베이스 변경 Observe하는 방법
  ```Dart
  // 인증상태(로그인) 변경
  FirebaseAuth.instance.authStateChanges().listen((User? user) {/*로직 처리*/});
  // 데이터베이스 변경
  FirebaseFirestore.instance.collection('memo').snapshots().listen((event) {/*로직 처리*/});
    });
  ```
- Extension 사용방법
  ```Dart
  extension 'extension이름' on '확장할 클래스 타입' {}
  ```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
