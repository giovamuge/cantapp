import 'package:cantapp/song/song_model.dart';
import 'package:equatable/equatable.dart';

abstract class SongState extends Equatable {
  const SongState();

  @override
  List<Object> get props => [];
}

class SongUninitialized extends SongState {}

class SongError extends SongState {}

class SongLoaded extends SongState {
  final List<Song> songs;
  final bool hasReachedMax;

  const SongLoaded({
    this.songs,
    this.hasReachedMax,
  });

  SongLoaded copyWith({
    List<Song> posts,
    bool hasReachedMax,
  }) {
    return SongLoaded(
      songs: posts ?? this.songs,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [songs, hasReachedMax];

  @override
  String toString() =>
      'PostLoaded { songs: ${songs.length}, hasReachedMax: $hasReachedMax }';
}
