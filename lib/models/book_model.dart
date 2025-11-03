// models/book_model.dart
class Book {
  final String id;
  final String title;
  final String? author;
  final String? thumbnail;
  bool isRead;
  bool isToRead;
  bool isFavorite;
  String? review;
  DateTime? lastViewed;

  Book({
    required this.id,
    required this.title,
    this.author,
    this.thumbnail,
    this.isRead = false,
    this.isToRead = false,
    this.isFavorite = false,
    this.review,
    this.lastViewed,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};

    return Book(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'Unknown Title',
      author: (volumeInfo['authors'] as List?)?.join(', '),
      thumbnail: imageLinks['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'thumbnail': thumbnail,
      'isRead': isRead,
      'isToRead': isToRead,
      'isFavorite': isFavorite,
      'review': review,
      'lastViewed': lastViewed?.toIso8601String(),
    };
  }

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? thumbnail,
    bool? isRead,
    bool? isToRead,
    bool? isFavorite,
    String? review,
    DateTime? lastViewed,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      thumbnail: thumbnail ?? this.thumbnail,
      isRead: isRead ?? this.isRead,
      isToRead: isToRead ?? this.isToRead,
      isFavorite: isFavorite ?? this.isFavorite,
      review: review ?? this.review,
      lastViewed: lastViewed ?? this.lastViewed,
    );
  }
}
