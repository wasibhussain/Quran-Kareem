import 'package:flutter/material.dart';
import 'package:quran_pak_app/features/home/widgets/app_drawer.dart';
import 'package:quran_pak_app/features/home/chapters_listing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
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
