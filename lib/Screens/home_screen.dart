// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/data_manager.dart';
import '../models/book_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE1BEE7), Color(0xFFF7F2FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
             const Padding(
                padding:  EdgeInsets.all(20.0),
                child: Row(
                  children: [
                     Text(
                      'Reading Now ',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A148C),
                      ),
                    ),
                  ],
                ),
              ),

              // Currently reading section
              Consumer<DataManager>(
                builder: (context, dataManager, child) {
                  final readingNow = dataManager.toReadBooks;

                  if (readingNow.isEmpty) {
                    return _buildEmptyState();
                  }

                  return SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: readingNow.length,
                      itemBuilder: (context, index) {
                        return _buildBookCard(readingNow[index]);
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Recently viewed section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Recently Viewed',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A1B9A),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: Consumer<DataManager>(
                  builder: (context, dataManager, child) {
                    final recentBooks = dataManager.recentlyViewed;

                    if (recentBooks.isEmpty) {
                      return Center(
                        child: Text(
                          'No recent books yet',
                          style: TextStyle(
                            color: Colors.deepPurple.withValues(alpha: 26.0),
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: recentBooks.length,
                      itemBuilder: (context, index) {
                        return _buildRecentBookTile(recentBooks[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 26.0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1BEE7), width: 2),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book_outlined, size: 64, color: Color(0xFFB39DDB)),
            SizedBox(height: 16),
            Text(
              'No books yet!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Search to add some',
              style: TextStyle(fontSize: 14, color: Color(0xFF9575CD)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(Book book) {
    final String? thumb = book.thumbnail;
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 6,
        shadowColor: Colors.deepPurple.withValues(alpha: 26.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: thumb != null
                    ? Image.network(
                        thumb,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A148C),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentBookTile(Book book) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shadowColor: Colors.deepPurple.withValues(alpha: 26.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: (() {
            final String? thumb = book.thumbnail;
            return thumb != null
                ? Image.network(
                    thumb,
                    width: 50,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildSmallPlaceholder(),
                  )
                : _buildSmallPlaceholder();
          })(),
        ),
        title: Text(
          book.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A148C),
          ),
        ),
        subtitle: book.author != null
            ? Text(
                book.author!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF9575CD), fontSize: 12),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (book.isRead)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF66BB6A),
                size: 20,
              ),
            if (book.isFavorite)
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(Icons.favorite, color: Color(0xFFE91E63), size: 20),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 140,
      width: double.infinity,
      color: const Color(0xFFE1BEE7),
      child: const Icon(Icons.book, size: 48, color: Color(0xFF9575CD)),
    );
  }

  Widget _buildSmallPlaceholder() {
    return Container(
      width: 50,
      height: 70,
      color: const Color(0xFFE1BEE7),
      child: const Icon(Icons.book, size: 24, color: Color(0xFF9575CD)),
    );
  }
}
