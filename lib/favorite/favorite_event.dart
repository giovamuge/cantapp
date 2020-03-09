import 'package:cantapp/favorite/favorite.dart';
import 'package:cantapp/favorite/favorite_repository.dart';
import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorite extends FavoriteEvent {}

class AddFavorite extends FavoriteEvent {
  final Favorite favorite;

  const AddFavorite(this.favorite);

  @override
  List<Object> get props => [favorite];

  @override
  String toString() => 'AddFavorite { favorite: $favorite }';
}

class UpdateFavorite extends FavoriteEvent {
  final Favorite updatedFavorite;

  const UpdateFavorite(this.updatedFavorite);

  @override
  List<Object> get props => [updatedFavorite];

  @override
  String toString() => 'UpdateFavorite { updatedFavorite: $updatedFavorite }';
}

class DeleteFavorite extends FavoriteEvent {
  final Favorite favorite;

  const DeleteFavorite(this.favorite);

  @override
  List<Object> get props => [favorite];

  @override
  String toString() => 'DeleteFavorite { favorite: $favorite }';
}

class ClearCompleted extends FavoriteEvent {}

class ToggleAll extends FavoriteEvent {}
