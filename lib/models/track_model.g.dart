// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Track _$TrackFromJson(Map<String, dynamic> json) => Track(
      id: json['id'] as String,
      title: json['title'] as String,
      albumName: json['album'] as String,
      releaseDate: json['release_date'] as String,
      imageUrl: json['cover'] as String,
      musicUrl: json['path'] as String,
      artistId: (json['artist_id'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      duration: (json['duration'] as num).toDouble(),
    );

Map<String, dynamic> _$TrackToJson(Track instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'album': instance.albumName,
      'release_date': instance.releaseDate,
      'cover': instance.imageUrl,
      'path': instance.musicUrl,
      'artist_id': instance.artistId,
      'duration': instance.duration,
    };
