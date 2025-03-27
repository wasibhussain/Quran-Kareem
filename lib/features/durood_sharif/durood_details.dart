import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model/durood_model.dart';

class DuroodSharifDetailsScreen extends StatelessWidget {
  final DuroodSharifConstants duroodSharif;

  const DuroodSharifDetailsScreen({super.key, required this.duroodSharif});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color(0xFF1F4068),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'درود شریف',
            style: TextStyle(
              fontFamily: 'Amiri',
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF1F4068),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Durood Sharif Text
                _buildDetailCard(
                  child: Text(
                    duroodSharif.duroodsharif,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 24,
                      color: Color(0xFF1F4068),
                      height: 1.6,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  shadowColor: Color(0xFF1F4068).withOpacity(0.2),
                ),
                SizedBox(height: 24),

                // Translation
                _buildDetailCard(
                  child: Text(
                    duroodSharif.translation,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Noto Naskh Arabic',
                      fontSize: 20,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  backgroundColor: Color(0xFFE6EAF0),
                  shadowColor: Color(0xFF1F4068).withOpacity(0.1),
                ),

                // Copy Button
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: duroodSharif.duroodsharif),
                    );
                  },
                  icon: Icon(Icons.copy, color: Colors.white),
                  label: Text(
                    'Copy Durood Sharif',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1F4068),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required Widget child,
    required Color backgroundColor,
    required Color shadowColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(padding: EdgeInsets.all(20), child: child),
    );
  }
}
