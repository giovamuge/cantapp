// Update the song class to include a `toMap` method.
class Favorite {
  final String id;

  Favorite({this.id});

  Favorite copyWith({bool complete, String id, String note, String task}) {
    return Favorite(
      id: id ?? this.id,
    );
  }

  // Convert a song into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {/*'id': id,*/ 'id': id};
  }

  @override
  List<Object> get props => [id];

  @override
  String toString() {
    return 'Favorite { id: $id }';
  }

  FavoriteEntity toEntity() {
    return FavoriteEntity(id);
  }

  static Favorite fromEntity(FavoriteEntity entity) {
    return Favorite(
      id: entity.id,
    );
  }
}

class FavoriteEntity extends Favorite {
  String id;

  FavoriteEntity(this.id);
}
