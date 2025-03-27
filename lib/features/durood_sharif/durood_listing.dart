import 'package:flutter/material.dart';
import 'package:quran_pak_app/features/durood_sharif/model/durood_model.dart';
import 'durood_details.dart';

class DuroodSharifListScreen extends StatelessWidget {
  const DuroodSharifListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
       'درود شریف',
          style: TextStyle(fontFamily: 'Amiri', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1F4068),
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
            Image.asset(
              'assets/images/muhammad_icon.png',
              height: 100,
            ),
            const SizedBox(height: 10),
            const Text(
              'Haftawar Durood Sharif',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F4068),
              ),
            ),

            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  itemCount: duroodpakList.length,
                  itemBuilder: (context, index) {
                    final durood = duroodpakList[index];
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
                              '${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F4068),
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          durood.englishTitle,
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F4068),
                          ),
                        ),
                        subtitle: Text(
                          durood.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 16,
                            color: Color(0xFF162447),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF1F4068),
                        ),
                        onTap: () => _openDuroodDetails(context, durood),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDuroodDetails(BuildContext context, DuroodSharifConstants durood) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DuroodSharifDetailsScreen(duroodSharif: durood),
      ),
    );
  }
}
