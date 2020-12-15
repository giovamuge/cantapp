part of 'songs_bloc.dart';

abstract class SongEvent extends Equatable {
  const SongEvent();

  @override
  List<Object> get props => [];
}

class SongsFetch extends SongEvent {
  final List<Song> songs;

  const SongsFetch(this.songs);

  @override
  List<Object> get props => [songs];
}

// class SongsFetch extends SongEvent {}

class UpdateSong extends SongEvent {
  final Song updatedSong;
  const UpdateSong(this.updatedSong);

  @override
  List<Object> get props => [updatedSong];

  @override
  String toString() => 'UpdateTodo { updatedTodo: $updatedSong }';
}

class SongsUpdated extends SongEvent {
  final List<SongLight> songs;

  const SongsUpdated(this.songs);

  @override
  List<Object> get props => [songs];
}
