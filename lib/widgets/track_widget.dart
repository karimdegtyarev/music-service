import 'dart:math';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/track_model.dart';

class TrackWidget extends StatefulWidget {
  final Track track;
  final VoidCallback? onTap;

  const TrackWidget({
    super.key,
    required this.track,
    this.onTap,
  });

  @override
  State<TrackWidget> createState() => _TrackWidgetState();
}

class _TrackWidgetState extends State<TrackWidget>
    with TickerProviderStateMixin {
  bool isPlay = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
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
              _buildAlbumArt(),
              const SizedBox(width: 16),
              Expanded(
                flex: 5,
                child: _buildTrackInfo(),
              ),
              const Spacer(),
              _buildPlayButton(),
              //Expanded(flex: 2,child: ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumArt() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        widget.track.imageUrl.replaceFirst("./lib/", ""),
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 56,
          height: 56,
          color: Colors.grey[800],
          child: const Icon(Icons.music_note, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTrackInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.track.title,
          style: GoogleFonts.balsamiqSans(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        //const SizedBox(height: 4),
        Text(
          widget.track.albumName,
          style: GoogleFonts.balsamiqSans(
            color: Colors.grey[400],
            fontSize: 12,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          _formatDuration(widget.track.duration),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayButton() {
    return GestureDetector(
      onTap: () {
        if (isPlay == false) {
          _controller.forward();
          isPlay = true;
        } else {
          _controller.reverse();
          isPlay = false;
        }
      },
      child: AnimatedIcon(
        icon: AnimatedIcons.play_pause,
        progress: _controller,
        size: 30,
        color: Colors.lightGreenAccent,
      ),
    );
  }

  String _formatDuration(double seconds) {
    final duration = Duration(seconds: seconds.toInt());
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}