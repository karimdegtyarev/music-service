import 'package:flutter/material.dart' hide RepeatMode;
import 'package:provider/provider.dart';

import '../providers/player_provider.dart';
import '../models/track_model.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({super.key});

  void _openFullPlayer(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const FractionallySizedBox(
          heightFactor: 0.95,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            child: _FullPlayerSheet(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final track = player.currentTrack;

    if (track == null) {
      return const SizedBox.shrink();
    }

    return Material(
      color: Colors.grey[900],
      child: InkWell(
        onTap: () => _openFullPlayer(context),
        child: SizedBox(
          height: 70,
          child: Column(
            children: [
              LinearProgressIndicator(
                minHeight: 2,
                value: player.progress,
                backgroundColor: Colors.grey[800],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Colors.lightGreenAccent,
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        track.imageUrl,
                        width: 46,
                        height: 46,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            width: 46,
                            height: 46,
                            child: Icon(
                              Icons.music_note,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            track.albumName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                      ),
                      onPressed: player.previous,
                    ),
                    IconButton(
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        player.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: player.togglePlay,
                    ),
                    IconButton(
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.skip_next,
                        color: Colors.white,
                      ),
                      onPressed: player.next,
                    ),
                    const SizedBox(width: 6),
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

class _FullPlayerSheet extends StatefulWidget {
  const _FullPlayerSheet();

  @override
  State<_FullPlayerSheet> createState() => _FullPlayerSheetState();
}

class _FullPlayerSheetState extends State<_FullPlayerSheet> {
  double? _dragPosition;

  String _formatDuration(Duration? duration) {
    if (duration == null) return '00:00';

    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final track = player.currentTrack;

    if (track == null) {
      return const SizedBox.shrink();
    }

    final duration = player.duration;
    final maxPosition = duration?.inMilliseconds.toDouble() ?? 1.0;

    final currentPosition = _dragPosition ??
        player.position.inMilliseconds.toDouble().clamp(0.0, maxPosition);

    final repeatIcon = switch (player.repeatMode) {
      RepeatMode.off => Icons.repeat,
      RepeatMode.all => Icons.repeat,
      RepeatMode.one => Icons.repeat_one,
    };

    final repeatColor = player.repeatMode == RepeatMode.off
        ? Colors.grey
        : Colors.lightGreenAccent;

    return Container(
      color: const Color(0xFF101010),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          child: Column(
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const Text(
                    'NOW PLAYING',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 22),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 340,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        track.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[900],
                            child: const Icon(
                              Icons.music_note,
                              color: Colors.white,
                              size: 100,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          track.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          track.albumName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.graphic_eq,
                    color: Colors.lightGreenAccent,
                    size: 28,
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Slider(
                value: currentPosition,
                min: 0,
                max: maxPosition,
                activeColor: Colors.lightGreenAccent,
                inactiveColor: Colors.grey[800],
                onChanged: duration == null
                    ? null
                    : (value) {
                        setState(() {
                          _dragPosition = value;
                        });
                      },
                onChangeEnd: duration == null
                    ? null
                    : (value) {
                        player.seek(
                          Duration(milliseconds: value.round()),
                        );
                        setState(() {
                          _dragPosition = null;
                        });
                      },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(
                        Duration(
                          milliseconds: currentPosition.round(),
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _formatDuration(duration),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: player.toggleShuffle,
                    icon: Icon(
                      Icons.shuffle,
                      color: player.shuffleEnabled
                          ? Colors.lightGreenAccent
                          : Colors.grey,
                      size: 26,
                    ),
                  ),
                  IconButton(
                    onPressed: player.previous,
                    icon: const Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.lightGreenAccent,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: player.togglePlay,
                      icon: Icon(
                        player.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.black,
                        size: 34,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: player.next,
                    icon: const Icon(
                      Icons.skip_next,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                  IconButton(
                    onPressed: player.cycleRepeatMode,
                    icon: Icon(
                      repeatIcon,
                      color: repeatColor,
                      size: 26,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  const Icon(
                    Icons.queue_music,
                    color: Colors.lightGreenAccent,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Очередь воспроизведения',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${player.queue.length} треков',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (player.queue.isEmpty)
                const Text(
                  'Очередь пуста',
                  style: TextStyle(color: Colors.grey),
                )
              else
                ...player.queue.map((Track queueTrack) {
                  final isCurrent = queueTrack.id == track.id;

                  return Material(
                    color: Colors.transparent,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset(
                          queueTrack.imageUrl,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              width: 44,
                              height: 44,
                              child: Icon(
                                Icons.music_note,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                      title: Text(
                        queueTrack.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isCurrent
                              ? Colors.lightGreenAccent
                              : Colors.white,
                          fontWeight:
                              isCurrent ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(
                        queueTrack.albumName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                      trailing: isCurrent
                          ? const Icon(
                              Icons.equalizer,
                              color: Colors.lightGreenAccent,
                            )
                          : null,
                      onTap: () => player.play(queueTrack),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
