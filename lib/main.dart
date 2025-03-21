import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const QuranApp());
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran Kareem',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1F4068),
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F4068),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F4068),
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 16,
            color: Color(0xFF162447),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1F4068),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('القرآن الكريم')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/subtle_pattern.png'),
            repeat: ImageRepeat.repeat,
            opacity: 0.1,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/images/quran_icon.png', height: 100),
            const SizedBox(height: 10),
            const Text(
              'The Noble Quran',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F4068),
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'With Sindhi Tarjuma',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 16,
                color: Color(0xFF162447),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: ChaptersList()),
          ],
        ),
      ),
    );
  }
}

class ChaptersList extends StatelessWidget {
  ChaptersList({super.key});

  final List<Map<String, dynamic>> chapters = [
    {'number': 1, 'name': 'Alif Lam Meem', 'arabicName': 'الم', 'pages': 141},
    {'number': 2, 'name': 'Sayaqool', 'arabicName': 'سَيَقُولُ', 'pages': 111},
    {
      'number': 3,
      'name': 'Tilkal Rusul',
      'arabicName': 'تلك الرسل',
      'pages': 120,
    },
    {
      'number': 4,
      'name': 'Lantanalu',
      'arabicName': 'لَنْ تَنَالُوا',
      'pages': 128,
    },
    {
      'number': 5,
      'name': 'Wal Mohsanat',
      'arabicName': 'وَالمُحْصَنَاتُ',
      'pages': 126,
    },
    {
      'number': 6,
      'name': 'Ya Ayyuha',
      'arabicName': 'يَا أَيُّهَا',
      'pages': 110,
    },
    {
      'number': 7,
      'name': 'Wa Iza Samiu',
      'arabicName': 'وَإِذَا سَمِعُوا',
      'pages': 124,
    },
    {
      'number': 8,
      'name': 'Wa Lau Annana',
      'arabicName': 'وَلَوْ أَنَّنَا',
      'pages': 125,
    },
    {
      'number': 9,
      'name': 'Qad Aflaha',
      'arabicName': 'قَدْ أَفْلَحَ',
      'pages': 129,
    },
    {
      'number': 10,
      'name': 'Wa A’lamu',
      'arabicName': 'وَاعْلَمُوا',
      'pages': 122,
    },
    {
      'number': 11,
      'name': 'Ya’taziruna',
      'arabicName': 'يَعْتَذِرُونَ',
      'pages': 127,
    },
    {
      'number': 12,
      'name': 'Wa Mamin Da’abba',
      'arabicName': 'وَمَا مِنْ دَآبَّةٍ',
      'pages': 111,
    },
    {
      'number': 13,
      'name': 'Wa Ma Ubrioo',
      'arabicName': 'وَمَا أُبَرِّئُ',
      'pages': 113,
    },
    {'number': 14, 'name': 'Rubama', 'arabicName': 'رُبَمَا', 'pages': 112},
    {
      'number': 15,
      'name': 'Subhanallazi',
      'arabicName': 'سُبْحَانَ الَّذِي',
      'pages': 127,
    },
    {
      'number': 16,
      'name': 'Qal Alam',
      'arabicName': 'قَالَ أَلَمْ',
      'pages': 130,
    },
    {
      'number': 17,
      'name': 'Aqtarabat',
      'arabicName': 'اقْتَرَبَتْ',
      'pages': 111,
    },
    {
      'number': 18,
      'name': 'Qadd Aflaha',
      'arabicName': 'قَدْ أَفْلَحَ',
      'pages': 120,
    },
    {
      'number': 19,
      'name': 'Wa Qalallazina',
      'arabicName': 'وَقَالَ الَّذِينَ',
      'pages': 115,
    },
    {
      'number': 20,
      'name': 'A’man Khalaq',
      'arabicName': 'أَمَّنْ خَلَقَ',
      'pages': 129,
    },
    {
      'number': 21,
      'name': 'Utlu Ma Oohiya',
      'arabicName': 'اتْلُ مَا أُوحِيَ',
      'pages': 111,
    },
    {
      'number': 22,
      'name': 'Wa Manyaqnut',
      'arabicName': 'وَمَنْ يَقْنُتْ',
      'pages': 130,
    },
    {'number': 23, 'name': 'Wa Mali', 'arabicName': 'وَمَا لِيَ', 'pages': 128},
    {
      'number': 24,
      'name': 'Faman Azlam',
      'arabicName': 'فَمَنْ أَظْلَمُ',
      'pages': 126,
    },
    {
      'number': 25,
      'name': 'Elahe Yuruddu',
      'arabicName': 'إِلَيْهِ يُرَدُّ',
      'pages': 128,
    },
    {'number': 26, 'name': 'Ha’a Meem', 'arabicName': 'حم', 'pages': 121},
    {
      'number': 27,
      'name': 'Qala Fama Khatbukum',
      'arabicName': 'قَالَ فَمَا خَطْبُكُمْ',
      'pages': 122,
    },
    {
      'number': 28,
      'name': 'Qadd Sami Allah',
      'arabicName': 'قَدْ سَمِعَ اللَّهُ',
      'pages': 137,
    },
    {
      'number': 29,
      'name': 'Tabarakallazi',
      'arabicName': 'تَبَارَكَ الَّذِي',
      'pages': 135,
    },
    {
      'number': 30,
      'name': 'Amma Yatasaloon',
      'arabicName': 'عَمَّ يَتَسَاءَلُونَ',
      'pages': 120,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          final chapter = chapters[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F4068).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '${chapter['number']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F4068),
                    ),
                  ),
                ),
              ),
              title: Text(
                chapter['name'],
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F4068),
                ),
              ),
              subtitle: Text(
                chapter['arabicName'],
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 16,
                  color: Color(0xFF162447),
                ),
              ),
              trailing: Text(
                '${chapter['pages']} verses',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              onTap: () => _openPdf(context, chapter['number']),
            ),
          );
        },
      ),
    );
  }

  void _openPdf(BuildContext context, int chapterNumber) async {
    try {
      final assetPath = 'assets/pdf/chapter_$chapterNumber.pdf';

      // For asset files, we can directly use the path
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => PdfViewerScreen(
                assetName: assetPath,
                chapterNumber: chapterNumber,
                chapterName: chapters[chapterNumber - 1]['name'],
                arabicName: chapters[chapterNumber - 1]['arabicName'],
              ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

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

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set back arrow color to white
        ),
        toolbarHeight: 80, // Set your custom height here
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
            SizedBox(height: 10),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {
              _pdfViewerController.jumpToPage(1);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bookmark added'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
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
          // FloatingActionButton(
          //   heroTag: 'search',
          //   backgroundColor: const Color(0xFF1F4068),
          //   child: const Icon(Icons.search, color: Colors.white),
          //   onPressed: () {
          //     _pdfViewerKey.currentState?.openSearchBar();
          //   },
          // ),
          // const SizedBox(height: 10),
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
    final TextEditingController _pageController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Jump to Page'),
            content: TextField(
              controller: _pageController,
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
                    final pageNumber = int.parse(_pageController.text);
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
