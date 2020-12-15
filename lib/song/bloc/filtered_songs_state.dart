part of 'filtered_songs_bloc.dart';

abstract class FilteredSongsState extends Equatable {
  const FilteredSongsState();

  @override
  List<Object> get props => [];
}

class FilteredSongsInitial extends FilteredSongsState {}

class FilteredSongsLoading extends FilteredSongsState {}

class FilteredSongsLoaded extends FilteredSongsState {
  final List<SongLight> songsFiltered;
  final Category activeFilter;

  const FilteredSongsLoaded(
    this.songsFiltered,
    this.activeFilter,
  );

  @override
  List<Object> get props => [songsFiltered, activeFilter];

  @override
  String toString() {
    return 'FilteredTodosLoaded { songsFiltered: $songsFiltered, activeFilter: $activeFilter }';
  }
}
