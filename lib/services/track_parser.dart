import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/track_model.dart';

class TrackParser {
  static Future<List<Track>> parseTracks() async {
    try {
      final jsonString = await rootBundle.loadString('assets/tracks.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      return jsonData.entries.map((entry) {
        final data = Map<String, dynamic>.from(entry.value as Map);

        data['id'] = entry.key;
        data['cover'] = _normalizeAssetPath(data['cover'] as String);
        data['path'] = _normalizeAssetPath(data['path'] as String);

        return Track.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Error parsing tracks: $e');
    }
  }

  static String _normalizeAssetPath(String path) {
    final normalized = path.replaceAll('\\', '/');

    if (normalized.startsWith('./lib/assets/')) {
      return normalized.replaceFirst('./lib/assets/', 'assets/');
    }

    if (normalized.startsWith('lib/assets/')) {
      return normalized.replaceFirst('lib/assets/', 'assets/');
    }

    if (normalized.startsWith('./')) {
      return normalized.substring(2);
    }

    return normalized;
  }
}
