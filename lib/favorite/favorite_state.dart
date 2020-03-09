import 'package:cantapp/favorite/favorite.dart';
import 'package:cantapp/favorite/favorite_repository.dart';
import 'package:equatable/equatable.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Favorite> favorites;

  const FavoriteLoaded([this.favorites = const []]);

  @override
  List<Object> get props => [favorites];

  @override
  String toString() => 'FavoriteLoaded { favorites: $favorites }';
}

class FavoriteNotLoaded extends FavoriteState {}
