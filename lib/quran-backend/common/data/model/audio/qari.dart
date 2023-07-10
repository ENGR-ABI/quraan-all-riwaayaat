import 'package:flutter/material.dart';

@immutable
class Qari {
  final int id;
  final int nameResource;
  final String url;
  final String path;
  final bool hasGaplessAlternative;
  final String? db;

  const Qari({
    required this.id,
    required this.nameResource,
    required this.url,
    required this.path,
    required this.hasGaplessAlternative,
    this.db,
  });

  String? get databaseName => db?.isNotEmpty == true ? db : null;
  bool get isGapless => databaseName != null;
}
