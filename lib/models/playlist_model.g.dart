// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistCategories _$PlaylistCategoriesFromJson(Map<String, dynamic> json) =>
    PlaylistCategories(
      categories: (json['categories'] as List<dynamic>)
          .map((e) => PlaylistCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlaylistCategoriesToJson(PlaylistCategories instance) =>
    <String, dynamic>{
      'categories': instance.categories,
    };

PlaylistCategory _$PlaylistCategoryFromJson(Map<String, dynamic> json) =>
    PlaylistCategory(
      title: json['title'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => Playlist.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlaylistCategoryToJson(PlaylistCategory instance) =>
    <String, dynamic>{
      'title': instance.title,
      'items': instance.items,
    };

Playlist _$PlaylistFromJson(Map<String, dynamic> json) => Playlist(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['cover'] as String,
      description: json['description'] as String,
      fans: (json['fans'] as num).toInt(),
      updated: json['updated'] as String,
      tracks: (json['tracks'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$PlaylistToJson(Playlist instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'cover': instance.imageUrl,
      'description': instance.description,
      'fans': instance.fans,
      'updated': instance.updated,
      'tracks': instance.tracks,
    };
