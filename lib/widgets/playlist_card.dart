import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_service/views/playlist_page.dart';
import '../models/playlist_category.dart';

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
                  Container(
                    width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.lightGreenAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.network(
                        playlist.imageUrl,
                        fit: BoxFit.fill,
                      )),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.black,
                            size: 50,
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
        context, MaterialPageRoute(builder: (context) => const PlaylistPage()));
  }
}
