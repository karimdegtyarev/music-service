import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/track_model.dart';
import '../services/track_parser.dart';

class FavoritesProvider extends ChangeNotifier {
  static const String _storageKey = 'favorite_track_ids';

  List<Track> _allTracks = [];
  final Set<String> _favoriteTrackIds = {};

  bool _isLoading = true;

  List<Track> get favorites => _allTracks
      .where((track) => _favoriteTrackIds.contains(track.id))
      .toList();

  bool get isLoading => _isLoading;

  bool isFavorite(Track track) {
    return _favoriteTrackIds.contains(track.id);
  }

  Future<void> loadFavorites() async {
    try {
      final results = await Future.wait([
        TrackParser.parseTracks(),
        SharedPreferences.getInstance(),
      ]);

      _allTracks = results[0] as List<Track>;

      final preferences = results[1] as SharedPreferences;
      final savedIds = preferences.getStringList(_storageKey) ?? [];

      _favoriteTrackIds
        ..clear()
        ..addAll(savedIds);
    } catch (e) {
      debugPrint('Ошибка загрузки избранного: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Track track) async {
    if (_favoriteTrackIds.contains(track.id)) {
      _favoriteTrackIds.remove(track.id);
    } else {
      _favoriteTrackIds.add(track.id);
    }

    notifyListeners();

    try {
      final preferences = await SharedPreferences.getInstance();

      await preferences.setStringList(
        _storageKey,
        _favoriteTrackIds.toList(),
      );
    } catch (e) {
      debugPrint('Ошибка сохранения избранного: $e');
    }
  }
}
