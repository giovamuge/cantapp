part of 'songs_bloc.dart';

abstract class SongState extends Equatable {
  const SongState();

  @override
  List<Object> get props => [];
}

class SongInitial extends SongState {}

class SongsLoading extends SongState {}

class SongsLoaded extends SongState {
  final List<SongLight> songs;

  const SongsLoaded([this.songs = const []]);

  @override
  List<Object> get props => [songs];

  @override
  String toString() => 'SongsLoaded { todos: $songs }';
}

class SongsNotLoaded extends SongState {}
