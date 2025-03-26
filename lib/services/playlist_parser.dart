import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/playlist_model.dart';


class PlaylistParser {
  static Future<PlaylistCategories> parsePlaylists() async {
    try {
      final jsonString = await rootBundle.loadString('assets/playlists.json');
      final Map<String, dynamic> data = json.decode(jsonString);

      final categories = [
        _parseCategory('Genres', data['Genres']),
        _parseCategory('Your Mixes', data['Your mixes']),
      ];

      return PlaylistCategories(categories: categories);
    } catch (e) {
      throw Exception('Error parsing playlists: $e');
    }
  }

  static PlaylistCategory _parseCategory(String title, dynamic data) {
    final items = (data as Map<String, dynamic>).entries.map((entry) {
      return Playlist(
        id: entry.key,
        title: entry.value['name'] as String,
        imageUrl: entry.value['cover'] as String,
        description: entry.value['description'] as String,
        fans: entry.value['fans'] as int,
        updated: entry.value['updated'] as String,
        tracks: List<int>.from(entry.value['tracks']),
      );
    }).toList();

    return PlaylistCategory(title: title, items: items);
  }
}