import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../data/model/audio/qari.dart';
import 'download_info_streams.dart';

class Downloader extends GetxController {
  final DownloadInfoStreams downloadInfoStreams;

  Downloader(this.downloadInfoStreams);

  Future<void> downloadSura(Qari qari, int sura) async {
    try {
      // Notify that a download has started
      //downloadInfoStreams.emitEvent(DownloadInfo.DownloadStarted(qari, sura));

      // Perform the HTTP request to download the sura
      final url = 'http://quranaudio.com/qari/mishary/files/$sura.mp3';
      final response = await http.get(Uri.parse(url));

      // Get the device's document directory
      final appDocumentsDir = await getApplicationDocumentsDirectory();
      final suraFilePath = '${appDocumentsDir.path}/$sura.mp3';

      // Save the downloaded sura to the document directory
      final file = File(suraFilePath);
      await file.writeAsBytes(response.bodyBytes);

      // Notify that the download has completed
      //downloadInfoStreams.emitEvent(DownloadInfo.DownloadCompleted(qari, sura));
    } catch (e) {
      // Handle any errors that occur during the download
      // ...

      // Notify that the download has failed
      //downloadInfoStreams.emitEvent(DownloadInfo.DownloadFailed(qari, sura, e.toString()));
    }
  }

  Future<void> downloadSuras(Qari qari, int startSura, int endSura) async {
    try {
      // Perform the HTTP requests to download the suras
      for (int sura = startSura; sura <= endSura; sura++) {
        // Check if the download has been cancelled
        // if (downloadInfoStreams.isCancelled) {
        //   break;
        // }

        // Notify that a download has started
        //downloadInfoStreams.emitEvent(DownloadInfo.DownloadStarted(qari, sura));

        // Perform the HTTP request to download the sura
        final url = 'http://quranaudio.com/qari/mishary/files/$sura.mp3';
        final response = await http.get(Uri.parse(url));

        // Get the device's document directory
        final appDocumentsDir = await getApplicationDocumentsDirectory();
        final suraFilePath = '${appDocumentsDir.path}/$sura.mp3';

        // Save the downloaded sura to the document directory
        final file = File(suraFilePath);
        await file.writeAsBytes(response.bodyBytes);

        // Notify that the download has completed
        //downloadInfoStreams.emitEvent(DownloadInfo.DownloadCompleted(qari, sura));
      }
    } catch (e) {
      // Handle any errors that occur during the download
      // ...

      // Notify that the download has failed
      //downloadInfoStreams.emitEvent(DownloadInfo.DownloadFailed(qari, sura, e.toString()));
    }
  }

  void cancelDownloads() {
    // Notify that the downloads have been cancelled
    //downloadInfoStreams.cancelDownloads();
  }
}
