import 'package:flutter/material.dart';
import 'package:quran_pak_app/features/home/pdf_view_screen.dart';
import 'bookmark_manager.dart';
import 'model/bookmark_model.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  List<Bookmark> _bookmarks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  void _loadBookmarks() async {
    final bookmarks = await BookmarkManager.getBookmarks();
    setState(() {
      _bookmarks = bookmarks;
      _isLoading = false;
    });
  }

  void _removeBookmark(Bookmark bookmark) async {
    await BookmarkManager.removeBookmark(bookmark);
    _loadBookmarks();
  }

  void _clearAllBookmarks() async {
    await BookmarkManager.clearBookmarks();
    _loadBookmarks();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All bookmarks cleared'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('My Bookmarks'),
        backgroundColor: const Color(0xFF1F4068),
        actions: [
          if (_bookmarks.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              tooltip: 'Clear All Bookmarks',
              onPressed: () => _showClearAllConfirmationDialog(),
            ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _bookmarks.isEmpty
              ? _buildEmptyBookmarksView()
              : _buildBookmarksList(),
    );
  }

  Widget _buildEmptyBookmarksView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text(
            'No Bookmarks Yet',
            style: TextStyle(
              fontSize: 22,
              color: Colors.grey,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Start reading and add bookmarks\nto keep track of your favorite pages',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarksList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: _bookmarks.length,
      separatorBuilder:
          (context, index) =>
              const Divider(indent: 16, endIndent: 16, color: Colors.grey),
      itemBuilder: (context, index) {
        final bookmark = _bookmarks[index];
        return Dismissible(
          key: Key(bookmark.hashCode.toString()),
          background: _buildDismissBackground(),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) => _removeBookmark(bookmark),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF1F4068).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  bookmark.chapterNumber.toString(),
                  style: TextStyle(
                    color: const Color(0xFF1F4068),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              bookmark.chapterName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Page ${bookmark.pageNumber} | ${bookmark.arabicName}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF1F4068)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => PdfViewerScreen(
                        assetName:
                            "assets/pdf/chapter_${bookmark.chapterNumber}.pdf",
                        chapterNumber: bookmark.chapterNumber,
                        chapterName: bookmark.chapterName,
                        arabicName: bookmark.arabicName,
                        initialPage: bookmark.pageNumber,
                      ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.delete, color: Colors.white, size: 30),
    );
  }

  void _showClearAllConfirmationDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear All Bookmarks'),
            content: const Text(
              'Are you sure you want to remove all bookmarks?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _clearAllBookmarks();
                },
                child: const Text('Clear', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
