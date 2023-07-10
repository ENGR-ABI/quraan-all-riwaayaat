import 'package:quranallriwayat/quran-backend/common/data/model/bookmark/tag.dart';

class Bookmark {
  final int id;
  final int? sura;
  final int? ayah;
  final int page;
  final int timestamp;
  final List<int> tags;
  final String? ayahText;

  Bookmark({
    required this.id,
    this.sura,
    this.ayah,
    required this.page,
    required this.timestamp, //=  DateTime.now().millisecondsSinceEpoch,
    this.tags = const [],
    this.ayahText,
  });

  bool isPageBookmark() => sura == null && ayah == null;

  Bookmark withTags(List<int> tagIds) {
    return Bookmark(
      id: id,
      sura: sura,
      ayah: ayah,
      page: page,
      timestamp: timestamp,
      tags: List<int>.from(tagIds),
      ayahText: ayahText,
    );
  }

  Bookmark withAyahText(String ayahText) {
    return Bookmark(
      id: id,
      sura: sura,
      ayah: ayah,
      page: page,
      timestamp: timestamp,
      tags: List<int>.from(tags),
      ayahText: ayahText,
    );
  }

  String getCommaSeparatedNames() {
    return "type, sura, ayah, page, timestamp, tags";
  }

  String getCommaSeparatedValues(List<Tag> tagsList) {
    final tagsString = getSemiColonSeparatedTags(tagsList);
    return "bookmark, $sura, $ayah, $page, $timestamp, $tagsString";
  }

  String getSemiColonSeparatedTags(List<Tag> tagsList) {
    final tagNames = tags.map((tagId) {
      var tag =
          tagsList.firstWhere((tag) => tag.id == tagId, orElse: () => Tag(id: id, name: ''));
      return tag.name;
    }).join('|');
    return tagNames;
  }

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'] as int,
      sura: json['sura'] as int,
      ayah: json['ayah'] as int,
      page: json['page'] as int,
      timestamp: json['timestamp'] as int,
      tags: List<int>.from(json['tags'] as Iterable<dynamic>? ?? []),
      ayahText: json['ayahText'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sura': sura,
      'ayah': ayah,
      'page': page,
      'timestamp': timestamp,
      'tags': tags,
      'ayahText': ayahText,
    };
  }
}
