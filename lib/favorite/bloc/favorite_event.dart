part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class FavoritesLoad extends FavoriteEvent {}

class FavoriteUpdate extends FavoriteEvent {
  final Favorite updatedFavorite;

  const FavoriteUpdate(this.updatedFavorite);

  @override
  List<Object> get props => [updatedFavorite];

  @override
  String toString() => 'UpdateFavorite { updatedFavorite: $updatedFavorite }';
}

class UpdateFavorites extends FavoriteEvent {
  final List<FavoriteFire> favorites;

  const UpdateFavorites(this.favorites);

  @override
  List<Object> get props => [favorites];

  @override
  String toString() => 'UpdateFavorites { favorites: $favorites }';
}

class AddFavorite extends FavoriteEvent {
  final FavoriteFire favorite;

  const AddFavorite(this.favorite);

  @override
  List<Object> get props => [favorite];

  @override
  String toString() => 'AddFavorite { favorite: $favorite }';
}

class RemoveFavorite extends FavoriteEvent {
  final String favoriteId;

  const RemoveFavorite(this.favoriteId);

  @override
  List<Object> get props => [favoriteId];

  @override
  String toString() => 'RemoveFavorite { favoriteId: $favoriteId }';
}

class RemoveFavoriteFromSong extends FavoriteEvent {
  final String songId;

  const RemoveFavoriteFromSong(this.songId);

  @override
  List<Object> get props => [songId];

  @override
  String toString() => 'RemoveFavoriteFromSong { songId: $songId }';
}

class FavoriteExist extends FavoriteEvent {
  final String songId;

  const FavoriteExist(this.songId);

  @override
  List<Object> get props => [songId];

  @override
  String toString() => 'FavoriteExist { songId: $songId }';
}

class UpdateAuthId extends FavoriteEvent {
  final String authId;

  const UpdateAuthId(this.authId);

  @override
  List<Object> get props => [authId];

  @override
  String toString() => 'UpdateAuthId { authId: $authId }';
}

class FavoriteExistSuccess extends FavoriteEvent {
  final bool exist;
  final String favoriteId;

  const FavoriteExistSuccess(this.exist, this.favoriteId);

  @override
  List<Object> get props => [exist];

  @override
  String toString() => 'FavoriteExistSuccess { exist: $exist }';
}

class FavoriteExistError extends FavoriteEvent {
  final String message;

  const FavoriteExistError(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'FavoriteExistError { message: $message }';
}
