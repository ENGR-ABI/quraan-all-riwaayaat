import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:libadwaita_window_manager/libadwaita_window_manager.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:quranallriwayat/quran-backend/common/config/constants.dart';
import 'package:quranallriwayat/quran-backend/common/config/initial_prefs.dart';
import 'package:quranallriwayat/quran-backend/common/data/core/ayah_info_handler.dart';
import 'package:quranallriwayat/quran-backend/common/data/core/db_manager.dart';
import 'package:quranallriwayat/quran-backend/common/data/model/ayah_bounds.dart';
import 'package:quranallriwayat/quran-backend/common/data/model/page_model.dart';
import 'package:quranallriwayat/quran-backend/common/data/model/sura_ayah.dart';
import 'package:quranallriwayat/quran-backend/common/data/source/madani_data_source.dart';
import 'package:quranallriwayat/quran-backend/common/database/sql/quran_types_table.dart';
import 'package:quranallriwayat/quran-backend/common/model/ayah_coordinates.dart';
import 'package:quranallriwayat/quran-backend/common/model/coodinates_model.dart';
import 'package:quranallriwayat/quran-backend/common/model/quran_type_model.dart';
import 'package:quranallriwayat/quran-backend/index.dart';
import 'package:quranallriwayat/quran-ui/controllers/app_storage.dart';
import 'package:quranallriwayat/quran-ui/layout/index.dart';
import 'package:quranallriwayat/quran-ui/screens/quran_page_viewer.dart';
import 'package:quranallriwayat/quran-ui/state.dart';
import 'package:quranallriwayat/quran-ui/theme/theme_controller.dart';
import 'package:quranallriwayat/quran-ui/utils/enums.dart';
import 'package:quranallriwayat/quran-ui/widgets/dialog/dialog.dart';
import 'package:quranallriwayat/quran-ui/widgets/quran_types.dart';

class QuranUIController extends GetxService {
  LayoutController layout = LayoutController.inst;
  QuranUIState state = QuranUIState();
  final Rx<ThemeData> activeTheme = ThemeController.inst.activeTheme;
  late List<QuranSurahMeta> quranSurahMeta;

  /// Var - holding directory path of the quran (Madani, Hafs, Warsh...)
  final quranTypeDir = ''.obs;

  /// To allow reading from previous page
  late int prevReadinngPage;

  /// To allow playing fom previous last listened verse
  late int prevRecitationPage;
  //final List<DownloadTask> _downloadTasks = [];
  final downloadProgress = 0.0.obs;
  final taskSize = ''.obs;
  final downloadStatus = 'Downloading...'.obs;
  QuranDataSourceMadani qurandataSourceMadani = QuranDataSourceMadani();
  late QuranInfo quranInfo;

  final List<Widget> screens = [const QuranTypes(), const QuraanPageViewer()];

  final RxBool fullScreen = true.obs;
  late AyahInfoHandler _ayahInfoHandler;
  late AyahCoordinates ayahCoordinates;
  late CoordinatesModel _coordinatesModel;
  late Rx<List<AyahBounds>?> singlePageAyahBounds;
  late Rx<List<AyahBounds>?> leftSelectedPageAyahBounds;
  late Rx<List<AyahBounds>?> rightSelectedPageAyahBounds;
  int firstVerse = 6;
  final currentPage = 0.obs;
  final RxBool ayahSelectioMode = false.obs;
  final Color selectionColor = Colors.blue.withOpacity(.5);
  final Color hoverColor = Colors.lightGreen.withOpacity(.4);
  final Color highlightColor = Colors.yellow.withOpacity(.5);
  final Rx<Color> selectedColor = Rx(Colors.transparent);
  final Rx<Offset> ayahOffset = Rx(Offset.zero);
  final Rx<SuraAyah?> selectedVerse = Rx(null);
  final RxBool shouldStreamAll = false.obs;
  final Rx<List<PageModel>> pagesToDisplay = Rx([]);
  late PageController pageController;
  late PageController quranTypePController;
  final quranTCurrentIndex = 0.obs;
  final Rx<List<QuranTypeModel>> quranTypes = Rx([]);
  final quranTypeHovered = false.obs;
  late String appDocumentDirectory;
  final loading = true.obs;
  final int maxPagesToLoad = 12;

