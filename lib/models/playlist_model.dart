import 'package:json_annotation/json_annotation.dart';

part 'playlist_model.g.dart';

@JsonSerializable()
class PlaylistCategories {
  final List<PlaylistCategory> categories;

  PlaylistCategories({required this.categories});

  factory PlaylistCategories.fromJson(Map<String, dynamic> json) =>
      _$PlaylistCategoriesFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistCategoriesToJson(this);
}

@JsonSerializable()
class PlaylistCategory {
  final String title;
  final List<Playlist> items;

  PlaylistCategory({required this.title, required this.items});

  factory PlaylistCategory.fromJson(Map<String, dynamic> json) =>
      _$PlaylistCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistCategoryToJson(this);
}

@JsonSerializable()
class Playlist {
  final String id;
  final String title;

  @JsonKey(name: 'cover')
  final String imageUrl;

  final String description;
  final int fans;
  final String updated;
  final List<int> tracks;

  Playlist({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.fans,
    required this.updated,
    required this.tracks,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistToJson(this);
}
