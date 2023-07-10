import 'package:get/state_manager.dart';

import 'download_info.dart';

/// Streams of information about ongoing downloads
/// These streams should replace the usage of broadcasts for conveying information about
/// download status throughout the app.
class DownloadInfoStreams extends GetxController {
  final _downloadInfoStream = Rx<DownloadInfo?>(null);

  void emitEvent(DownloadInfo downloadInfo) {
    _downloadInfoStream.value = downloadInfo;
  }

  Stream<DownloadInfo?> downloadInfoStream() => _downloadInfoStream.stream;
}

