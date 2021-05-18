part of 'songs_bloc.dart';

abstract class SongEvent extends Equatable {
  const SongEvent();

  @override
  List<Object> get props => [];
}

class SongsFetch extends SongEvent {
  final SongLight last;
  final Category category;

  const SongsFetch(this.last, this.category);

  @override
  List<Object> get props => [last, category];
}

class SongsUpdated extends SongEvent {
  final List<SongLight> songs;
  final bool isInitial;

  const SongsUpdated(this.songs, this.isInitial);

  @override
  List<Object> get props => [songs];
}

class SongsAuthIdUpdated extends SongEvent {
  final String authId;

  const SongsAuthIdUpdated(this.authId);

  @override
  List<Object> get props => [authId];
}
