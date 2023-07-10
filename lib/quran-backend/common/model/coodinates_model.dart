import 'dart:math';
import 'dart:ui';
import '../data/model/ayah_bounds.dart';
import 'ayah_coordinates.dart';

class CoordinatesModel {
  // ignore: constant_identifier_names
  static const double THRESHOLD_PERCENTAGE = 0.015;

  //final AyahInfoDatabaseProvider ayahInfoDatabaseProvider;

  CoordinatesModel();

  // Observable<PageCoordinates> getPageCoordinates(
  //     bool wantPageBounds, List<int> pages) {
  //   final database = ayahInfoDatabaseProvider.getAyahInfoHandler();
  //   if (database == null) {
  //     return Observable.error(
  //         NoSuchElementException('No AyahInfoDatabaseHandler found!'));
  //   }

  //   return Observable.fromIterable(pages)
  //       .map((page) => database.getPageInfo(page, wantPageBounds))
  //       .subscribeOn(ComputationalScheduler());
  // }

  // Observable<AyahCoordinates> getAyahCoordinates(List<int> pages) {
  //   final database = ayahInfoDatabaseProvider.getAyahInfoHandler();
  //   if (database == null) {
  //     return Observable.error(
  //         NoSuchElementException('No AyahInfoDatabaseHandler found!'));
  //   }

  //   return Observable.fromIterable(pages)
  //       .map(database.getVersesBoundsForPage)
  //       .map(normalizePageAyahs)
  //       .subscribeOn(ComputationalScheduler());
  // }

  AyahCoordinates normalizePageAyahs(
      AyahCoordinates ayahCoordinates, Size size) {
    final original = ayahCoordinates.ayahCoordinates;
    final normalizedMap = <String, List<AyahBounds>>{};
    final keys = original.keys.toSet();

    for (final key in keys) {
      final normalBounds = original[key];
      if (normalBounds != null) {
        normalizedMap[key] = normalizeAyahBoundsBySize(normalBounds, size);
      }
    }

    return AyahCoordinates(
      page: ayahCoordinates.page,
      suraAyah: ayahCoordinates.suraAyah,
      lastSuraAyah: ayahCoordinates.lastSuraAyah,
      ayahCoordinates: normalizedMap,
    );
  }

  // ...

  List<AyahBounds> normalizeAyahBounds(List<AyahBounds> ayahBounds) {
    final int total = ayahBounds.length;
    if (total < 2) {
      return ayahBounds;
    } else if (total < 3) {
      return consolidate(ayahBounds[0], ayahBounds[1]);
    } else {
      AyahBounds middle = ayahBounds[1];
      for (int i = 2; i < total - 1; i++) {
        middle.engulf(ayahBounds[i]);
      }

      List<AyahBounds> top = consolidate(ayahBounds[0], middle);
      final int topSize = top.length;
      // the first parameter is essentially middle (after its consolidation with the top line)
      List<AyahBounds> bottom =
          consolidate(top[topSize - 1], ayahBounds[total - 1]);

      List<AyahBounds> result = [];
      if (topSize == 1) {
        return bottom;
      } else if (topSize + bottom.length > 4) {
        // this happens when a verse spans 3 incomplete lines (i.e. starts towards the end of
        // one line, takes one or more whole lines, and ends early on in the line). in this case,
        // just remove the duplicates.

        // add the first parts of top
        for (int i = 0; i < topSize - 1; i++) {
          result.add(top[i]);
        }

        // resolve the middle part which may overlap with bottom
        final AyahBounds lastTop = top[topSize - 1];
        final AyahBounds firstBottom = bottom[0];
        if (lastTop == firstBottom) {
          // only add one if they're both the same
          result.add(lastTop);
        } else {
          // if one contains the other, add the larger one
          final Offset topOffset = Offset(
            lastTop.bounds.left.toDouble(),
            lastTop.bounds.top.toDouble(),
          );
          final Offset bottomOffset = Offset(
            firstBottom.bounds.left.toDouble(),
            firstBottom.bounds.top.toDouble(),
          );
          if (Rect.fromPoints(topOffset, bottomOffset).contains(bottomOffset)) {
            result.add(lastTop);
          } else if (Rect.fromPoints(bottomOffset, topOffset)
              .contains(topOffset)) {
            result.add(firstBottom);
          } else {
            // otherwise add both
            result.add(lastTop);
            result.add(firstBottom);
          }
        }

        // add everything except the first bottom entry
        for (int i = 1, size = bottom.length; i < size; i++) {
          result.add(bottom[i]);
        }
        return result;
      } else {
        // re-consolidate top and middle again, since middle may have changed
        top = consolidate(top[0], bottom[0]);
        result.addAll(top);
        if (bottom.length > 1) {
          result.add(bottom[1]);
        }
        return result;
      }
    }
  }

// ...

