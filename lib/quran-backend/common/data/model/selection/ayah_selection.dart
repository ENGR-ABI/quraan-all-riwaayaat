import '../sura_ayah.dart';
import 'selection_indicator.dart';

abstract class AyahSelection {}

class None extends AyahSelection {}

class Ayah extends AyahSelection {
  final SuraAyah suraAyah;
  final SelectionIndicator selectionIndicator;

  Ayah(this.suraAyah, {required this.selectionIndicator});
}

class AyahRange extends AyahSelection {
  final SuraAyah startSuraAyah;
  final SuraAyah endSuraAyah;
  final SelectionIndicator selectionIndicator;

  AyahRange(this.startSuraAyah, this.endSuraAyah,
      {required this.selectionIndicator});
}

AyahSelection withSelectionIndicator(
    AyahSelection ayahSelection, SelectionIndicator selectionIndicator) {
  if (ayahSelection is None) {
    return ayahSelection;
  } else if (ayahSelection is Ayah) {
    return Ayah(
      ayahSelection.suraAyah,
      selectionIndicator: selectionIndicator,
    );
  } else if (ayahSelection is AyahRange) {
    return AyahRange(
      ayahSelection.startSuraAyah,
      ayahSelection.endSuraAyah,
      selectionIndicator: selectionIndicator,
    );
  }
  throw ArgumentError("Invalid ayahSelection");
}

SelectionIndicator selectionIndicator(AyahSelection ayahSelection) {
  if (ayahSelection is None) {
    return NoneIndicator();
  } else if (ayahSelection is Ayah) {
    return ayahSelection.selectionIndicator;
  } else if (ayahSelection is AyahRange) {
    return ayahSelection.selectionIndicator;
  }
  throw ArgumentError("Invalid ayahSelection");
}

SuraAyah? startSuraAyah(AyahSelection ayahSelection) {
  if (ayahSelection is Ayah) {
    return ayahSelection.suraAyah;
  } else if (ayahSelection is AyahRange) {
    return ayahSelection.startSuraAyah;
  } else {
    return null;
  }
}

SuraAyah? endSuraAyah(AyahSelection ayahSelection) {
  if (ayahSelection is Ayah) {
    return ayahSelection.suraAyah;
  } else if (ayahSelection is AyahRange) {
    return ayahSelection.endSuraAyah;
  } else {
    return null;
  }
}
