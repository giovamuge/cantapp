part of 'songs_bloc.dart';

abstract class SongsState extends Equatable {
  const SongsState();

  @override
  List<Object> get props => [];
}

class SongInitial extends SongsState {}

class SongsLoading extends SongsState {
  final Category activeFilter;
  const SongsLoading(this.activeFilter);
}

class SongsLoaded extends SongsState {
  final List<SongLight> songs;
  final bool hasReachedMax;
  final Category activeFilter;

  const SongsLoaded([
    this.songs = const [],
    this.hasReachedMax = false,
    this.activeFilter,
  ]);

  SongsState copyWith({
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

class SongsNotLoaded extends SongsState {}
