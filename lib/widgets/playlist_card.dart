import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_service/views/playlist_page.dart';
import '../models/playlist_model.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;

  const PlaylistCard({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPlaylist(context, playlist.id),
      child: SizedBox(
          width: 150,
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 300,
                    height: 150,
                    child: Image.asset(
                      playlist.imageUrl.replaceFirst('./lib/', ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(220, 76, 175, 80),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                playlist.title,
                style: GoogleFonts.balsamiqSans(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
              Text(
                playlist.description,
                style: GoogleFonts.balsamiqSans(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ],
          )),
    );
  }

  


  void _openPlaylist(BuildContext context, String id) {
    log("Navigating to Playlist Page");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const PlaylistPage(tracks: [],)));
  }
}
