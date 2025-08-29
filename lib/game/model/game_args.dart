class GameArgs {
  final bool isNormal;
  final bool isImage;

  const GameArgs({required this.isNormal, required this.isImage});

  /**
   * 기존 GameScreen에서 매번 GameArgs 객체를 new로 생성해서 ref.watch(...)에 넘겨주고 있음.
      → GameArgs(isNormal: ..., isImage: ...)가 매번 새로운 객체라서 family 입장에서는 "다른 arg"로 인식함.
      → 매번 새로운 provider 인스턴스를 만들고, 그 안에서 getGameQuestions()가 다시 실행됨.
      그 결과, error 상태여도 build → watch → provider 새로 생성 → 다시 요청 → error → 무한 루프
      -> GameArgs를 const + equatable 처리 (자바와 비슷하게 ==, hashcode override 함으로써 GameArgs가 같은 객체임을 보장)
   */

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameArgs &&
          runtimeType == other.runtimeType &&
          isNormal == other.isNormal &&
          isImage == other.isImage;

  @override
  int get hashCode => isNormal.hashCode ^ isImage.hashCode;
}
