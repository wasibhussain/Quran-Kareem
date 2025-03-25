import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'model/bookmark_model.dart';

class BookmarkManager {
  static const _bookmarksKey = 'quran_bookmarks';

  // Save a bookmark
  static Future<void> saveBookmark(Bookmark bookmark) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();

    // Check if bookmark already exists
    final existingIndex = bookmarks.indexWhere(
      (b) =>
          b.chapterNumber == bookmark.chapterNumber &&
          b.pageNumber == bookmark.pageNumber,
    );

    if (existingIndex == -1) {
      bookmarks.add(bookmark);
    }

    // Save bookmarks
    await prefs.setStringList(
      _bookmarksKey,
      bookmarks.map((b) => json.encode(b.toJson())).toList(),
    );
  }

  // Get all bookmarks
  static Future<List<Bookmark>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkStrings = prefs.getStringList(_bookmarksKey) ?? [];

    return bookmarkStrings
        .map((b) => Bookmark.fromJson(json.decode(b)))
        .toList();
  }

  // Remove a specific bookmark
  static Future<void> removeBookmark(Bookmark bookmark) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();

    bookmarks.removeWhere(
      (b) =>
          b.chapterNumber == bookmark.chapterNumber &&
          b.pageNumber == bookmark.pageNumber,
    );

    await prefs.setStringList(
      _bookmarksKey,
      bookmarks.map((b) => json.encode(b.toJson())).toList(),
    );
  }

  // Clear all bookmarks
  static Future<void> clearBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_bookmarksKey);
  }
}
