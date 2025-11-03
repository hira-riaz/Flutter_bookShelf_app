// data/data_manager.dart
import 'package:flutter/foundation.dart';
import '../models/book_model.dart';

class DataManager extends ChangeNotifier {
  final List<Book> _books = [];

  List<Book> get allBooks => List.unmodifiable(_books);

  List<Book> get readBooks => _books.where((book) => book.isRead).toList();

  List<Book> get toReadBooks =>
      _books.where((book) => book.isToRead && !book.isRead).toList();

  List<Book> get favoriteBooks =>
      _books.where((book) => book.isFavorite).toList();

  List<Book> get recentlyViewed {
    final viewed = _books.where((book) => book.lastViewed != null).toList();
    viewed.sort((a, b) => b.lastViewed!.compareTo(a.lastViewed!));
    return viewed.take(10).toList();
  }

  List<Book> get booksWithReviews => _books
      .where((book) => book.review != null && book.review!.isNotEmpty)
      .toList();

  Book? getBookById(String id) {
    try {
      return _books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }

  void addBook(Book book) {
    if (!_books.any((b) => b.id == book.id)) {
      _books.add(book);
      notifyListeners();
    }
  }

  void updateBook(Book updatedBook) {
    final index = _books.indexWhere((book) => book.id == updatedBook.id);
    if (index != -1) {
      _books[index] = updatedBook;
      notifyListeners();
    }
  }

  void deleteBook(String id) {
    _books.removeWhere((book) => book.id == id);
    notifyListeners();
  }

  void markAsRead(String id) {
    final book = getBookById(id);
    if (book != null) {
      book.isRead = true;
      book.isToRead = false; // Can't be both
      notifyListeners();
    } else {
      // Book not in library, add it
      final newBook = Book(id: id, title: 'Book', isRead: true);
      addBook(newBook);
    }
  }

  void markAsToRead(String id) {
    final book = getBookById(id);
    if (book != null) {
      if (!book.isRead) {
        book.isToRead = true;
      }
      notifyListeners();
    }
  }

  void toggleFavorite(String id) {
    final book = getBookById(id);
    if (book != null) {
      book.isFavorite = !book.isFavorite;
      notifyListeners();
    }
  }

  void addReview(String id, String reviewText) {
    final book = getBookById(id);
    if (book != null) {
      book.review = reviewText;
      notifyListeners();
    }
  }

  void updateLastViewed(String id) {
    final book = getBookById(id);
    if (book != null) {
      book.lastViewed = DateTime.now();
      notifyListeners();
    }
  }

  void addOrUpdateBookFromSearch(Book searchBook) {
    final existingBook = getBookById(searchBook.id);
    if (existingBook == null) {
      addBook(searchBook);
    }
  }
}
