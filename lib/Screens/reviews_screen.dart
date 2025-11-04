// screens/reviews_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/data_manager.dart';
import '../models/book_model.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'My Reviews',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A148C),
                ),
              ),
            ),

            // Reviews list
            Expanded(
              child: Consumer<DataManager>(
                builder: (context, dataManager, child) {
                  final reviewedBooks = dataManager.booksWithReviews;

                  if (reviewedBooks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 80,
                            color: Colors.deepPurple.withValues(alpha: 26.0),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No reviews yet!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple.withValues(alpha: 26.0),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Write your first one',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.deepPurple.withValues(alpha: 26.0),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    itemCount: reviewedBooks.length,
                    itemBuilder: (context, index) {
                      return _buildReviewCard(
                        context,
                        reviewedBooks[index],
                        dataManager,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(
    BuildContext context,
    Book book,
    DataManager dataManager,
  ) {
    final String? thumb = book.thumbnail;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shadowColor: Colors.deepPurple.withValues(alpha: 26.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book info row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: thumb != null
                      ? Image.network(
                          thumb,
                          width: 50,
                          height: 75,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),
                const SizedBox(width: 12),

                // Book details- auther and title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
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
                    ],
                  ),
                ),

                // Action buttons
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Color(0xFF9575CD),
                        size: 20,
                      ),
                      onPressed: () {
                        _showEditReviewDialog(context, book, dataManager);
                      },
                      tooltip: 'Edit review',
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFFEF5350),
                        size: 20,
                      ),
                      onPressed: () {
                        _showDeleteReviewDialog(context, book, dataManager);
                      },
                      tooltip: 'Delete review',
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // space divider for decoration
            Container(height: 1, color: const Color(0xFFE1BEE7)),

            const SizedBox(height: 12),

            // Review text
            Text(
              book.review ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6A1B9A),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 50,
      height: 75,
      color: const Color(0xFFE1BEE7),
      child: const Icon(Icons.book, size: 24, color: Color(0xFF9575CD)),
    );
  }

  void _showEditReviewDialog(
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
          'Edit Review',
          style: TextStyle(color: Color(0xFF4A148C)),
        ),
        content: TextField(
          controller: controller,
          maxLines: 5,
          autofocus: true,
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
                  content: Text('Review updated!'),
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

  void _showDeleteReviewDialog(
    BuildContext context,
    Book book,
    DataManager dataManager,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Review?',
          style: TextStyle(color: Color(0xFF4A148C)),
        ),
        content: const Text(
          'Are you sure you want to delete this review?',
          style: TextStyle(color: Color(0xFF6A1B9A)),
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
              dataManager.addReview(book.id, '');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Review deleted'),
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
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
