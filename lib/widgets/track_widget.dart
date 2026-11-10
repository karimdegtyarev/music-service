import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';

import '../models/track_model.dart';
import '../providers/player_provider.dart';

class TrackWidget extends StatelessWidget {
  final Track track;
  final VoidCallback? onTap;

  const TrackWidget({
    super.key,
    required this.track,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final favorites = context.watch<FavoritesProvider>();
    final isFavorite = favorites.isFavorite(track);

    final isCurrentTrack = player.currentTrack?.id == track.id;
    final isPlaying = isCurrentTrack && player.isPlaying;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!();
          } else if (isCurrentTrack) {
            player.togglePlay();
          } else {
            player.play(track);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 81,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  track.imageUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 56,
                    height: 56,
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      style: GoogleFonts.balsamiqSans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      track.albumName,
                      style: GoogleFonts.balsamiqSans(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _formatDuration(track.duration),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                size: 30,
                color: Colors.lightGreenAccent,
              ),
              const SizedBox(width: 8),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.greenAccent : Colors.white,
                ),
                onPressed: () {
                  context.read<FavoritesProvider>().toggleFavorite(track);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(double seconds) {
    final duration = Duration(seconds: seconds.toInt());
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}
