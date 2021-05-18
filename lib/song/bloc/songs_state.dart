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
  final bool hasReachedMax;

  const SongsLoaded([
    this.songs = const [],
    this.hasReachedMax = false,
  ]);

  SongState copyWith({
    List<SongLight> songs,
    bool hasReachedMax,
  }) {
    return SongsLoaded(
      songs ?? this.songs,
      hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [songs, hasReachedMax];

  @override
  String toString() =>
      '''SongsLoaded { songs: $songs, hasReachedMax: $hasReachedMax }''';
}

class SongsNotLoaded extends SongState {}
