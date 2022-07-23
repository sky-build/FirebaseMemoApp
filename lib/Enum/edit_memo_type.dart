enum EditMemoType { add, edit, shareData }

extension EditMemoTypeToString on EditMemoType {
  String getTitle() {
    switch (this) {
      case EditMemoType.add:
        return '생성';
      case EditMemoType.edit:
        return '수정';
      case EditMemoType.shareData:
        return '공유메모';
    }
  }

  String getButtonText() {
    switch (this) {
      case EditMemoType.add:
        return '추가';
      case EditMemoType.edit:
        return '수정';
      case EditMemoType.shareData:
        return '공유메모';
    }
  }
}