import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../models/track_model.dart';

class PlayerProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Track? _currentTrack;
  double _progress = 0;
  bool _isPlaying = false;

  List<Track> _queue = [];
  int _currentIndex = -1;

  late final StreamSubscription<PlayerState> _playerStateSubscription;
  late final StreamSubscription<Duration> _positionSubscription;

  Track? get currentTrack => _currentTrack;
  double get progress => _progress;
  bool get isPlaying => _isPlaying;

  List<Track> get queue => List.unmodifiable(_queue);

  PlayerProvider() {
    _playerStateSubscription =
        _audioPlayer.playerStateStream.listen((state) {
          _isPlaying = state.playing;
          notifyListeners();
        });

    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      final duration = _audioPlayer.duration;

      if (duration != null && duration.inMilliseconds > 0) {
        _progress =
            (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
        notifyListeners();
      }
    });
  }

  /// Устанавливает очередь воспроизведения.
  Future<void> setQueue(
      List<Track> tracks, {
        int initialIndex = 0,
        bool autoPlay = true,
      }) async {
    if (tracks.isEmpty) return;

    _queue = List.from(tracks);
    _currentIndex = initialIndex.clamp(0, _queue.length - 1);

    if (autoPlay) {
      await play(_queue[_currentIndex]);
    } else {
      _currentTrack = _queue[_currentIndex];
      _progress = 0;
      notifyListeners();
    }
  }

  /// Воспроизводит выбранный трек.
  Future<void> play(Track track) async {
    final index = _queue.indexWhere((item) => item.id == track.id);

    if (index >= 0) {
      _currentIndex = index;
    } else {
      _queue = [track];
      _currentIndex = 0;
    }

    if (_currentTrack?.id != track.id) {
      _currentTrack = track;
      _progress = 0;
      notifyListeners();

      await _audioPlayer.setAsset(track.musicUrl);
    }

    await _audioPlayer.play();
  }

  Future<void> togglePlay() async {
    if (_currentTrack == null) return;

    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  /// Переключает на следующий трек в очереди.
  Future<void> next() async {
    if (_queue.isEmpty || _currentIndex >= _queue.length - 1) return;

    await play(_queue[_currentIndex + 1]);
  }

  /// Возвращает предыдущий трек.
  Future<void> previous() async {
    if (_queue.isEmpty || _currentIndex <= 0) return;

    await play(_queue[_currentIndex - 1]);
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _playerStateSubscription.cancel();
    _positionSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