  late FlapController flapController;

  @override
  void onInit() {
    quranSurahMeta =
        QuranConstants.quranSurahInfoMeta.map(QuranSurahMeta.fromJson).toList();
    quranInfo = QuranInfo(qurandataSourceMadani);
    quranTypePController = PageController(
      initialPage: quranTCurrentIndex.value,
      viewportFraction: 0.45,
    );
    flapController = FlapController();
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    quranTypePController.dispose();
    flapController.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    init();
    super.onReady();
  }

  void startQuran(QuranSurahMeta quranSurahMeta) {
    if (quranTypeDir.isEmpty) {
      showDownloadDialog(
        onDownload: (_) async {
          await startQuranDownload(
            onDownloaded: (downloaded) =>
                _handleAfterQuranDownload(downloaded, quranSurahMeta),
          );
        },
        onStream: (_) {
          final starting =
              quranInfo.getPageFromSuraAyah(quranSurahMeta.surahNumber, 1);
          startReading(starting, shouldStream: true);
        },
      );
    } else {
      var startingPage =
          quranInfo.getPageFromSuraAyah(quranSurahMeta.surahNumber, 1);
      currentPage.value = startingPage;
      startReading(startingPage);
    }
  }

  Future<void> _handleAfterQuranDownload(
    bool downloaded,
    QuranSurahMeta? quranSurahMeta,
  ) async {
    if (downloaded) {
      if (quranSurahMeta != null) {
        final startingPage =
            quranInfo.getPageFromSuraAyah(quranSurahMeta.surahNumber, 1);
        await startReading(startingPage);
      }
    } else {
      await Future.delayed(const Duration(seconds: 1));
      Get.back();
    }
  }

  Future<void> startReading(int startingPage,
      {bool shouldStream = false}) async {
    shouldStreamAll.value = shouldStream;
    loading.value = true;
    if (state.index.value == ScreensList.quranPage.index) {
      final initialPagesToDisplay = generateNextAndPrevPages(startingPage);

      _clearAll();
      var initialPage =
          await _preparePages(initialPagesToDisplay, startingPage);
      pagesToDisplay.refresh();
      loading.value = false;
      final pageToStart = isSingle() ? initialPage : initialPage ~/ 2;
      currentPage.value = pageToStart;
      pageController = PageController(
        initialPage: pageToStart,
      );
    } else {
      ///TODO - To Fix Coe Duplicate and Streaming feature
      await _initialize(startingPage).then((initialPage) {
        var pageToStart = isSingle() ? initialPage : initialPage ~/ 2;
        currentPage.value = pageToStart;
        pageController = PageController(
          initialPage: pageToStart,
        );
        loading.value = false;
        state.set(ScreensList.quranPage.index);
      });
    }
  }

  Future<int> _initialize(int startingPage) async {
    _ayahInfoHandler = AyahInfoHandler();
    _coordinatesModel = CoordinatesModel();
    singlePageAyahBounds = Rx(null);
    rightSelectedPageAyahBounds = Rx(null);
    leftSelectedPageAyahBounds = Rx(null);
    selectedColor.value = hoverColor;
    final appDir = await getApplicationDocumentsDirectory();
    appDocumentDirectory = '${appDir.path}/$APP_BASE_DIR';

    final initialPagesToDisplay = generateNextAndPrevPages(startingPage);
    return await _preparePages(initialPagesToDisplay, startingPage);
  }

