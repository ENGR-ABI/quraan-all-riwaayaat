

// import 'package:quranallriwayat/common/bookmarks/sql/bookmarks.dart';
// import 'package:quranallriwayat/common/data/model/bookmark/bookmark_data.dart';

// import '../../data/model/bookmark/bookmark.dart';

// import '../../data/model/sura_ayah.dart';
// import '../mapper/mapper.dart';




// class BookmarkModel {
//   final BookmarksDatabase bookmarkData;

//   BookmarkModel(this.bookmarkData);

//   Stream<List<Bookmark>> bookmarksForPage(int page) {
//     return bookmarkData
//         .getBookmarksByPage(page, Mappers.bookmarkWithTagMapper)
//         .map((query) => query.map((row) => Bookmark.fromMap(row.data)).toList());
//   }

//   Future<MapEntry<SuraAyah, bool>> isSuraAyahBookmarked(SuraAyah suraAyah) async {
//     final bookmarkId = await bookmarkQueries
//         .getBookmarkIdForSuraAyah(suraAyah.sura, suraAyah.ayah)
//         .watchSingleOrNull()
//         .then((query) => query?.data);
//     return MapEntry(suraAyah, bookmarkId != null);
//   }
// }
