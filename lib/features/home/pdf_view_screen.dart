import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final int? initialPage; // New optional parameter

  const PdfViewerScreen({
    super.key,
    required this.assetName,
    required this.chapterNumber,
    required this.chapterName,
    required this.arabicName,
    this.initialPage,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late PdfViewerController _pdfViewerController;

  Uint8List? _pdfBytes;
  bool _isLoading = true;
  final double _zoomLevel = 1.0;
  int _currentPage = 1;
  List<Bookmark> _bookmarks = [];
  int? _targetPage;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    _targetPage = widget.initialPage;

    _loadPdfFromAsset();
    _loadBookmarks();

    _pdfViewerController.addListener(_updateCurrentPage);
  }

  /// **Load PDF from assets into memory**
  Future<void> _loadPdfFromAsset() async {
    try {
      final ByteData data = await rootBundle.load(widget.assetName);
      if (mounted) {
        setState(() {
          _pdfBytes = data.buffer.asUint8List();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading PDF: $e');
      _showSnackBar('Failed to load PDF');
    }
  }

  /// **Load existing bookmarks**
  Future<void> _loadBookmarks() async {
    try {
      final bookmarks = await BookmarkManager.getBookmarks();

      if (mounted) {
        setState(() {
          _bookmarks = bookmarks;
        });
      }
    } catch (e) {
      debugPrint('Error loading bookmarks: $e');
    }
  }

  /// **Optimize page update with microtask**
  void _updateCurrentPage() {
    Future.microtask(() {
      if (mounted) {
        setState(() {
          _currentPage = _pdfViewerController.pageNumber;
        });
      }
    });
  }

  /// **Check if the current page is bookmarked**
  bool _isCurrentPageBookmarked() {
    return _bookmarks.any(
      (bookmark) =>
          bookmark.chapterNumber == widget.chapterNumber &&
          bookmark.pageNumber == _currentPage,
    );
  }

  /// **Toggle bookmark for the current page**
  void _toggleBookmark() async {
    final currentBookmark = Bookmark(
      chapterNumber: widget.chapterNumber,
      chapterName: widget.chapterName,
      arabicName: widget.arabicName,
      pageNumber: _currentPage,
    );

    try {
      if (_isCurrentPageBookmarked()) {
        await BookmarkManager.removeBookmark(currentBookmark);
        _showSnackBar('Bookmark removed');
      } else {
        await BookmarkManager.saveBookmark(currentBookmark);
        _showSnackBar('Bookmark added');
      }

      _loadBookmarks();
    } catch (e) {
      _showSnackBar('Error managing bookmark');
      debugPrint('Bookmark error: $e');
    }
  }

  /// **Helper method to show snackbar**
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  /// **Zoom In Functionality**
  // void _zoomIn() {
  //   setState(() {
  //     _zoomLevel += 0.25;
  //     _pdfViewerController.zoomLevel = _zoomLevel;
  //   });
  // }

  // /// **Zoom Out Functionality**
  // void _zoomOut() {
  //   setState(() {
  //     if (_zoomLevel > 0.5) {
  //       _zoomLevel -= 0.25;
  //       _pdfViewerController.zoomLevel = _zoomLevel;
  //     }
  //   });
  // }

  /// **Show jump to page dialog**
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
                  final pageNumber = int.tryParse(pageController.text);
                  if (pageNumber != null) {
                    _pdfViewerController.jumpToPage(pageNumber);
                  } else {
                    _showSnackBar('Invalid page number');
                  }
                  Navigator.pop(context);
                },
                child: const Text('Go'),
              ),
            ],
          ),
    );
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
            icon: Icon(FeatherIcons.search, color: Colors.white),
            onPressed: () => _showJumpToPageDialog(context),
          ),
        ],
      ),
      body:
          _isLoading || _pdfBytes == null
              ? const Center(child: CircularProgressIndicator())
              : SfPdfViewer.memory(
                _pdfBytes!,
                key: _pdfViewerKey,
                controller: _pdfViewerController,
                canShowScrollHead: true,
                canShowScrollStatus: false,
                pageSpacing: 0,
                enableDoubleTapZooming: false,
                interactionMode: PdfInteractionMode.pan,
                enableTextSelection: false,
                onDocumentLoaded: (details) {
                  if (_targetPage != null) {
                    _pdfViewerController.jumpToPage(_targetPage!);
                    _targetPage = null; // Reset after navigation
                  }
                },
                onDocumentLoadFailed: (details) {
                  _showSnackBar('Error: ${details.error}');
                },
              ),
      //   floatingActionButton: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     FloatingActionButton(
      //       heroTag: 'zoom_in',
      //       onPressed: _zoomIn,
      //       child: const Icon(FeatherIcons.zoomIn),
      //     ),
      //     const SizedBox(height: 10),
      //     FloatingActionButton(
      //       heroTag: 'zoom_out',
      //       onPressed: _zoomOut,
      //       child: const Icon(FeatherIcons.zoomOut),
      //     ),
      //   ],
      // ),
    );
  }

  @override
  void dispose() {
    _pdfViewerController.removeListener(_updateCurrentPage);
    _pdfViewerController.dispose();
    super.dispose();
  }
}
