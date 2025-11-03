// screens/library_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/data_manager.dart';
import '../models/book_model.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Text(
                      'My Library 📚',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A148C),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Read Books Section
            Consumer<DataManager>(
              builder: (context, dataManager, child) {
                return _buildSection(
                  context,
                  'Read Books ✅',
                  dataManager.readBooks,
                  dataManager,
                );
              },
            ),

            // To-Read Books Section
            Consumer<DataManager>(
              builder: (context, dataManager, child) {
                return _buildSection(
                  context,
                  'To-Read Books 📘',
                  dataManager.toReadBooks,
                  dataManager,
                );
              },
            ),

            // Favorite Books Section
            Consumer<DataManager>(
              builder: (context, dataManager, child) {
                return _buildSection(
                  context,
                  'Favorites 💖',
                  dataManager.favoriteBooks,
                  dataManager,
                );
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Book> books,
    DataManager dataManager,
  ) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A),
              ),
            ),
          ),
          if (books.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withValues(alpha: 26.0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE1BEE7)),
                ),
                child: Center(
                  child: Text(
                    'No books in this section yet',
                    style: TextStyle(
                      color: Colors.deepPurple.withValues(alpha: 26.0),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return _buildBookCard(context, books[index], dataManager);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBookCard(
    BuildContext context,
    Book book,
    DataManager dataManager,
  ) {
    return Card(
      elevation: 4,
      shadowColor: Colors.deepPurple.withValues(alpha: 26.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book Cover
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: book.thumbnail != null
                      ? Image.network(
                          book.thumbnail!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),
                // Status Icons
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      if (book.isRead)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Color(0xFF66BB6A),
                            size: 18,
                          ),
                        ),
                      if (book.isToRead)
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.bookmark,
                            color: Color(0xFF42A5F5),
                            size: 18,
                          ),
                        ),
                      if (book.isFavorite)
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Color(0xFFE91E63),
                            size: 18,
                          ),
                        ),
                    ],
                  ),
                ),
                // 3-dot menu
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Color(0xFF6A1B9A),
                        size: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) {
                        _handleMenuAction(context, value, book, dataManager);
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'read',
                          child: Row(
                            children: [
                              Icon(
                                book.isRead
                                    ? Icons.remove_circle_outline
                                    : Icons.check_circle_outline,
                                color: const Color(0xFF66BB6A),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                book.isRead ? 'Unmark as Read' : 'Mark as Read',
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'toread',
                          child: Row(
                            children: [
                              Icon(
                                book.isToRead
                                    ? Icons.bookmark_remove
                                    : Icons.bookmark_add_outlined,
                                color: const Color(0xFF42A5F5),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                book.isToRead
                                    ? 'Remove from To-Read'
                                    : 'Add to To-Read',
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'favorite',
                          child: Row(
                            children: [
                              Icon(
                                book.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: const Color(0xFFE91E63),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                book.isFavorite
                                    ? 'Remove from Favorites'
                                    : 'Add to Favorites',
                              ),
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
                              Text('Write a Review'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: Color(0xFFEF5350),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text('Remove Book'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Book Info
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
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
                        fontSize: 11,
                        color: Color(0xFF9575CD),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFE1BEE7),
      child: const Icon(Icons.book, size: 48, color: Color(0xFF9575CD)),
    );
  }

  void _handleMenuAction(
    BuildContext context,
    String action,
    Book book,
    DataManager dataManager,
  ) {
    switch (action) {
      case 'read':
        if (book.isRead) {
          book.isRead = false;
          dataManager.updateBook(book);
        } else {
          dataManager.markAsRead(book.id);
        }
        break;
      case 'toread':
        if (book.isToRead) {
          book.isToRead = false;
          dataManager.updateBook(book);
        } else {
          if (!book.isRead) {
            dataManager.markAsToRead(book.id);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cannot add Read books to To-Read'),
                backgroundColor: Color(0xFF9575CD),
              ),
            );
          }
        }
        break;
      case 'favorite':
        dataManager.toggleFavorite(book.id);
        break;
      case 'review':
        _showReviewDialog(context, book, dataManager);
        break;
      case 'delete':
        _showDeleteDialog(context, book, dataManager);
        break;
    }
  }

  void _showReviewDialog(
    BuildContext context,
    Book book,
    DataManager dataManager,
  ) {
    final controller = TextEditingController(text: book.review ?? '');

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

  void _showDeleteDialog(
    BuildContext context,
    Book book,
    DataManager dataManager,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Remove Book?',
          style: TextStyle(color: Color(0xFF4A148C)),
        ),
        content: Text(
          'Are you sure you want to remove "${book.title}" from your library?',
          style: const TextStyle(color: Color(0xFF6A1B9A)),
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
              dataManager.deleteBook(book.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Book removed'),
                  backgroundColor: Color(0xFF9575CD),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF5350),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
