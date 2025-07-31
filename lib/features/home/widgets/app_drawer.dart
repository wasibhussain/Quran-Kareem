import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:quran_pak_app/features/bookmarks/view_bookmarks.dart';
import 'package:quran_pak_app/features/durood_sharif/durood_listing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.quran_kareem_sindhi.app';

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
            leading: Icon(
              FeatherIcons.home,
              color: Color(0xFF1F4068),
              size: 24,
            ),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          // Bookmarks Section
          const Divider(),
          ListTile(
            leading: Icon(
              FeatherIcons.bookmark,
              color: Color(0xFF1F4068),
              size: 24,
            ),
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
            leading: Icon(
              FeatherIcons.bookOpen,
              color: Color(0xFF1F4068),
              size: 24,
            ),
            title: const Text('Haftawar Durood Sharif'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DuroodSharifListScreen(),
                ),
              );
            },
          ),
          // const Divider(),
          // ListTile(
          //   leading: Icon(
          //     FeatherIcons.settings,
          //     color: Color(0xFF1F4068),
          //     size: 24,
          //   ),
          //   title: const Text('App Settings'),
          //   onTap: () {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(
          //         content: Text('Settings feature coming soon'),
          //         duration: Duration(seconds: 2),
          //       ),
          //     );
          //     Navigator.pop(context);
          //   },
          // ),
          const Divider(),
          ListTile(
            // ← RATE‑APP TILE
            leading: Icon(
              FeatherIcons.star,
              color: Color(0xFF1F4068),
              size: 24,
            ),
            title: const Text('Rate this App'),
            onTap: () async {
              Navigator.pop(context);
              final uri = Uri.parse(_playStoreUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Could not open the Play Store'),
                  ),
                );
              }
            },
          ),
          Divider(),

          ListTile(
            // ← SHARE‑APP TILE
            leading: Icon(
              FeatherIcons.share2,
              color: Color(0xFF1F4068),
              size: 24,
            ),
            title: const Text('Share this App'),
            onTap: () {
              Navigator.pop(context);
              SharePlus.instance.share(
                ShareParams(
                  text: 'Check out this Quran Kareem app: $_playStoreUrl',
                  subject: 'Quran Kareem App',
                ),
              );
            },
          ),

          const Divider(),
          ListTile(
            leading: Icon(
              FeatherIcons.info,
              color: Color(0xFF1F4068),
              size: 24,
            ),
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
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    spreadRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/quran_icon.png',
                          height: 100,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'About',
                          style: TextStyle(
                            color: Color(0xFF1F4068),
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          'Quran Kareem App',
                          style: TextStyle(
                            color: Color(0xFF1F4068),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'A comprehensive digital Quran application providing the Noble Quran with Sindhi translation. '
                      'Dedicated to my beloved Mother, whose love and prayers are my greatest strength. '
                      '\nThis app is designed to make Quranic learning accessible, convenient, and spiritually enriching.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),

                  // Version and Details
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Text(
                          'Version: 1.0.0',
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Talib-e-Dua: Wasib Zameer',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),

                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16,
                      left: 16,
                      right: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Add any additional action like privacy policy
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1F4068),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            '   Close  ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
