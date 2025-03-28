import 'package:flutter/material.dart';
//import 'package:music_service/models/track_model.dart';
import 'package:provider/provider.dart';

import '../providers/player_provider.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<PlayerProvider>(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: player.currentTrack != null ? 80 : 0,
      color: Colors.grey[900],
      child: player.currentTrack == null
          ? const SizedBox.shrink()
          : Column(
        children: [
          LinearProgressIndicator(
            value: player.progress,
            backgroundColor: Colors.grey[800],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          ListTile(
            leading: Image.asset(
              player.currentTrack!.imageUrl,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
            title: Text(
              player.currentTrack!.title,
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              player.currentTrack!.albumName,
              style: TextStyle(color: Colors.grey[400]),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    player.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: player.togglePlay,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, color: Colors.white),
                  onPressed: player.next,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}