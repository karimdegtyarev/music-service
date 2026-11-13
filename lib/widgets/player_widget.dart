import 'package:flutter/material.dart' hide RepeatMode;
import 'package:provider/provider.dart';

import '../models/track_model.dart';
import '../providers/player_provider.dart';
import '../providers/favorites_provider.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({super.key});

  void _openFullPlayer(BuildContext context) {
    var isClosing = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          child: NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              if (!isClosing && notification.extent <= 0.051) {
                isClosing = true;
                Navigator.of(sheetContext).pop();
              }

              return false;
            },
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.95,
              minChildSize: 0.05,
              maxChildSize: 0.95,
              snap: true,
              snapSizes: const [0.05, 0.95],
              builder: (context, scrollController) {
                return _FullPlayerSheet(
                  scrollController: scrollController,
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasTrack = context
        .select<PlayerProvider, bool>((player) => player.currentTrack != null);

    if (!hasTrack) {
      return const SizedBox.shrink();
    }

    return _MiniPlayer(
      onTap: () => _openFullPlayer(context),
    );
  }
}

class _MiniPlayer extends StatelessWidget {
  const _MiniPlayer({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: InkWell(
        onTap: onTap,
        child: const SizedBox(
          height: 80,
          child: Column(
            children: [
              _MiniSeekBar(),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 10),
                    _MiniTrackImage(),
                    SizedBox(width: 10),
                    _MiniTrackInfo(),
                    _MiniPlayerControls(),
                    SizedBox(width: 6),
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

class _MiniSeekBar extends StatefulWidget {
  const _MiniSeekBar();

  @override
  State<_MiniSeekBar> createState() => _MiniSeekBarState();
}

class _MiniSeekBarState extends State<_MiniSeekBar> {
  double? _dragPosition;

  @override
  Widget build(BuildContext context) {
    final player = context.read<PlayerProvider>();
    final duration = context.select<PlayerProvider, Duration?>(
      (player) => player.duration,
    );

    return ValueListenableBuilder<Duration>(
      valueListenable: player.positionListenable,
      builder: (context, position, child) {
        final maxPosition = duration?.inMilliseconds.toDouble() ?? 0.0;
        final canSeek = maxPosition > 0;

        final currentPosition =
            (_dragPosition ?? position.inMilliseconds.toDouble())
                .clamp(0.0, canSeek ? maxPosition : 1.0);

        return SizedBox(
          height: 20,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 4,
                disabledThumbRadius: 4,
              ),
              overlayShape: const RoundSliderOverlayShape(
                overlayRadius: 9,
              ),
              trackShape: const RoundedRectSliderTrackShape(),
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            child: Slider(
              value: currentPosition,
              min: 0,
              max: canSeek ? maxPosition : 1.0,
              activeColor: Colors.lightGreenAccent,
              inactiveColor: Colors.grey[800],
              onChanged: canSeek
                  ? (value) {
                      setState(() => _dragPosition = value);
                    }
                  : null,
              onChangeEnd: canSeek
                  ? (value) async {
                      await player.seek(
                        Duration(milliseconds: value.round()),
                      );

                      if (mounted) {
                        setState(() => _dragPosition = null);
                      }
                    }
                  : null,
            ),
          ),
        );
      },
    );
  }
}

class _MiniTrackImage extends StatelessWidget {
  const _MiniTrackImage();

  @override
  Widget build(BuildContext context) {
    final imageUrl = context.select<PlayerProvider, String?>(
      (player) => player.currentTrack?.imageUrl,
    );

    if (imageUrl == null) {
      return const SizedBox(width: 46, height: 46);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.asset(
        imageUrl,
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
    );
  }
}

class _MiniTrackInfo extends StatelessWidget {
  const _MiniTrackInfo();

  @override
  Widget build(BuildContext context) {
    final track = context.select<PlayerProvider, Track?>(
      (player) => player.currentTrack,
    );

    if (track == null) {
      return const Expanded(child: SizedBox.shrink());
    }

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
    );
  }
}

class _MiniPlayerControls extends StatelessWidget {
  const _MiniPlayerControls();

  @override
  Widget build(BuildContext context) {
    final player = context.read<PlayerProvider>();
    final isPlaying =
        context.select<PlayerProvider, bool>((player) => player.isPlaying);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
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
            isPlaying ? Icons.pause : Icons.play_arrow,
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
      ],
    );
  }
}

class _FullPlayerSheet extends StatelessWidget {
  const _FullPlayerSheet({
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final hasTrack = context.select<PlayerProvider, bool>(
          (player) => player.currentTrack != null,
    );

    if (!hasTrack) {
      return const SizedBox.shrink();
    }

    return Container(
      color: const Color(0xFF101010),
      child: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          child: const Column(
            children: [
              _HandleBar(),
              _PlayerHeader(),
              SizedBox(height: 22),
              _TrackArt(),
              SizedBox(height: 28),
              _TrackInfo(),
              SizedBox(height: 22),
              _PlayerProgressBar(),
              SizedBox(height: 16),
              _PlaybackControls(),
              SizedBox(height: 26),
              _QueueHeader(),
              SizedBox(height: 12),
              _QueueList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HandleBar extends StatefulWidget {
  const _HandleBar();

  @override
  State<_HandleBar> createState() => _HandleBarState();
}

class _HandleBarState extends State<_HandleBar> {
  void _close() {
    final navigator = Navigator.of(context);

    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _close,
      child: SizedBox(
        width: double.infinity,
        height: 32,
        child: Center(
          child: Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayerHeader extends StatelessWidget {
  const _PlayerHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'NOW PLAYING',
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

class _TrackArt extends StatelessWidget {
  const _TrackArt();

  @override
  Widget build(BuildContext context) {
    final imageUrl = context.select<PlayerProvider, String?>(
      (player) => player.currentTrack?.imageUrl,
    );

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: imageUrl == null
                ? const ColoredBox(
                    color: Color(0xFF202020),
                    child: Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 100,
                    ),
                  )
                : Image.asset(
                    imageUrl,
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
    );
  }
}

class _TrackInfo extends StatelessWidget {
  const _TrackInfo();

  @override
  Widget build(BuildContext context) {
    final track = context.select<PlayerProvider, Track?>(
      (player) => player.currentTrack,
    );

    if (track == null) {
      return const SizedBox.shrink();
    }

    final isFavorite = context.select<FavoritesProvider, bool>(
      (favorites) => favorites.isFavorite(track),
    );
    final favoritesLoading = context.select<FavoritesProvider, bool>(
      (favorites) => favorites.isLoading,
    );

    return Row(
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
        IconButton(
          tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
          onPressed: favoritesLoading
              ? null
              : () => context.read<FavoritesProvider>().toggleFavorite(track),
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.lightGreenAccent : Colors.grey[400],
            size: 28,
          ),
        ),
      ],
    );
  }
}

class _PlayerProgressBar extends StatelessWidget {
  const _PlayerProgressBar();

  @override
  Widget build(BuildContext context) {
    return const _InternalSlider();
  }
}

class _InternalSlider extends StatefulWidget {
  const _InternalSlider();

  @override
  State<_InternalSlider> createState() => _InternalSliderState();
}

class _InternalSliderState extends State<_InternalSlider> {
  double? _dragPosition;

  @override
  Widget build(BuildContext context) {
    final player = context.read<PlayerProvider>();
    final duration = context.select<PlayerProvider, Duration?>(
      (player) => player.duration,
    );

    return ValueListenableBuilder<Duration>(
      valueListenable: player.positionListenable,
      builder: (context, position, child) {
        final durationMilliseconds = duration?.inMilliseconds.toDouble() ?? 1.0;

        final maxPosition =
            durationMilliseconds > 0 ? durationMilliseconds : 1.0;

        final currentPosition =
            (_dragPosition ?? position.inMilliseconds.toDouble())
                .clamp(0.0, maxPosition);

        return Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                padding: EdgeInsets.zero,
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 6,
                ),
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 12,
                ),
              ),
              child: Slider(
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(
                      Duration(milliseconds: currentPosition.round()),
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
          ],
        );
      },
    );
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) {
      return '00:00';
    }

    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}

class _PlaybackControls extends StatelessWidget {
  const _PlaybackControls();

  @override
  Widget build(BuildContext context) {
    final player = context.read<PlayerProvider>();

    // Подписываем панель управления только на три её состояния.
    final controlsState =
        context.select<PlayerProvider, (bool, bool, RepeatMode)>(
      (player) => (
        player.isPlaying,
        player.shuffleEnabled,
        player.repeatMode,
      ),
    );

    final isPlaying = controlsState.$1;
    final shuffleEnabled = controlsState.$2;
    final repeatMode = controlsState.$3;

    final repeatIcon = switch (repeatMode) {
      RepeatMode.off => Icons.repeat,
      RepeatMode.all => Icons.repeat,
      RepeatMode.one => Icons.repeat_one,
    };

    final repeatColor =
        repeatMode == RepeatMode.off ? Colors.grey : Colors.lightGreenAccent;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: player.toggleShuffle,
          icon: Icon(
            Icons.shuffle,
            color: shuffleEnabled ? Colors.lightGreenAccent : Colors.grey,
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
              isPlaying ? Icons.pause : Icons.play_arrow,
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
    );
  }
}

class _QueueHeader extends StatelessWidget {
  const _QueueHeader();

  @override
  Widget build(BuildContext context) {
    final queueCount = context.select<PlayerProvider, int>(
      (player) => player.queue.length,
    );

    return Row(
      children: [
        const Icon(
          Icons.queue_music,
          color: Colors.lightGreenAccent,
        ),
        const SizedBox(width: 10),
        const Text(
          'Play queue',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          '$queueCount tracks',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _QueueList extends StatelessWidget {
  const _QueueList();

  @override
  Widget build(BuildContext context) {
    final queueKey = context.select<PlayerProvider, String>(
      (player) => player.queue.map((track) => track.id).join('\u0000'),
    );
    final currentTrackId = context.select<PlayerProvider, String?>(
      (player) => player.currentTrack?.id,
    );

    final queue = context.read<PlayerProvider>().queue;

    if (queue.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'Queue is empty',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      key: ValueKey(queueKey),
      children: [
        for (final queueTrack in queue)
          _QueueTrackTile(
            key: ValueKey(queueTrack.id),
            track: queueTrack,
            isCurrent: queueTrack.id == currentTrackId,
          ),
      ],
    );
  }
}

class _QueueTrackTile extends StatelessWidget {
  const _QueueTrackTile({
    super.key,
    required this.track,
    required this.isCurrent,
  });

  final Track track;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final player = context.read<PlayerProvider>();

    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.asset(
            track.imageUrl,
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
          track.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isCurrent ? Colors.lightGreenAccent : Colors.white,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          track.albumName,
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
        onTap: () => player.play(track),
      ),
    );
  }
}
