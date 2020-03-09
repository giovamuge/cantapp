import 'package:bloc/bloc.dart';
import 'package:cantapp/favorite/favorite.dart';
import 'package:cantapp/favorite/favorite_event.dart';
import 'package:cantapp/favorite/favorite_repository.dart';
import 'package:cantapp/favorite/favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository repository;

  FavoriteBloc({this.repository});

  @override
  FavoriteState get initialState => FavoriteLoading();

  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
    // final FavoriteRepository repo = FavoriteRepository();
    if (event is LoadFavorite) {
      yield* _mapLoadFavoriteToState();
    } else if (event is AddFavorite) {
      yield* _mapAddFavoriteToState(event);
    } else if (event is UpdateFavorite) {
      yield* _mapUpdateFavoriteToState(event);
    } else if (event is DeleteFavorite) {
      yield* _mapDeleteFavoriteToState(event);
    } else if (event is ToggleAll) {
      // yield * _mapToggleAllToState();
    } else if (event is ClearCompleted) {
      // yield * _mapClearCompletedToState();
    }
  }

  Stream<FavoriteState> _mapLoadFavoriteToState() async* {
    try {
      final favorites = await this.repository.favorites();
      yield FavoriteLoaded(
        favorites.map((f) => Favorite.fromEntity(f)).toList(),
      );
    } catch (_) {
      yield FavoriteNotLoaded();
    }
  }

  Stream<FavoriteState> _mapAddFavoriteToState(AddFavorite event) async* {
    if (state is FavoriteLoaded) {
      final List<Favorite> updatedFavorite =
          List.from((state as FavoriteLoaded).favorites)..add(event.favorite);
      yield FavoriteLoaded(updatedFavorite);
      _saveFavorite(updatedFavorite);
    }
  }

  Stream<FavoriteState> _mapUpdateFavoriteToState(UpdateFavorite event) async* {
    if (state is FavoriteLoaded) {
      final List<Favorite> updatedFavorite =
          (state as FavoriteLoaded).favorites.map((fav) {
        return fav.id == event.updatedFavorite.id ? event.updatedFavorite : fav;
      }).toList();
      yield FavoriteLoaded(updatedFavorite);
      _saveFavorite(updatedFavorite);
    }
  }

  Stream<FavoriteState> _mapDeleteFavoriteToState(DeleteFavorite event) async* {
    if (state is FavoriteLoaded) {
      final updatedFavorite = (state as FavoriteLoaded)
          .favorites
          .where((fav) => fav.id != event.favorite.id)
          .toList();
      yield FavoriteLoaded(updatedFavorite);
      _saveFavorite(updatedFavorite);
    }
  }

  // Stream<FavoriteState> _mapToggleAllToState() async* {
  //   if (state is FavoriteLoaded) {
  //     final allComplete =
  //         (state as FavoriteLoaded).favorites.every((fav) => fav.complete);
  //     final List<Favorite> updatedFavorite = (state as FavoriteLoaded)
  //         .favorites
  //         .map((fav) => fav.copyWith(complete: !allComplete))
  //         .toList();
  //     yield FavoriteLoaded(updatedFavorite);
  //     _saveFavorite(updatedFavorite);
  //   }
  // }

  // Stream<FavoriteState> _mapClearCompletedToState() async* {
  //   if (state is FavoriteLoaded) {
  //     final List<Favorite> updatedFavorite = (state as FavoriteLoaded)
  //         .favorites
  //         .where((fav) => !fav.complete)
  //         .toList();
  //     yield FavoriteLoaded(updatedFavorite);
  //     _saveFavorite(updatedFavorite);
  //   }
  // }

  Future _saveFavorite(List<Favorite> favorites) {
    // return favoriteRepository.add(
    //   favorites.map((fav) => fav.toEntity()).toList(),
    // );
    // return favoriteRepository.add(favorites)
  }
}
