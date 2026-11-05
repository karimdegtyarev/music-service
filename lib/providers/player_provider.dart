import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

import '../models/track_model.dart';

enum RepeatMode {
  off,
  one,
  all,
}

class PlayerProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Track? _currentTrack;

  List<Track> _queue = [];
  List<Track> _originalQueue = [];

  int _currentIndex = -1;

  Duration _position = Duration.zero;
  Duration? _duration;

  bool _isPlaying = false;
  bool _shuffleEnabled = false;
  bool _handlingCompletion = false;

  int _playRequestId = 0;

  String? _loadedTrackId;

  Future<void> _sourceOperation = Future<void>.value();

  RepeatMode _repeatMode = RepeatMode.off;

  final Map<String, String> _cachedAudioFiles = {};

  late final StreamSubscription<PlayerState> _playerStateSubscription;
  late final StreamSubscription<Duration> _positionSubscription;
  late final StreamSubscription<Duration?> _durationSubscription;
  late final StreamSubscription<ProcessingState> _processingSubscription;

  Track? get currentTrack => _currentTrack;

  bool get isPlaying => _isPlaying;

  bool get shuffleEnabled => _shuffleEnabled;

  RepeatMode get repeatMode => _repeatMode;

  Duration get position => _position;

  Duration? get duration => _duration;

  List<Track> get queue => List.unmodifiable(_queue);

  double get progress {
    if (_duration == null || _duration!.inMilliseconds <= 0) {
      return 0;
    }

    return (_position.inMilliseconds / _duration!.inMilliseconds)
        .clamp(0.0, 1.0);
  }

  PlayerProvider() {
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });

    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });

    _durationSubscription = _audioPlayer.durationStream.listen((duration) {
      _duration = duration;
      notifyListeners();
    });

    _processingSubscription =
        _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        _handleTrackCompletion();
      }
    });
  }

  Future<void> setQueue(
      List<Track> tracks, {
        int initialIndex = 0,
        bool autoPlay = true,
      }) async {
    if (tracks.isEmpty) return;

    _originalQueue = List<Track>.from(tracks);

    final safeIndex = initialIndex.clamp(0, tracks.length - 1);
    final selectedTrack = _originalQueue[safeIndex];

    if (_shuffleEnabled) {
      _queue = List<Track>.from(_originalQueue)
        ..removeWhere((track) => track.id == selectedTrack.id)
        ..shuffle();

      _queue.insert(0, selectedTrack);
      _currentIndex = 0;
    } else {
      _queue = List<Track>.from(_originalQueue);
      _currentIndex = safeIndex;
    }

    if (autoPlay) {
      await play(selectedTrack);
    } else {
      // Отменяем незавершённые запросы предыдущего выбора.
      _playRequestId++;

      _currentTrack = selectedTrack;
      _position = Duration.zero;
      _duration = null;
      _loadedTrackId = null;

      notifyListeners();
    }
  }


  Future<void> play(Track track) async {
    final requestId = ++_playRequestId;

    final index = _queue.indexWhere(
          (item) => item.id == track.id,
    );

    if (index >= 0) {
      _currentIndex = index;
    } else {
      _queue = [track];
      _originalQueue = [track];
      _currentIndex = 0;
    }

    final isNewTrack = _currentTrack?.id != track.id;

    if (isNewTrack) {
      _currentTrack = track;
      _position = Duration.zero;
      _duration = null;
      _isPlaying = false;
    }

    notifyListeners();

    try {
      final filePath = await _prepareAudioFile(track);

      if (requestId != _playRequestId) return;

      // В очередь помещаем только загрузку аудиоисточника.
      final loadOperation = _sourceOperation.then((_) async {
        if (requestId != _playRequestId) return;

        if (_loadedTrackId != track.id) {
          // Останавливаем предыдущий источник перед заменой.
          await _audioPlayer.stop();

          if (requestId != _playRequestId) return;

          await _audioPlayer.setFilePath(filePath);
          _loadedTrackId = track.id;
        } else if (
        _audioPlayer.processingState == ProcessingState.completed
        ) {
          await _audioPlayer.seek(Duration.zero);
        }
      });

      // Ошибка загрузки не должна блокировать последующие операции.
      _sourceOperation = loadOperation.then<void>(
            (_) {},
        onError: (Object error, StackTrace stackTrace) {
          debugPrint('Ошибка загрузки аудиоисточника: $error');
        },
      );

      await loadOperation;

      if (requestId != _playRequestId) return;

      // ВАЖНО: play() находится вне очереди загрузки.
      // Поэтому следующий трек можно загружать, не ожидая окончания текущего.
      await _audioPlayer.play();
    } catch (error, stackTrace) {
      if (requestId != _playRequestId) return;

      _loadedTrackId = null;
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
      if (_audioPlayer.processingState == ProcessingState.completed) {
        await _audioPlayer.seek(Duration.zero);
      }

      await _audioPlayer.play();
    }
  }

  Future<void> next() async {
    if (_queue.isEmpty) return;

    if (_currentIndex < _queue.length - 1) {
      await play(_queue[_currentIndex + 1]);
    } else if (_repeatMode == RepeatMode.all) {
      await play(_queue.first);
    }
  }

  Future<void> previous() async {
    if (_queue.isEmpty) return;

    if (_currentIndex > 0) {
      await play(_queue[_currentIndex - 1]);
    } else if (_repeatMode == RepeatMode.all) {
      await play(_queue.last);
    } else {
      await seek(Duration.zero);
    }
  }

  Future<void> seek(Duration position) async {
    final total = _duration;

    if (total == null) return;

    final safePosition = Duration(
      milliseconds: position.inMilliseconds.clamp(0, total.inMilliseconds),
    );

    await _audioPlayer.seek(safePosition);
  }

  void toggleShuffle() {
    _shuffleEnabled = !_shuffleEnabled;

    final currentTrack = _currentTrack;

    if (currentTrack == null || _originalQueue.isEmpty) {
      notifyListeners();
      return;
    }

    if (_shuffleEnabled) {
      _applyShuffle();
    } else {
      _queue = List.from(_originalQueue);
      _currentIndex = _queue.indexWhere((track) => track.id == currentTrack.id);
    }

    notifyListeners();
  }

  void _applyShuffle() {
    final currentTrack =
        _currentTrack ?? (_currentIndex >= 0 ? _queue[_currentIndex] : null);

    _queue = List.from(_originalQueue);

    if (currentTrack == null) return;

    _queue.removeWhere((track) => track.id == currentTrack.id);
    _queue.shuffle();

    _queue.insert(0, currentTrack);
    _currentIndex = 0;
  }

  void cycleRepeatMode() {
    switch (_repeatMode) {
      case RepeatMode.off:
        _repeatMode = RepeatMode.all;
        break;
      case RepeatMode.all:
        _repeatMode = RepeatMode.one;
        break;
      case RepeatMode.one:
        _repeatMode = RepeatMode.off;
        break;
    }

    notifyListeners();
  }

  Future<void> _handleTrackCompletion() async {
    if (_handlingCompletion) return;

    _handlingCompletion = true;

    try {
      if (_repeatMode == RepeatMode.one) {
        await _audioPlayer.seek(Duration.zero);
        await _audioPlayer.play();
      } else if (_currentIndex < _queue.length - 1) {
        await next();
      } else if (_repeatMode == RepeatMode.all && _queue.isNotEmpty) {
        await play(_queue.first);
      } else {
        _isPlaying = false;
        notifyListeners();
      }
    } catch (error) {
      debugPrint('Ошибка автоматического перехода: $error');
    } finally {
      _handlingCompletion = false;
    }
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
      '${tempDir.path}${Platform.pathSeparator}'
      '${track.id}_$safeName',
    );

    await file.writeAsBytes(bytes, flush: true);

    _cachedAudioFiles[track.musicUrl] = file.path;

    return file.path;
  }

  @override
  void dispose() {
    _playerStateSubscription.cancel();
    _positionSubscription.cancel();
    _durationSubscription.cancel();
    _processingSubscription.cancel();

    _audioPlayer.dispose();

    super.dispose();
  }
}
