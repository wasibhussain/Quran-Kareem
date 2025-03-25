import 'package:flutter/material.dart';
import 'package:quran_pak_app/features/bookmarks/view_bookmarks.dart';

import 'package:quran_pak_app/pdf_view_screen.dart';

import 'features/bookmarks/bookmark_manager.dart';
import 'features/bookmarks/model/bookmark_model.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  List<Bookmark> _bookmarks = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  void _loadBookmarks() async {
    final bookmarks = await BookmarkManager.getBookmarks();
    setState(() {
      _bookmarks = bookmarks;
    });
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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: const Color(0xFF1F4068)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  'القرآن الكريم',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'The Noble Quran',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'Amiri',
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Color(0xFF1F4068)),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          // Bookmarks Section
          const Divider(),
          ListTile(
            leading: Icon(Icons.bookmark, color: Color(0xFF1F4068)),
            title: const Text('Bookmarks'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookmarksScreen(),
                ),
              );
            },
          ),

          const Divider(),
          ListTile(
            leading: Icon(Icons.settings, color: Color(0xFF1F4068)),
            title: const Text('App Settings'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings feature coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: Color(0xFF1F4068)),
            title: const Text('About'),
            onTap: () {
              _showAboutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('About Quran Kareem App'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const [
                  Text(
                    'Quran Kareem App',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'A digital Quran application providing the Noble Quran with Sindhi translation.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text('Version: 1.0.0', style: TextStyle(fontSize: 14)),
                  SizedBox(height: 10),
                  Text(
                    '© 2024 Quran Kareem App',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
    Navigator.pop(context); // Close the drawer
  }
}
