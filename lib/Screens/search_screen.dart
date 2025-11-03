// screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/data_manager.dart';
import '../models/book_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchBooks(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://www.googleapis.com/books/v1/volumes?q=${Uri.encodeComponent(query)}&maxResults=20&key=AIzaSyCd2HyJkpHgyfu7jdYPzBvGFVJqLNg-89I',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List items = data['items'] ?? [];

        setState(() {
          _searchResults = items.map((item) => Book.fromJson(item)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _searchResults = [];
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to load books'),
              backgroundColor: Color(0xFFEF5350),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Network error. Please try again.'),
            backgroundColor: Color(0xFFEF5350),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header & Search Bar
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Search Books 🔍',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A148C),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1BEE7).withValues(alpha: 26.0),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withValues(alpha: 26.0),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: _searchBooks,
                      decoration: InputDecoration(
                        hintText: 'Search for books...',
                        hintStyle: const TextStyle(color: Color(0xFF9575CD)),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF6A1B9A),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Color(0xFF9575CD),
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchResults = [];
                                    _hasSearched = false;
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      style: const TextStyle(color: Color(0xFF4A148C)),
                    ),
                  ),
                ],
              ),
            ),

            // Results
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF9575CD),
                      ),
                    )
                  : _searchResults.isEmpty && _hasSearched
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.deepPurple.withValues(alpha: 26.0),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No books found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.deepPurple.withValues(alpha: 26.0),
                            ),
                          ),
                        ],
                      ),
                    )
                  : _searchResults.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.menu_book_rounded,
                            size: 80,
                            color: Colors.deepPurple.withValues(alpha: 26.0),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Search for your next book! 📖',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.deepPurple.withValues(alpha: 26.0),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        return _buildBookCard(_searchResults[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(Book book) {
    return Consumer<DataManager>(
      builder: (context, dataManager, child) {
        var existingBook = dataManager.getBookById(book.id);
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          shadowColor: Colors.deepPurple.withValues(alpha: 26.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: book.thumbnail != null
                      ? Image.network(
                          book.thumbnail!,
                          width: 60,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),
                const SizedBox(width: 12),

                // Book info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A148C),
                        ),
                      ),
                      if (book.author != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          book.author!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9575CD),
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      if (existingBook != null)
                        Wrap(
                          spacing: 4,
                          children: [
                            if (existingBook.isRead)
                              _buildStatusChip(
                                'Read',
                                Icons.check_circle,
                                const Color(0xFF66BB6A),
                              ),
                            if (existingBook.isToRead)
                              _buildStatusChip(
                                'To-Read',
                                Icons.bookmark,
                                const Color(0xFF42A5F5),
                              ),
                            if (existingBook.isFavorite)
                              _buildStatusChip(
                                'Favorite',
                                Icons.favorite,
                                const Color(0xFFE91E63),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),

                // Menu button
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Color(0xFF6A1B9A)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    _handleMenuAction(context, value, book, dataManager);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'read',
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Color(0xFF66BB6A),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text('Mark as Read ✅'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'toread',
                      child: Row(
                        children: [
                          Icon(
                            Icons.bookmark_add_outlined,
                            color: Color(0xFF42A5F5),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text('Add to To-Read 📚'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'favorite',
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            color: Color(0xFFE91E63),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text('Add to Favorites 💖'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'review',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            color: Color(0xFF9575CD),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text('Write a Review 📝'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String label, IconData icon, Color color) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
      avatar: Icon(icon, size: 14, color: Colors.white),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 60,
      height: 90,
      color: const Color(0xFFE1BEE7),
      child: const Icon(Icons.book, size: 30, color: Color(0xFF9575CD)),
    );
  }

  void _handleMenuAction(
    BuildContext context,
    String action,
    Book book,
    DataManager dataManager,
  ) {
    dataManager.addOrUpdateBookFromSearch(book);

    switch (action) {
      case 'read':
        dataManager.markAsRead(book.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Marked as Read! ✅'),
            backgroundColor: Color(0xFF66BB6A),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'toread':
        dataManager.markAsToRead(book.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to To-Read! 📚'),
            backgroundColor: Color(0xFF42A5F5),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'favorite':
        dataManager.toggleFavorite(book.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to Favorites! 💖'),
            backgroundColor: Color(0xFFE91E63),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'review':
        _showReviewDialog(context, book, dataManager);
        break;
    }

    dataManager.updateLastViewed(book.id);
  }

  void _showReviewDialog(
    BuildContext context,
    Book book,
    DataManager dataManager,
  ) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Write a Review 📝',
          style: TextStyle(color: Color(0xFF4A148C)),
        ),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Share your thoughts...',
            hintStyle: TextStyle(
              color: Colors.deepPurple.withValues(alpha: 26.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE1BEE7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF9575CD), width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF9575CD)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              dataManager.addReview(book.id, controller.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Review saved! 💜'),
                  backgroundColor: Color(0xFF9575CD),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCE93D8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
