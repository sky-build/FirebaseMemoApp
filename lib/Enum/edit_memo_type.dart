enum EditMemoType { add, edit }

extension EditMemoTypeToString on EditMemoType {
  String getTitle() {
    switch (this) {
      case EditMemoType.add:
        return '생성';
      case EditMemoType.edit:
        return '수정';
    }
  }

  String getButtonText() {
    switch (this) {
      case EditMemoType.add:
        return '추가';
      case EditMemoType.edit:
        return '수정';
    }
  }
}