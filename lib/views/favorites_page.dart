
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../providers/player_provider.dart';
import '../widgets/track_widget.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Dynamic',
          style: GoogleFonts.permanentMarker(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: favorites.isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.lightGreenAccent,
        ),
      )
          : favorites.favorites.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_border,
              color: Colors.grey,
              size: 70,
            ),
            const SizedBox(height: 16),
            Text(
              'Здесь пока ничего нет',
              style: GoogleFonts.balsamiqSans(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Добавляй любимые треки сердечком',
              style: GoogleFonts.balsamiqSans(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: favorites.favorites.length,
        separatorBuilder: (_, __) =>
        const SizedBox(height: 4),
        itemBuilder: (context, index) {
          final track = favorites.favorites[index];

          return TrackWidget(
            track: track,
            onTap: () {
              context.read<PlayerProvider>().setQueue(
                favorites.favorites,
                initialIndex: index,
              );
            },
          );
        },
      ),
    );
  }
}
