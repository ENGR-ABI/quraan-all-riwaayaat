class RecentPage {
  final int page;
  final int timestamp;

  RecentPage({
    required this.page,
    required this.timestamp,
  });

  String getCommaSeparatedValues() {
    return "recent,,, $page, $timestamp";
  }
}
