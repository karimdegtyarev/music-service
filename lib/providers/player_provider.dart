import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
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

  bool _sourceLoaded = false;
  final Map<String, String> _cachedAudioFiles = {};

  late final StreamSubscription<PlayerState> _playerStateSubscription;
  late final StreamSubscription<Duration> _positionSubscription;

  Track? get currentTrack => _currentTrack;
  double get progress => _progress;
  bool get isPlaying => _isPlaying;
  Duration? get duration => _audioPlayer.duration;

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
      _sourceLoaded = false;
      notifyListeners();
    }

    try {
      if (!_sourceLoaded) {
        debugPrint('🎵 Попытка воспроизведения: ${track.title}');
        debugPrint('📁 Путь: ${track.musicUrl}');
        final filePath = await _prepareAudioFile(track);
        await _audioPlayer.setFilePath(filePath);
        _sourceLoaded = true;
      }

      await _audioPlayer.play();
    } catch (error, stackTrace) {
      _sourceLoaded = false;
      _isPlaying = false;

      debugPrint('Ошибка воспроизведения: ${track.title}');
      debugPrint('Путь: ${track.musicUrl}');
      debugPrint('Причина: $error');
      debugPrintStack(stackTrace: stackTrace);

      notifyListeners();
    }
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

  Future<String> _prepareAudioFile(Track track) async {
    final cachedPath = _cachedAudioFiles[track.musicUrl];

    if (cachedPath != null && await File(cachedPath).exists()) {
      return cachedPath;
    }

    final byteData = await rootBundle.load(track.musicUrl);

    final bytes = byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    );

    final tempDir = Directory.systemTemp;

    final originalName = track.musicUrl.split('/').last;
    final safeName = originalName.replaceAll(
      RegExp(r'[^a-zA-Z0-9._-]'),
      '_',
    );

    final file = File(
      '${tempDir.path}${Platform.pathSeparator}${track.id}_$safeName',
    );

    await file.writeAsBytes(bytes, flush: true);

    _cachedAudioFiles[track.musicUrl] = file.path;

    return file.path;
  }

  @override
  void dispose() {
    _playerStateSubscription.cancel();
    _positionSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
