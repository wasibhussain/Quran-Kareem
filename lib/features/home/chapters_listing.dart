import 'package:flutter/material.dart';
import 'package:quran_pak_app/utils/constant.dart';

import 'pdf_view_screen.dart';

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
