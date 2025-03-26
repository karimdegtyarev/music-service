import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_service/widgets/playlist_card.dart';
import 'playlist_model.dart';

class CategorySection extends StatelessWidget {
  final PlaylistCategory category;

  const CategorySection({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            category.title,
            style: GoogleFonts.balsamiqSans(color: Colors.green, fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SizedBox(
            height: 210,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: category.items.length,
              itemBuilder: (_, index) =>
                  PlaylistCard(playlist: category.items[index]),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
            ),
          ),
        ),
      ],
    );
  }
}
