import 'package:flutter/material.dart';
import 'package:quran_pak_app/features/bookmarks/bookmark_manager.dart'
    show BookmarkManager;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';

import 'features/bookmarks/model/bookmark_model.dart';

class PdfViewerScreen extends StatefulWidget {
  final String assetName;
  final int chapterNumber;
  final String chapterName;
  final String arabicName;

  const PdfViewerScreen({
    super.key,
    required this.assetName,
    required this.chapterNumber,
    required this.chapterName,
    required this.arabicName,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late PdfViewerController _pdfViewerController;
  bool _isNightMode = false;
  double _zoomLevel = 1.0;
  int _currentPage = 1;
  List<Bookmark> _bookmarks = [];

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    _loadBookmarks();

    // Add listener to track current page
    _pdfViewerController.addListener(() {
      setState(() {
        _currentPage = _pdfViewerController.pageNumber;
      });
    });
  }

  // Load existing bookmarks
  void _loadBookmarks() async {
    final bookmarks = await BookmarkManager.getBookmarks();
    setState(() {
      _bookmarks = bookmarks;
    });
  }

  // Check if current page is bookmarked
  bool _isCurrentPageBookmarked() {
    return _bookmarks.any(
      (bookmark) =>
          bookmark.chapterNumber == widget.chapterNumber &&
          bookmark.pageNumber == _currentPage,
    );
  }

  // Toggle bookmark for current page
  void _toggleBookmark() async {
    final currentBookmark = Bookmark(
      chapterNumber: widget.chapterNumber,
      chapterName: widget.chapterName,
      arabicName: widget.arabicName,
      pageNumber: _currentPage,
    );

    if (_isCurrentPageBookmarked()) {
      // Remove bookmark
      await BookmarkManager.removeBookmark(currentBookmark);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bookmark removed'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      // Add bookmark
      await BookmarkManager.saveBookmark(currentBookmark);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bookmark added'),
          duration: Duration(seconds: 1),
        ),
      );
    }

    // Reload bookmarks
    _loadBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 80,
        title: Column(
          children: [
            Text(widget.chapterName),
            Text(
              widget.arabicName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isCurrentPageBookmarked()
                  ? Icons.bookmark
                  : Icons.bookmark_border,
              color: Colors.white,
            ),
            onPressed: _toggleBookmark,
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              _showSettingsDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        color: _isNightMode ? Colors.black87 : Colors.white,
        child: SfPdfViewer.asset(
          widget.assetName,
          key: _pdfViewerKey,
          controller: _pdfViewerController,
          canShowScrollHead: true,
          canShowScrollStatus: true,
          pageSpacing: 4,
          enableDoubleTapZooming: true,
          initialZoomLevel: _zoomLevel,
          onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${details.error}'),
                backgroundColor: Colors.red,
              ),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'zoom_in',
            backgroundColor: const Color(0xFF1F4068),
            child: const Icon(Icons.zoom_in, color: Colors.white),
            onPressed: () {
              setState(() {
                _zoomLevel += 0.25;
                _pdfViewerController.zoomLevel = _zoomLevel;
              });
            },
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'zoom_out',
            backgroundColor: const Color(0xFF1F4068),
            child: const Icon(Icons.zoom_out, color: Colors.white),
            onPressed: () {
              setState(() {
                if (_zoomLevel > 0.5) {
                  _zoomLevel -= 0.25;
                  _pdfViewerController.zoomLevel = _zoomLevel;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Reading Settings'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.format_size),
                  title: const Text('Text Size'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            if (_zoomLevel > 0.5) {
                              _zoomLevel -= 0.25;
                              _pdfViewerController.zoomLevel = _zoomLevel;
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _zoomLevel += 0.25;
                            _pdfViewerController.zoomLevel = _zoomLevel;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.brightness_4),
                  title: const Text('Night Mode'),
                  trailing: Switch(
                    value: _isNightMode,
                    onChanged: (value) {
                      Navigator.pop(context);
                      setState(() {
                        _isNightMode = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.skip_next),
                  title: const Text('Jump to Page'),
                  onTap: () {
                    Navigator.pop(context);
                    _showJumpToPageDialog(context);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showJumpToPageDialog(BuildContext context) {
    final TextEditingController pageController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Jump to Page'),
            content: TextField(
              controller: pageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Page Number',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  try {
                    final pageNumber = int.parse(pageController.text);
                    _pdfViewerController.jumpToPage(pageNumber);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid page number'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Go'),
              ),
            ],
          ),
    );
  }
}
