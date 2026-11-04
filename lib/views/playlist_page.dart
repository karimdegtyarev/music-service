
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/track_model.dart';
import '../providers/player_provider.dart';
import '../widgets/player_widget.dart';
import '../widgets/track_widget.dart';

class PlaylistPage extends StatelessWidget {
  final List<Track> tracks;

  const PlaylistPage({
    super.key,
    required this.tracks,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Плейлист',
          style: GoogleFonts.permanentMarker(
            color: Colors.lightGreenAccent,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: tracks.isEmpty
          ? const Center(
        child: Text(
          'В этом плейлисте пока нет треков',
          style: TextStyle(color: Colors.white),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tracks.length,
        itemBuilder: (context, index) {
          return TrackWidget(
            track: tracks[index],
            onTap: () {
              context.read<PlayerProvider>().setQueue(
                tracks,
                initialIndex: index,
              );
            },
          );
        },
      ),
      bottomNavigationBar: const PlayerWidget(),
    );
  }
}
