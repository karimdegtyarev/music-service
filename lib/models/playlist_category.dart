class PlaylistCategory {
  final String title;
  final List<Playlist> items;

  PlaylistCategory(this.title, this.items);
}

class Playlist {
  final String id;
  final String title;
  final String imageUrl;
  final String description;

  Playlist(this.id, this.title, this.imageUrl, this.description);
}