# firebase_memo_app
- FirebaseStore를 사용해 원격으로 메모를 저장하고 공유할 수 있는 앱 

## Feature
- 메모 생성, 수정, 삭제
- 메모 공유
  - 메모공유 요청
  - 메모공유 승인 or 거절
- 로그인, 회원가입(공유할 때 회원가입 필요)

## 프로젝트 목표
- Firebase를 사용해 외부 사용자와 공유할 수 있도록 구현
- RxDart 라이브러리 사용
- Bloc 아키텍처 적용


## 데이터베이스 구조
<img width="537" alt="스크린샷 2022-08-03 오후 5 51 45" src="https://user-images.githubusercontent.com/26789278/182566855-c4f11a50-be54-433e-a3a3-53400450f2d6.png">

## Issue
- BlocBuilder가 업데이트되지않는 문제점
  - State를 싱글톤으로 사용하고, event로 state의 변수를 업데이트할 때 Widget이 업데이트되지 않는 문제점이 있었다.
  - state를 업데이트하지 않고, state의 값만 변경했기 때문에 BlocBuilder에서 변수의 변경을 감지하지 못했다.
  - 아래 코드처럼 State의 BehaviorSubject 변수를 가져와서 StreamBuilder를 이용했다.
  ```Dart
  // Bloc 가져오기
  final editMemoBloc = context.read<EditMemoBloc>();
  return StreamBuilder<Memo?>(
      // state에 있는 스트림
      stream: editMemoBloc.state.memo,
      builder: (context, snapshot) {
       ...
      });
  ```
- Firebase 데이터베이스 변경 Observe하는 방법
  ```Dart
  // 인증상태(로그인) 변경
  FirebaseAuth.instance.authStateChanges().listen((User? user) {/*로직 처리*/});
  // 데이터베이스 변경
  FirebaseFirestore.instance.collection('memo').snapshots().listen((event) {/*로직 처리*/});
  ```
- Extension 사용방법
  ```Dart
  extension 'extension이름' on '확장할 클래스 타입' {}
  ```

## 화면

### Home 화면
|로그인이 되어있지 않을때|로그인 되어있을 때|공유한 메모가 수정되어있을 때|
|-|-|-|
|<img src="https://user-images.githubusercontent.com/26789278/182555552-162bdab2-d449-4673-8e2d-1563cbc5a043.png"  width="200" height="410">|<img src="https://user-images.githubusercontent.com/26789278/182555730-3cbf914e-adc6-4571-9bf3-1e761195b082.png"  width="200" height="410">|<img src="https://user-images.githubusercontent.com/26789278/182556811-5dc6f319-89b9-44a0-810e-0148f310e7f9.png"  width="200" height="410">|

### EditMemo화면
|추가화면|메모수정화면|메모공유 요청화면공유|메모공유 요청 후 화면|
|-|-|-|-|
|<img src="https://user-images.githubusercontent.com/26789278/182557248-a30251a4-9bd1-4425-8b9c-efe6f5a4fffb.png"  width="200" height="410">|<img src="https://user-images.githubusercontent.com/26789278/182557390-f569096b-9eda-4d09-965a-c8f65ccb5265.png"  width="200" height="410">|<img src="https://user-images.githubusercontent.com/26789278/182557443-436e410f-897e-40a5-bb3a-1d0a74e5d7d9.png"  width="200" height="410">|<img src="https://user-images.githubusercontent.com/26789278/182557504-1fccd826-b6ec-4840-ad0b-11ee1d650f45.png"  width="200" height="410">|

|메모공유 되었을 때|공유요청 거절되었을 때|
|-|-|
|<img src="https://user-images.githubusercontent.com/26789278/182557300-0a77adf8-4295-47da-a64e-54796a3fea72.png"  width="200" height="410">|<img src="https://user-images.githubusercontent.com/26789278/182558229-6afe4198-74b4-4110-975f-e16142214e9e.png"  width="200" height="410">|

### 공유메모 화면
|로그인되어있지 않을 때|로그인 되어있을 때|공유한 메모가 수정되어있을 떄|요청된 메모|
|-|-|-|-|
|<img src="https://user-images.githubusercontent.com/26789278/182561566-0c0226dc-ee6b-4c48-ae86-424992ab5586.png"  width="200" height="410">|<img src="https://user-images.githubusercontent.com/26789278/182561512-64ba0d1a-467c-47d3-92d9-a935692b307d.png"  width="200" height="410">|<img src="https://user-images.githubusercontent.com/26789278/182561394-7cd71c0a-aa4e-4367-803e-4d27e9cbbc34.png"  width="200" height="410">|<img src="https://user-images.githubusercontent.com/26789278/182561269-cf8563c9-bb79-4789-92be-098b50ba773e.png"  width="200" height="410">|

### 설정 화면
|로그아웃 화면|로그인 되어있을 때|회원가입|로그인|
|-|-|-|-|
|<img src="https://user-images.githubusercontent.com/26789278/182562167-348f5c89-7286-4282-bd1f-46829d3e398a.png"  width="200" height="410">|<img src="https://user-images.githubusercontent.com/26789278/182562235-196370d5-2111-451b-bf0f-b7de1c457bf3.png"  width="200" height="410">|<img src="https://user-images.githubusercontent.com/26789278/182562271-a4693405-d440-4f7e-8c35-f142a1d2255d.png"  width="200" height="410">|<img src="https://user-images.githubusercontent.com/26789278/182562315-5eabced3-ef46-44f5-9d4d-6d2d5e46837f.png"  width="200" height="410">|

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
