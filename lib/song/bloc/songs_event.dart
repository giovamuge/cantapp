part of 'songs_bloc.dart';

abstract class SongsEvent extends Equatable {
  const SongsEvent();

  @override
  List<Object> get props => [];
}

class UpdateFilter extends SongsEvent {
  final Category filter;

  const UpdateFilter(this.filter);

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'UpdateFilter { filter: $filter }';
}

class SongsFetch extends SongsEvent {
  final SongLight last;
  // final Category category;
  // final List<SongLight> songs;
  // final bool hasReachedMax;

  const SongsFetch(
      this.last /*, this.category, this.songs, this.hasReachedMax*/);

  SongsFetch.init()
      : last =
            null /*,
        category = Categories.first(),
        songs = [],
        hasReachedMax = false*/
  ;

  @override
  List<Object> get props => [last];
}

class SongsUpdated extends SongsEvent {
  final List<SongLight> songs;
  final bool isInitial;

  const SongsUpdated(this.songs, this.isInitial);

  @override
  List<Object> get props => [songs];
}

class SongsAuthIdUpdated extends SongsEvent {
  final String authId;

  const SongsAuthIdUpdated(this.authId);

  @override
  List<Object> get props => [authId];
}
