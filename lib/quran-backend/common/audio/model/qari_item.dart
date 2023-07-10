import 'package:flutter/material.dart';
import '../../data/index.dart';

@immutable
class QariItem {
  final int id;
  final String name;
  final String url;
  final String path;
  final bool hasGaplessAlternative;
  final String? db;

  const QariItem({
    required this.id,
    required this.name,
    required this.url,
    required this.path,
    required this.hasGaplessAlternative,
    this.db,
  });

  bool get isGapless => db != null;

  factory QariItem.fromQari(BuildContext context, Qari qari) {
    return QariItem(
      id: qari.id,
      name: qari.nameResource
          .toString(), //MaterialLocalizations.of(context).getString(qari.nameResource),
      url: qari.url,
      path: qari.path,
      hasGaplessAlternative: qari.hasGaplessAlternative,
      db: qari.db,
    );
  }
}
