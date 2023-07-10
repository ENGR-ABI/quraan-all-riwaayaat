import 'bookmark.dart';
import 'recent_page.dart';
import 'tag.dart';

class BookmarkData {
  final List<Tag> tags;
  final List<Bookmark> bookmarks;
  final List<RecentPage> recentPages;

  BookmarkData({
    List<Tag>? tags,
    List<Bookmark>? bookmarks,
    List<RecentPage>? recentPages,
  })  : tags = tags ?? [],
        bookmarks = bookmarks ?? [],
        recentPages = recentPages ?? [];

  String getRecentPagesByLine() {
    return recentPages
        .map((recentPage) => "${recentPage.getCommaSeparatedValues()} \n")
        .reduce((acc, recent) => "$acc$recent");
  }

  String getBookmarksByLine() {
    return bookmarks
        .map((bookmark) => "${bookmark.getCommaSeparatedValues(tags)} \n")
        .reduce((acc, bookmark) => "$acc$bookmark");
  }
}