  Future<int> _preparePages(
    List<int> initialPagesToDisplay,
    int startingPage,
  ) async {
    var quranWidth = !fullScreen.isTrue ? Get.width : Get.width - 300;
    var quranInnerWidth = quranWidth - 90;
    final pagesCoordinates = await _ayahInfoHandler.getVersesBoundsForPage(
      initialPagesToDisplay,
      quranTypeDir.value,
      '1280',
    );
    pagesToDisplay.value.clear();
    pagesCoordinates.forEach((key, value) {
      final pageImage =
          '$appDocumentDirectory/quraan/$quranTypeDir/width_1280/page${key.toString().padLeft(3, '0')}.png';
      final ayahCoordinates = _coordinatesModel.normalizePageAyahs(
        AyahCoordinates(
          page: key,
          suraAyah: value.suraAyah,
          lastSuraAyah: value.lastSuraAyah,
          ayahCoordinates: value.ayahCoordinates,
        ),
        Size(
          quranInnerWidth / 2,
          Get.height - 180,
        ),
      );
      final page = PageModel(
        pageNumber: key,
        suraAyah: ayahCoordinates.suraAyah,
        lastSuraAyah: ayahCoordinates.lastSuraAyah,
        pageImage: pageImage,
        ayahCoordinates: ayahCoordinates.ayahCoordinates,
      );
      pagesToDisplay.value.add(page);
    });
    pagesToDisplay.value.sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
    final initialPage = initialPagesToDisplay.indexOf(startingPage);
    highligthAyah(
      pagesToDisplay.value[initialPage].pageNumber,
      pagesToDisplay.value[initialPage].ayahCoordinates,
      ayahOffset.value,
    );
    return initialPage;
  }

  List<int> generateNextAndPrevPages(int middlePage, {int maxLength = 20}) {
    var pageNumbers = <int>[];
    for (var i = middlePage + 1; i <= middlePage + (maxLength / 2); i++) {
      if (i <= 604) {
        pageNumbers.add(i);
      }
    }
    pageNumbers.add(middlePage);
    var subtractor = middlePage.isEven ? (maxLength ~/ 2) + 1 : maxLength ~/ 2;
    for (var i = middlePage - 1; i >= middlePage - subtractor; i--) {
      if (i >= 1) {
        pageNumbers.add(i);
      }
    }
    pageNumbers.sort();
    return pageNumbers;
  }

  List<int> generatePreviousPages(int start, maxLength) {
    var pageNumbers = <int>[];
    final int maxFix = start == maxLength - 1 ? 1 : maxLength;
    for (var i = start; i >= maxFix; i--) {
      if (i >= 1) {
        pageNumbers.add(i);
      }
      if (pageNumbers.length == maxLength) break;
    }
    return pageNumbers;
  }

  highligthAyah(
    int page,
    Map<String, List<AyahBounds>> ayahCoordinates,
    Offset details,
  ) {
    //print(page);
    ayahCoordinates.forEach((key, value) {
      for (var i = 0; i < value.length; i++) {
        if (value[i].bounds.contains(details)) {
          if (ayahSelectioMode.isTrue) {
            selectedColor.value = selectionColor;
          } else {
            selectedColor.value = hoverColor;
          }
          final offsetPosition = value.first.bounds.bottomLeft;
          final ayahBound = value.first.bounds;

          //: value[1].bounds.centerLeft;
          final lines = value.map((e) => e.line).toList();
          final dy = lines.any((element) => element == 1 || element == 3)
              ? ayahBound.bottomCenter.dy
              : ayahBound.topCenter.dy;
          var dx = page.isOdd && !isSingle()
              ? offsetPosition.dx + Get.width / 2
              : offsetPosition.dx;
          dx = dx > value.first.bounds.width
              ? dx - value.first.bounds.width
              : dx;
          ayahOffset.value = Offset(
            dx,
            dy,
          );
          //ayahOffset.value = details;
          final suraAyah = key.split(':');
          selectedVerse.value =
              SuraAyah(int.parse(suraAyah.first), int.parse(suraAyah[1]));
          singlePageAyahBounds.value = value;
          if (page.isOdd) {
            rightSelectedPageAyahBounds.value = value;
            leftSelectedPageAyahBounds.value = null;
          } else {
            leftSelectedPageAyahBounds.value = value;
            rightSelectedPageAyahBounds.value = null;
          }
          break;
        }
      }
    });
  }

