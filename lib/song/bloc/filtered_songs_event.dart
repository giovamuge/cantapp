part of 'filtered_songs_bloc.dart';

abstract class FilteredSongsEvent extends Equatable {
  const FilteredSongsEvent();

  @override
  List<Object> get props => [];
}

class UpdateFilter extends FilteredSongsEvent {
  final Category filter;

  const UpdateFilter(this.filter);

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'UpdateFilter { filter: $filter }';
}

class UpdateSongs extends FilteredSongsEvent {
  final List<SongLight> songs;

  const UpdateSongs(this.songs);

  @override
  List<Object> get props => [songs];

  @override
  String toString() => 'UpdateSongs { todos: $songs }';
}
