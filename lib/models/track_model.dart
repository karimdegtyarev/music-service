import 'package:json_annotation/json_annotation.dart';

part 'track_model.g.dart';

@JsonSerializable()
class Track {
  final String id;
  final String title;

  @JsonKey(name: 'album')
  final String albumName;

  @JsonKey(name: 'release_date')
  final String releaseDate;

  @JsonKey(name: 'cover')
  final String imageUrl;

  @JsonKey(name: 'path')
  final String musicUrl;

  @JsonKey(name: 'artist_id')
  final List<int> artistId;

  final double duration;

  const Track({
    required this.id,
    required this.title,
    required this.albumName,
    required this.releaseDate,
    required this.imageUrl,
    required this.musicUrl,
    required this.artistId,
    required this.duration,
  });

  factory Track.fromJson(Map<String, dynamic> json) =>
      _$TrackFromJson(json);

  Map<String, dynamic> toJson() => _$TrackToJson(this);
}