  Future<void> init() async {
    //AppStorage.inst.remove(DEFAULT_QURAN_TYPE);
    quranTypeDir.value = AppStorage.inst.fetch(DEFAULT_QURAN_TYPE).toString();
    final lastPageRead = AppStorage.inst.fetch(LAST_RECITED_PAGE).toString();
    final shouldAlwaysStream = AppStorage.inst.fetch(ALWAYS_STREAM);
    final appDocDir = await getApplicationDocumentsDirectory();
    appDocumentDirectory = '${appDocDir.path}/$APP_BASE_DIR';
    bool hasCreatedDB = false;

    /// If [quranTypeDir] is null
    /// - It means the first time launch or that app data has been cleared
    /// - Asking user for permission to download important app files
    ///   - If allowed? download or stream pages
    /// Else go ahead and open last page if not default (0)
    if (quranTypeDir.value.contains('null') || quranTypeDir.value.isEmpty) {
      try {
        final dbMAnager = DBManager(
          '${appDocDir.path}/$APP_BASE_DIR/quranType/quranType.db',
        );
        final result =
            dbMAnager.fetchRecord(QuranTypesTableQueries.getAllQuranTypes);

        final qTypes = result.rows.map(QuranTypeModel.fromList).toList();
        quranTypes.value.addAll(qTypes);
        quranTypes.refresh();
        hasCreatedDB = true;
      } catch (_) {
        hasCreatedDB = false;
      }

      if (shouldAlwaysStream == true) {
        if (!lastPageRead.contains('null')) {
          _handleReadingResume(lastPageRead);
        }
      } else {
        ///NOTE - NO NEED FOR DOWNLLOAD
        ///
        ///
        if (!hasCreatedDB) {
          print('REACHED DB CREATION');
          await _createQuranTypeDB();
          var counter = 1;
          for (final element in defaultQuranTypes) {
            quranTypes.value.add(
              QuranTypeModel(
                id: counter,
                title: element['title'],
                description: element['description'],
                images: element['images'].toString().split(','),
                downlaodURL: element['downlaodURL'],
                isDownloaded: element['isDownloaded'] == 0 ? true : false,
              ),
            );
            counter++;
          }
          quranTypes.refresh();
          await AppStorage.inst.store(initialPreferences);
        }

        showDownloadDialog(
          onDownload: (_) async {
            await startQuranDownload(
              onDownloaded: (downloaded) =>
                  _handleAfterQuranDownload(downloaded, null),
            );
          },
          onStream: (_) {
            Get.back();
          },
        );
      }
    } else {
      _handleReadingResume(lastPageRead);
    }
  }

  Future _createQuranTypeDB() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final quranTypeDBPath = '${appDocDir.path}/$APP_BASE_DIR/quranType';
    final dbFile = File('$quranTypeDBPath/quranType.db');

    if (!dbFile.existsSync()) dbFile.createSync(recursive: true);

