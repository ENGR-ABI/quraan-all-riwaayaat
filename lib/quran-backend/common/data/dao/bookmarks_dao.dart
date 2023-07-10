import '../model/bookmark/bookmark.dart';
import '../model/bookmark/recent_page.dart';

abstract class BookmarksDao {
  Future<List<Bookmark>> bookmarks();
  Future<void> replaceBookmarks(List<Bookmark> bookmarks);

  // Recent pages
  Future<List<RecentPage>> recentPages();
  Future<void> removeRecentPages();
  Future<void> replaceRecentPages(List<RecentPage> pages);
}
