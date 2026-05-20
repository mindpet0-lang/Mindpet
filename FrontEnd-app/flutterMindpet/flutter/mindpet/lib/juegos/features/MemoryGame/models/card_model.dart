class MemoryCardModel {
  final String image;
  bool isFlipped;
  bool isMatched;

  MemoryCardModel({
    required this.image,
    this.isFlipped = false,
    this.isMatched = false,
  });
}