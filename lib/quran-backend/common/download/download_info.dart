abstract class DownloadInfo {
  String get key;
  int get type;
  dynamic get metadata;
}

class DownloadBatchSuccess extends DownloadInfo {
  @override
  final String key;
  @override
  final int type;
  @override
  final dynamic metadata;

  DownloadBatchSuccess({
    required this.key,
    required this.type,
    required this.metadata,
  });
}

class DownloadBatchError extends DownloadInfo {
  @override
  final String key;
  @override
  final int type;
  @override
  final dynamic metadata;
  final int errorId;
  final String errorString;

  DownloadBatchError({
    required this.key,
    required this.type,
    required this.metadata,
    required this.errorId,
    required this.errorString,
  });
}

class FileDownloaded extends DownloadInfo {
  @override
  final String key;
  @override
  final int type;
  @override
  final dynamic metadata;
  final String filename;
  final int? sura;
  final int? ayah;

  FileDownloaded({
    required this.key,
    required this.type,
    required this.metadata,
    required this.filename,
    required this.sura,
    required this.ayah,
  });
}

class FileDownloadProgress extends DownloadInfo {
  @override
  final String key;
  @override
  final int type;
  @override
  final dynamic metadata;
  final int progress;
  final int? sura;
  final int? ayah;
  final int? downloadedSize;
  final int? totalSize;

  FileDownloadProgress({
    required this.key,
    required this.type,
    required this.metadata,
    required this.progress,
    required this.sura,
    required this.ayah,
    required this.downloadedSize,
    required this.totalSize,
  });
}
