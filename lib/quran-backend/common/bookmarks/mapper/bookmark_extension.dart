import '../../data/model/bookmark/bookmark.dart';

/// Converges a list in which commonly tagged [Bookmark]s are listed
/// several times into a list where each [Bookmark] is only visible
/// once.
extension ConvergeCommonlyTagged on List<Bookmark> {
  List<Bookmark> convergeCommonlyTagged() {
    final resultMap = <int, Bookmark>{};

    for (final bookmark in this) {
      final existingBookmark = resultMap[bookmark.id];

      if (existingBookmark == null) {
        resultMap[bookmark.id] = bookmark;
      } else {
        final tagIds = existingBookmark.tags.toSet()..addAll(bookmark.tags);
        resultMap[bookmark.id] = existingBookmark.withTags(tagIds.toList());
      }
    }

    return resultMap.values.toList();
  }
}
