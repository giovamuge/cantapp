part of 'favorite_bloc.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<FavoriteFire> favorites;

  const FavoriteLoaded(this.favorites);

  @override
  List<Object> get props => [favorites];

  @override
  String toString() => 'UpdateFavorites { favorites: $favorites }';
}

class FavoriteExistSuccessed extends FavoriteState {
  final bool exist;
  final String favoriteId;

  const FavoriteExistSuccessed(this.exist, this.favoriteId);

  @override
  List<Object> get props => [exist];

  @override
  String toString() =>
      'FavoriteExistSuccessed { exist: $exist, favoriteId: $favoriteId }';
}

class FavoriteExistLoading extends FavoriteState {}

class FavoriteExistErrored extends FavoriteState {
  final String message;

  const FavoriteExistErrored(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'FavoriteExistError { message: $message }';
}

class FavoriteAddedSuccess extends FavoriteState {}

class FavoriteAddedError extends FavoriteState {}

class FavoriteRemoveSuccess extends FavoriteState {}

class FavoriteRemoveError extends FavoriteState {}
