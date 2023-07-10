

import '../../data/model/bookmark/bookmark.dart';
import '../../data/model/bookmark/recent_page.dart';
import '../../data/model/bookmark/tag.dart';

class Mappers {
  static Bookmark bookmarkWithTagMapper(int id, int? sura, int? ayah, int page, int addedDate, int? tagId) {
    final List<int> tags = tagId != null ? [tagId] : [];
    return Bookmark(id: id, sura: sura, ayah: ayah, page: page, timestamp: addedDate, tags: tags);
  }

  static RecentPage recentPageMapper(int id, int page, int addedDate) {
    return RecentPage(timestamp: addedDate, page: page);
  }

  static Tag tagMapper(int id, String name, int addedDate) {
    return Tag(id: id, name: name);
  }
}
