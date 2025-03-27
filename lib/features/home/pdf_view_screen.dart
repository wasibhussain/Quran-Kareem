import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:quran_pak_app/features/bookmarks/bookmark_manager.dart'
    show BookmarkManager;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../bookmarks/model/bookmark_model.dart';

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
  
  // Performance and state variables
  bool _isLoading = true;
  final bool _isNightMode = false;
  double _zoomLevel = 1.0;
  int _currentPage = 1;
  List<Bookmark> _bookmarks = [];

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    
    // Load bookmarks asynchronously
    _loadBookmarks().then((_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });

    // Optimize controller listener
    _pdfViewerController.addListener(_updateCurrentPage);
  }

  // Separate method to update current page with minimal rebuilds
  void _updateCurrentPage() {
    if (mounted) {
      setState(() {
        _currentPage = _pdfViewerController.pageNumber;
      });
    }
  }

  // Load existing bookmarks
  Future<void> _loadBookmarks() async {
    try {
      final bookmarks = await BookmarkManager.getBookmarks();
      if (mounted) {
        setState(() {
          _bookmarks = bookmarks;
        });
      }
    } catch (e) {
      // Handle potential errors in loading bookmarks
      print('Error loading bookmarks: $e');
    }
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

    try {
      if (_isCurrentPageBookmarked()) {
        // Remove bookmark
        await BookmarkManager.removeBookmark(currentBookmark);
        _showSnackBar('Bookmark removed');
      } else {
        // Add bookmark
        await BookmarkManager.saveBookmark(currentBookmark);
        _showSnackBar('Bookmark added');
      }

      // Reload bookmarks
      await _loadBookmarks();
    } catch (e) {
      _showSnackBar('Error managing bookmark');
      print('Bookmark error: $e');
    }
  }

  // Helper method to show snackbar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Zoom in method
  void _zoomIn() {
    setState(() {
      _zoomLevel += 0.25;
      _pdfViewerController.zoomLevel = _zoomLevel;
    });
  }

  // Zoom out method
  void _zoomOut() {
    setState(() {
      if (_zoomLevel > 0.5) {
        _zoomLevel -= 0.25;
        _pdfViewerController.zoomLevel = _zoomLevel;
      }
    });
  }

  // Show jump to page dialog
  void _showJumpToPageDialog(BuildContext context) {
    final TextEditingController pageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                _showSnackBar('Please enter a valid page number');
              }
            },
            child: const Text('Go'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
            icon: Icon(FeatherIcons.search, color: Colors.white),
            onPressed: () => _showJumpToPageDialog(context),
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
          // Performance optimizations
          interactionMode: PdfInteractionMode.pan,
          enableTextSelection: false,
          onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
            _showSnackBar('Error: ${details.error}');
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'zoom_in',
            backgroundColor: const Color(0xFF1F4068),
            onPressed: _zoomIn,
            child: const Icon(FeatherIcons.zoomIn, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'zoom_out',
            backgroundColor: const Color(0xFF1F4068),
            onPressed: _zoomOut,
            child: const Icon(FeatherIcons.zoomOut, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of controllers and listeners
    _pdfViewerController.removeListener(_updateCurrentPage);
    _pdfViewerController.dispose();
    super.dispose();
  }
}