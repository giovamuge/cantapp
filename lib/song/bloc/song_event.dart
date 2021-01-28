part of 'song_bloc.dart';

abstract class SongEvent extends Equatable {
  const SongEvent();

  @override
  List<Object> get props => [];
}

class SongFetched extends SongEvent {
  final String songId;

  const SongFetched(this.songId);

  @override
  List<Object> get props => [songId];

  @override
  String toString() => 'GetStong { songId: $songId }';
}

class SongUpdated extends SongEvent {
  final Song updatedSong;
  const SongUpdated(this.updatedSong);

  @override
  List<Object> get props => [updatedSong];

  @override
  String toString() => 'SongUpdated { SongUpdated: $updatedSong }';
}

class SongViewIncremented extends SongEvent {
  final String songId;

  const SongViewIncremented(this.songId);

  @override
  List<Object> get props => [songId];

  @override
  String toString() => 'SongViewIncremented { songId: $songId }';
}
