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

class SongsUpdated extends SongEvent {
  final List<SongLight> songs;

  const SongsUpdated(this.songs);

  @override
  List<Object> get props => [songs];
}

class UpdateAuthIdSong extends SongEvent {
  final String authId;

  const UpdateAuthIdSong(this.authId);

  @override
  List<Object> get props => [authId];
}