  List<AyahBounds> consolidate(AyahBounds top, AyahBounds bottom) {
    Rect firstRect = top.bounds;
    Rect lastRect = bottom.bounds;

    AyahBounds? middle;

    double pageWidth = 1280;
    int threshold = (THRESHOLD_PERCENTAGE * pageWidth).toInt();

    bool firstIsFullLine = (firstRect.right - lastRect.right).abs() < threshold;
    bool secondIsFullLine = (firstRect.left - lastRect.left).abs() < threshold;

    if (firstIsFullLine && secondIsFullLine) {
      top.engulf(bottom);
      return [top];
    } else if (firstIsFullLine) {
      double bestStartOfLine = max(firstRect.right, lastRect.right);
      lastRect = Rect.fromLTRB(
        lastRect.left,
        firstRect.bottom,
        bestStartOfLine,
        lastRect.bottom,
      );
      firstRect = Rect.fromLTRB(
        firstRect.left,
        firstRect.top,
        bestStartOfLine,
        lastRect.top,
      );

      top = top.withBounds(firstRect);
      bottom = bottom.withBounds(lastRect);
    } else if (secondIsFullLine) {
      double bestEndOfLine = min(firstRect.left, lastRect.left);
      firstRect = Rect.fromLTRB(
        bestEndOfLine,
        firstRect.top,
        firstRect.left,
        lastRect.top,
      );
      lastRect = Rect.fromLTRB(
        bestEndOfLine,
        firstRect.bottom,
        lastRect.right,
        lastRect.top,
      );

      top = top.withBounds(firstRect);
      bottom = bottom.withBounds(lastRect);
    } else {
      if (lastRect.left < firstRect.right) {
        Rect middleBounds = Rect.fromLTRB(
          lastRect.left,
          firstRect.bottom,
          min(firstRect.right, lastRect.right),
          lastRect.top,
        );
        middle = AyahBounds.withRect(
          top.ayah,
          top.line,
          top.position,
          middleBounds,
        );
      }
    }

    List<AyahBounds> result = [];
    result.add(top);
    if (middle != null) result.add(middle);
    result.add(bottom);
    return result;
  }

  List<AyahBounds> normalizeAyahBoundsBySize(
      List<AyahBounds> bounds, Size size) {
    List<AyahBounds> result = [];
    for (var bound in bounds) {
      final rect = bound.bounds;

      //bool isFirstVerse = verse.ayah == firstVerse;

      final newLeft = (rect.left * .37) < 0.0 ? 0.0 : rect.left * .37;
      final newRight =
          (rect.right * .37) > size.width ? size.width : rect.right * .37;
      double topScaleFactor =
          ((size.height / 15) * (bound.line - 1)) / rect.top;
      double bottomScaleFactor =
          ((size.height / 15) * bound.line) / rect.bottom;

      // Create the adjusted Rect
      final adjustedRect = Rect.fromLTRB(
        newLeft,
        rect.top * topScaleFactor + 6,
        newRight,
        rect.bottom * bottomScaleFactor + 6,
      );
      result.add(
        AyahBounds.withRect(
            bound.ayah, bound.line, bound.position, adjustedRect),
      );
    }
    return result;
  }
}
