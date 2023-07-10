class QuranTypeModel {
  int id;
  String title;
  String description;
  List<String> images;
  String downlaodURL;
  bool isDownloaded;
  QuranTypeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.downlaodURL,
    required this.isDownloaded,
  });

  factory QuranTypeModel.fromList(List<Object?> list) {
    return QuranTypeModel(
      id: list[0] as int,
      title: list[1] as String,
      description: list[2] as String,
      images: (list[3] as String).split(','),
      downlaodURL: list[4] as String,
      isDownloaded: list[5] == 0 ? false : true,
    );
  }
}
