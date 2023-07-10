class QuranDataStatus {
  final String portraitWidth;
  final String landscapeWidth;
  final bool havePortrait;
  final bool haveLandscape;
  final String? patchParam;

  QuranDataStatus({
    required this.portraitWidth,
    required this.landscapeWidth,
    required this.havePortrait,
    required this.haveLandscape,
    this.patchParam,
  });

  bool needPortrait() {
    return !havePortrait;
  }

  bool needLandscape() {
    return !haveLandscape;
  }

  bool havePages() {
    return havePortrait && haveLandscape;
  }
}
