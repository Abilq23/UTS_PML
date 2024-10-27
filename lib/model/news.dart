class News {
  final String id;
  final String title;
  final String content;
  final String date;
  final String? imageId;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.imageId,
  });

  factory News.fromMap(Map<String, dynamic> data) {
    return News(
      id: data['\$id'],
      title: data['title'],
      content: data['content'],
      date: data['date'],
      imageId: data['imageId'],
    );
  }
}