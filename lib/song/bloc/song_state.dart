part of 'song_bloc.dart';

abstract class SongState extends Equatable {
  const SongState();

  @override
  List<Object> get props => [];
}

class SongLoading extends SongState {}

class SongLoaded extends SongState {
  final Song song;

  const SongLoaded(this.song);

  @override
  toString() => 'SongLoaded { song: $song }';
}

class SongNotLoaded extends SongState {}

class SongViewIncrementedSuccess extends SongState {}

class SongViewIncrementedError extends SongState {}
