import 'package:flutter/material.dart';
import 'partially_downloaded_sura.dart'; // Replace with the actual file name of the PartiallyDownloadedSura class
import '../../data/index.dart';

@immutable
abstract class QariDownloadInfo {
  Qari get qari;
  List<int> get fullyDownloadedSuras;
}

@immutable
class GaplessQariDownloadInfo extends QariDownloadInfo {
  final Qari passedQari;
  final List<int> passedFullyDownloadedSuras;
  final List<int> partiallyDownloadedSuras;

  GaplessQariDownloadInfo({
    required this.passedQari,
    required this.passedFullyDownloadedSuras,
    required this.partiallyDownloadedSuras,
  });

  @override
  List<int> get fullyDownloadedSuras => passedFullyDownloadedSuras;

  @override
  Qari get qari => passedQari;
}

@immutable
class GappedQariDownloadInfo extends QariDownloadInfo {
  final Qari passedQari;
  final List<int> passedFullyDownloadedSuras;
  final List<PartiallyDownloadedSura> partiallyDownloadedSuras;

  GappedQariDownloadInfo({
    required this.passedQari,
    required this.passedFullyDownloadedSuras,
    required this.partiallyDownloadedSuras,
  });

  @override
  Qari get qari => passedQari;

  @override
  List<int> get fullyDownloadedSuras => passedFullyDownloadedSuras;
}
