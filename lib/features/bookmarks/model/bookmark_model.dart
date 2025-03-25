class Bookmark {
  final int chapterNumber;
  final String chapterName;
  final String arabicName;
  final int pageNumber;

  Bookmark({
    required this.chapterNumber,
    required this.chapterName,
    required this.arabicName,
    required this.pageNumber,
  });

  // Convert Bookmark to JSON
  Map<String, dynamic> toJson() => {
    'chapterNumber': chapterNumber,
    'chapterName': chapterName,
    'arabicName': arabicName,
    'pageNumber': pageNumber,
  };

  // Create Bookmark from JSON
  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
    chapterNumber: json['chapterNumber'],
    chapterName: json['chapterName'],
    arabicName: json['arabicName'],
    pageNumber: json['pageNumber'],
  );
}