    final dbMAnager = DBManager(dbFile.path);
    final parameters =
        defaultQuranTypes.map((quranType) => quranType.values).toList();
    dbMAnager.writeRecord(QuranTypesTableQueries.createTableQuranTypes);
    dbMAnager.writeRecords(QuranTypesTableQueries.addQuranType, parameters);
    await _listImagesAndSaveQuranTypeImages(quranTypeDBPath);
  }

  Future<void> _listImagesAndSaveQuranTypeImages(String quranTypeDBPath) async {
    try {
      var assetsPath = await rootBundle.loadString('AssetManifest.json');
      Map<String, dynamic> manifest = json.decode(assetsPath);

      for (var key in manifest.keys) {
        if (key.contains('quranTypeImages') && !key.contains('.DS_Store')) {
          var image = key.replaceAll('assets/quranTypeImages/', '');
          final file = File('$quranTypeDBPath/$image');
          final byteData = await rootBundle.load(key);
          final bytes = byteData.buffer.asUint8List();
          if (!file.existsSync()) file.writeAsBytesSync(bytes);
        }
      }
    } catch (_) {}
  }

  Future<void> copyAssets() async {
    try {
      var appDocDir = await getApplicationDocumentsDirectory();
      var appDocPath = appDocDir.path;

      var assetDir = await getAssetDir();
      var files = assetDir.listSync(recursive: true);

      for (var file in files) {
        var newPath = file.path.replaceFirst(assetDir.path, appDocPath);
        if (await FileSystemEntity.isDirectory(file.path)) {
          await Directory(newPath).create(recursive: true);
        } else {
          await (file as File).copy(newPath);
        }
      }
    } catch (e) {
      //print(e);
    }
  }

  Future<Directory> getAssetDir() async {
    final assetPath = await rootBundle.loadString('AssetManifest.json');
    var assets = assetPath
        .split('\n')
        .where((String asset) => asset.trim().isNotEmpty)
        .toList();
    var appDocPath = await getApplicationDocumentsDirectory()
        .then((Directory dir) => dir.path);
    var firstAsset = assets[0].replaceAll(RegExp(r'^"|"$'), '');
    var assetDirPath = '$appDocPath/${firstAsset.split('/').first}';
    return Directory(assetDirPath);
  }

  _handleReadingResume(String lastPageRead) {
    if (!lastPageRead.contains('null')) {
      prevReadinngPage = int.parse(lastPageRead);
      if (prevReadinngPage > 0) {
        startReading(int.parse(lastPageRead), shouldStream: true);
      }
    }
  }

  void showDownloadDialog({
    ValueChanged<String>? onDownload,
    ValueChanged<String>? onStream,
  }) {
    Get.dialog(
      name: 'Download dialog',
      GtkDialog(
        constraints: const BoxConstraints(
          maxWidth: 360,
        ),
        title: const Text(
          'Download Required Files?',
        ),
        start: const [],
        end: const [],
        actions: AdwActions(
          onClose: Get.back,
        ),
        headerBarStyle: const HeaderBarStyle(
          isTransparent: false,
        ),
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              'In order for the Quran app to work reliably without internet connection, we need to download some Quranic files, otherwise you will always need internet connection to stream Quran pages and recitations',
              textAlign: TextAlign.center,
            ),
          ),
          Divider(
            indent: 0,
            endIndent: 0,
            height: 0,
            color: Get.theme.dividerColor,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: SizedBox(
                  width: double.infinity,
                  child: AdwButton.flat(
                    padding: AdwButton.defaultButtonPadding.copyWith(
                      top: 10,
                      bottom: 10,
                    ),
                    child: const Text(
                      'Stream',
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      if (onStream != null) {
                        onStream('stream');
                      }
                    },
                  ),
                ),
              ),
              Container(
                color: Get.theme.dividerColor,
                height: 40,
                width: 2,
              ),
              Flexible(
                child: SizedBox(
                  width: double.infinity,
                  child: AdwButton.flat(
                    padding: AdwButton.defaultButtonPadding.copyWith(
                      top: 10,
                      bottom: 10,
                    ),
                    child: const Text(
                      'Downlaod',
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      if (onDownload != null) {
                        onDownload('downlaod');
                        Get.back();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future startQuranDownload({
    String quranType = 'tajweed',
    String size = 'width_1280',
    required ValueChanged<bool> onDownloaded,
  }) async {
    final storageRef = FirebaseStorage.instance.ref();
    try {
      final quranDbFile = storageRef.child('quran/$quranType/$quranType.zip');
      final appDocDir = await getApplicationDocumentsDirectory();
      final filePath = '${appDocDir.path}/$APP_BASE_DIR/quraan/$quranType.zip';

      final file = File(filePath);

      if (!file.existsSync()) file.createSync(recursive: true);

      final downloadTask = quranDbFile.writeToFile(file);
      await Get.dialog(
        Obx(
          () => WillPopScope(
            onWillPop: () async => false,
            child: IqraaDialog(
              title: 'Downloading $quranType',
              contents: [
                Row(
                  children: [
                    Text(
                      downloadStatus.value,
                    ),
                    const Spacer(),
                    Text(taskSize.value),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                LinearProgressIndicator(
                  value: downloadProgress.value,
                ),
              ],
            ),
          ),
        ),
      );
      downloadTask.snapshotEvents.listen((taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            downloadStatus.value = 'Downloading...';
            downloadProgress.value =
                taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
            final tSize = calculateDownloadProgress(
              taskSnapshot.totalBytes,
              taskSnapshot.bytesTransferred,
            ).toPrecision(1);
            taskSize.value = '${tSize}MB';
            break;
          case TaskState.paused:
            break;
          case TaskState.success:
            downloadStatus.value = 'Processing...';
            taskSize.value = '';
            downloadProgress.value = 0.0;
            await extractZipFile(file, (progress) {
              taskSize.value = '${progress.toInt()}%';
              downloadProgress.value = progress / 100.0;
              if (progress == 100.0) {
                /// Update preferences
                AppStorage.inst.store({
                  DEFAULT_QURAN_TYPE: quranType,
                });
                quranTypeDir.value = '$quranType/$size';
                onDownloaded(true);
              }
            });
            break;
          case TaskState.canceled:
            downloadStatus.value = 'Download cancelled';
            taskSize.value = '';
            downloadProgress.value = 0.0;
            onDownloaded(false);
            break;
          case TaskState.error:
            downloadStatus.value = 'Something went wrong';
            taskSize.value = '';
            downloadProgress.value = 0.0;
            onDownloaded(false);
            break;
        }
      });
    } catch (e) {
      downloadStatus.value = 'Something went wrong';
      taskSize.value = '';
      downloadProgress.value = 0.0;
    }
  }

  double calculateDownloadProgress(int totalBytes, int bytesTransferred) {
    final totalMB = totalBytes / (1024 * 1024);
    final transferredMB = bytesTransferred / (1024 * 1024);
    return transferredMB == totalMB ? totalMB : transferredMB / totalMB * 100;
  }

  Future<void> extractZipFile(File file, ValueChanged<double> onExtract) async {
    final bytes = file.readAsBytesSync();

    final archive = ZipDecoder().decodeBytes(bytes);
    final extractPath = path.dirname(file.path);
    var totalFiles = archive.length;
    var extractedFiles = 0;

    for (final file in archive) {
      final fileName = file.name;
      final filePath = '$extractPath/$fileName';

      if (file.isFile) {
        final data = file.content as List<int>;
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory(filePath).createSync(recursive: true);
      }
      extractedFiles++;
      var progress = extractedFiles / totalFiles * 100;
      onExtract(progress);
    }
    File(file.path).deleteSync();
  }

  void resetAyahSelection() {
    rightSelectedPageAyahBounds.value = null;
    leftSelectedPageAyahBounds.value = null;
    singlePageAyahBounds.value = null;
  }

  bool isSingle() {
    return !layout.isComputer(Get.context!);
  }

  void stopReading() {
    pageController.dispose();
    state.index.value = 0;
    _clearAll();
  }

  void _clearAll() {
    pagesToDisplay.value.clear();
    singlePageAyahBounds.value = null;
    leftSelectedPageAyahBounds.value = null;
    rightSelectedPageAyahBounds.value = null;
    pagesToDisplay.refresh();
  }

  Future<void> loadMorePages(int page, bool isNext) async {
    final totalPages = isSingle()
        ? pagesToDisplay.value.length
        : (pagesToDisplay.value.length ~/ 2);

    if (totalPages - page == 2 && isNext) {
      final lastPageNumber = pagesToDisplay.value.last.pageNumber;
      final nextPageInitial =
          totalPages.isEven ? lastPageNumber + 7 : lastPageNumber + 6;
      var maxLength = totalPages.isEven ? maxPagesToLoad - 1 : maxPagesToLoad;
      final nextPagesList =
          generateNextAndPrevPages(nextPageInitial, maxLength: maxLength);

      if (nextPagesList.isNotEmpty) {
        /// IF > [maxPagesToLoad] REMOVING FIRST 2 - TO AVOID DUPLICATE PAGES
        if (nextPagesList.length > maxPagesToLoad) {
          nextPagesList.removeRange(0, 2);
        }

        // IF == [maxPagesToLoad - 1] ADD FIRST 1 MISSING PAGE
        nextPagesList.addIf(
          nextPagesList.length == maxPagesToLoad - 1,
          lastPageNumber + 1,
        );
        nextPagesList.sort();

        final morePages = await _getPages(nextPagesList);
        morePages.sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
        pagesToDisplay.value.addAll(morePages);
        print(
          'More pages loaded: we now have total of ${pagesToDisplay.value.length} pages',
        );
        // Reduce already read pages [from 0 - maxPagesToLoad] if current pages > 30
        if (pagesToDisplay.value.length > 50) {
          final pagesToReduce = pagesToDisplay.value.length - 22;
          pagesToDisplay.value.removeRange(0, pagesToReduce);
          print(
            'current page is $page ] pages reduced to ${pagesToDisplay.value.length}',
          );
          pagesToDisplay.value
              .sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
          print(pagesToDisplay.value[page - pagesToReduce].pageNumber);
          pageController.jumpToPage(page - pagesToReduce);
        }
        pagesToDisplay.refresh();
      }
    } else if (totalPages - page == totalPages - 1 && !isNext) {
      final firstPageNumber = pagesToDisplay.value.first.pageNumber;
      var prevPageInitial = firstPageNumber - 1;
      final prevPagesList =
          generatePreviousPages(prevPageInitial, maxPagesToLoad);
      if (prevPagesList.isNotEmpty) {
        final morePrevPages = await _getPages(prevPagesList);
        //morePrevPages.reversed;
        pagesToDisplay.value.insertAll(0, morePrevPages);
        // // Reducing pages if greater than 30
        print(
          'CURRENT $page More Prev Loaded: we now have total of ${pagesToDisplay.value.length} pages',
        );
        //if (pagesToDisplay.value.length > 22) {
        var pagesToReduce = pagesToDisplay.value.length - 22;
        //print('pages to remove $pagesToReduce');
        // pagesToDisplay.value.removeRange(
        //     pagesToDisplay.value.length - pagesToReduce,
        //     pagesToDisplay.value.length);
        //print('pages reduced to ${pagesToDisplay.value.length}');
        pagesToDisplay.value
            .sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
        //}
        pagesToDisplay.refresh();
        //pageController.jumpToPage(page + morePrevPages.length - 1);
      }
    }
  }

  Future<List<PageModel>> _getPages(List<int> pageNumbers) async {
    var quranWidth = !fullScreen.isTrue ? Get.width : Get.width - 300;
    var quranInnerWidth = quranWidth - 90;
    final pagesCoordinates = await _ayahInfoHandler.getVersesBoundsForPage(
      pageNumbers,
      quranTypeDir.value,
      '1280',
    );
    var pages = <PageModel>[];
    pagesCoordinates.forEach((key, value) {
      final pageImage =
          '$appDocumentDirectory/quraan/$quranTypeDir/width_1280/page${key.toString().padLeft(3, '0')}.png';
      final ayahCoordinates = _coordinatesModel.normalizePageAyahs(
        AyahCoordinates(
          page: key,
          suraAyah: value.suraAyah,
          lastSuraAyah: value.lastSuraAyah,
          ayahCoordinates: value.ayahCoordinates,
        ),
        Size(
          quranInnerWidth / 2,
          Get.height - 180,
        ),
      );
      final page = PageModel(
        pageNumber: key,
        suraAyah: ayahCoordinates.suraAyah,
        lastSuraAyah: ayahCoordinates.lastSuraAyah,
        pageImage: pageImage,
        ayahCoordinates: ayahCoordinates.ayahCoordinates,
      );
      pages.add(page);
    });
    return pages;
  }
}

// Exciting Update! 🎉 Don't miss out on the ongoing Al-Tibyan American International Quran Competition, happening right now in the enchanting state of Minnesota. Today marks the second day of this incredible program, filled with reverence and excellence.

// Join me in this immersive experience by following the live link below. Witness the mastery of recitation and the profound connection to the Quran displayed by talented participants from around the globe.

// Let's come together virtually and celebrate the power of faith and unity. Be part of this remarkable event, even from the comfort of your own home. Don't miss out on this extraordinary opportunity to connect with the beauty of the Quran and be inspired.

// #quran #experience #event #AlTibyanQuranCompetition #Minnesota #FaithInAction #liveevents
