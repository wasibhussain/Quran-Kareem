import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_pak_app/app_drawer.dart';
import 'package:quran_pak_app/constant.dart';
import 'package:quran_pak_app/pdf_view_screen.dart';
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
      drawer: const AppDrawer(), // Add this line
      appBar: AppBar(
        title: const Text('القرآن الكريم'),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
  const ChaptersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        itemCount: ChaptersConstant().chapters.length,
        itemBuilder: (context, index) {
          final chapter = ChaptersConstant().chapters[index];
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
                chapterName:
                    ChaptersConstant().chapters[chapterNumber - 1]['name'],
                arabicName:
                    ChaptersConstant().chapters[chapterNumber -
                        1]['arabicName'],
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
